Return-Path: <linux-kernel-owner+w=401wt.eu-S1764153AbYETJrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764153AbYETJrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757486AbYETJrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:47:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58460 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754536AbYETJrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:47:39 -0400
Date: Tue, 20 May 2008 02:45:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <oberparleiter@googlemail.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] consolidate all within() implementations
Message-Id: <20080520024535.6b4f487e.akpm@linux-foundation.org>
In-Reply-To: <48328700.4000907@googlemail.com>
References: <48313E23.4030104@de.ibm.com>
	<1211230216.5915.90.camel@brick>
	<48328700.4000907@googlemail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 10:08:32 +0200 Peter Oberparleiter <oberparleiter@googlemail.com> wrote:

> Harvey Harrison wrote:
> > On Mon, 2008-05-19 at 10:45 +0200, Peter Oberparleiter wrote:
> >> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> >> 
> >> This patch consolidates a number of different implementations of the
> >> within() function which checks whether an address is within a specified
> >> address range.
> > 
> > Would it be that hard to just make them static inlines taking unsigned
> > longs?
> 
> I was hoping to get by without the spray of unsigned long casts that
> entails the enforcement of this specific parameter type, seeing that
> each implementation had it's own combination of longs and void *.
> 
> On the other hand, an inline function would of course be the cleaner
> approach, so if the code owners agree, here goes take #2:
> 
> --
> 
> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> 
> This patch consolidates a number of different implementations of the
> within() function which checks whether an address is within a specified
> address range. Apart from parameter typing, existing implementations can
> be classified in two categories which differ in the way the range is
> specified:
> 
>   1) by start and end address
>   2) by start and size
> 
> Case 1) is covered by addr_within() while 2) is covered by
> addr_within_len().
> 
> Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> ---
>  arch/x86/mm/pageattr.c |   20 ++++++++------------
>  include/linux/kernel.h |   24 ++++++++++++++++++++++++
>  kernel/lockdep.c       |   12 +++++-------
>  kernel/module.c        |   35 ++++++++++++++++++++---------------
>  4 files changed, 57 insertions(+), 34 deletions(-)
> 
> Index: linux-2.6.26-rc3/include/linux/kernel.h
> ===================================================================
> --- linux-2.6.26-rc3.orig/include/linux/kernel.h
> +++ linux-2.6.26-rc3/include/linux/kernel.h
> @@ -434,6 +434,30 @@ static inline char *pack_hex_byte(char *
>  	__val > __max ? __max: __val; })
>  
>  /**
> + * addr_within - check whether address is in start-and-end address range
> + * @addr: address
> + * @start: start address (included in range)
> + * @end: end address (excluded from range)
> + */
> +static inline int addr_within(unsigned long addr, unsigned long start,
> +			      unsigned long end)
> +{
> +	return (addr >= start) && (addr < end);
> +}
> +
> +/**
> + * addr_within_len - check whether address is in start-and-length address range
> + * @addr: address
> + * @start: start of range
> + * @len: number of bytes in range
> + */
> +static inline int addr_within_len(unsigned long addr, unsigned long start,
> +				  unsigned long len)
> +{
> +	return (addr >= start) && (addr < (start + len));
> +}

The kernel's use of unsigned long to represent pointers sometimes makes
sense, but often gets us into a mess.  It's OK in bootup code which
fiddles with memory map layout because there is no reason why such
code will ever dereference any of the addresses.

But I don't think we can assume this usage pattern when creating a
kernel-wide facility in kernel.h.

So yes, I do think that an address-comparison tool like this should
operate on void*'s.  (They will need to be const void*'s).

> +			if (addr_within_len((unsigned long) class->key,
> +					    (unsigned long) start, size))
> +			else if (addr_within_len((unsigned long) class->name,
> +						 (unsigned long) start, size))
> +	if (addr_within_len(addr, (unsigned long) mod->module_init,
> +		if (addr_within_len(addr, (unsigned long) mod->module_init,
> +		    || addr_within_len(addr, (unsigned long) mod->module_core,
> +		if (addr_within_len(addr, (unsigned long) mod->module_init,
> +		    addr_within_len(addr, (unsigned long) mod->module_core,
> +		if (addr_within_len(addr, (unsigned long) mod->module_init,
> +		    addr_within_len(addr, (unsigned long) mod->module_core,
> +		if (addr_within_len(addr, (unsigned long) mod->module_core,
> +		if (addr_within_len(addr, (unsigned long) mod->module_init,
> +		    || addr_within_len(addr, (unsigned long) mod->module_core,

And you've had to add a great pile of casts anwyay?
