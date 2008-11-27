Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYK0RsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYK0RsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 12:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYK0RsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 12:48:00 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:38132 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbYK0Rr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 12:47:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=qRJu4MnKr2p3aYFSsRPp6aF66Orpwo6DMqNAyqBFvqrp3wmnsotjELP5W9JDyFe/5u
         NcaCQt0Qt7LCeBzStgFnoDnfxs3MiTJJqjeAhhnC7ebm++RWIyDQ14XB8ha2fTXpOp/f
         NAedaoM0Nb8081/m3ZuIRGdgpm03RfKYR8C+o=
Message-ID: <7c86c4470811270947q585cba5vf8bdb875962a1856@mail.gmail.com>
Date: Thu, 27 Nov 2008 18:47:54 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [patch 02/24] perfmon: base code
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, sfr@canb.auug.org.au
In-Reply-To: <alpine.LFD.2.00.0811271638350.3325@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0bd8.11435e0a.1686.ffff8801@mx.google.com>
	 <alpine.LFD.2.00.0811271638350.3325@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,



On Thu, Nov 27, 2008 at 6:24 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 26 Nov 2008, eranian@googlemail.com wrote:
>
>> Index: o3/perfmon/perfmon_res.c
>
>> +/*
>> + * global information about all sessions
>> + */
>> +struct pfm_resources {
>> +     cpumask_t sys_cpumask;     /* bitmask of used cpus */
>> +     u32 thread_sessions; /* #num loaded per-thread sessions */
>> +};
>
> What's the purpose of this being a structure if it's just a single
> instance ?
>
There is a single instance.
I was just trying to regroup related fields together instead of having them as
separate variables. I can make the change.


>> +static struct pfm_resources pfm_res;
>> +
>> +static __cacheline_aligned_in_smp DEFINE_SPINLOCK(pfm_res_lock);
>
>> +/**
>> + * pfm_session_acquire - reserve a per-thread session
>> + *
>> + * return:
>> + *    0    : success
>> + *   -EBUSY: if conflicting session exist
>
>  Where ?

Not in the patchset, conflict can arise when you add system-wide sessions.

>
>> + */
>> +int pfm_session_acquire(void)
>> +{
>> +     unsigned long flags;
>> +     int ret = 0;
>> +
>> +     /*
>> +      * validy checks on cpu_mask have been done upstream
>> +      */
>
>  How please ? pfm_res.sys_cpumask is local to this file and you want
>  to check it under the lock and _before_ you increment
>  thread_sessions blindly.
>
Stale comment.

>
> +EXPORT_SYMBOL(pfm_session_allcpus_release);
>
> All what that code should do (in fact it does not) is preventing the
> mix of thread and system wide sessions.
>
True. That is a current limitation.

> It does neither need a cpumask nor tons of useless loops and debug
> outputs with zero value.
>
Well, the the cpumask is indeed needed but you don't see the reason
why in the patchset!

Perfmon in system-wide does not operate like Oprofile. In system-wide
a perfmon session (context) monitors only ONE CPU at a time. Each
session is independent of each other. You can therefore measure different
things on different CPUs. Reservation is thus done independently for each
CPU, therefore we need a cpu bitmask  to track allocation.

The Oprofile reservation you see is built on top of the cpumask reservation.
It tries to allocate in one call and atomically ALL the CPUs as this is the way
Oprofile operates. Thus it fails if one perfmon system-wide session or one
perfmon per-thread exists. I believe there is enough bitmask functions to
avoid loops as you pointed out. I will fix that.


> static int global_session;
> static int thread_sessions;
> static DEFINE_SPINLOCK(session_lock);
>
> int pfm_session_request(int global)
> {
>        unsigned long flags;
>        int res = -EBUSY;
>
>        spin_lock_irqsave(&session_lock, flags);
>
>        if (!global && !global_session) {
>                thread_sessions++;
>                res = 0;
>        }
>
>        if (global && !thread_sessions && !global_session) {
>                global_session = 1;
>                res = 0;
>        }
>
>        spin_unlock_irqrestore(&session_lock, flags);
>        return res;
> }
>
> void pfm_session_release(int global)
> {
>        unsigned long flags;
>
>        spin_lock_irqsave(&session_lock, flags);
>
>        if (global) {
>                WARN_ON(!global_session);
>                global_session = 0;
>        } else {
>                if (!global_session && thread_sessions)
>                        thread_session--;
>                else
>                        WARN();
>        }
>
>        spin_unlock_irqrestore(&session_lock, flags);
> }
>
> Would do it nicely including useful sanity checks and 70% less code.
>
> Thanks,
>
>        tglx
>
