Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab0BWPfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 10:35:12 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59485 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab0BWPfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 10:35:10 -0500
X-Greylist: delayed 14765 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Feb 2010 10:35:10 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h0/7RvN9vyyQOoDiUx3sxXmiXiCPiIPaKnfNlESIWeZcSrtujaxunX0KvNd2OFWRZA
         wc2n8u9zwLunNw/c66zGBrjvR344FSc/ztdx8Xt0ExWkb1kxTIjeY/XbTp0WfpqO4MwA
         jabniNcQ1QFSskuDQKDtz1i7QGXkxTFF0ernA=
MIME-Version: 1.0
In-Reply-To: <20100223123016.GA12857@Krystal>
References: <f5a7b3811002160717y65b4577buf53e5784c71575c3@mail.gmail.com>
	 <alpine.LFD.2.00.1002161727570.2811@localhost.localdomain>
	 <20100216164744.GA25115@Krystal>
	 <alpine.LFD.2.00.1002161757050.2811@localhost.localdomain>
	 <20100216170540.GA28039@Krystal>
	 <f5a7b3811002170236i6c560eadp2de7deb10082db4f@mail.gmail.com>
	 <20100217230854.GA25636@Krystal>
	 <f5a7b3811002220737r502e75c1w5ab5a64b6cc27b68@mail.gmail.com>
	 <f5a7b3811002230329w64cabac9lff95a40cb5e7dfa5@mail.gmail.com>
	 <20100223123016.GA12857@Krystal>
Date: Tue, 23 Feb 2010 21:05:08 +0530
Message-ID: <f5a7b3811002230735p2eb90904l33e8090ade66fc14@mail.gmail.com>
Subject: Re: LTTng 0.193 fixes RT kernel support
From: naresh kamboju <naresh.kernel@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 6:00 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> * naresh kamboju (naresh.kernel@gmail.com) wrote:
>> On Mon, Feb 22, 2010 at 9:07 PM, naresh kamboju <naresh.kernel@gmail.com> wrote:
>> > On Thu, Feb 18, 2010 at 4:38 AM, Mathieu Desnoyers
>> > <mathieu.desnoyers@efficios.com> wrote:
>> >> * naresh kamboju (naresh.kernel@gmail.com) wrote:
>> >>> On Tue, Feb 16, 2010 at 10:35 PM, Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
>> >>> > Oh, right. Thanks for the explanation. I'll look into moving LTTng to a
>> >>> > saner del_timer_sync() scheme to delete the timers.
>>
>> patch trace-clock-32-to-64-use-del-timer-sync.patch is causing above
>> problem on SMP.
>>
>> with out this patch on SMP reported the previous bug as BUG: sleeping
>> function called from invalid context at kernel/rtmutex.c:685
>>
>> However, i'll investigate.
>
> Hrm, we should turn the arch/{arm/mach-omap2,x86/kernel}/trace-clock.c:
> trace_clock_lock into a mutex, and kernel/trace/trace-clock-32-to-64.c:
> synthetic_tsc_lock into a mutex too.

I have modified kernel/trace/trace-clock-32-to-64.c spin_lock to
mutex_lock to all the calls

-static DEFINE_SPINLOCK(synthetic_tsc_lock);
+static DEFINE_MUTEX(synthetic_tsc_lock);

-       spin_lock(&synthetic_tsc_lock);
+       mutex_lock(&synthetic_tsc_lock);

for arch/{arm/mach-omap2/kernel}/trace-clock.c is already modified as
above from the patch
omap-trace-clock-fix-mutex.patch
from LTTng patches 02-Feb-2009.
this patch was prepared by you to fix
BUG: sleeping function called from invalid context at kernel/mutex.c:207.

Still reporting same bug at my end :-(

let me try in all possible ways.

Best regards
Naresh Kamboju
>
> I used a spinlock previously on ARM because it was called from power
> management resume, but now that the data structures touched by this code
> path are per-cpu, this lock is not taken there, so it should be OK to
> turn it into a mutex.
>
> Can you try that and tell me if that fixes your issues ?
>
> Thanks,
>
> Mathieu
>
>>
>> Best regards,
>> Naresh Kamboju
>> >> Thanks,
>> >>
>> >> Mathieu
>> >>
>> >> --
>> >> Mathieu Desnoyers
>> >> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
>> >>
>> >
>>
>> _______________________________________________
>> ltt-dev mailing list
>> ltt-dev@lists.casi.polymtl.ca
>> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
>>
>
> --
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
>
