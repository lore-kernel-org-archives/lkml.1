Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbXGSGJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbXGSGJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 02:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbXGSGJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 02:09:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49049 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773AbXGSGJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 02:09:25 -0400
Date: Wed, 18 Jul 2007 23:09:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: linux-kernel@vger.kernel.org, shai@scalex86.org, mingo@elte.hu
Subject: Re: [patch] Change softlockup trigger limit using a kernel
 parameter
Message-Id: <20070718230907.741ae56c.akpm@linux-foundation.org>
In-Reply-To: <20070719054121.GA15074@localdomain>
References: <20070716222650.GA5947@localdomain>
	<20070718160858.75865461.akpm@linux-foundation.org>
	<20070719054121.GA15074@localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 22:41:21 -0700 Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> On Wed, Jul 18, 2007 at 04:08:58PM -0700, Andrew Morton wrote:
> > On Mon, 16 Jul 2007 15:26:50 -0700
> > Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
> >
> > > Kernel warns of softlockups if the softlockup thread is not able to run
> > > on a CPU for 10s.  It is useful to lower the softlockup warning
> > > threshold in testing environments to catch potential lockups early.
> > > Following patch adds a kernel parameter 'softlockup_lim' to control
> > > the softlockup threshold.
> > >
> >
> > Why not make it tunable at runtime?
> 
> Sure! Like a sysctl?
> 
> Here's a patch that does that (On top of Ingo's
> softlockup-improve-debug-output.patch)
>
> ...
>
> --- linux-2.6.22.orig/kernel/sysctl.c	2007-07-08 16:32:17.000000000 -0700
> +++ linux-2.6.22/kernel/sysctl.c	2007-07-18 21:05:57.877436750 -0700
> @@ -78,6 +78,7 @@ extern int percpu_pagelist_fraction;
>  extern int compat_log;
>  extern int maps_protect;
>  extern int sysctl_stat_interval;
> +extern int softlockup_thresh;

Just because sysctl.c does this all over the place doesn't make it right ;)
Please, if poss, find a header file for it.

>  /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
>  static int maxolduid = 65535;
> @@ -206,6 +207,10 @@ static ctl_table root_table[] = {
>  	{ .ctl_name = 0 }
>  };
>  
> +/* Constants for kernel table minimum and  maximum */
> +static int one = 1;
> +static int ten = 10;

I'd suggest that these go next to "zero", "two" and "one_hundred".  Move 'em
all to top-of-file where they should always have been.

>  static ctl_table kern_table[] = {
>  	{
>  		.ctl_name	= KERN_PANIC,
> @@ -615,6 +620,19 @@ static ctl_table kern_table[] = {
>  		.proc_handler   = &proc_dointvec,
>  	},
>  #endif
> +#ifdef CONFIG_DETECT_SOFTLOCKUP
> +	{
> +		.ctl_name	= KERN_SOFTLOCKUP_THRESHOLD,
> +		.procname	= "softlockup_thresh",
> +		.data		= &softlockup_thresh,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= &proc_dointvec_minmax,
> +		.strategy	= &sysctl_intvec,
> +		.extra1		= &one,
> +		.extra2		= &ten,
> +	},
> +#endif

argh.  There's supposed to be a big comment right here:

/*
 * NOTE: do not add new entries to this table unless you have read
 * Documentation/sysctl/ctl_unnumbered.txt
 */

I'll fix that up.  Please use CTL_UNNUMBERED.

>  };
> Index: linux-2.6.22/include/linux/sysctl.h
> ===================================================================
> --- linux-2.6.22.orig/include/linux/sysctl.h	2007-07-08 16:32:17.000000000 -0700
> +++ linux-2.6.22/include/linux/sysctl.h	2007-07-18 21:41:56.584347500 -0700
> @@ -165,6 +165,7 @@ enum
>  	KERN_MAX_LOCK_DEPTH=74,
>  	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
>  	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
> +	KERN_SOFTLOCKUP_THRESHOLD=77, /* int: softlockup tolerance threshold */
>  };

and zap this

> Index: linux-2.6.22/Documentation/sysctl/kernel.txt
> ===================================================================
> --- linux-2.6.22.orig/Documentation/sysctl/kernel.txt	2007-07-08 16:32:17.000000000 -0700
> +++ linux-2.6.22/Documentation/sysctl/kernel.txt	2007-07-18 22:07:29.460146250 -0700
> @@ -320,6 +320,14 @@ kernel.  This value defaults to SHMMAX.
>  
>  ==============================================================
>  
> +softlockup_thresh:
> +
> +This value can be used to lower the softlockup tolerance
> +threshold. The default threshold is 10s.  If a cpu is locked up
> +for 10s, the kernel complains.  Valid values are 1-10s.
> +

neato.
