Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbXGHMCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbXGHMCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 08:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757901AbXGHMBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 08:01:47 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46676 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758200AbXGHMBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 08:01:44 -0400
Date: Sun, 8 Jul 2007 07:58:06 -0400
Message-Id: <200707081158.l68Bw61u021912@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, ezk@cs.sunysb.edu,
       jsipek@cs.sunysb.edu, linux-kernel@vger.kernel.org,
       unionfs@filesystems.org, axboe@kernel.dk
Subject: Re: 2.6.22-rc6-mm1: UNION_FS=y + BLOCK=n = compile error 
In-reply-to: Your message of "Sat, 07 Jul 2007 04:01:42 +0200."
             <20070707020142.GA3492@stusta.de> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm adding Jens Axboe to the CC list (BLOCK layer maintainer).

In message <20070707020142.GA3492@stusta.de>, Adrian Bunk writes:
> On Thu, Jun 28, 2007 at 03:43:21AM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.22-rc4-mm2:
> >...
> >  git-unionfs.patch
> >...
> >  git trees
> >...
> 
> CONFIG_UNION_FS=y, CONFIG_BLOCK=n results in the following compile error:
> 
> <--  snip  -->
> 
> ...
>   CC      fs/unionfs/file.o
> /home/bunk/linux/kernel-2.6/linux-2.6.22-rc6-mm1/fs/unionfs/file.c:147: error: â€˜file_fsyncâ€™ undeclared here (not in a function)
> make[3]: *** [fs/unionfs/file.o] Error 1
> ...
> 
> <--  snip  -->
> 
> cu
> Adrian

Adrian, thanks.  I was able to reproduce this compiler error.  But I think
there may be a problem with the mainline kernel itself.

Unionfs defines its fsync file op to file_fsync.  file_fsync, defined in
fs/sync.c, appears to be a generic syncing function that can be used by
other file systems.  In fact, the comment above it says "Generic function to
fsync a file."  From fs/Makefile, it looks like sync.c gets compiled
regardless whether CONFIG_BLOCK is defined or not.

Moreover, file_fsync() makes a call to sync_blockdev(), clearly a function
which depends on CONFIG_BLOCK=y.  However, include/linux/buffer_head.h
defines sync_blockdev() to a noop if CONFIG_BLOCK=n:

  static inline int sync_blockdev(struct block_device *bdev) { return 0; }

This further indicates to me that someone went through the effort of making
file_fsync available and operational *even* if CONFIG_BLOCK=n.

But here's the problem: if CONFIG_BLOCK=n, the function file_fsync exists
and gets compiled into the kernel, but the extern definition for it is not
compiled in (it's wrapped in an #ifdef CONFIG_BLOCK in buffer_head.h).  This
looks to me like a discrepancy: why compile the file_fsync function, and
even ensure that it will find a dummy sync_blockdev() symbol, if one doesn't
provide an extern for it?

One more oddity: the EXPORT_SYMBOL for fs/sync.c:file_fsync() is in
fs/buffer.c, and buffer.c does not get compiled if CONFIG_BLOCK=n.  I
thought all EXPORT_SYMBOL calls are supposed to be near their respective
functions, no?

I suggest one of two things:

1. If you agree with me as to this discrepancy, then we can move the extern
   for file_fsync() outside the #ifdef CONFIG_BLOCK in buffer_head.h -- it
   should be defined regardless.  Then move the EXPORT_SYMBOL(file_fsync)
   from buffer.c to sync.  I can provide a small patch right away.

2. If you disagree, then I can change Unionfs to avoid calling file_fsync
   directly.  I can define a unionfs_fsync file method which does the usual
   stuff (pass the op to the layer below).

My preference is option #1; I'd like to avoid defining any more stackable
wrappers than I have to.

Thanks,
Erez.
