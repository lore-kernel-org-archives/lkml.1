Return-Path: <linux-kernel-owner+w=401wt.eu-S1757154AbYGHLot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbYGHLot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 07:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbYGHLom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 07:44:42 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:51220 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbYGHLol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 07:44:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Vr4bB7YX7WupOKZRMLTeG1HqzBrTe6vw7bDf/DlGt0zq85/eTFX3sc/+neOfTJXuVj
         FIbF+BqyLRclfppPwFQ+81LSS5nSXrelbntjAVIAI7/D5RJf7REOxb4oZw+2Mt2Bl5hh
         c/LwEobA+tiV1pf5bssYvi6UTeVN77iHd6qEE=
Message-ID: <961aa3350807080444i4439ca33x3eee80113cd6a907@mail.gmail.com>
Date: Tue, 8 Jul 2008 20:44:40 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/3] stop_machine: simplify
Cc: linux-kernel@vger.kernel.org, "Jason Baron" <jbaron@redhat.com>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Max Krasnyansky" <maxk@qualcomm.com>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <200807081756.47140.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807081750.55536.rusty@rustcorp.com.au>
	 <200807081756.02838.rusty@rustcorp.com.au>
	 <200807081756.47140.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found a small possible cleanup in this patch.

> diff --git a/kernel/cpu.c b/kernel/cpu.c
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -192,7 +192,6 @@ static int __ref _cpu_down(unsigned int
>  static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
>  {
>        int err, nr_calls = 0;
> -       struct task_struct *p;
>        cpumask_t old_allowed, tmp;
>        void *hcpu = (void *)(long)cpu;
>        unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
> @@ -226,19 +225,15 @@ static int __ref _cpu_down(unsigned int
>        cpu_clear(cpu, tmp);
>        set_cpus_allowed_ptr(current, &tmp);
>
> -       p = __stop_machine_run(take_cpu_down, &tcd_param, cpu);
> +       err = __stop_machine_run(take_cpu_down, &tcd_param, cpu);
>
> -       if (IS_ERR(p) || cpu_online(cpu)) {
> +       if (err || cpu_online(cpu)) {

I think checking cpu_online() is now unnecessary by __stop_machine_run()
change in this patch. i.e. this line can simply be:

        if (err) {

Because __stop_machine_run(take_cpu_down, ...) returned zero means
take_cpu_down() has already finished and suceeded (returned zero).
It also means __cpu_disable() in take_cpu_down() has been succeeded.
So you can remove cpu_online() check.

>                /* CPU didn't die: tell everyone.  Can't complain. */
>                if (raw_notifier_call_chain(&cpu_chain, CPU_DOWN_FAILED | mod,
>                                            hcpu) == NOTIFY_BAD)
>                        BUG();
>
> -               if (IS_ERR(p)) {
> -                       err = PTR_ERR(p);
> -                       goto out_allowed;
> -               }
> -               goto out_thread;
> +               goto out_allowed;
>        }
>
>        /* Wait for it to sleep (leaving idle task). */
