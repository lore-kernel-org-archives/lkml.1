Return-Path: <linux-kernel-owner+w=401wt.eu-S1760688AbYJITwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760688AbYJITwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 15:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbYJITvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 15:51:55 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55305 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbYJITvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 15:51:54 -0400
To: torvalds@linux-foundation.org
CC: miklos@szeredi.hu, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <alpine.LFD.2.00.0810091218300.3210@nehalem.linux-foundation.org>
	(message from Linus Torvalds on Thu, 9 Oct 2008 12:22:23 -0700 (PDT))
Subject: Re: splice vs O_APPEND
References: <E1Knx26-0003ds-Ch@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810090830170.3210@nehalem.linux-foundation.org> <E1Knxzm-0003y2-Jy@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810090908200.3210@nehalem.linux-foundation.org>
 <E1KnyOw-00044y-K4@pomaz-ex.szeredi.hu> <alpine.LFD.2.00.0810091218300.3210@nehalem.linux-foundation.org>
Message-Id: <E1Ko1Xu-0004vP-EX@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 09 Oct 2008 21:51:38 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Oct 2008, Linus Torvalds wrote:
> Of course, I think POSIX is crazy, and we probably _should_ always honor 
> O_APPEND, and returning -EINVAL is the right thing for both pwrite and 
> splice, but this is all a murkier issue than it looked like originally, 
> and any possible "security" implications are dubious in that you cannot 
> really depend on O_APPEND/IS_APPEND anyway.

The thing is, the append-only attribute is absolutely useless without
being able to depend on it.  So in that sense I think the IS_APPEND
issue is important, and I'm fine with your original proposal for that
(except we don't need the IS_IMMUTABLE check).

I also agree that the O_APPEND issue is murky and should probably be
discussed separately.

Thanks,
Miklos
----

Subject: splice: disallow random writes for append-only inodes

From: Linus Torvalds <torvalds@linux-foundation.org>

It was possible to write to a random location in an append-only file
using splice.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/splice.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2008-10-09 21:46:07.000000000 +0200
+++ linux-2.6/fs/splice.c	2008-10-09 21:47:42.000000000 +0200
@@ -891,6 +891,7 @@ static long do_splice_from(struct pipe_i
 			   loff_t *ppos, size_t len, unsigned int flags)
 {
 	int ret;
+	struct inode *inode;
 
 	if (unlikely(!out->f_op || !out->f_op->splice_write))
 		return -EINVAL;
@@ -898,6 +899,10 @@ static long do_splice_from(struct pipe_i
 	if (unlikely(!(out->f_mode & FMODE_WRITE)))
 		return -EBADF;
 
+	inode = out->f_dentry->d_inode;
+	if (IS_APPEND(inode))
+		return -EINVAL;
+
 	ret = rw_verify_area(WRITE, out, ppos, len);
 	if (unlikely(ret < 0))
 		return ret;
