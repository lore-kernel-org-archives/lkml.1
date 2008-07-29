Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbYG2XX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbYG2XX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 19:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbYG2XW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 19:22:56 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47746 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbYG2XWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 19:22:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>,
       Alan Mayer <ajm@sgi.com>, Cliff Wickman <cpw@sgi.com>
References: <20080729160939.GA4484@linux.vnet.ibm.com>
	<86802c440807291135m7f8e2163xdde14545e311649a@mail.gmail.com>
	<86802c440807291220t7813effcwb32ae6c18e3cddfe@mail.gmail.com>
	<m1d4kwbg8f.fsf@frodo.ebiederm.org> <488F96DD.6020505@sgi.com>
Date: Tue, 29 Jul 2008 16:12:05 -0700
In-Reply-To: <488F96DD.6020505@sgi.com> (Mike Travis's message of "Tue, 29 Jul
	2008 15:17:01 -0700")
Message-ID: <m1bq0g8euy.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Travis <travis@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: kernel BUG at arch/x86/kernel/io_apic_64.c:357!
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:

> I didn't follow this from the start but one reason why NR_IRQS based on
> NR_CPUS is a bad idea, is the huge (nearly 300Mb) increase in memory usage
> (that's mostly wasted.)  I believe there's another patch coming real soon
> now to make irq allocations dynamic.  (I had also hoped to look closer at
> your irq abstraction patch you sent a while back.  Does that also address
> this issue?)

The patch I sent out earlier is one of the key patches needed for killing
NR_IRQS usage in generic code.  Which is part of what we need to make this
dynamic.

In systems where the I/O is well balanced with the compute the typical
usage is usually within 16 irqs per core, and at worst 32.  That is an old
rule of thumb observation and that makes for reasonable allocations.

I don't have a problem at all with your code that updated the heuristic to
be based on the NR_IOAPICS.

My problem is with Thomas's patch that totally threw out all of our tuned
heuristics and made NR_IRQS=256.  Which is ludicrous.  Even on 32bit systems
there are cases where 1024 irq sources needed to be supported.

Which is what NR_IRQ_VECTORS is.  I goofed slightly in my comments.
irq_vector only needs to be NR_IRQS in size.  I think ACPI still needs
NR_IRQ_VECTORS to know how many GSI the kernel can support.  The fact they
are not mapped 1-1 right now in the 32bit kernel is unfortunate.

> But this would be a show stopper for SGI being able to ship systems if the
> distros do not want to waste this much memory and won't set NR_CPUS=4096.

Yes.  We absolutely need to dynamically allocate the irq data structures.  Then
we can use the irq numbers sparsely and not have problems.

I just have problems with the code setting NR_IRQS at 256 when we have single
potentially common hardware devices talking about having that many irqs on
a single device.

We really need to be able to scale to an unreasonable number of IRQs when we
have the hardware plugged into the system that will use them.  Just like
we need to scale to an unreasonable number of cpus when you plug them into
a system.

I expect irqs to actually grow faster then cpus while all of the devices are
learning how to accommodate hardware virtualization.  It would not surprise
me in the slightest if I can plug in the right hardware and exceed
NR_CPUS*32 irqs in an sgi machine in the next year or so.

The only problem with NR_IRQS=NR_CPUS*32 is that we pay the price on lower
end machines when we compile to support a higher cpu count.

Eric

