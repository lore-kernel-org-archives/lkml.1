Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbZF2Iaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbZF2Iaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 04:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZF2Iar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 04:30:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50187 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbZF2Iaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 04:30:46 -0400
Date: Mon, 29 Jun 2009 10:30:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Luming Yu <luming.yu@gmail.com>, Arjan van de Ven <arjan@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com,
       venkatesh.pallipadi@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC patch] Use IPI_shortcut for lapic timer broadcast
Message-ID: <20090629083035.GA4017@elte.hu>
References: <3877989d0906282347i311eb14bp80a7c80878219c31@mail.gmail.com> <20090629072047.GB20225@elte.hu> <3877989d0906290104q11a767b6qcc1acc4c2d1feba6@mail.gmail.com> <20090629081615.GB571@elte.hu> <3877989d0906290121l15705d2cn72e4c49dd96ed950@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3877989d0906290121l15705d2cn72e4c49dd96ed950@mail.gmail.com>
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


* Luming Yu <luming.yu@gmail.com> wrote:

> On Mon, Jun 29, 2009 at 4:16 PM, Ingo Molnar<mingo@elte.hu> wrote:
> >
> > * Luming Yu <luming.yu@gmail.com> wrote:
> >
> >> On Mon, Jun 29, 2009 at 3:20 PM, Ingo Molnar<mingo@elte.hu> wrote:
> >> >
> >> > * Luming Yu <luming.yu@gmail.com> wrote:
> >> >
> >> >> Hello,
> >> >>
> >> >> We need to use IPI shortcut to send lapic timer broadcast
> >> >> to avoid the latency of sending IPI one bye one on systems with many
> >> >> logical processors when NO_HZ is disabled.
> >> >> Without this patch,I have seen upstream kernel with RHEL 5 kernel
> >> >> config boot hang .
> >> >
> >> > hm, that might be a valid optimization - but why does the lack of
> >> > this optimization result in a hang?
> >>
> >> It is hang caused by kernel code for work around lapic-timer-stop
> >> issue. With HZ=1000, and a lot of cpus (eg. 64 logical cpus), cpu
> >> 0 will be busy working on send TIMER IPI instead of making
> >> progress in boot (right after deep-C-state has been used).
> >
> > that's a bit weird. With HZ=1000 we have 1000 usecs between each
> > timer tick. Assuming a CPU sends to a lot of CPUs (64 logical CPUs)
> > that means that each IPI takes more than ~15 microseconds to
> > process. On what hardware/platform can this happen realistically?
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=499271
> 
> Someone has measured that it needs 50-100us latency to send one 
> IPI

Ugh. What platform is it that takes this much time to pass an IPI? 

IPIs are the lifeline of process messaging under Linux. TLB flushes 
in threaded apps rely on it (heavily), the scheduler relies on it 
for wakeups (heavily) and a lot of other code relies on IPIs as 
well.

Even a Pentium-5 100 MHz dual box was able to do cross-CPU IPIs 
within 10-20 microseconds more than a decade ago - so 50-100 usecs 
latency on a modern platform is totally out of this planet and will 
hurt Linux performance big time. And the worst thing about it is 
that none of the usual performance metrics will really show _why_ 
performance is tanking ...

	Ingo
