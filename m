Return-Path: <linux-kernel-owner+w=401wt.eu-S1758827AbYHNRfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827AbYHNRfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbYHNRfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:35:25 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:38996 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbYHNRfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:35:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAHYGpEhMRKxB/2dsb2JhbACBYrUmgVU
Date: Thu, 14 Aug 2008 13:30:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC PATCH] x86 alternatives : fix LOCK_PREFIX race with
	preemptible kernel and CPU hotplug
Message-ID: <20080814173021.GA4697@Krystal>
References: <20080813200119.GA18966@Krystal> <20080813234156.GA25775@Krystal> <48A375E3.9090609@zytor.com> <48A388CE.2020404@goop.org> <20080814014944.GA31883@Krystal> <48A3A806.8060509@goop.org> <20080814151805.GA29507@Krystal> <48A459B1.2070601@zytor.com> <20080814165802.GC517@Krystal> <48A465F2.8000701@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48A465F2.8000701@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:26:41 up 70 days, 22:07,  7 users,  load average: 0.67, 0.91,
	0.83
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Mathieu Desnoyers wrote:
>> * H. Peter Anvin (hpa@zytor.com) wrote:
>>   
>>> Mathieu Desnoyers wrote:
>>>     
>>>> I can't argue about the benefit of using VM CPU pinning to manage
>>>> resources because I don't use it myself, but I ran some tests out of
>>>> curiosity to find if uncontended locks were that cheap, and it turns out
>>>> they aren't. Here are the results :
>>>> Xeon 2.0GHz
>>>> Summary
>>>> make -j1 kernel/      33.94 +/- 0.07         34.91 +/- 0.27      2.8 %
>>>> hackbench 50           2.99 +/- 0.01          3.74 +/- 0.01     25.1 %
>>>> 1 CPU, replace smp lock prefixes with DS segment selector prefixes
>>>> 1 CPU, noreplace-smp
>>>>       
>>> For reference, could you also compare replace smp lock with NOPs?
>>>
>>> 	-hpa
>>>     
>>
>> Sure, here are the updated tables. Basically, they show no significant
>> difference between the NOP and the DS segment selector prefix
>> approaches.
>>   
>
> BTW, are you changing the initial prefix to DS too?  Ie, are you doing a 
> nop->lock->ds transition, or ds->lock->ds?
>
>    J

Yeah, I thought about this case yesterday, good thing you ask.

include/asm-x86/alternative.h defines LOCK_PREFIX as :

#define LOCK_PREFIX \
                ".section .smp_locks,\"a\"\n"   \
                _ASM_ALIGN "\n"                 \
                _ASM_PTR "661f\n" /* address */ \
                ".previous\n"                   \
                "661:\n\tlock; "

So we have the locked instructions built into the kernel, not the nop'd
one. Therefore, the only transition I am doing for my benchmarks is :

lock->ds

but I tried to switch back to SMP and it worked fine.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
