Return-Path: <linux-kernel-owner+w=401wt.eu-S1763093AbYEHU20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763093AbYEHU20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYEHU2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:28:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755911AbYEHU2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:28:13 -0400
Date: Thu, 8 May 2008 13:26:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: segher@kernel.crashing.org, hancockr@shaw.ca, lists@nerdbynature.de,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       johnstul@us.ibm.com
Subject: Re: [PATCH] common implementation of iterative div/mod
Message-Id: <20080508132630.f4105b42.akpm@linux-foundation.org>
In-Reply-To: <48231959.4050406@goop.org>
References: <fa.QTbvQYXhEm5VNP5dvkl5JG7NHYQ@ifi.uio.no>
	<481DF3D8.3010108@shaw.ca>
	<a6dd201e0149f8dbdf10a7a194673833@kernel.crashing.org>
	<48217674.8080903@goop.org>
	<48231959.4050406@goop.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 May 2008 16:16:41 +0100
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> We have a few instances of the open-coded iterative div/mod loop, used
> when we don't expcet the dividend to be much bigger than the divisor.
> Unfortunately modern gcc's have the tendency to strength "reduce" this
> into a full mod operation, which isn't necessarily any faster, and
> even if it were, doesn't exist if gcc implements it in libgcc.
> 
> The workaround is to put a dummy asm statement in the loop to prevent
> gcc from performing the transformation.
> 
> This patch creates a single implementation of this loop, and uses it
> to replace the open-coded versions I know about.

Fair enough.  I'll plan on feeding this into 2.6.26 soon.

>  #endif /* BITS_PER_LONG == 32 */
> +
> +/*
> + * Iterative div/mod for use when dividend is not expected to be much
> + * bigger than divisor.
> + */
> +unsigned iter_div_u64_rem(u64 dividend, u32 divisor, u64 *remainder)
> +{
> +	unsigned ret = 0;
> +
> +	while(dividend >= divisor) {
> +		/* The following asm() prevents the compiler from
> +		   optimising this loop into a modulo operation.  */
> +		asm("" : "+rm"(dividend));
> +
> +		dividend -= divisor;
> +		ret++;
> +	}
> +
> +	*remainder = dividend;
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(iter_div_u64_rem);
> 

I think it would be better to do s/unsigned/u32/ here.  It's cosmetic, but
all this sort of code is pretty formal about the sizes of the types which
it uses, and it sure needs to be.

