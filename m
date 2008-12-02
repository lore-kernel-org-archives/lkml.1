Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbYLBIR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbYLBIR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 03:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbYLBIRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 03:17:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36378 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbYLBIRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 03:17:47 -0500
Date: Tue, 2 Dec 2008 09:17:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <ak@linux.intel.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] oprofile: fix CPU unplug panic in ppro_stop()
Message-ID: <20081202081729.GA5424@elte.hu>
References: <4934D3E1.1000507@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4934D3E1.1000507@cosmosbay.com>
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


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> If oprofile statically compiled in kernel, a cpu unplug triggers
> a panic in ppro_stop(), because a NULL pointer is dereferenced.
>
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> ---
> arch/x86/oprofile/op_model_ppro.c |    4 ++++
> 1 files changed, 4 insertions(+)

> diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
> index 716d26f..e9f80c7 100644
> --- a/arch/x86/oprofile/op_model_ppro.c
> +++ b/arch/x86/oprofile/op_model_ppro.c
> @@ -156,6 +156,8 @@ static void ppro_start(struct op_msrs const * const msrs)
>  	unsigned int low, high;
>  	int i;
>  
> +	if (!reset_value)
> +		return;
>
> 	for (i = 0; i < num_counters; ++i) {
>  		if (reset_value[i]) {
>  			CTRL_READ(low, high, msrs, i);

i checked which commit caused this, and it is:

  From b99170288421c79f0c2efa8b33e26e65f4bb7fb8 Mon Sep 17 00:00:00 2001
  From: Andi Kleen <ak@linux.intel.com>
  Date: Mon, 18 Aug 2008 14:50:31 +0200
  Subject: [PATCH] oprofile: Implement Intel architectural perfmon support

it is an absolutely horrible commit - which has caused the second 
regression in a row already. The _real_ "perfmon support" patch should 
have been a _oneliner_:

  -#define NUM_COUNTERS 2
  -#define NUM_CONTROLS 2
  +#define NUM_COUNTERS 8
  +#define NUM_CONTROLS 8

as Nehalem has 4 performance counters so 8 is plenty - and we dont expect 
more than 8 in the next 5 years or so.

It was absolutely unnecessary to add kmalloc to this rarely executed 
codepath - and the way it was added was absolutely horrible as well, it 
was tacked on in the middle of an existing codepath, instead of factoring 
it out nicely. Perfmon will eventually replace PMC management anyway, so 
there was no "this way it's cleaner" argument either. So this code should 
have been changed minimally, instead of slapping in a full kmalloc for a 
simple array extension from 2 to 4 entries ...

You need to be more careful when changing x86 architecture code.

	Ingo
