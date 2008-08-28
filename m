Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbYH1AdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbYH1AdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 20:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757164AbYH1Acw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 20:32:52 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:34987 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756734AbYH1Acs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 20:32:48 -0400
Date: Thu, 28 Aug 2008 09:32:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Message-ID: <20080828003211.GA18893@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	"Alan D. Brunelle" <Alan.Brunelle@hp.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Ingo Molnar <mingo@elte.hu>, linux-embedded@vger.kernel.org
References: <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org> <20080826205916.GB11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org> <20080826232411.GC11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261648140.3363@nehalem.linux-foundation.org> <20080827002316.GE11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261726560.3363@nehalem.linux-foundation.org> <20080827115829.GF11734@cs181140183.pp.htv.fi> <20080827160052.GA15968@linux-sh.org> <20080827173544.GH11734@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827173544.GH11734@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 08:35:44PM +0300, Adrian Bunk wrote:
> On Thu, Aug 28, 2008 at 01:00:52AM +0900, Paul Mundt wrote:
> > On Wed, Aug 27, 2008 at 02:58:30PM +0300, Adrian Bunk wrote:
> > In addition to that, debugging the runaway stack users on 4k tends to be
> > easier anyways since you end up blowing the stack a lot sooner. On sh
> > we've had pretty good luck with it, though most of our users are using
> > fairly deterministic workloads and continually profiling the footprint.
> > Anything that runs away or uses an insane amount of stack space needs to
> > be fixed well before that anyways, so catching it sooner is always
> > preferable. I imagine the same case is true for m68knommu (even sans IRQ
> > stacks).
> 
> CONFIG_DEBUG_STACKOVERFLOW should give you the same information, and if
> wanted with an arbitrary limit.
> 
In some cases, yes. In the CONFIG_DEBUG_STACKOVERFLOW case the check is
only performed from do_IRQ(), which is sporadic at best, especially on
tickless. While it catches some things, it's not a complete solution in
and of iteslf.

In addition to this, there are even fewer platforms that support it than
there are platforms that do 4k stacks. At first glance, it looks like
it's only m32r, powerpc, sh, x86, and xtensa. Others support the Kconfig
option, but don't seem to realize that it's not an option that the kernel
does anything with by itself, and so don't actually do anything (ie,
FRV).

> > Things might be more sensitive on x86, but it's certainly not something
> > that's a huge problem for the various embedded platforms to wire up,
> > whether they want to go the IRQ stack route or not.
> 
> How many platforms use 4kB stacks on sh?
> 
> Only 1 out of 34 defconfigs uses it.
> 
The defconfigs tend to enable as much random stuff as people are
interested in for development and testing purposes. Most of these end up
being reference boards and are the basis for products, rather than
shipping products themselves. In the latter case, everything is gradually
tightened down, and 4k stack utilization in that case is the norm, rather
than the exception.

> > In any event, lack of support for something on embedded architectures in
> > the kernel is more often due to apathy/utter indifference on the part of
> > the architecture maintainer rather than being indicative of any intrinsic
> > difficulty in supporting the thing in question. Most new "features" on the
> > lesser maintained architectures tend to end up there either out of peer
> > pressure or copying-and-pasting accidents rather than any sort of design.
> > ;-)
> 
> arm or powerpc aren't exactly lesser maintained architectures.
> 
Indeed, which is why I find it bizarre that you would even bother
applying what was said to those platforms. Specifically I was referring
to the embedded platforms that don't do 4k stacks today. The fact they
don't support them today has much less to do with 4k being an
unattainable limit as it does with people simply not bothering to
implement it on their platform.

> IMHO there seems to currently be a mismatch between it's maintainance 
> cost and the actual number of users. That's in my opinion the main 
> problem with it, no matter in which direction it gets resolved.
> 
Perhaps that's true on x86, but in general I take issue with that. On sh
we've had to do very little maintenance for it and most shipping products
are using it today (at least on MMU-Linux, we don't bother with it on
nommu). Most of the problems we ran in to with 4k stacks tended to be
stuff that we wanted to fix for 8k anyways. I suspect that this case is
true for the other embedded platforms also.

Note that on sh we also conditionalize IRQ stacks separately, so while
they are often used together, it's possible to use 4k stacks without
resorting to IRQ stacks (as m68knommu also seems to do).
