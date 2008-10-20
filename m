Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbYJTQB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbYJTQB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYJTQBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:01:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33603 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbYJTQBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:01:18 -0400
Date: Mon, 20 Oct 2008 18:00:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ivan Vecera <ivecera@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, nhorman@redhat.com, jmarchan@redhat.com
Subject: Re: [PATCH] x86: call machine_shutdown and stop all CPUs in
	native_machine_halt
Message-ID: <20081020160058.GB22779@elte.hu>
References: <1224504787-11403-1-git-send-email-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224504787-11403-1-git-send-email-ivecera@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ivan Vecera <ivecera@redhat.com> wrote:

> Function machine_halt (resp. native_machine_halt) is empty for x86 
> architectures. When command 'halt -f' is invoked, the message "System 
> halted." is displayed but this is not really true because all CPUs are 
> still running. There are also similar inconsistencies for other arches 
> (some uses power-off for halt or forever-loop with IRQs 
> enabled/disabled). IMO there should be used the same approach for all 
> architectures OR what does the message "System halted" really mean?

no fundamental objections, but could you please do it a bit cleaner:

>  static void native_machine_halt(void)
>  {
> +	/* stop other cpus and apics */
> +	machine_shutdown();
> +
> +	/* stop this cpu */
> +	local_irq_disable();
> +	if (hlt_works(smp_processor_id()))
> +		for (;;) halt();
> +	for (;;);
>  }

the code in arch/x86/kernel/smp.c::stop_this_cpu() is very similar to 
this and could be shared. You could move the stop_this_cpu() function to 
arch/x86/kernel/process.c (out of smp.c), so that it can be used by 
reboot.c.

furthermore, native_machine_power_off() should probably fall back to 
native_machine_halt() as well - should pm_power_off() be disabled (or if 
it fails to stop the machine).

hm?

	Ingo
