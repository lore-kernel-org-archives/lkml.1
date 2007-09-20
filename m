Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbXITKYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbXITKYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 06:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750717AbXITKYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 06:24:38 -0400
Received: from hu-out-0506.google.com ([72.14.214.236]:2790 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbXITKYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 06:24:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=jOwqAeIjruGKgj/EnFfbjZVQxGF3EwgFAgEAcgiShEthLF2toL2VP0nQk/gkNYK44gqC/E02ZjADpyBlc5GUlDwdKlDGHuxV5XX3dAX60YbsxNsT79xoQQa2sgQf4jBH1UKgtiuyeNSXJSHBct3P2sRXJT7w1vVaBNALKqCWakY=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
Date: Thu, 20 Sep 2007 11:24:12 +0100
User-Agent: KMail/1.9.1
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca>
In-Reply-To: <20070918210853.588573678@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201124.13097.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2007 22:07, Mathieu Desnoyers wrote:
> i386 optimization of the immediate values which uses a movl with code patching
> to set/unset the value used to populate the register used as variable source.
> 
> Changelog:
> - Use text_poke_early with cr0 WP save/restore to patch the bypass. We are doing
>   non atomic writes to a code region only touched by us (nobody can execute it
>   since we are protected by the immediate_mutex).
> - Put immediate_set and _immediate_set in the architecture independent header.

> +struct __immediate {
> +	long var;		/* Pointer to the identifier variable of the
> +				 * immediate value
> +				 */
> +	long immediate;		/*
> +				 * Pointer to the memory location of the
> +				 * immediate value within the instruction.
> +				 */
> +	long size;		/* Type size. */
> +};


> +		case 2:							\
> +			asm (	".section __immediate, \"a\", @progbits;\n\t" \
> +					".long %1, (0f)+2, 2;\n\t"	\
> +					".previous;\n\t"		\
> +					"1:\n\t"			\
> +					".align 2;\n\t"			\
> +					"0:\n\t"			\
> +					"mov %2,%0;\n\t"		\
> +				: "=r" (value)				\
> +				: "m" (name##__immediate),		\
> +				  "i" (0));				\

Instead of letting gcc use whatever instruction it sees fit best
for accessing the variable (like add/cmp/test...)
now we force it to use mov imm,reg first. Maybe with preceding nop
due to "align 2".

And then we use 12 more bytes in __immediate section
*for each* place where you read the variable.

Do you plan to use the same approach on x86_64?
I mean, longs there are twice as long.

Can this be made conditional, on CONFIG_CC_OPTIMIZE_FOR_SIZE perhaps?
--
vda
