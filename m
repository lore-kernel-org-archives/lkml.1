Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZFGJym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZFGJym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 05:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbZFGJyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 05:54:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43727 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbZFGJye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 05:54:34 -0400
Date: Sun, 7 Jun 2009 11:54:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gary Hade <garyhade@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
       x86@kernel.org, yinghai@kernel.org, lcm@us.ibm.com
Subject: Re: [RESEND] [PATCH v2] [BUGFIX] x86/x86_64: fix CPU offlining
	triggered "inactive" device IRQ interrruption
Message-ID: <20090607095403.GG31286@elte.hu>
References: <20090602193202.GB7282@us.ibm.com> <m1hbyxv8ep.fsf@fess.ebiederm.org> <20090604163840.GB7233@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604163840.GB7233@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gary Hade <garyhade@us.ibm.com> wrote:

> On Wed, Jun 03, 2009 at 04:55:26AM -0700, Eric W. Biederman wrote:
> > Gary Hade <garyhade@us.ibm.com> writes:
> > 
> > > Impact: Eliminates a race that can leave the system in an
> > >         unusable state
> > >
> > > During rapid offlining of multiple CPUs there is a chance
> > > that an IRQ affinity move destination CPU will be offlined
> > > before the IRQ affinity move initiated during the offlining
> > > of a previous CPU completes.  This can happen when the device
> > > is not very active and thus fails to generate the IRQ that is
> > > needed to complete the IRQ affinity move before the move
> > > destination CPU is offlined.  When this happens there is an
> > > -EBUSY return from __assign_irq_vector() during the offlining
> > > of the IRQ move destination CPU which prevents initiation of
> > > a new IRQ affinity move operation to an online CPU.  This
> > > leaves the IRQ affinity set to an offlined CPU.
> > >
> > > I have been able to reproduce the problem on some of our
> > > systems using the following script.  When the system is idle
> > > the problem often reproduces during the first CPU offlining
> > > sequence.
> > 
> > Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > 
> > fixup_irqs() is broken for allowing such a thing.
> 
> When fixup_irqs() calls the set_affinity function:
>                    ...
>   if (desc->chip->set_affinity)
>   	desc->chip->set_affinity(irq, affinity);
>                    ...
> it receives no feedback so it obviously expects the set_affinity
> function or it's called functions to do the right thing by preventing
> or correctly handling any problems that should arise.  In the case of
> this bug there is obviously a problem happening during the set_affinity
> function call that needs to be resolved and/or properly handled.
> 
> When you made your "x86_64 irq: Safely cleanup an irq after moving it."
> changes (re: http://lkml.org/lkml/2007/2/23/92) you added the check
> to __assign_irq_vector() that causes it to return -EBUSY if the
> migration of the IRQ is still in progress:
> +	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
> +		return -EBUSY;
> +
> However, you did not add any code to other functions on the
> call stack to properly deal with this error.  When doing this
> you may have assumed (as I may have also assumed) that the underlying
> code was solid enough that the handling was not needed.  Unfortunately,
> you apparently did not anticipate the case where an idle or relatively
> idle device may not generate the IRQ needed to complete the move
> before the CPU that is still handling that IRQ is offlined.
> 
> My fix only addresses the issue that caused the -EBUSY return
> and subsequent mess.  It does not address the omitted handling
> for this error condition.  If we were to add the handling to
> fixup_irq() and the arch and non-arch specific functions above
> it on the call stack as you may be suggesting, it would be quite
> involved because of all the things that would need to be undone.
> 
> I am not certain that my fix plugs the very last hole that could 
> cause the -EBUSY return from __assign_irq_vector() so maybe we 
> should at least add a warning or BUG_ON to make the unhandled 
> error more obvious in the future.  I would be happy to provide 
> this via a separate patch.

A WARN_ON_ONCE() patch would certainly be nice, as a reminder and as 
a prodder-tool.

	Ingo
