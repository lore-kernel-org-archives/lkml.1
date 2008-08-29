Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYH2AyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYH2AyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 20:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbYH2AyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 20:54:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752955AbYH2AyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 20:54:05 -0400
Date: Thu, 28 Aug 2008 17:53:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v3
In-Reply-To: <1219970489-1615-1-git-send-email-yhlu.kernel@gmail.com>
Message-ID: <alpine.LFD.1.10.0808281750520.3300@nehalem.linux-foundation.org>
References: <1219970489-1615-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 28 Aug 2008, Yinghai Lu wrote:
>  /*
>   * Mark e820 reserved areas as busy for the resource manager.
>   */
> +struct resource __initdata *e820_res;

Btw, make this one "static" - I don't think anybody outside of this file 
should ever use it anyway.

And this:

> +		if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20))
> +			insert_resource(&iomem_resource, res);

is probably worthy of a comment. 

And finally:

> +void __init e820_reserve_resources_late(void)
> +{
> +	int i;
> +	struct resource *res;
> +
> +	res = e820_res;
> +	for (i = 0; i < e820.nr_map; i++) {
> +		if (e820.map[i].type == E820_RESERVED && res->start >= (1ULL<<20))
> +			insert_resource(&iomem_resource, res);

instead of duplicating the conditional and always having to worry about it 
matching, how about just making it

		if (!res->parent)
			insert_resource(&iomem_resource, res);

which basically says that "if it's not already inserted, try to re-insert 
it now".

		Linus
