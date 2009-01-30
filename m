Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbZA3VlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbZA3VlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 16:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZA3Vkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 16:40:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511AbZA3Vky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 16:40:54 -0500
Date: Fri, 30 Jan 2009 13:40:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: sandeen@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, t-sato@yk.jp.nec.com
Subject: Re: [PATCH V3] Allow SysRq emergency thaw to thaw frozen
 filesystems
Message-Id: <20090130134009.02d4a576.akpm@linux-foundation.org>
In-Reply-To: <4970E4FB.7040407@redhat.com>
References: <496EB639.6090800@redhat.com>
	<4970E087.8020308@redhat.com>
	<4970E4FB.7040407@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 13:50:19 -0600
Eric Sandeen <sandeen@redhat.com> wrote:

> +void do_thaw_all(unsigned long unused)
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

Is there any reason why we're not taking the appropriate locks here?

If so, please add a comment justifying the implementation.

> +/**
> + * emergency_thaw_all -- forcibly thaw every frozen filesystem
> + *
> + * Used for emergency unfreeze of all filesystems via SysRq
> + */
> +void emergency_thaw_all(void)
> +{
> +	pdflush_operation(do_thaw_all, 0);
> +}
