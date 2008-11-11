Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbYKKPaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbYKKPaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 10:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYKKPaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 10:30:12 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:15704 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbYKKPaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 10:30:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qYxqpvG8m1xVUnpumvfxqrk1SZuBWS7zUkuFWzqS9qFEzC0GxG6el8TanGsjNeiCNA
         Gm6nnNxBC0lSa3uqzcUPmgqUoFOVfLNV/vyKic1pPEYP+wieaHm7JTUoepNLhqtudtUY
         QjIMcb5wPDmihPJ+sm/EEI1ip7rRdVZW8XOCk=
Message-ID: <c62985530811110730x13bc92abo891b49934ea2ae6f@mail.gmail.com>
Date: Tue, 11 Nov 2008 16:30:09 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RFC v3][PATCH 0/2] Make ftrace able to trace function return
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081111094312.GA16496@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49191C31.1050402@gmail.com> <20081111094312.GA16496@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/11 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> This patchset adds the ability for ftrace to trace the function even
>> on call time and on return time. So we can now measure the time of
>> execution of the most part of the functions inside the kernel with
>> ftrace.
>>
>> The first patch bring the low level tools to add the support of
>> return tracing on X86-32. It is totally separated from the
>> traditional implementation of ftrace and doesn't support dynamic
>> ftrace at this time.
>>
>> The second patch adds a tracer based on the ring-buffer which
>> measure the time of execution of the functions inside the kernel.
>
> okay, i've created tip/tracing/function-return-tracer topic so that we
> can start testing this for real and do can start iterating it via
> smaller changes. I've also integrated it into tip/master, it's looking
> good so far.


Thanks!

> i did a couple of  cleanups straight away:
>
>  1) i did a FTRACE_RETURN => FUNCTION_RET_TRACER rename, to move it in
>    line with the function tracer


Yes I started the development of this thing when FUNCTION_TRACER was
still FTRACE and I kept the old and confusing
name.

>  2) i cleaned up the arch/x86/Kconfig impact:
>
>      f1c4be5: tracing, x86: clean up FUNCTION_RET_TRACER Kconfig


Ok.
And concerning the constraint fixed in assembly. That's strange my
compiler didn't even warn me about it.
Thanks for these three fixes.

> the return-tracer builds and boots, and works fabulously:
>
>  # cd /sys/debug/tracing/
>
>  # cat available_tracers
>  return function sched_switch nop
>
>  # echo return > current_tracer
>
>  clocksource_read+0xd/0xf -> acpi_pm_read (1547 ns)
>  getnstimeofday+0x3e/0xc8 -> clocksource_read (1951 ns)
>  ktime_get_ts+0x25/0x49 -> getnstimeofday (2354 ns)
>  ktime_get_ts+0x45/0x49 -> set_normalized_timespec (120 ns)
>
> Small quirk, it does not seem possible to switch from ftrace to
> ftrace-ret:
>
>  # echo ftrace > current_tracer
>  # echo return > current_tracer
>  bash: echo: write error: Invalid argument
>
> i have to go via the "nop" tracer for this to work. Steve: switching
> between tracer plugins should be seemless.
>
> Question: have you thought about extending the return-tracer to
> dyn-function-tracer?


Yes. I forgot it into the project section. But it will be implemented :-)


> That's where it will really shine: the dftrace workflow is to
> typically enable a low number of functions - and there the
> return-tracing overhead does not show up nearly as much as in the
> static-function-tracing workflow.
>
> Another suggestion: i think the "return" plugin name is confusing to
> users (it confused me when i first saw it listed in
> available_tracers).
>
> So lets use "function_full" and "function" tracing perhaps? The "full"
> tracer is what traces both entry and exit points, and establishes full
> function-call timings/costs. The "function" tracer is more lightweight
> and traces function entry events.


Right. I first chose function_return but it was the largest tracer
name and so raised a bug that has been corrected
since. And I kept this confusing name.
I'm not sure function_full is really the good one because it's not
really a full version of the function tracer. It doesn't do the same
thing: when you look into a trace done by the function tracer, the
functions appear in order of their call whereas with the function
return tracer, they appear in the order of their return which is not
the same. The effect is not the same.
Why not function_return or something like that?
