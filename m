Return-Path: <linux-kernel-owner+w=401wt.eu-S1762978AbXGUMAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762978AbXGUMAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 08:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933908AbXGUMAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 08:00:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:9330 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764283AbXGUMAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 08:00:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=H5lWRFGzELQQYtD+vjwJ7hXxp3FygAd5dJCt6VpqdzYJ7lWltwjv0bzvwJTrtIWgEpBwaG1bBIGvESClWLQv3ckAFdRz+h/iR+NNWcAK3jq8gO16YF9qvJN2fXz+WasopwgnNTkHQDd9saGyFGQmG9BYuabl1RFHFcLWqE9Sg0A=
Date: Sat, 21 Jul 2007 16:00:01 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: juergen@kreuzholzen.de, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [9/11] x86: Replace NSC/Cyrix specific chipset access macros by inlined functions.
Message-ID: <20070721120001.GA5832@martell.zuzino.mipt.ru>
References: <20070720532.949522000@suse.de> <20070720153253.D17F214E7B@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720153253.D17F214E7B@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 05:32:53PM +0200, Andi Kleen wrote:
> --- /dev/null
> +++ linux/include/asm-i386/processor-cyrix.h
> @@ -0,0 +1,30 @@
> +/*
> + * NSC/Cyrix CPU indexed register access. Must be inlined instead of
> + * macros to ensure correct access ordering
> + * Access order is always 0x22 (=offset), 0x23 (=value)
> + *
> + * When using the old macros a line like
> + *   setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
> + * gets expanded to:
> + *  do {
> + *    outb((CX86_CCR2), 0x22);
> + *    outb((({
> + *        outb((CX86_CCR2), 0x22);
> + *        inb(0x23);
> + *    }) | 0x88), 0x23);
> + *  } while (0);
> + *
> + * which in fact violates the access order (= 0x22, 0x22, 0x23, 0x23).
> + */
> +
> +static inline u8 getCx86(u8 reg)
> +{
> +	outb(reg, 0x22);
> +	return inb(0x23);
> +}
> +
> +static inline void setCx86(u8 reg, u8 data)
> +{
> +	outb(reg, 0x22);
> +	outb(data, 0x23);
> +}

Why bother with new header, just make static inline in asm/processor.h.

