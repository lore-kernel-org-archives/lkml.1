Return-Path: <linux-kernel-owner+w=401wt.eu-S1761983AbYBTJfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761983AbYBTJfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 04:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbYBTJfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 04:35:33 -0500
Received: from brick.kernel.dk ([87.55.233.238]:15137 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756102AbYBTJfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 04:35:31 -0500
Date: Wed, 20 Feb 2008 10:35:28 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Johann Felix Soden <johfel@gmx.de>
Cc: Patrick McManus <mcmanus@ducksong.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splice: fix problem with sys_tee and SPLICE_F_NONBLOCK
Message-ID: <20080220093528.GU23197@kernel.dk>
References: <1203452091.7758.5.camel@localhost> <20080219202543.GK23197@kernel.dk> <1203455538.7758.17.camel@localhost> <20080219212530.GN23197@kernel.dk> <1203457661.7758.31.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203457661.7758.31.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19 2008, Johann Felix Soden wrote:
> 
> Am Dienstag, den 19.02.2008, 22:25 +0100 schrieb Jens Axboe:
> > On Tue, Feb 19 2008, Johann Felix Soden wrote:
> > > > On Tue, Feb 19 2008, Johann Felix Soden wrote:
> > > > > From: Johann Felix Soden <johfel@users.sourceforge.net>
> > > > > 
> > > > > With SPLICE_F_NONBLOCK sys_tee should return number of duplicated bytes,
> > > > > not only -EAGAIN on success.
> > > > 
> > > > ?
> > > > 
> > > > The current behaviour is to return bytes tee'd, or return -EAGAIN for
> > > > zero bytes if SPLICE_F_NONBLOCK is set. It doesn't return "-EAGAIN on
> > > > success", not sure what you mean there.
> > > > 
> > > Sorry, my patch description was not correct. 
> > > 
> > > The new behavior of sys_tee with my patch is: 
> > > 	- return -EAGAIN if there are no data in the pipe, but writer
> > > 	  connected to the pipe, 
> > > 	- return 0 if there are not writers connected
> > > 	- else return number of duplicated byte 
> > > 
> > > The old behavior was: return -EAGAIN or the number (>0) of duplicated
> > > bytes.
> > 
> > Your patch has an odd way of achieving that goal, modify the real
> > location of the assignment instead of overriding something. That has the
> > potential to turn into another confusing bug later on, wondering why the
> > heck your return value isn't being passed back.
> > 
> > Improvement is welcome though, you can't distuingish -EAGAIN on the
> > input side from the output side currently.
> > 
> 
> I thought again about the problem and my patch: you are right, the patch
> is nonsense. I have learnt, that the correctness of a patch is not
> guaranteed by the (bad, but anyhow working) solution of the problem the
> patch was written for.
> Sorry for wasting your time.

Don't worry, it's not a waste of time even though your solution isn't
the correct one.

When non-blocking is set, ideally we want to return 0 if there's no hope
of anymore data and EAGAIN if trying later may yield some data. So how
about this instead?

diff --git a/fs/splice.c b/fs/splice.c
index 9b559ee..0670c91 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1669,6 +1669,13 @@ static int link_pipe(struct pipe_inode_info *ipipe,
 		i++;
 	} while (len);
 
+	/*
+	 * return EAGAIN if we have the potential of some data in the
+	 * future, otherwise just return 0
+	 */
+	if (!ret && ipipe->waiting_writers && (flags & SPLICE_F_NONBLOCK))
+		ret = -EAGAIN;
+
 	inode_double_unlock(ipipe->inode, opipe->inode);
 
 	/*
@@ -1709,11 +1716,8 @@ static long do_tee(struct file *in, struct file *out, size_t len,
 		ret = link_ipipe_prep(ipipe, flags);
 		if (!ret) {
 			ret = link_opipe_prep(opipe, flags);
-			if (!ret) {
+			if (!ret)
 				ret = link_pipe(ipipe, opipe, len, flags);
-				if (!ret && (flags & SPLICE_F_NONBLOCK))
-					ret = -EAGAIN;
-			}
 		}
 	}
 

-- 
Jens Axboe

