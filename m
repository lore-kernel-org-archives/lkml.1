Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbYKHS6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbYKHS6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 13:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbYKHS6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 13:58:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37636 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbYKHS6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 13:58:14 -0500
Date: Sat, 8 Nov 2008 19:57:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] scheduler updates
Message-ID: <20081108185758.GA3986@elte.hu>
References: <20081108170224.GA553@elte.hu> <alpine.LFD.2.00.0811081026280.3468@nehalem.linux-foundation.org> <20081108185219.GA23413@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081108185219.GA23413@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> For that one, i chickened out, because we have this use in 
> arch/x86/kernel/vsyscall_64.c:
> 
>                 now = vread();
>                 base = __vsyscall_gtod_data.clock.cycle_last;
>                 mask = __vsyscall_gtod_data.clock.mask;
>                 mult = __vsyscall_gtod_data.clock.mult;
>                 shift = __vsyscall_gtod_data.clock.shift;
> 
> which can be triggered by gettimeofday() on certain systems.
>
> And i couldnt convince myself that this sequence couldnt result in 
> userspace-observable GTOD time warps there, so i went for the 
> obvious fix first.
> 
> If the "now = vread()"'s RDTSC instruction is speculated to after it 
> reads cycle_last, and another vdso call shortly after this does 
> another RDTSC in this same sequence, the two RDTSC's could be mixed 
> up in theory, resulting in negative time?

the fuller sequence is:

                now = vread();
                base = __vsyscall_gtod_data.clock.cycle_last;
                mask = __vsyscall_gtod_data.clock.mask;
                mult = __vsyscall_gtod_data.clock.mult;
                shift = __vsyscall_gtod_data.clock.shift;

                tv->tv_sec = __vsyscall_gtod_data.wall_time_sec;
                nsec = __vsyscall_gtod_data.wall_time_nsec;
        } while (read_seqretry(&__vsyscall_gtod_data.lock, seq));

now here we could have another race as well: on another CPU we have a 
timer IRQ running, which updates 
__vsyscall_gtod_data.wall_time_[n]sec.

now __vsyscall_gtod_data updates are protected via the 
__vsyscall_gtod_data.lock seqlock, but that assumes that all 
instructions within that sequence listen to the barriers.

Except for RDTSC, which can be speculated to outside that region of 
code.

RDTSC has no 'explicit' data dependency - there's no MESI-alike 
coherency guarantee for stuffing a cycle counter into a register and 
then putting that into __vsyscall_gtod_data.clock.cycle_last. So we 
create one, by using the combination of LFENCE and SFENCE. (because 
RDTSC implementations on Intel and AMD CPUs listen to different 
sequences.)

all in one, i think it's still needed to avoid negative GTOD jumps. 

	Ingo
