Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbZGJPgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbZGJPgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 11:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbZGJPfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 11:35:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64035 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbZGJPfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 11:35:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] sched: Drop the need_resched() loop from cond_resched()
Date: Fri, 10 Jul 2009 17:35:29 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-2-generic; KDE/4.2.95; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1247237391-5352-1-git-send-email-fweisbec@gmail.com> <200907101717.39460.arnd@arndb.de> <20090710152425.GB5318@nowhere>
In-Reply-To: <20090710152425.GB5318@nowhere>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907101735.29463.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/YC9vksshAXgHljdF1mo+P1UwRKpgHhi12nDu
 4frzjlKecyHtBAzPYaAiHnlYjkqPrz/gglUjF12/ZtM9hndwRY
 djHhnY2gbX1eDcpBaq91A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 July 2009, Frederic Weisbecker wrote:
> On Fri, Jul 10, 2009 at 05:17:38PM +0200, Arnd Bergmann wrote:
> > On Friday 10 July 2009, Frederic Weisbecker wrote:
> > > --- a/kernel/sched.c
> > > +++ b/kernel/sched.c
> > > @@ -6613,11 +6613,9 @@ static void __cond_resched(void)
> > >          * PREEMPT_ACTIVE, which could trigger a second
> > >          * cond_resched() call.
> > >          */
> > > -       do {
> > > -               add_preempt_count(PREEMPT_ACTIVE);
> > > -               schedule();
> > > -               sub_preempt_count(PREEMPT_ACTIVE);
> > > -       } while (need_resched());
> > > +       add_preempt_count(PREEMPT_ACTIVE);
> > > +       schedule();
> > > +       sub_preempt_count(PREEMPT_ACTIVE);
> > >  }
> > >  
> > 
> > If you drop the loop, then you should also remove the comment that
> > explains why it was put there.
> > 
> 
> Hmm, these comments seem to actually explain why we do the PREEMPT_ACTIVE
> trick, which is to prevent from cond_resched() recursion, right?
> 

I think we both misinterpreted the comment, which seemed to refer
to older code added by Ingo in 5bbcfd900 "cond_resched(): fix bogus
might_sleep() warning" and removed by Andrew in e7b384043e2
"cond_resched() fix".

The original code in Ingos version looked like

 static inline void __cond_resched(void)
 {
       /*
        * The BKS might be reacquired before we have dropped
        * PREEMPT_ACTIVE, which could trigger a second
        * cond_resched() call.
        */
       if (unlikely(preempt_count()))
               return;
       do {
               add_preempt_count(PREEMPT_ACTIVE);
               schedule();
	...


So, it's got nothing to do with the loop, but should still be removed
because the 'if (unlikely(preempt_count()))' is no longer there.

	Arnd <><
