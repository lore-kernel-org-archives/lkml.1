Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbYKFJBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbYKFJBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 04:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYKFJB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 04:01:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36822 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbYKFJB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 04:01:27 -0500
Date: Thu, 6 Nov 2008 10:01:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mark.langsdorf@amd.com
Subject: Re: [PATCH] Warn of incorrect cpu_khz on AMD systems
Message-ID: <20081106090118.GC4890@elte.hu>
References: <20081104152720.9964.71959.sendpatchset@prarit.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104152720.9964.71959.sendpatchset@prarit.bos.redhat.com>
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


* Prarit Bhargava <prarit@redhat.com> wrote:

> If none of the perfctrs are free when calculating cpu_khz we default 
> to using ctr 3 (ie, we just choose 3).  This may lead to an 
> incorrect tsc freq value which can cause the system to be unstable.
> 
> To aid in future debugging, WARN the user of a potential problem.

oh, nasty... when can this happen - are you using nmi_watchdog=2?

Cannot we avoid this situation somehow? The calibrate_cpu() function 
is quite ugly and does a dangerous thing by ignoring the reservation. 

This whole sequence is sloppy:

        for (i = 0; i < 4; i++)
                if (avail_to_resrv_perfctr_nmi_bit(i))
                        break;
        no_ctr_free = (i == 4);
        if (no_ctr_free) {
                i = 3;
                rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
                wrmsrl(MSR_K7_EVNTSEL3, 0);
                rdmsrl(MSR_K7_PERFCTR3, pmc3);
        } else {
                reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
                reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
        }

>  	no_ctr_free = (i == 4);
>  	if (no_ctr_free) {
> +		printk(KERN_WARN "Warning: AMD perfctrs busy ... "
> +		       "cpu_khz value may be incorrect.\n");

also, please use a WARN() instead so that kerneloops.org picks it up.

	Ingo
