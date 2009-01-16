Return-Path: <linux-kernel-owner+w=401wt.eu-S1762424AbZAPAVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762424AbZAPAVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZAPAUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:20:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733AbZAPAUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:20:49 -0500
Date: Thu, 15 Jan 2009 16:20:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       t-sato@yk.jp.nec.com
Subject: Re: [PATCH] Allow SysRq emergency sync to thaw frozen filesystems
Message-Id: <20090115162031.a512232b.akpm@linux-foundation.org>
In-Reply-To: <496EB639.6090800@redhat.com>
References: <496EB639.6090800@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 22:06:17 -0600
Eric Sandeen <sandeen@redhat.com> wrote:

> Now that the filesystem freeze operation has been elevated
> to the VFS, and is just an ioctl away, some sort of safety net
> for unintentionally frozen root filesystems may be in order.
> 
> The timeout thaw originally proposed did not get merged, but
> perhaps something like this would be useful in emergencies.
> 
> This doesn't have to piggyback on the existing emergency sync
> sysrq, but it seems like a reasonable, simple addition to me.
> 
> I've tested this on a non-root fs with multiple (nested) freezers,
> as well as on a system rendered unresponsive due to a frozen
> root fs.

Worried.

Under what operational scenarios is ths feature actually needed/used?

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Index: linux-2.6/drivers/char/sysrq.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/sysrq.c
> +++ linux-2.6/drivers/char/sysrq.c
> @@ -151,6 +151,7 @@ static struct sysrq_key_op sysrq_reboot_
>  
>  static void sysrq_handle_sync(int key, struct tty_struct *tty)
>  {
> +	emergency_thaw();
>  	emergency_sync();
>  }

Kind of weird.   The thaw will happen after/during the sync().

I guess that if the sync is blocked on a frozen fs then things will
sort themselves out.

otoh, if all the pdflush threads are blocked on frozen filesystems
(possible?) then the emergency_thaw() simply won't do anything.

> ===================================================================
> --- linux-2.6.orig/fs/buffer.c
> +++ linux-2.6/fs/buffer.c
> @@ -258,6 +258,29 @@ struct super_block *freeze_bdev(struct b
>  }
>  EXPORT_SYMBOL(freeze_bdev);
>  
> +void do_thaw(unsigned long unused)
> +{
> +	struct super_block *sb;
> +	char b[BDEVNAME_SIZE];
> +
> +	list_for_each_entry(sb, &super_blocks, s_list) {
> +		while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
> +			printk(KERN_WARNING "Emergency Thaw on %s\n",
> +			       bdevname(sb->s_bdev, b));

hm, I made the args to bdevname() backwards.  Bad me.

> +	}
> +	printk(KERN_WARNING "Emergency Thaw complete\n");
> +}

