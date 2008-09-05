Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbYIEKZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbYIEKZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 06:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbYIEKYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 06:24:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32809 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751AbYIEKYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 06:24:49 -0400
Date: Fri, 5 Sep 2008 12:24:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
       "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>,
       Andi Kleen <andi@firstfloor.org>, Prarit Bhargava <prarit@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arozansk@redhat.com" <arozansk@redhat.com>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
Message-ID: <20080905102416.GA11212@elte.hu>
References: <20080904172052.GN3400@redhat.com> <20080904175231.GH18288@one.firstfloor.org> <20080904182637.GP3400@redhat.com> <20080904190816.GB4349@redhat.com> <20080904200032.GM18288@one.firstfloor.org> <183C1D5A376DE343AA8F94FC2A1EC14938D3E74841@GVW1091EXB.americas.hpqcorp.net> <20080904205725.GC4349@redhat.com> <183C1D5A376DE343AA8F94FC2A1EC14938D3E748D1@GVW1091EXB.americas.hpqcorp.net> <20080904212134.GD4349@redhat.com> <20080904212453.GR3400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904212453.GR3400@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> Prarit's patch disabled the timer upon registering a callback to 
> prevent this case.  The thought was if you have your own handler you 
> could provide your own watchdog.

btw., while we are talking about watchdog design problems, the current 
way the NMI timer watchdog oprofile fallback uses the die handler and 
how it all interacts with the ioapic/lapic-timer NMI watchdog is 
misdesigned as well. (this is used in the relatively rare but still 
possible case where no primary oprofile handler is found and installed)

The i386 and x86_64 architecture code started using die notifiers for 
the NMI timer watchdog oprofile code two years ago, via commit 2fbe7b25 
"i386/x86-64: Remove un/set_nmi_callback and reserve/release_lapic_nmi 
functions". [ Hey - what a coincidence - that was done by you! ;-) ]

It was a nice cleanup but not complete: using a die notifier for the NMI 
watchdog does not work properly as the NMI watchdog driver has no 
knowledge currently about whether it got activated (often it's not even 
possible to tell it):

 +       case DIE_NMI:
 +               oprofile_add_sample(args->regs, 0);
 +               ret = NOTIFY_STOP;
 +               break;

it always returns NOTIFY_STOP. That breaks all other lower prio 
notifiers down the chain which might have proper knowledge about the 
source of the NMI. Such kind of cross-notifier breakage is one of the 
reasons why driver notifiers try to become exclusive and try to play 
tricks with the nmi watchdog.

Instead the full solution would be for it to return NOTIFY_OK when it is 
not the source of the NMI (and is able to tell it).

[
  The reason why i qualified my statement with "when it is able to tell 
  it" is that while it is possible to disambiguate the NMI source when 
  the source of the NMI was the local apic timer (we already do that in 
  lapic_wd_event() - we return 1 if we rearmed the counter in the CPU), 
  it is not possible to tell it reliably that the NMI source was the
  IO-APIC.

  The reason for that is that the IO-APIC generated NMIs are 
  fundamentally 'anonymous' in that case: we put the legacy PIC into 
  auto-EOI mode and the IO-APIC broadcasts the NMIs and they are edge 
  triggered (on all but some really ancient systems) . So there's no 
  permanent and reliable information left about why the NMI was raised 
  in the CPU. This is a property of the hardware, we cannot solve it on 
  the kernel side. (we tried explicit ACKs before, and those are even 
  worse.)
]

So the right long-term solution is to move all NMI watchdog code 
(including the lockup detection bits - nmi_watchdog_tick(), etc.) into 
the notifier, then to propagate the re-arm information from 
lapic_wd_event() back into the notifier return code, and perhaps to 
print a (one-time) warning into the kernel log about the (in essence) 
deactivated lower-prio notifiers when the IO-APIC watchdog is activated.

This is all non-default debug or instrumentation functionality so if 
they cancel out each other in certain rare cases that's not a big issue 
in practice, as long as the user is informed about the constraints.

	Ingo
