Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbYBSVMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbYBSVMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYBSVM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:12:29 -0500
Received: from mail.gmx.net ([213.165.64.20]:38489 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752719AbYBSVM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:12:28 -0500
X-Authenticated: #36809985
X-Provags-ID: V01U2FsdGVkX19ReOJP4WZRMDawf+cUf9a2REonD0t+hqxj9O2sAH
	lgwXcrT6guDVdW
Subject: Re: [PATCH] splice: fix problem with sys_tee and SPLICE_F_NONBLOCK
From: Johann Felix Soden <johfel@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Johann Felix Soden <johfel@gmx.de>, Patrick McManus <mcmanus@ducksong.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080219202543.GK23197@kernel.dk>
References: <1203452091.7758.5.camel@localhost>
	 <20080219202543.GK23197@kernel.dk>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 22:12:18 +0100
Message-Id: <1203455538.7758.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Feb 19 2008, Johann Felix Soden wrote:
> > From: Johann Felix Soden <johfel@users.sourceforge.net>
> > 
> > With SPLICE_F_NONBLOCK sys_tee should return number of duplicated bytes,
> > not only -EAGAIN on success.
> 
> ?
> 
> The current behaviour is to return bytes tee'd, or return -EAGAIN for
> zero bytes if SPLICE_F_NONBLOCK is set. It doesn't return "-EAGAIN on
> success", not sure what you mean there.
> 
Sorry, my patch description was not correct. 

The new behavior of sys_tee with my patch is: 
	- return -EAGAIN if there are no data in the pipe, but writer
	  connected to the pipe, 
	- return 0 if there are not writers connected
	- else return number of duplicated byte 

The old behavior was: return -EAGAIN or the number (>0) of duplicated
bytes.

> > This patch also solves the problem, which is described on
> > http://article.gmane.org/gmane.linux.kernel/642502.
> > 
> > Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
> > ---
> >  fs/splice.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/splice.c b/fs/splice.c
> > index 9b559ee..184fd66 100644
> > --- a/fs/splice.c
> > +++ b/fs/splice.c
> > @@ -1711,7 +1711,7 @@ static long do_tee(struct file *in, struct file *out, size_t len,
> >  			ret = link_opipe_prep(opipe, flags);
> >  			if (!ret) {
> >  				ret = link_pipe(ipipe, opipe, len, flags);
> > -				if (!ret && (flags & SPLICE_F_NONBLOCK))
> > +				if (ret < 0 && (flags & SPLICE_F_NONBLOCK))
> >  					ret = -EAGAIN;
> >  			}
> >  		}
> 
> Perhaps it's just me, but this doesn't make a lot of sense. You override
> any other error with EAGAIN, hm? In fact the only < 0 value that
> link_pipe() will return is -EPIPE, which is perfectly in sync with that
> a pipe write will return if there are no readers attached.

The reason, why I wrote the patch, was, that the example program
mentioned in manpage of tee(2) doesn't stop, if it used like
cat textfile | tee_example outfile | wc because sys_tee returns only
-EAGAIN or the duplicated bytes, not something like EOF.

See also http://article.gmane.org/gmane.linux.kernel/642502. 
Patrick McManus described the problem there.

--

Johann Felix Soden

