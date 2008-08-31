Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbYHaRvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbYHaRvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 13:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbYHaRvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 13:51:05 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45105 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbYHaRvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 13:51:03 -0400
Date: Sun, 31 Aug 2008 10:51:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, jes@sgi.com,
       manfred@colorfullife.com, akpm@linux-foundation.org
Subject: Re: [PATCH] prevent ia64 from invoking irq handlers on offline CPUs
Message-ID: <20080831175100.GD7015@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080831172814.GA15087@linux.vnet.ibm.com> <19f34abd0808311046g47907414wf3ef939d0a7bbfdb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808311046g47907414wf3ef939d0a7bbfdb@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 07:46:33PM +0200, Vegard Nossum wrote:
> On Sun, Aug 31, 2008 at 7:28 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > Make ia64 refrain from clearing a given to-be-offlined CPU's bit in the
> > cpu_online_mask until it has processed pending irqs.  This change
> > prevents other CPUs from being blindsided by an apparently offline CPU
> > nevertheless changing globally visible state.
> >
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >
> >  smpboot.c |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
> > index bcea81e..7a90f42 100644
> > --- a/arch/ia64/kernel/smpboot.c
> > +++ b/arch/ia64/kernel/smpboot.c
> > @@ -741,8 +741,6 @@ int __cpu_disable(void)
> >                        return -EBUSY;
> >        }
> >
> > -       cpu_clear(cpu, cpu_online_map);
> > -
> >        if (migrate_platform_irqs(cpu)) {
> >                cpu_set(cpu, cpu_online_map);
> >                return (-EBUSY);
> > @@ -751,6 +749,7 @@ int __cpu_disable(void)
> >        remove_siblinginfo(cpu);
> >        cpu_clear(cpu, cpu_online_map);
> >        fixup_irqs();
> > +       cpu_clear(cpu, cpu_online_map);
> >        local_flush_tlb_all();
> >        cpu_clear(cpu, cpu_callin_map);
> >        return 0;
> 
> Hm. Maybe my eyes are going bad. But isn't that now clearing the cpu
> both before and after calling fixup_irqs()?

I don't believe so...  I removed the earlier one and added the later
one.  Or is there another one hidden somewhere that I missed?

							Thanx, Paul
