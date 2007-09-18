Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbXIRVv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbXIRVv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbXIRVvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:51:20 -0400
Received: from gw.goop.org ([64.81.55.164]:42296 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbXIRVvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:51:19 -0400
Message-ID: <46F04856.3010808@goop.org>
Date: Tue, 18 Sep 2007 14:51:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca>
In-Reply-To: <20070918210853.588573678@polymtl.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:

> +#define immediate_read(name)						\
> +	({								\
> +		__typeof__(name##__immediate) value;			\
> +		switch (sizeof(value)) {				\
> +		case 1:							\
> +			asm (	".section __immediate, \"a\", @progbits;\n\t" \
> +					".long %1, (0f)+1, 1;\n\t"	\
> +					".previous;\n\t"		\
> +					"0:\n\t"			\
> +					"mov %2,%0;\n\t"		\

Given that you're relying on the exact instruction that this mov
generates, it might be better to explicitly put the opcodes in with
.byte.  That way you're protected from the assembler deciding to
generate some other form of the instruction (for whatever reason).  I
guess substituting in different registers would be a pain.

Aside from that,  is there any reason not to just put $0 in there rather
than use %2?


> +					".long %1, (0f)+1, 4;\n\t"	\
> +					".previous;\n\t"		\
> +					"1:\n\t"			\
> +					".org (1b)+(3-((1b)%%4)), 0x90;\n\t" \
>   
Seems a little complex, but I couldn't come up with anything much better:

	.org . + 3 - (. & 3), 0x90

You can use . rather than needing to define 1:, it doesn't need quite so
many parens, and using &3 avoids the %% wart. 

It's a pity that gas seems to generate plain 0x90 nops rather than
long-nop forms here.  I thought it could do that.

    J
