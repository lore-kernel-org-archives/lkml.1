Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbZABQun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbZABQun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZABQue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:50:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756667AbZABQud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:50:33 -0500
Date: Fri, 2 Jan 2009 08:49:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       rdreier@cisco.com, ian.campbell@citrix.com,
       jeremy.fitzhardinge@citrix.com, deller@gmx.de, rusty@rustcorp.com.au,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@mcmartin.ca, randolph@tausq.org, sam@ravnborg.org,
       dave@hiauly1.hia.nrc.ca
Subject: Re: [PATCH] kbuild: Disallow GCC 4.1.0 / 4.1.1
In-Reply-To: <20090102115547.GB3027@elte.hu>
Message-ID: <alpine.LFD.2.00.0901020844070.5086@localhost.localdomain>
References: <alpine.LFD.2.00.0812310942110.5086@localhost.localdomain> <20081231105425.9ccac21d.akpm@linux-foundation.org> <alpine.LFD.2.00.0812311318420.5086@localhost.localdomain> <20081231.141408.60544902.davem@davemloft.net>
 <20090102115547.GB3027@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Jan 2009, Ingo Molnar wrote:
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -36,12 +36,25 @@ extern void __chk_io_ptr(const volatile void __iomem *);
>  
>  #ifdef __KERNEL__
>  
> -#if __GNUC__ >= 4
> +/*
> + * GCC 4.1.0 and 4.1.1 has a bug that can miscompile __weak symbols,
> + * by inlining __weak functions into same-file call sites - breaking the
> + * kernel if the __weak symbol is overriden later on.
> + *
> + * We have not found a clean way to work around this bug on the source
> + * code level, so we do not allow these compilers (which are quite
> + * rare these days, have other bugs and are superceded by the 4.1.2
> + * bugfix release anyway):
> + */
> +#define gcc41_inlining_bug \
> +	(__GNUC__ == 4 && __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ <= 1)
> +
> +#if __GNUC__ >= 4 && !gcc41_inlining_bug
>  # include <linux/compiler-gcc4.h>

I think this is wrong.

Just move the check into <linux/compiler-gcc4.h>

It makes no sense to do stuff that is specific to gcc4 in the general gcc 
header file. It seems you did this just in order to re-use a (bad) generic 
error case. 

			Linus
