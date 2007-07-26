Return-Path: <linux-kernel-owner+w=401wt.eu-S1762017AbXGZFZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762017AbXGZFZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 01:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbXGZFZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 01:25:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44040 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163AbXGZFZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 01:25:17 -0400
Date: Wed, 25 Jul 2007 22:25:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dougthompson@xmission.com
Cc: greg@kroah.com, ralf@linux-mips.org, egor@pasemi.com,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] include asm-mips add missing edac h file
Message-Id: <20070725222500.e537531d.akpm@linux-foundation.org>
In-Reply-To: <46a7b8a5.iyNdV9o+A3Vzog2D%dougthompson@xmission.com>
References: <46a7b8a5.iyNdV9o+A3Vzog2D%dougthompson@xmission.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 14:55:01 -0600 dougthompson@xmission.com wrote:

> --- /dev/null
> +++ linux-2.6.23-rc1/include/asm-mips/edac.h
> @@ -0,0 +1,35 @@
> +#ifndef ASM_EDAC_H
> +#define ASM_EDAC_H
> +
> +/* ECC atomic, DMA, SMP and interrupt safe scrub function */
> +
> +static __inline__ void atomic_scrub(void *va, u32 size)

Please don't use __inline__ or __inline.  Good old "inline" will do.

<cc's the checkpatch maintainer>

<edits the diff>

> +{
> +	unsigned long *virt_addr = va;
> +	unsigned long temp;
> +	u32 i;
> +
> +	for (i = 0; i < size / sizeof(unsigned long); i++, virt_addr++) {
> +
> +		/*
> +		 * Very carefully read and write to memory atomically
> +		 * so we are interrupt, DMA and SMP safe.
> +		 *
> +		 * Intel: asm("lock; addl $0, %0"::"m"(*virt_addr));
> +		 */
> +
> +		__asm__ __volatile__ (
> +		"       .set    mips3                                   \n"
> +		"1:     ll      %0, %1          # atomic_add            \n"
> +		"       ll      %0, %1          # atomic_add            \n"
> +		"       addu    %0, $0                                  \n"
> +		"       sc      %0, %1                                  \n"
> +		"       beqz    %0, 1b                                  \n"
> +		"       .set    mips0                                   \n"
> +		: "=&r" (temp), "=m" (*virt_addr)
> +		: "m" (*virt_addr));
> +
> +	}
> +}

hm, I'd have thought that we could us plain old atomic_add() for this.
