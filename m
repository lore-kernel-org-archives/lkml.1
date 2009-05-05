Return-Path: <linux-kernel-owner+w=401wt.eu-S1758449AbZEEWUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbZEEWUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 18:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755670AbZEEWUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 18:20:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52201 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbZEEWUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 18:20:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Date: Wed, 6 May 2009 00:19:35 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905050023.38064.rjw@sisk.pl> <alpine.DEB.2.00.0905041735590.24101@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0905041735590.24101@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905060019.36542.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 May 2009, David Rientjes wrote:
> On Tue, 5 May 2009, Rafael J. Wysocki wrote:
> 
> > Index: linux-2.6/kernel/power/process.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/power/process.c
> > +++ linux-2.6/kernel/power/process.c
> > @@ -19,6 +19,8 @@
> >   */
> >  #define TIMEOUT	(20 * HZ)
> >  
> > +static bool tasks_frozen;
> > +
> >  static inline int freezeable(struct task_struct * p)
> >  {
> >  	if ((p == current) ||
> > @@ -120,6 +122,10 @@ int freeze_processes(void)
> >   Exit:
> >  	BUG_ON(in_atomic());
> >  	printk("\n");
> > +
> > +	if (!error)
> > +		tasks_frozen = true;
> > +
> >  	return error;
> >  }
> >  
> > @@ -145,6 +151,8 @@ static void thaw_tasks(bool nosig_only)
> >  
> >  void thaw_processes(void)
> >  {
> > +	tasks_frozen = false;
> > +
> >  	printk("Restarting tasks ... ");
> >  	thaw_tasks(true);
> >  	thaw_tasks(false);
> > @@ -152,3 +160,7 @@ void thaw_processes(void)
> >  	printk("done.\n");
> >  }
> >  
> > +bool processes_are_frozen(void)
> > +{
> > +	return tasks_frozen;
> > +}
> > Index: linux-2.6/include/linux/freezer.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/freezer.h
> > +++ linux-2.6/include/linux/freezer.h
> > @@ -50,6 +50,7 @@ extern int thaw_process(struct task_stru
> >  extern void refrigerator(void);
> >  extern int freeze_processes(void);
> >  extern void thaw_processes(void);
> > +extern bool processes_are_frozen(void);
> >  
> >  static inline int try_to_freeze(void)
> >  {
> > @@ -170,6 +171,7 @@ static inline int thaw_process(struct ta
> >  static inline void refrigerator(void) {}
> >  static inline int freeze_processes(void) { BUG(); return 0; }
> >  static inline void thaw_processes(void) {}
> > +static inline bool processes_are_frozen(void) { return false; }
> >  
> >  static inline int try_to_freeze(void) { return 0; }
> >  
> > Index: linux-2.6/mm/page_alloc.c
> > ===================================================================
> > --- linux-2.6.orig/mm/page_alloc.c
> > +++ linux-2.6/mm/page_alloc.c
> > @@ -46,6 +46,7 @@
> >  #include <linux/page-isolation.h>
> >  #include <linux/page_cgroup.h>
> >  #include <linux/debugobjects.h>
> > +#include <linux/freezer.h>
> >  
> >  #include <asm/tlbflush.h>
> >  #include <asm/div64.h>
> > @@ -1599,7 +1600,8 @@ nofail_alloc:
> >  					zonelist, high_zoneidx, alloc_flags);
> >  		if (page)
> >  			goto got_pg;
> > -	} else if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
> > +	} else if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)
> > +			&& !processes_are_frozen()) {
> >  		if (!try_set_zone_oom(zonelist, gfp_mask)) {
> >  			schedule_timeout_uninterruptible(1);
> >  			goto restart;
> 
> Cool, that looks like the semantics of __GFP_NO_OOM_KILL without requiring 
> a new gfp flag.  Thanks.

Well, you're welcome.

BTW, I think that Andrew was actually right when he asked if I checked whether
the existing __GFP_NORETRY would work as-is for __GFP_FS set and
__GFP_NORETRY unset.  Namely, in that case we never reach the code before
nopage: that checks __GFP_NORETRY, do we?

So I think we shouldn't modify the 'else if' condition above and check for
!processes_are_frozen() at the beginning of the block below.

Thanks,
Rafael

