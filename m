Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbYI0Qvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbYI0Qvd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 12:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbYI0QvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 12:51:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53231 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbYI0QvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 12:51:24 -0400
Date: Sat, 27 Sep 2008 18:51:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Davidson <md@google.com>
Cc: linux-kernel@vger.kernel.org, mbligh@google.com, tglx@linutronix.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: TSC resync
Message-ID: <20080927165107.GF4600@elte.hu>
References: <20080925220212.45B0029683@localhost> <20080926070217.GA26081@elte.hu> <6cc912950809261218u5a1bf8b8w216556b50d0e33ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cc912950809261218u5a1bf8b8w216556b50d0e33ab@mail.gmail.com>
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


* Michael Davidson <md@google.com> wrote:

> On Fri, Sep 26, 2008 at 12:02 AM, Ingo Molnar <mingo@elte.hu> wrote:
> 
> > hm, this patch syncs the TSCs every 20 seconds. That is enough to 
> > sync up AMD CPUs where the TSC slows down _slightly_ (at 10 ppm per 
> > second or so) when it's in HLT.
> 
> Actually by default it syncs them every time the CPU comes out of idle 
> or, optionally, on the first user space access to the TSC via RDTSC or 
> RDTSCP after the CPU has been in idle.

hm, that would be a performance problem.

coming out of idle is a fastpath: the CPU just got notified of more 
work, so any delay there costs.

[ going _to_ idle is more relaxed from a performance POV - but that 
  doesnt help much here. ]

and the default_idle()->tsc_resync_idle_notifier()->tsc_resync()-> 
ref_clock_tsc_read()->ref_clock() codepath does this:

+               offset = (uint32_t)hpet_readl(HPET_COUNTER) - ref_clock_last;

i.e. we read the HPET every time we exit from idle. The HPET usually 
sits in the southbridge and thus we add ~5000 cycles of overhead to 
every idle-exit event.

Another thing i noticed. You set the TSC via the 0x10 MSR:

+               asm __volatile__ (
+                       "xorl %%eax, %%eax\n\t"
+                       "cpuid\n\t"
+                       "movl $0x10, %%ecx\n\t"
+                       "rdmsr\n\t"
+                       "addl %%edi, %%eax\n\t"
+                       "adcl %%esi, %%edx\n\t"
+                       "wrmsr\n"

some CPUs (P3's?) will crop the TSC at 32 bits when wrtsc is used [even 
if a larger than 0xfffffffff value is presented in ax/dx. - i.e. the TSC 
will go round and round, with a rollover every few seconds.

those CPUs would have to be detected and excluded from this scheme.

	Ingo
