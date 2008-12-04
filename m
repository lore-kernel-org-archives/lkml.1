Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbYLDXDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbYLDXDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 18:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYLDXDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 18:03:25 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:44943 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbYLDXDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 18:03:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NQMaxLjVHrL/NN75VBAZ8COEgEfeom2VcFSk0cgklqMX8Nkx6BxTBSj8ywXjYxomIL
         d1+1J2V7AdrSc/ne75nJumQ3khs0a6/ymxaByJxtmo+sc5VOFyrxX72oSiNy0zaHp7zB
         P+PKWbpnY3IsPyGGc0s25owdRQD7sJZEv/wX0=
Message-ID: <c62985530812041503g4e6f8fa8uc9b7a1166fd3a907@mail.gmail.com>
Date: Fri, 5 Dec 2008 00:03:20 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 1/3] tracing/ftrace: don't insert TRACE_PRINT during selftests
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812041752210.32726@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49385E07.7050304@gmail.com>
	 <alpine.DEB.1.10.0812041752210.32726@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/4 Steven Rostedt <rostedt@goodmis.org>:
> The comment style should be:
>
> /*
>  * comment
>  * comment
>  * comment
>  */

Sorry, will fix it.

>
>> +static atomic_t tracing_selftest_running = ATOMIC_INIT(0);
>
> Do we need that is atomic? Also, it needs to be __read_mostly.


I thought it should be atomic to be sure the value is synchronized
on smp when read. But actually that should have been more likely an
int with smp_wb after writing it.

>> +
>>  /* For tracers that don't implement custom flags */
>>  static struct tracer_opt dummy_tracer_opt[] = {
>>       { }
>> @@ -589,6 +597,8 @@ int register_tracer(struct tracer *type)
>>               struct tracer *saved_tracer = current_trace;
>>               struct trace_array *tr = &global_trace;
>>               int i;
>> +
>> +             atomic_set(&tracing_selftest_running, 1);
>
> Enable this in the mutex lock, and we could make it a normal int.
>


But ftrace_printk can be called from interrupt context. I think we can loose
some TRACE_PRINT entries at the selftests time since the tracer are not enabled
by the user at this time, except the boot tracer...

>>               /*
>>                * Run a selftest on this tracer.
>>                * Here we reset the trace buffer, and set the current
>> @@ -603,6 +613,7 @@ int register_tracer(struct tracer *type)
>>               /* the test is responsible for initializing and enabling */
>>               pr_info("Testing tracer %s: ", type->name);
>>               ret = type->selftest(type, tr);
>> +             atomic_set(&tracing_selftest_running, 0);
>>               /* the test is responsible for resetting too */
>>               current_trace = saved_tracer;
>>               if (ret) {
>> @@ -3594,7 +3605,7 @@ int trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args)
>>       unsigned long flags, irq_flags;
>>       int cpu, len = 0, size, pc;
>>
>> -     if (tracing_disabled)
>> +     if (tracing_disabled || atomic_read(&tracing_selftest_running))
>>               return 0;
>>
>>       pc = preempt_count();
>> --
>
> -- Steve
>
>
