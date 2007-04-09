Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbXDIXxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbXDIXxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 19:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbXDIXxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 19:53:46 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36161 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbXDIXxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 19:53:45 -0400
Date: Mon, 9 Apr 2007 16:53:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org
Subject: Re: per-thread rusage
Message-Id: <20070409165315.4704021f.akpm@linux-foundation.org>
In-Reply-To: <20070404181050.GN2986@holomorphy.com>
References: <20070404172931.GM2986@holomorphy.com>
	<20070404194829.1a93d8fd.dada1@cosmosbay.com>
	<20070404181050.GN2986@holomorphy.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007 11:10:50 -0700
William Lee Irwin III <wli@holomorphy.com> wrote:

> On Wed, 4 Apr 2007 10:29:31 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:
> >> It is not now possible for a thread to retrieve its own rusage in
> >> isolation. Its rusage is nowhere exposed without being intermixed with
> >> that of its sibling threads. This patch adds support for an
> >> RUSAGE_THREAD who argument that returns rusage for only the desired
> >> thread.
> 
> On Wed, Apr 04, 2007 at 07:48:29PM +0200, Eric Dumazet wrote:
> > Please check mm, because we now return ru_inblock and ru_oublock as well.
> > r->ru_inblock = task_io_get_inblock(p);
> > r->ru_oublock = task_io_get_oublock(p);
> 
> Respun vs. 2.6.21-rc5-mm4, still untested. Also...
> 
> Signed-off-by: William Irwin <bill.irwin@oracle.com>
> 
> 
> -- wli
> 
> 
> Index: mm-2.6.21-rc5-4/include/linux/resource.h
> ===================================================================
> --- mm-2.6.21-rc5-4.orig/include/linux/resource.h	2007-04-03 23:31:19.000000000 -0700
> +++ mm-2.6.21-rc5-4/include/linux/resource.h	2007-04-04 13:08:47.000000000 -0700
> @@ -18,7 +18,8 @@
>   */
>  #define	RUSAGE_SELF	0
>  #define	RUSAGE_CHILDREN	(-1)
> -#define RUSAGE_BOTH	(-2)		/* sys_wait4() uses this */
> +#define RUSAGE_THREAD	(-2)
> +#define RUSAGE_BOTH	(-3)		/* sys_wait4() uses this */
>  
>  struct	rusage {
>  	struct timeval ru_utime;	/* user time used */
> Index: mm-2.6.21-rc5-4/kernel/sys.c
> ===================================================================
> --- mm-2.6.21-rc5-4.orig/kernel/sys.c	2007-04-03 23:33:27.000000000 -0700
> +++ mm-2.6.21-rc5-4/kernel/sys.c	2007-04-04 13:11:17.000000000 -0700
> @@ -2074,6 +2074,16 @@
>  	}
>  
>  	switch (who) {
> +		case RUSAGE_THREAD:
> +			utime = p->utime;
> +			stime = p->stime;
> +			r->ru_nvcsw = p->nvcsw;
> +			r->ru_nivcsw = p->nivcsw;
> +			r->ru_minflt = p->min_flt;
> +			r->ru_majflt = p->maj_flt;
> +			r->ru_inblock = task_io_get_inblock(p);
> +			r->ru_oublock = task_io_get_oublock(p);
> +			break;
>  		case RUSAGE_BOTH:
>  		case RUSAGE_CHILDREN:
>  			utime = p->signal->cutime;
> @@ -2131,7 +2141,8 @@
>  
>  asmlinkage long sys_getrusage(int who, struct rusage __user *ru)
>  {
> -	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN)
> +	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN &&
> +						who != RUSAGE_THREAD)
>  		return -EINVAL;
>  	return getrusage(current, who, ru);
>  }

Seems sane.  Could we please get it tested and get a full description in
place?  Something which provides enough detail for the manpage maintainers.

Also, a quick comparison between Linux's RUSAGE_THREAD and $other-os's
implementations would reduce the possibility of silly, cast-in-stone
incompatabilities.



