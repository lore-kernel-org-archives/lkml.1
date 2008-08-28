Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbYH1VRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbYH1VRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 17:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbYH1VRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 17:17:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44355 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbYH1VRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 17:17:05 -0400
Date: Thu, 28 Aug 2008 23:16:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Witbrodt <dawitbro@sbcglobal.net>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v2
Message-ID: <20080828211647.GA32431@elte.hu>
References: <1219955655-18357-1-git-send-email-yhlu.kernel@gmail.com> <alpine.LFD.1.10.0808281339250.3300@nehalem.linux-foundation.org> <86802c440808281352y1371f437vf3409d9e104d1a51@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808281352y1371f437vf3409d9e104d1a51@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> +void __init e820_reserve_resources_late(void)
> +{
> +	int i;
> +	struct resource *res;
> +
> +	res = e820_res;
> +	for (i = 0; i < e820.nr_map; i++) {
> +		if (e820.map[i].type == E820_RESERVED && res->start >= (1ULL<<20))
> +			insert_resource(&iomem_resource, res);
> +		res++;
> +	}
> +}

Here we have the problem of overlap i outlined earlier: if there's a 
partial overlap at this stage (as i think it can happen in the hpet case 
on David's box), we wont insert the E820_RESERVED resource.

The hpet hang will be solved, because we dont reprogram the BAR, but we 
now keep the formerly e820-reserved area as 'free' - which the PCI code 
could allocate new resources into - which could cause other problems 
(hangs, non-working devices, etc.) down the line.

Which most likely wont happen currently in practice (there's enough free 
space elsewhere), but it's still a not truly 'free' area and it would be 
nice to have a complete and correct picture, based on all sources of 
information we have.

	Ingo
