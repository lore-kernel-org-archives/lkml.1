Return-Path: <linux-kernel-owner+w=401wt.eu-S1751255AbXBML1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbXBML1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 06:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbXBML1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 06:27:54 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:45710 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbXBML1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 06:27:54 -0500
Message-ID: <45D1A092.6030804@cosmosbay.com>
Date: Tue, 13 Feb 2007 12:27:14 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: "Bryan O'Sullivan" <bos@pathscale.com>, Roland Dreier <rolandd@cisco.com>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21 review I] [21/25] x86_64: a memcpy that tries to
 reduce cache pressure
References: <200702101250.142420000@suse.de> <20070210115034.694B013DBF@wotan.suse.de>
In-Reply-To: <20070210115034.694B013DBF@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 13 Feb 2007 12:27:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen a écrit :
> From: "Bryan O'Sullivan" <bos@pathscale.com>
> 
> This copy routine is memcpy-compatible, but on some architectures will use
> cache-bypassing loads to avoid bringing the source data into the cache.
> 
> One case where this is useful is when a device issues a DMA to a memory
> region, and the CPU must copy the DMAed data elsewhere before doing any work
> with it.  Since the source data is read-once, write-never from the CPU's
> perspective, caching the data at those addresses can only evict potentially
> useful data.
> 
> We provide an x86_64 implementation that uses SSE non-temporal loads, and a
> generic version that falls back to plain memcpy.

> +	movq	%r11, 56(%rdi)
> +	addq	%rcx, %rdi
> +	cmpq	%rdx, %rcx	/* is rdx >= 64? */
> +	jbe	.L42
> +	sfence
> +	orl	%edx, %edx
> +	je	.L33

I have three questions/remarks

1) Just curious why sfence is necessary here ?

2) Shouldnt we use this for large buffers, and restrict them to a size 
multiple of 64, to avoid all these conditional branches ?

3) Also, the first 128 bytes of the source buffer will be bring into cache.

