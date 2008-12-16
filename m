Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755417AbYLPVjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYLPVjl (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 16:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYLPVjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:39:31 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:44330 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbYLPVja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:39:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kaTIHXsD26kl4AefBE/2H4Fg4ZZJCsY4Jfa5BnrKAEJIkj+l+u27G17LwRu9uH7zw6
         NnzBqp4qFVIrrJYxbLbTVW7UpcL0X/S1uDCnLh7+I/DZjAqYx18uhh6ppHCkkDihJDRX
         ENl2vtlGEX73Auh9n6ajA34v0MLL8h40dSpyc=
Message-ID: <c62985530812161339p6296f032rdc3c74650331f3d8@mail.gmail.com>
Date: Tue, 16 Dec 2008 22:39:26 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing/ftrace: use preempt_enable_no_resched_notrace in ring_buffer_time_stamp()
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081216212028.GP14787@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <494818EA.7080807@gmail.com> <20081216212028.GP14787@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/16 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Impact: prevent a trace recursion
>>
>> After some tests with function graph tracer under x86-32, I saw some recursions
>> caused by ring_buffer_time_stamp() that calls preempt_enable_no_notrace() which
>> calls preempt_schedule() which is traced itself.
>>
>> This patch re-enables preemption without rescheduling.
>>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> ---
>>  kernel/trace/ring_buffer.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> applied to tip/tracing/ftrace, thanks Frederic!
>
> Does this explain+fix the weird crashes/reboots you were seeing?
>
>        Ingo
>

No, actually the functions tracers are protected against recursion,
but rescheduling attempts
during all trace insertions (and moreover a call to
prepare_ftrace_return with cancelled insertion)
is a useless payload.

The hard reboots I've seen are related to x86-64 while
disabling/reenabling a CPU through /sys/device/system/cpu
No tracer was enabled at these times (the problem still remains with
latest updates on -tip for half an hour).

One other thing: I've seen these pointless calls to preempt_schedule
while testing the function graph tracer on
VirtualBox. Since it provides virtual serial lines, it was more easy
to debug than usual (I haven't any serial line
on my box).
The function graph tracer hangs on VirtualBox with a x86-32 -tip. It
seems that the tracing is too slow and so hrtimer_interrupt()
does an eternal loop, assuming that a new time update has to be done
(because too much time elapsed during th tracing) after each
iteration.
I'm not sure what to do...disabling tracing for hrtimers or....
