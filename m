Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbZFLMmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbZFLMmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbZFLMmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:42:06 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:56995 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZFLMmF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:42:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=SJExZ1wbTThapMImApF0RCIgRfmnyUTCdEmv/pTghg1iRMQJ5uUHzAK9nKV6Iphxl6
         44ItdQsBdLA6FnrSVZQXFkD0p8CpZbRasSiPtLi71Al9r07/rcI3jAqc4pvPwZ9Qk5Jx
         CcJU83iSIg41zhTZ/8wb/ms+CwuwMrIlCeXYA=
MIME-Version: 1.0
In-Reply-To: <20090612123152.GE31845@elte.hu>
References: <1244806169-12232-1-git-send-email-vapier@gentoo.org> 
	<20090612120507.GH16044@elte.hu> <8bd0f97a0906120513u4e823460t8192f00fd0460ab@mail.gmail.com> 
	<20090612121757.GD31845@elte.hu> <8bd0f97a0906120522v51ae0151i48d5f6846ddcff10@mail.gmail.com> 
	<20090612123152.GE31845@elte.hu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 12 Jun 2009 08:41:46 -0400
Message-ID: <8bd0f97a0906120541x739b7902pe40ff7aa91337bac@mail.gmail.com>
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open 
	when supported
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 08:31, Ingo Molnar wrote:
> * Mike Frysinger <vapier.adi@gmail.com> wrote:
>> On Fri, Jun 12, 2009 at 08:17, Ingo Molnar wrote:
>> > * Mike Frysinger <vapier.adi@gmail.com> wrote:
>> >> On Fri, Jun 12, 2009 at 08:05, Ingo Molnar wrote:
>> >> > * Mike Frysinger <vapier@gentoo.org> wrote:
>> >> >> If the port does not support HAVE_PERF_COUNTERS, then they can't
>> >> >> support the perf_counter_open syscall either.  Rather than forcing
>> >> >> everyone to add an ignore (or suffer the warning until they get
>> >> >> around to implementing support), only whine about the syscall when
>> >> >> applicable.
>> >> >
>> >> > No, this patch is wrong - it's really easy to add support: just hook
>> >> > up the syscall. This should happen for every architecture really, so
>> >> > the warning is correct and it should not be patched out.
>> >> >
>> >> > PMU support is not required to get perfcounters support: if an
>> >> > architecture hooks up the syscall it will get generic software
>> >> > counters and the tools will work as well.
>> >> >
>> >> > Profiling falls back to a hrtimer-based sampling method - this is a
>> >> > much better fallback than oprofile's fall-back to the timer tick.
>> >> > This hrtimer based sampling is dynticks/nohz-correct and can go
>> >> > beyond HZ if the architecture supports hrtimers.
>> >>
>> >> if there is generic support available, why must every arch select
>> >> HAVE_PERF_COUNTERS in their Kconfig ?
>> >
>> > Because we only want to enable it on architectures that have tested
>> > it. It should only need a syscall addition, but nothing beats having
>> > tested things, hence we have that additional Kconfig symbol.
>>
>> that is a pretty weak reason. [...]
>
> It isnt - this is proper isolation - dont offer something to the
> user to enable that 1) cannot be used due to the lack of a syscall
> 2) has not been tested by anyone on that architecture, ever.
>
> That way say build breakages or runtime failures due to perfcounters
> only become possible on an architecture if the architecture
> maintainer has hooked up the syscall and has provided
> HAVE_PERF_COUNTERS explicitly.

except that the syscall presence is trivial to detect in the code by
something like:
#ifndef __NR_perf_counter_open
# error sorry, your arch has not hooked up perf_counter_open syscall yet
#endif

as for "no arch testing yet", there are plenty of drivers which lack
arch depends in the Kconfig specifically so that it can be *easily*
tested on random systems out there without requiring manual twiddling.
 having it not build on an arch results in someone noticing and things
getting fixed.  having it not even be an option means it often times
goes largely unnoticed.

the missing syscall is obvious for arch porters -- they get a warning
on every make.  the need for a useless HAVE_PERF_COUNTERS in the
Kconfig however is completely unknown because there's (yet again) 0
information on this define and what it takes for arch people to add
support for it.  in this case, the define is completely spurious.
-mike
