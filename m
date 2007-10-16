Return-Path: <linux-kernel-owner+w=401wt.eu-S935694AbXJPXd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935694AbXJPXd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 19:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbXJPXdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 19:33:46 -0400
Received: from mga07.intel.com ([143.182.124.22]:42919 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757188AbXJPXdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 19:33:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,285,1188802800"; 
   d="scan'208";a="299860666"
Date: Tue, 16 Oct 2007 16:31:26 -0700
From: Mark Gross <mgross@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: 2.6.23-mm1
Message-ID: <20071016233126.GA23784@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <200710152240.03543.rjw@sisk.pl> <20071016195834.GA23157@linux.intel.com> <200710162228.14136.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710162228.14136.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 10:28:13PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, 16 October 2007 21:58, Mark Gross wrote:
> > On Mon, Oct 15, 2007 at 10:40:02PM +0200, Rafael J. Wysocki wrote:
> > > On Monday, 15 October 2007 18:09, Mark Gross wrote:
> > > > On Fri, Oct 12, 2007 at 11:32:40PM +0200, Rafael J. Wysocki wrote:
> > > > > On Friday, 12 October 2007 06:31, Andrew Morton wrote:
> > > > > > 
> > > > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> > > > > > 
> > > > > > - I've been largely avoiding applying anything since rc8-mm2 in an attempt
> > > > > >   to stabilise things for the 2.6.23 merge.
> > > > > > 
> > > > > >   But that didn't stop all the subsystem maintainers from going nuts, with
> > > > > >   the usual accuracy.  We're up to a 37MB diff now, but it seems to be working
> > > > > >   a bit better.
> > > > > 
> > > > > I get many traces similar to the one below from it (w/ hotfixes):
> > > > > 
> > > > > WARNING: at /home/rafael/src/mm/linux-2.6.23-mm1/arch/x86_64/kernel/smp.c:397 smp_call_function_mask()
> > > > 
> > > > This is from : WARN_ON(irqs_disabled()) in the cmp_call_function_mask
> > > > processor_idle.c is registering a acpi_processor_latency_notify 
> > > > 
> > > > my code changed the notifier call from blocking_notifier_call_chain to
> > > > srcu_notifier_call_chain, because dynamic creation of notifier chains at
> > > > runtime where easier with the srcu_notifier_call_chain than the
> > > > blocking_notifier_call_chain.  
> > > > 
> > > > As dynamic creation of PM_QOS parameters are no longer needed I can
> > > > change the notifiers back to match what was in lanency.c
> > > > 
> > > > However; looking at the call tree differences between
> > > > blockin_notifier_call_chain and srcu_notifier_call_chain I cannot see a
> > > > difference in irq enabling / disabling.  I'm not confident this will
> > > > address this yet.
> > > 
> > > Well, you can send me a patch to check. :-)
> > 
> > I think I'll have to send you a patch that changes the notifiers but I
> > doubt it will fix it.  
> > 
> > After a bit of messing around I have the 2.6.23-mm1 running on my core-2
> > box  note: Ubuntu's make-kpkg on the mm1 tree resulted in a system that
> > wouldn't boot past the intrd.  Looks like the pivot root failed or
> > something.
> > 
> > Anyway, I'm not reproducing your experience, snd_pcm is loaded.  I don't
> > know none of the WARN's are not hitting on my box.
> > 
> > do you have some configuration information that could help me reproduce
> > the issue?
> 
> Well, I can send you the .config, but the box is AMD-based (Turion 64 X2),
> with an ATI chipset and an HP BIOS, so it seems to be much different from
> yours.

it may be worth a shot anyway.  

BTW while changing my code to use the blocking notifiers I found that
there is a initialization race between cpu-idle and pm_qos I have to
fix.

I need to re factor my start up code to handle cpuidle registering
itself in as a notifier at core_initcall time.

I'll have a patch ready tomorrow.

thanks,

--mgross
