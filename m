Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbZELRud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbZELRud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbZELRuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:50:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33661 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbZELRuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:50:23 -0400
Date: Tue, 12 May 2009 19:48:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 5/10 -tip] x86: check_powernow() for K8 and later user
	of Advanced Power Management features
Message-ID: <20090512174848.GA3313@elte.hu>
References: <1242142530.2547.11.camel@ht.satnam> <1242142623.2547.13.camel@ht.satnam> <1242142692.2547.15.camel@ht.satnam> <1242142753.2547.16.camel@ht.satnam> <1242142807.2547.18.camel@ht.satnam> <1242142849.2547.19.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242142849.2547.19.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> -		eax = cpuid_eax(CPUID_GET_MAX_CAPABILITIES);
> -		if (eax < CPUID_FREQ_VOLT_CAPABILITIES) {
> +		/* Advanced Power Management capabilities */
> +		if (c->x86_capability[9]) {
>  			printk(KERN_INFO PFX
>  			       "No frequency change capabilities detected\n");
>  			goto out;
>  		}

How is the new check equivalent to the old one? It isnt and this is 
a bug.

Also, open-coding x86_capability[9] like that is quite unclean. Were 
we ever to reorder those bits internally, this could would break.

But i see what you are trying to do. A better method might be to add 
a new helper:

+#define X86_FEATURE_TS         (9*32+ 0) /* Temperatue sensor          */
+#define X86_FEATURE_FID                (9*32+ 1) /* Frequency ID control	*/
+#define X86_FEATURE_VID                (9*32+ 2) /* Voltage ID control		*/
+#define X86_FEATURE_TTP                (9*32+ 3) /* Thermal trip   	*/
+#define X86_FEATURE_HTC                (9*32+ 4) /* Hardware thermal control   */
+#define X86_FEATURE_STC                (9*32+ 5) /* Software thermal control   */
+#define X86_FEATURE_100MHZSTEPS        (9*32+ 6) /* 100 MHz multiplier control */
+#define X86_FEATURE_HWPSTATE   (9*32+ 7) /* Hardware P-State control   */
+#define X86_FEATURE_CONSTANT_TSC (9*32+ 8) /* Constant rate TSC ticks  */

... to represent the 'is any of these set' property.

[ btw., there's a typo in the X86_FEATURE_TS comment above ]

	Ingo
