Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbXKMW10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbXKMW10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbXKMW1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:27:08 -0500
Received: from r00tworld.com ([212.85.137.21]:58678 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbXKMW1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:27:07 -0500
X-Greylist: delayed 1906 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Nov 2007 17:27:06 EST
From: pageexec@freemail.hu
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 13 Nov 2007 22:54:18 +0200
MIME-Version: 1.0
Subject: Re: [patch 06/11] Text Edit Lock - Alternative code for x86
Reply-to: pageexec@freemail.hu
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>
Message-ID: <473A2B1A.16967.38D5698D@pageexec.freemail.hu>
In-reply-to: <20071113184719.506949138@polymtl.ca>
References: <20071113184627.667866257@polymtl.ca>, <20071113184719.506949138@polymtl.ca>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Tue, 13 Nov 2007 22:53:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 Nov 2007 at 13:46, Mathieu Desnoyers wrote:

> +void *text_poke_early(void *addr, const void *opcode, size_t len)
> +{
> +	memcpy(addr, opcode, len);
> +	text_sync(addr, len);
> +	return addr;
> +}

why do you need this function (vs. using text_poke throughout)?

> +#define kernel_wp_save(cr0)					\
> +	do {							\
> +		preempt_disable();				\
> +		cr0 = read_cr0();				\
> +		if (cpu_data(smp_processor_id()).wp_works_ok)	\

why do you need this test? if cr0.wp is ineffective, then it doesn't
matter whether it's on or off (in fact, at least the intel manual
says that 386s would not even let you change its value, they'll
silently ignore attempts of setting the wp bit).

> +			write_cr0(cr0 & ~X86_CR0_WP);		\
> +	} while (0)
> +
> +#define kernel_wp_restore(cr0)					\
> +	do {							\
> +		if (cpu_data(smp_processor_id()).wp_works_ok)	\

ditto...

> +			write_cr0(cr0);				\
> +		preempt_enable();				\
> +	} while (0)
>  
>  #endif /* _I386_ALTERNATIVE_H */


