Return-Path: <linux-kernel-owner+w=401wt.eu-S1765469AbZAPIsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765469AbZAPIsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759083AbZAPIsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:48:31 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57334 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406AbZAPIs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:48:29 -0500
Date: Fri, 16 Jan 2009 09:48:28 +0100
From: Pavel Machek <pavel@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Takashi Sato <t-sato@yk.jp.nec.com>
Subject: Re: [PATCH] Allow SysRq emergency sync to thaw frozen filesystems
Message-ID: <20090116084828.GB4795@atrey.karlin.mff.cuni.cz>
References: <496EB639.6090800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496EB639.6090800@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Emergency Sync should not do this. Invent another key.

...because otherwise, if you hit emergency sync but the system is
still alive and relies on filesystem freezing, bad stuff will happen.

								Pavel
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
>  static struct sysrq_key_op sysrq_sync_op = {
> Index: linux-2.6/fs/buffer.c
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
> +	}
> +	printk(KERN_WARNING "Emergency Thaw complete\n");
> +}
> +
> +/**
> + * emergency_thaw -- force thaw every filesystem
> + *
> + * Used for emergency unfreeze of all filesystems via SysRq
> + */
> +void emergency_thaw(void)
> +{
> +	pdflush_operation(do_thaw, 0);
> +}
> +
>  /**
>   * thaw_bdev  -- unlock filesystem
>   * @bdev:	blockdevice to unlock
> Index: linux-2.6/include/linux/buffer_head.h
> ===================================================================
> --- linux-2.6.orig/include/linux/buffer_head.h
> +++ linux-2.6/include/linux/buffer_head.h
> @@ -171,6 +171,7 @@ void __wait_on_buffer(struct buffer_head
>  wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
>  int fsync_bdev(struct block_device *);
>  struct super_block *freeze_bdev(struct block_device *);
> +void emergency_thaw(void);
>  int thaw_bdev(struct block_device *, struct super_block *);
>  int fsync_super(struct super_block *);
>  int fsync_no_super(struct block_device *);
> Index: linux-2.6/Documentation/sysrq.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/sysrq.txt
> +++ linux-2.6/Documentation/sysrq.txt
> @@ -101,7 +101,8 @@ On all -  write a character to /proc/sys
>  
>  'r'     - Turns off keyboard raw mode and sets it to XLATE.
>  
> -'s'     - Will attempt to sync all mounted filesystems.
> +'s'     - Will attempt to sync all mounted filesystems, and unfreeze
> +	  any frozen fileystems.
>  
>  't'     - Will dump a list of current tasks and their information to your
>            console.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
