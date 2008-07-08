Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbYGHPCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbYGHPCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 11:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbYGHPCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 11:02:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:60554 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbYGHPCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 11:02:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BJH5A0zJC2+6J+fd484nvv0agroq5tbpcd2Q5jW2XpARxlY6QIT/dehXqV09JUEDMP
         oNKfsBNt7n88imPJBMG6aqHPsvbXal1VpIH7p5jyuI01lTQ3hWPI+8o7zUEMgY9m0X07
         n3DEXQNJdyLNas8bPIZRIqsM978Rqpq7ZYNeI=
Message-ID: <961aa3350807080802w7e6acef9g4e931e26b3061d7e@mail.gmail.com>
Date: Wed, 9 Jul 2008 00:02:02 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/3] stop_machine: simplify
Cc: linux-kernel@vger.kernel.org, "Jason Baron" <jbaron@redhat.com>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Max Krasnyansky" <maxk@qualcomm.com>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <200807082311.35793.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807081750.55536.rusty@rustcorp.com.au>
	 <200807081756.47140.rusty@rustcorp.com.au>
	 <961aa3350807080444i4439ca33x3eee80113cd6a907@mail.gmail.com>
	 <200807082311.35793.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/8 Rusty Russell <rusty@rustcorp.com.au>:
> On Tuesday 08 July 2008 21:44:40 Akinobu Mita wrote:
>> I found a small possible cleanup in this patch.
>
> Well spotted!  I think this cleanup is actually orthogonal to my patch,
> so best served as a separate patch, how's this?

Actually the cpu_online() check was necessary before appling this
stop_machine: simplify patch.

With old __stop_machine_run(), __stop_machine_run() could succeed
(return !IS_ERR(p) value) even if take_cpu_down() returned non-zero value.
The return value of take_cpu_down() was obtained through kthread_stop().

> ===
> Hotplug CPU: don't check cpu_online after take_cpu_down

So it seems that folding this patch into stop_machine: simplify patch is
more appropriate.

> Akinobu points out that if take_cpu_down() succeeds, the cpu must be offline
> (otherwise we're in deep trouble anyway.
>
> Remove the cpu_online() check, and put a BUG_ON().
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Akinobu Mita" <akinobu.mita@gmail.com>
>
> diff -r 805a2e5e68dd kernel/cpu.c
> --- a/kernel/cpu.c      Tue Jul 08 23:04:48 2008 +1000
> +++ b/kernel/cpu.c      Tue Jul 08 23:07:43 2008 +1000
> @@ -226,8 +226,7 @@ static int __ref _cpu_down(unsigned int
>        set_cpus_allowed_ptr(current, &tmp);
>
>        err = __stop_machine_run(take_cpu_down, &tcd_param, cpu);
> -
> -       if (err || cpu_online(cpu)) {
> +       if (err) {
>                /* CPU didn't die: tell everyone.  Can't complain. */
>                if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
>                                            hcpu) == NOTIFY_BAD)
> @@ -235,6 +234,7 @@ static int __ref _cpu_down(unsigned int
>
>                goto out_allowed;
>        }
> +       BUG_ON(cpu_online(cpu));
>
>        /* Wait for it to sleep (leaving idle task). */
>        while (!idle_cpu(cpu))
>
