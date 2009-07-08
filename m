Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbZGHFFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbZGHFFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 01:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbZGHFFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 01:05:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:58531 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbZGHFFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 01:05:25 -0400
Date: Tue, 7 Jul 2009 22:06:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v4] RO/NX protection for loadable kernel modules
Message-ID: <20090707220640.5352ac94@infradead.org>
In-Reply-To: <817ecb6f0907071747g1d3455cdy9eb84102c17c5ad0@mail.gmail.com>
References: <817ecb6f0907051623l46ad93e9uc24d8d61669c938e@mail.gmail.com>
	<200907061043.11793.rusty@rustcorp.com.au>
	<817ecb6f0907071747g1d3455cdy9eb84102c17c5ad0@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009 20:47:42 -0400
Siarhei Liakh <sliakh.lkml@gmail.com> wrote:

> 
> The patch have been developed for Linux 2.6.30 by Siarhei Liakh
> <sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.
> 
> ---
> 
> Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
> Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>

I like it, you can already put

Acked-by: Arjan van de Ven <arjan@linux.intel.com> 

there if you want. If you're going to make a v5 then I do have another
suggestion for improvement... (only possible now that the code is very
clean)

> +	/* Set RO for module text and RO-data*/
> +	if (ro_size > 0) {
> +		begin_addr = (unsigned long) base;
> +		end_addr = begin_addr + ro_size;
> +
> +		/*skip last page if end address is not page-aligned*/
> +		if (!IS_ALIGNED(end_addr, PAGE_SIZE))
> +			end_addr = ALIGN(end_addr - PAGE_SIZE,PAGE_SIZE); 
> +
> +		/*Set text RO if there are still pages between begin
> and end*/
> +		if (end_addr > begin_addr) {
> +			pg_count = PFN_DOWN(end_addr - 1) -
> +					PFN_DOWN(begin_addr) + 1;
> +			DEBUGP("  RO: 0x%lx %lu\n", begin_addr,
> pg_count);
> +			set_memory_ro(begin_addr, pg_count);
> +		} else {
> +			DEBUGP("  RO: less than a page, not
> enforcing.\n");
> +		}
> +	} else {
> +		DEBUGP("  RO: section not present.\n");
> +	}

I *think* this can be done as

begin_pfn = PFN_UP( (base);
end_pfn = PFN_DOWN(base + ro_size);

if (end_pfn > begin_pfn)
	set_memory_ro(begin_pfn >> PAGE_SHIFT, end_pfn - begin_pfn);

(note that I think the +1 you have might be buggy)

if you use PFN_UP/PFN_DOWN like this (rounding the start up, rounding the end down),
then your entire "fix alignment" is not needed, the PFN rounding will automatically
take case of this.

similar construct also applies to the NX codepath that follows right after this RO codepath.
