Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbZIJUio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbZIJUio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbZIJUin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:38:43 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:39527 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbZIJUin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:38:43 -0400
Subject: Re: [PATCH 18/16] implement posix O_SYNC and O_DSYNC semantics
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       drepper@redhat.com, viro@zeniv.linux.org.uk, kyle@mcmartin.ca
In-Reply-To: <20090910202521.GA20261@lst.de>
References: <1251899966-7316-1-git-send-email-jack@suse.cz>
	 <20090910202521.GA20261@lst.de>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 16:38:40 -0400
Message-Id: <1252615120.8722.148.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 9 msgs/h 2 sum rcpts/h 12 sum msgs/h 3 total rcpts 1391 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: E42F66EED4BC0D01E9CD5A0F9932479CEA2241DE
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 241 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 22:25 +0200, Christoph Hellwig wrote:
> Index: linux-2.6/fs/sync.c
> ===================================================================
> --- linux-2.6.orig/fs/sync.c	2009-09-10 16:30:32.414027738 -0300
> +++ linux-2.6/fs/sync.c	2009-09-10 16:31:19.042005715 -0300
> @@ -285,10 +285,11 @@ SYSCALL_DEFINE1(fdatasync, unsigned int,
>   */
>  int generic_write_sync(struct file *file, loff_t pos, loff_t count)
>  {
> -	if (!(file->f_flags & O_SYNC) && !IS_SYNC(file->f_mapping->host))
> +	if (!(file->f_flags & O_DSYNC) && !IS_SYNC(file->f_mapping->host))
>  		return 0;
>  	return vfs_fsync_range(file, file->f_path.dentry, pos,
> -			       pos + count - 1, 1);
> +			       pos + count - 1,
> +			       (file->f_flags & O_SYNC) ? 1 : 0);
>  }
>  EXPORT_SYMBOL(generic_write_sync);
>  
Shouldn't this be testing for

   file->f_flags & __O_SYNC

?

