Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbYHAVDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbYHAVDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757222AbYHAVDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:03:04 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43648 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072AbYHAVDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:03:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cliff Wickman <cpw@sgi.com>
Cc: Alan Mayer <ajm@sgi.com>, jeremy@goop.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Dean Nelson <dcn@sgi.com>
References: <48922D16.1080704@sgi.com> <m13alp1z8w.fsf@frodo.ebiederm.org>
	<20080801155120.GA21706@sgi.com>
Date: Fri, 01 Aug 2008 14:00:16 -0700
In-Reply-To: <20080801155120.GA21706@sgi.com> (Cliff Wickman's message of
	"Fri, 1 Aug 2008 10:51:20 -0500")
Message-ID: <m18wvgv4bj.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Cliff Wickman <cpw@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] x86_64:  Dynamically allocate arch specific system vectors
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cliff Wickman <cpw@sgi.com> writes:
>
> I assume you mean create_irq() and destroy_irq().
> They are close to what we need.

Actually that isn't quite what I was thinking.

> However for any given system use:
> - we need to request a high priority vector for some irq's, rather than
>   one randomly allocated as per __assign_irq_vector().

Well I was actually thinking mostly about reusing assign_irq_vector.

The high priority vector seems to be the place where we would need
to reexamine the vector allocator.

> - we want the irq/vector to be targeted to all cpu's (as specified in a
>   mask,
>   and can include currently offline cpu's) rather than a single cpu. 

__assign_irq_vector should be able to handle that case.

> I suppose those abilities could be added to create_irq(), but we didn't
> want to intrude into that interface.

Right.  That part gets custom and there is no intersection.

> A smaller consideration is simplicity of use.  We want any such user to
> use
> the generic do_IRQ() flow (not alloc_intr_gate()).

My primary concern is that you are generalizing an interface that is
designed for alloc_intr_gate consumers.  In particular for people
who wish to allocate vectors that can be triggered by software to
do this.

If this is normal irq handling I would really prefer to use the
normal data structures that we use for allocating vectors to irqs,
because that is what you are doing.

> But make it easy to set
> up the irq/vector, irq_chip and irq_desc without getting intimate with
> the details.
> I suppose some other wrapper for an enhanced create_irq() could be done.
>
> We are going to need such irq/vector pairs for a couple of UV drivers
> (drivers/misc/sgi-gru/ and sgi-xp/).  And would prefer it for the UV TLB
> shootdown (x86/kernel/tlb.uv.c) rather than using alloc_intr_gate().

I also want to ask why do you need an irq that fires on every cpu?

That concept seems to be responsible for one of the nastiest data
structures in the kernel.  Where we track how many times any irq has
occurred on any cpu.  Look at the percpu variable kernel_stat.  It
seems to be one of the nastiest variables I know of.  Of size:
NR_CPUS*NR_CPUS*32  Assuming you have a machine with a reasonable
number of irqs per cpu.

Eric
