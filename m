Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbZFIUrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbZFIUrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 16:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755769AbZFIUrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 16:47:03 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58268 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729AbZFIUrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 16:47:01 -0400
Date: Tue, 9 Jun 2009 13:46:50 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, Gary Hade <garyhade@us.ibm.com>,
       mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       hpa@zytor.com, x86@kernel.org, yinghai@kernel.org, lcm@us.ibm.com
Subject: Re: [RESEND] [PATCH v2] [BUGFIX] x86/x86_64: fix CPU offlining
	triggered "inactive" device IRQ interrruption
Message-ID: <20090609204650.GB7282@us.ibm.com>
References: <20090602193202.GB7282@us.ibm.com> <m1hbyxv8ep.fsf@fess.ebiederm.org> <20090604163840.GB7233@us.ibm.com> <20090607095403.GG31286@elte.hu> <m1hbyqcz3x.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hbyqcz3x.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 12:19:30PM -0700, Eric W. Biederman wrote:
> Ingo Molnar <mingo@elte.hu> writes:
> 
> > * Gary Hade <garyhade@us.ibm.com> wrote:
> >
> >> On Wed, Jun 03, 2009 at 04:55:26AM -0700, Eric W. Biederman wrote:
> >> > Gary Hade <garyhade@us.ibm.com> writes:
> >> > 
> >> > > Impact: Eliminates a race that can leave the system in an
> >> > >         unusable state
> >> > >
> >> > > During rapid offlining of multiple CPUs there is a chance
> >> > > that an IRQ affinity move destination CPU will be offlined
> >> > > before the IRQ affinity move initiated during the offlining
> >> > > of a previous CPU completes.  This can happen when the device
> >> > > is not very active and thus fails to generate the IRQ that is
> >> > > needed to complete the IRQ affinity move before the move
> >> > > destination CPU is offlined.  When this happens there is an
> >> > > -EBUSY return from __assign_irq_vector() during the offlining
> >> > > of the IRQ move destination CPU which prevents initiation of
> >> > > a new IRQ affinity move operation to an online CPU.  This
> >> > > leaves the IRQ affinity set to an offlined CPU.
> >> > >
> >> > > I have been able to reproduce the problem on some of our
> >> > > systems using the following script.  When the system is idle
> >> > > the problem often reproduces during the first CPU offlining
> >> > > sequence.
> >> > 
> >> > Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> >> > 
> >> > fixup_irqs() is broken for allowing such a thing.
> >> 
> >> When fixup_irqs() calls the set_affinity function:
> >>                    ...
> >>   if (desc->chip->set_affinity)
> >>   	desc->chip->set_affinity(irq, affinity);
> >>                    ...
> >> it receives no feedback so it obviously expects the set_affinity
> >> function or it's called functions to do the right thing by preventing
> >> or correctly handling any problems that should arise.  In the case of
> >> this bug there is obviously a problem happening during the set_affinity
> >> function call that needs to be resolved and/or properly handled.
> >> 
> >> When you made your "x86_64 irq: Safely cleanup an irq after moving it."
> >> changes (re: http://lkml.org/lkml/2007/2/23/92) you added the check
> >> to __assign_irq_vector() that causes it to return -EBUSY if the
> >> migration of the IRQ is still in progress:
> >> +	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
> >> +		return -EBUSY;
> >> +
> >> However, you did not add any code to other functions on the
> >> call stack to properly deal with this error.  When doing this
> >> you may have assumed (as I may have also assumed) that the underlying
> >> code was solid enough that the handling was not needed.  Unfortunately,
> >> you apparently did not anticipate the case where an idle or relatively
> >> idle device may not generate the IRQ needed to complete the move
> >> before the CPU that is still handling that IRQ is offlined.
> >> 
> >> My fix only addresses the issue that caused the -EBUSY return
> >> and subsequent mess.  It does not address the omitted handling
> >> for this error condition.  If we were to add the handling to
> >> fixup_irq() and the arch and non-arch specific functions above
> >> it on the call stack as you may be suggesting, it would be quite
> >> involved because of all the things that would need to be undone.
> >> 
> >> I am not certain that my fix plugs the very last hole that could 
> >> cause the -EBUSY return from __assign_irq_vector() so maybe we 
> >> should at least add a warning or BUG_ON to make the unhandled 
> >> error more obvious in the future.  I would be happy to provide 
> >> this via a separate patch.
> >
> > A WARN_ON_ONCE() patch would certainly be nice, as a reminder and as 
> > a prodder-tool.
> 
> In fixup_irqs such a warning would be reasonable.  In assign_irq_vector
> it makes no sense.
> 
> I just read through the code.  Anything that assumes assign_irq_vector
> will always succeed is BROKEN.  We can not guarantee it.  There are
> also memory allocation failures and the fundamental problem that we
> may have more irqs than can fit on a single cpu.

Yes, I am certain that there are other bugs lurking that haven't
yet manifested into real and serious failures.  I am simply
proposing that we fix one very serious bug that has.

> 
> Furthermore while we require at least two irqs to complete a irq migration
> I don't believe we can avoid returning -EBUSY there.

I didn't see anything in send_cleanup_vector() such as a memory
allocation failure (already handled there) that, in the absense
of a yet to be discoverd bug, should prevent cfg->move_in_progress
from getting zeroed.  Assuming a memory allocation failure in
send_cleanup_vector() that brings cfg->move_cleanup_count into
the picture, I didn't see anything, in the absense of a yet to
be discovered bug, in smp_irq_move_cleanup_interrupt() that I
thought would prevent cfg->move_cleanup_count from getting
decremented to zero.

If you are still uncomfortable with this, the WARN_ON_ONCE
could be limited to the instances where the CPU is being offlined
i.e. the case that is known to be so very destructive.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

