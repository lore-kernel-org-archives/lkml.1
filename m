Return-Path: <linux-kernel-owner+w=401wt.eu-S1757560AbYKURIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbYKURIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757311AbYKURHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:07:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45179 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757289AbYKURHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:07:45 -0500
Date: Fri, 21 Nov 2008 18:07:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 04/10] x86: add helper functions for consistency checks
Message-ID: <20081121170719.GI733@elte.hu>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com> <1227284770-19215-5-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227284770-19215-5-git-send-email-joerg.roedel@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> +static bool check_unmap(struct dma_debug_entry *ref,
> +		struct dma_debug_entry *entry)
> +{
> +	bool errors = false;
> +
> +	if (!entry) {
> +		dev_printk(KERN_ERR, ref->dev, "PCI-DMA: device driver tries "
> +			   "to free DMA memory it has not allocated "
> +			   "[device address=0x%016llx] [size=%llu bytes]\n",
> +			   ref->dev_addr, ref->size);
> +		dump_stack();
> +
> +		return false;

okay, the warnings need to be one-shot. It will be enabled by distros 
in debug kernels to test a wide range of drivers, and the output will 
be collected by kerneloops.org. Distros will disable the debug feature 
fast if it spams the logs.

So please make it WARN_ONCE() type of warnings. Dont use dump_stack() 
directly but use the WARN() signature so that it's picked up by 
automated bug collection mechanisms.

This holds true for all the other warnings as well. Plus probably the 
whole mechanism should self-deactivate like lockdep does, when it 
notices the first error. That guarantees that even if it has a false 
positive or some other bug it wont break more stuff.

> +	struct dma_debug_entry ref = {
> +		.dev = dev,
> +		.dev_addr = addr,
> +		.size = size,
> +		.direction = direction,
> +	};

(align the field init vertically please.)

	Ingo
