Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbYLXDWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbYLXDWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 22:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbYLXDWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 22:22:05 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:55997 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYLXDWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 22:22:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lIwVv1+YSP8JG8UsxUsSzO4Yc8Xl6c2at8odZnLPaYVW9q2NgHyzIroXRxi0DWnlOs
         uVpEMGyCYsU6UdJWLCs0vqo+0NgSQ+SZUHVDc/aL8iY89tAQK1SjTQkFrnqcbQL5ean1
         1MYf+pRUBw+5niWGRXZNm8kKvko1uA8UhMR6Y=
Message-ID: <c62985530812231922j1b5827fbw1b7b4cdb6fea54ea@mail.gmail.com>
Date: Wed, 24 Dec 2008 04:22:01 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] tracing/ftrace: don't trace on early stage of secondary cpu boot
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812232201110.20511@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49518535.8080105@gmail.com>
	 <alpine.DEB.1.10.0812232106080.6972@gandalf.stny.rr.com>
	 <c62985530812231844w7bdc493secbbeaf4372afa52@mail.gmail.com>
	 <alpine.DEB.1.10.0812232201110.20511@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/24 Steven Rostedt <rostedt@goodmis.org>:
>
> On Wed, 24 Dec 2008, Fr?d?ric Weisbecker wrote:
>> >>       /*
>> >> @@ -1233,7 +1233,7 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
>> >>       int cpu;
>> >>       int pc;
>> >>
>> >> -     if (!ftrace_trace_task(current))
>> >> +     if (!ftrace_trace_task(current) || ftrace_in_early_cpuinit())
>> >>               return 0;
>> >
>> > Actually, didn't you say current is not available either? We are testing
>> > current first.
>>
>> Oops. Strange, my tests didn't give me any problem.
>> I will fix it.
>
> Are you sure 'current' is dangerous? Perhaps we do not need to worry here,
> since we are testing current against something else, and if the CPU
> is just coming on line, it will not be the task we want.


Yes, a simple local_irq_save might call trace_hardirqs_off(), and then
increment something in current....
And current is found toward reading pda, hence a crash...

>>
>>
>> > I still wonder if there's a better way to find out if it is safe to run.
>> > Perhaps the arch code can test the %gs register to see if it is actually
>> > something valid?
>> >
>> > -- Steve
>>
>> I could test if MSR_GS_BASE references cpu_pda(cpu) but that remains
>> as much heavy...
>
> Perhaps just reading the %gs register and see if it faults would be good
> enough?
>
>        long dummy;
>        int faulted=0;
>
>            asm(
>                "1:     movq %%gs:0, %0\n"
>                "2:
>                ".section .fixup \"ax\"\n"
>                "3:     movl $1, %1\n"
>                "       jmp 2b\n"
>                ".previous"
>                _ASM_EXTABLE(1b, 3b)
>                : "=r"(dummy), "=r"(faulted)
>                : "1"(faulted));
>
>
> Would this work?  On the good cases, all we do is a read of the %gs
> section, which is the same as doing a smp_process_id(). On the bad case,
> we fault, but we also catch that fact. We are more interested in the good
> case being fast. but I'm not sure how well the start up code could take a
> fault, even when it is expected.


But on the worst case, that could cause a fault recursion since the first line
of do_page_fault in x86 is:

tsk = current;

> -- Steve
>
>
