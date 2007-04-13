Return-Path: <linux-kernel-owner+w=401wt.eu-S965197AbXDMUcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965197AbXDMUcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965271AbXDMUcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:32:52 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35978 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965197AbXDMUcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:32:51 -0400
Message-ID: <461FE8EC.3090304@zytor.com>
Date: Fri, 13 Apr 2007 13:32:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Crash while mapping memory in pagetable_init() (Was: Re: .config)
References: <20070413174913.GA25234@ezr.goop.org> <20070413183841.GP10574@sequoia.sous-sol.org> <20070413190552.GQ10574@sequoia.sous-sol.org> <461FD97B.1010203@goop.org> <461FE36D.1050205@vmware.com> <461FE77A.6020307@zytor.com> <461FE7C7.7050204@goop.org>
In-Reply-To: <461FE7C7.7050204@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> Really (pae ? 2M : 1M), in other words, plus the 128K for bootmem. 
>> Note that this is creating page tables for, not erasing.  To map 2M,
>> we will only use 2K of additional memory (meaning there is 50% chance
>> we end up using an additional 4K page.)
>>
>> So the solution is simply to change INIT_MAP_BEYOND_END in head.S
>> appropriately.
> Like this?  Should we bother adding some slop pages for allocations
> which happen before paging_init()?

Yes, although it really should be sensitive to CONFIG_X86_PAE.

>  
>  /*
>   * This is how much memory *in addition to the memory covered up to
> - * and including _end* we need mapped initially.  We need one bit for
> - * each possible page, but only in low memory, which means
> - * 2^32/4096/8 = 128K worst case (4G/4G split.)
> + * and including _end* we need mapped initially.
> + * We need:
> + *  - one bit for each possible page, but only in low memory, which means
> + *     2^32/4096/8 = 128K worst case (4G/4G split.)
> + *  - enough space to map all low memory, which means
> + *     (2^32/4096) / 512 + 4 pages (worst case for PAE)
>   *
>   * Modulo rounding, each megabyte assigned here requires a kilobyte of
>   * memory, which is currently unreclaimed.
>   *
>   * This should be a multiple of a page.
>   */
> -#define INIT_MAP_BEYOND_END	(128*1024)
> +#define INIT_MAP_BEYOND_END	(128*1024 + (2048 + 4)*4096)

I suggest, for clarity and to minimize bloat:

#ifdef CONFIG_X86_PAE
# define PAGE_TABLE_SIZE	((2048+4)*4096)
#else
# define PAGE_TABLE_SIZE	((1024+1)*4096)
#endif

#define BOOTMEM_SIZE		(128*1024)

#define INIT_MAP_BEYOND_END	(BOOTMEM_SIZE+PAGE_TABLE_SIZE)

	-hpa
