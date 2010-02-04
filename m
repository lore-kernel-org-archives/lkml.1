Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab0BDAW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 19:22:58 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50106 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab0BDAW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 19:22:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: John Kacur <jkacur@redhat.com>
Subject: Re: [RFC][PATCH] vmscan: balance local_irq_disable() and  local_irq_enable()
Cc: kosaki.motohiro@jp.fujitsu.com, rostedt@goodmis.org,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org
In-Reply-To: <520f0cf11002031212p4f1497e3he82dce3af668e676@mail.gmail.com>
References: <1265227746.24386.15.camel@gandalf.stny.rr.com> <520f0cf11002031212p4f1497e3he82dce3af668e676@mail.gmail.com>
Message-Id: <20100204091938.C2C6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  4 Feb 2010 09:22:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Feb 3, 2010 at 9:09 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > t On Wed, 2010-02-03 at 20:53 +0100, John Kacur wrote:
> >> Balance local_irq_disable() and local_irq_enable() as well as
> >> spin_lock_irq() and spin_lock_unlock_irq
> >>
> >> Signed-off-by: John Kacur <jkacur@redhat.com>
> >> ---
> >>  mm/vmscan.c |    3 ++-
> >>  1 files changed, 2 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >> index c26986c..b895025 100644
> >> --- a/mm/vmscan.c
> >> +++ b/mm/vmscan.c
> >> @@ -1200,8 +1200,9 @@ static unsigned long shrink_inactive_list(unsigned long max_scan,
> >>               if (current_is_kswapd())
> >>                       __count_vm_events(KSWAPD_STEAL, nr_freed);
> >>               __count_zone_vm_events(PGSTEAL, zone, nr_freed);
> >> +             local_irq_enable();
> >>
> >> -             spin_lock(&zone->lru_lock);
> >> +             spin_lock_irq(&zone->lru_lock);
> >>               /*
> >>                * Put back any unfreeable pages.
> >>                */
> >
> >
> > The above looks wrong. I don't know the code, but just by looking at
> > where the locking and interrupts are, I can take a guess.
> >
> > Lets add a little more of the code:
> >
> >                local_irq_disable();
> >                if (current_is_kswapd())
> >                        __count_vm_events(KSWAPD_STEAL, nr_freed);
> >                __count_zone_vm_events(PGSTEAL, zone, nr_freed);
> >
> >                spin_lock(&zone->lru_lock);
> >                /*
> >
> > I'm guessing the __count_zone_vm_events and friends need interrupts
> > disabled here, probably due to per cpu stuff. But if you enable
> > interrupts before the spin_lock() you may let an interrupt come in and
> > invalidate what was done above it.
> >
> > So no, I do not think enabling interrupts here is a good thing.
> >
> 
> okay, and since we have already done local_irq_disable(), then that is
> why we only need the spin_lock() and not the spin_lock_irq() flavour?

Yes, spin_lock_irq() is equivalent to spin_lock() + irq_disable().
Now, we already disabled irq. then, we only need spin_lock().

So, I don't think shrink_inactive_list need any fix.


