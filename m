Return-Path: <linux-kernel-owner+w=401wt.eu-S1763418AbZLQAHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763418AbZLQAHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762949AbZLQAHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:07:34 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:43056 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761273AbZLQAHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:07:33 -0500
Date: Thu, 17 Dec 2009 11:07:30 +1100
From: Simon Horman <horms@verge.net.au>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] timers: Remove duplicate setting of new_base in
 __mod_timer()
Message-ID: <20091217000730.GB25317@verge.net.au>
References: <20091216222028.GA15841@verge.net.au>
 <alpine.LFD.2.00.0912170053400.2755@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912170053400.2755@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 12:58:27AM +0100, Thomas Gleixner wrote:
> B1;2005;0cSimon,
> 
> On Thu, 17 Dec 2009, Simon Horman wrote:
> 
> > I am wondering if the first line of the following snippet of
> > __mod_timer() can be removed as new_base always seems to be reset.
> 
> Good catch.
>  
> > Alternatively perhaps smp_processor_id() and  per_cpu() could
> > be moved to inside the #if and the call to __get_cpu_var() moved to
> > inside #else ?
> 
> Nah, __get_cpu_var does a smp_processor_id() anyway. Removing that
> first new_base assignment is the right thing to do.
> 
> >         new_base = __get_cpu_var(tvec_bases);
> > 
> >         cpu = smp_processor_id();
> >         
> > #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
> >         if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu)) {
> >                 int preferred_cpu = get_nohz_load_balancer();
> >                         
> >                 if (preferred_cpu >= 0)
> >                         cpu = preferred_cpu;
> >         }
> > #endif
> >         new_base = per_cpu(tvec_bases, cpu);
> > 
> > Signed-off-by: Simon Horman <horms@verge.net.au>
> > 
> > Index: linux-2.6/kernel/timer.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/timer.c	2009-12-17 07:02:57.000000000 +0900
> > +++ linux-2.6/kernel/timer.c	2009-12-17 07:03:17.000000000 +0900
> > @@ -656,8 +656,6 @@ __mod_timer(struct timer_list *timer, un
> >  
> >  	debug_activate(timer, expires);
> >  
> > -	new_base = __get_cpu_var(tvec_bases);
> > -
> >  	cpu = smp_processor_id();
> >  
> >  #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
> 
> Could you please resend the patch with a proper change log ?

Will do.

