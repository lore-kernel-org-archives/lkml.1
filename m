Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZHKQxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZHKQxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbZHKQxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:53:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42445 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbZHKQxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:53:12 -0400
Date: Tue, 11 Aug 2009 18:52:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Stezenbach <js@sig21.net>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de
Subject: Re: [tip:perfcounters/urgent] perf_counter, x86: Fix/improve apic
	fallback
Message-ID: <20090811165251.GA27521@elte.hu>
References: <tip-83f19150242ee57730a4331b6ae9a9b90ccc718c@git.kernel.org> <20090811162313.GA8325@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811162313.GA8325@sig21.net>
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


* Johannes Stezenbach <js@sig21.net> wrote:

> On Tue, Aug 11, 2009 at 11:34:21AM +0000, tip-bot for Ingo Molnar wrote:
> > Commit-ID:  83f19150242ee57730a4331b6ae9a9b90ccc718c
> > Gitweb:     http://git.kernel.org/tip/83f19150242ee57730a4331b6ae9a9b90ccc718c
> > Author:     Ingo Molnar <mingo@elte.hu>
> > AuthorDate: Tue, 11 Aug 2009 10:40:08 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Tue, 11 Aug 2009 13:19:07 +0200
> > 
> > perf_counter, x86: Fix/improve apic fallback
> > 
> > Johannes Stezenbach reported that his Pentium-M based
> > laptop does not have the local APIC enabled by default,
> > and hence perfcounters do not get initialized.
> > 
> > Add a fallback for this case: allow non-sampled counters
> > and return with an error on sampled counters. This allows
> > 'perf stat' to work out of box - and allows 'perf top'
> > and 'perf record' to fall back on a hrtimer based sampling
> > method.
> > 
> > ( Passing 'lapic' on the boot line will allow hardware
> >   sampling to occur - but if the APIC is disabled
> >   permanently by the hardware then this fallback still
> >   allows more systems to use perfcounters. )
> > 
> > Also decouple perfcounter support from X86_LOCAL_APIC.
> 
> Seems to work.  From dmesg:
> 
>    Performance Counters: 
>    no APIC, boot with the "lapic" boot parameter to force-enable it.
>    no hardware sampling interrupt available.
>    p6 PMU driver.
>    ... version:                 0
>    ... bit width:               32
>    ... generic counters:        2
>    ... value mask:              00000000ffffffff
>    ... max period:              000000007fffffff
>    ... fixed-purpose counters:  0
>    ... counter mask:            0000000000000003
>    CPU: Intel(R) Pentium(R) M processor 1.80GHz stepping 06
> 
> However:
> 
>    oprofile: using timer interrupt.
> 
> I tried "perf top", "perf stat -a sleep 1", "perf stat java foo", 
> it all looks good to my untrained eye.

Ok, thanks for reporting it and for testing it!

The tools fall back to a hrtimer based sampling method - i.e. not 
NMI based. You can still improve the quality of performance 
instrumentation on your box by booting with 'lapic' - in that case 
the APIC and an NMI is used by 'perf top' and 'perf record/report'. 
(perf stat should be unaffected)

	Ingo
