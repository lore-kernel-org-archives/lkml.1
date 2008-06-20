Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515AbYFTTv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbYFTTv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYFTTvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:51:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbYFTTvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:51:47 -0400
Date: Fri, 20 Jun 2008 15:45:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: kexec@lists.infradead.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Limit E820 map when a user-defined memory map is
	specified
Message-ID: <20080620194540.GD21235@redhat.com>
References: <1213977420-1555-1-git-send-email-bwalle@suse.de> <1213977420-1555-4-git-send-email-bwalle@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213977420-1555-4-git-send-email-bwalle@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 05:57:00PM +0200, Bernhard Walle wrote:
> This patch brings back limiting of the E820 map when a user-defined
> E820 map is specified. While the behaviour of i386 (32 bit) was to limit
> the E820 map (and /proc/iomem), the behaviour of x86-64 (64 bit) was not to
> limit.
> 
> That patch limits the E820 map again for both x86 architectures.
> 
> Code was tested for compilation and booting on a 32 bit and 64 bit system.
> 
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> ---
>  arch/x86/kernel/e820.c |   30 ++++++++++++++++++++++++++++++
>  1 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index f5b1736..2e7d385 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -934,6 +934,33 @@ static void early_panic(char *msg)
>  	panic(msg);
>  }
>  
> +void __init e820_limit_regions(unsigned long long size)
> +{
> +	unsigned long long current_addr;
> +	int i;
> +
> +	for (i = 0; i < e820.nr_map; i++) {
> +		current_addr = e820.map[i].addr + e820.map[i].size;
> +		if (current_addr < size)
> +			continue;
> +
> +		if (e820.map[i].type != E820_RAM)
> +			continue;
> +
> +		if (e820.map[i].addr >= size) {
> +			/*
> +			 * This region starts past the end of the
> +			 * requested size, skip it completely.
> +			 */
> +			e820.nr_map = i;
> +		} else {
> +			e820.nr_map = i + 1;
> +			e820.map[i].size -= current_addr - size;
> +		}
> +		return;
> +	}
> +}
> +
>  /* "mem=nopentium" disables the 4MB page tables. */
>  static int __init parse_memopt(char *p)
>  {
> @@ -951,6 +978,8 @@ static int __init parse_memopt(char *p)
>  
>  	mem_size = memparse(p, &p);
>  	end_user_pfn = mem_size>>PAGE_SHIFT;
> +	e820_limit_regions(mem_size);
> +
>  	return 0;
>  }
>  early_param("mem", parse_memopt);
> @@ -995,6 +1024,7 @@ static int __init parse_memmap_opt(char *p)
>  		e820_add_region(start_at, mem_size, E820_RESERVED);
>  	} else {
>  		end_user_pfn = (mem_size >> PAGE_SHIFT);
> +		e820_limit_regions(mem_size);
>  	}

Hi Bernhard,

Just curious, when do we hit this bottom else condition?

In Documentation/kernel-parameters.txt file, I see, there are four
types of memmap= options. "exactmap" "@" "#" and "$". In the code
above we have already parsed all these option. So default condition
should be an error. Instead we seem to be limiting the memory size,
(something done by mem= parameter)..

Thanks
Vivek
