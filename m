Return-Path: <linux-kernel-owner+w=401wt.eu-S1758349AbXGCW0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349AbXGCW0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 18:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbXGCWZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 18:25:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33226 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757397AbXGCWZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 18:25:50 -0400
Date: Tue, 3 Jul 2007 15:25:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: bbpetkov@yahoo.de
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix error handling in ext3_create_journal
Message-Id: <20070703152543.e58ad39a.akpm@linux-foundation.org>
In-Reply-To: <20070701221111.GA8627@gollum.tnic>
References: <20070701221111.GA8627@gollum.tnic>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2007 00:11:11 +0200
Borislav Petkov <bbpetkov@yahoo.de> wrote:

> 
> ---
> From: Borislav Petkov <bbpetkov@yahoo.de>
> 
> Fix error handling in ext3_create_journal according to kernel conventions.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> --
> 
> Index: linux-2.6.22-rc6/fs/ext3/super.c
> ===================================================================
> --- linux-2.6.22-rc6/fs/ext3/super.c.orig	2007-07-01 21:12:51.000000000 +0200
> +++ linux-2.6.22-rc6/fs/ext3/super.c	2007-07-01 21:14:32.000000000 +0200
> @@ -2075,6 +2075,7 @@
>  			       unsigned int journal_inum)
>  {
>  	journal_t *journal;
> +	int err;
>  
>  	if (sb->s_flags & MS_RDONLY) {
>  		printk(KERN_ERR "EXT3-fs: readonly filesystem when trying to "
> @@ -2082,13 +2083,15 @@
>  		return -EROFS;
>  	}
>  
> -	if (!(journal = ext3_get_journal(sb, journal_inum)))
> +	journal = ext3_get_journal(sb, journal_inum);
> +	if (!journal)
>  		return -EINVAL;
>  
>  	printk(KERN_INFO "EXT3-fs: creating new journal on inode %u\n",
>  	       journal_inum);
>  
> -	if (journal_create(journal)) {
> +	err = journal_create(journal);
> +	if (err) {
>  		printk(KERN_ERR "EXT3-fs: error creating journal.\n");
>  		journal_destroy(journal);
>  		return -EIO;

Please prepare the equivalent patch for ext4.  Without that, it'd probably
be better to avoid applying the ext3 patch: there are advantages to keeping
the two in sync where possible.

