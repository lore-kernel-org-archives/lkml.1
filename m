Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbZJLKeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbZJLKeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbZJLKeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:34:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46373 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbZJLKeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:34:15 -0400
Date: Mon, 12 Oct 2009 12:33:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RESEND PATCH] mce, edac: use an atomic notifier for MCEs
	decoding
Message-ID: <20091012103333.GB20051@elte.hu>
References: <20091007112038.GA2505@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007112038.GA2505@aftab>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <borislav.petkov@amd.com> wrote:

> @@ -1420,6 +1428,10 @@ void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
>  	mce_cpu_features(c);
>  	mce_init_timer();
>  	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
> +
> +	if (raw_smp_processor_id() == 0)
> +		atomic_notifier_chain_register(&x86_mce_decoder_chain,
> +					       &mce_dec_nb);
>  }

this bit should be done in a cleaner way, by introducing a boot init 
function for MCE functionality.

(It's also broken if we boot on non-0 CPUs. Doesnt happen currently but 
still.)

Also, the function names there are pretty messy - please do another, 
rename patch that does something like:

  mcheck_init()       => mcheck_cpu_init()
  mce_init()          => __mcheck_cpu_init_generict()
  mce_cpu_features()  => __mcheck_cpu_init_vendor()
  mce_init_timer()    => __mcheck_cpu_init_timer()

etc.

I've applied your patch to x86/mce - please send delta patches to clean 
up the other aspects of it.

Thanks,

	Ingo
