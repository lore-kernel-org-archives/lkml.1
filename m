Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753059AbYLRMrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbYLRMrY (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 07:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYLRMrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 07:47:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58074 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbYLRMrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 07:47:12 -0500
Date: Thu, 18 Dec 2008 13:46:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, venkatesh.pallipadi@intel.com,
        a.p.zijlstra@chello.nl, dipankar@in.ibm.com, balbir@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, ego@in.ibm.com, andi@firstfloor.org,
        davecb@sun.com, tconnors@astro.swin.edu.au, maxk@qualcomm.com,
        gregory.haskins@gmail.com, pavel@suse.cz,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 6/7] sched: add SD_BALANCE_NEWIDLE at MC and CPU
	level for sched_mc>0
Message-ID: <20081218124644.GA31733@elte.hu>
References: <20081217172309.534.28847.stgit@drishya.in.ibm.com> <20081217172738.534.3118.stgit@drishya.in.ibm.com> <20081217174254.ea19a246.akpm@linux-foundation.org> <20081218093538.GB4272@dirshya.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081218093538.GB4272@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:

> * Andrew Morton <akpm@linux-foundation.org> [2008-12-17 17:42:54]:
> 
> > On Wed, 17 Dec 2008 22:57:38 +0530
> > Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> > 
> > > --- a/include/linux/sched.h
> > > +++ b/include/linux/sched.h
> > > @@ -782,6 +782,16 @@ enum powersavings_balance_level {
> > >  	((sched_mc_power_savings || sched_smt_power_savings) ?	\
> > >  	 SD_POWERSAVINGS_BALANCE : 0)
> > 
> > What's with all the crappy macros in here?
> 
> Hi Andrew,
> 
> These macros set the SD_POWERSAVINGS_BALANCE flag based on the
> sysfs tunable.
>  
> > > +/*
> > > + * Optimise SD flags for power savings:
> > > + * SD_BALANCE_NEWIDLE helps agressive task consolidation and power savings.
> > > + * Keep default SD flags if sched_{smt,mc}_power_saving=0
> > > + */
> > > +
> > > +#define POWERSAVING_SD_FLAGS	\
> > > +	((sched_mc_power_savings || sched_smt_power_savings) ?	\
> > > +	  SD_BALANCE_NEWIDLE : 0)
> > 
> > This one purports to be a constant, but it isn't - it's code.
> > 
> > It would be cleaner, clearer and more idiomatic to do
> > 
> > static inline int powersaving_sd_flags(void)
> > {
> > 	...
> > }
> 
> Your are suggesting to move these to inline functions.   I will write
> a patch and post for review.
>  
> > Also, doing (sched_mc_power_savings | sched_smt_power_saving) might
> > save a branch.
> > 
> > >  #define test_sd_parent(sd, flag)	((sd->parent &&		\
> > >  					 (sd->parent->flags & flag)) ? 1 : 0)
> > 
> > buggy when passed an expression with side-effects.  Doesn't need to be
> > implemented as a macro.
> 
> Agreed, but these macros are used throughout sched.c and are performance 
> sensitive.  Inline functions are a close enough replacement for the 
> macro let me look for any performance penalty as well and report.

those macros are historic so feel free to convert them to inlines without 
re-measuring performance impact.

The patchset looks pretty good in principle otherwise, so if you could 
address Andrew's comments and clean up those bits in the next iteration we 
could start testing it in the scheduler tree. (Please also add Balbir 
Singh's acks to the next iteration.)

and please fix your mailer to not inject stuff like this:

 Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
        venkatesh.pallipadi@intel.com, a.p.zijlstra@chello.nl,
        mingo@elte.hu, dipankar@in.ibm.com, balbir@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, ego@in.ibm.com, andi@firstfloor.org,
        davecb@sun.com, tconnors@astro.swin.edu.au, maxk@qualcomm.com,
        gregory.haskins@gmail.com, pavel@suse.cz

It utterly messed up the addressing mode of my reply here and i had to 
edit the raw email headers manually to fix it up ;-)

	Ingo
