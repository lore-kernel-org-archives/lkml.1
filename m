Return-Path: <linux-kernel-owner+w=401wt.eu-S1762436AbXIZVaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762436AbXIZVaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756154AbXIZVaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:30:09 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:46403 "EHLO
	outbound1-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752349AbXIZVaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:30:06 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Wed, 26 Sep 2007 15:30:07 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "Joerg Pommnitz" <pommnitz@yahoo.com>, cebbert@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Regression in 2.6.23-pre Was: Problems with 2.6.23-rc6 on
 AMD Geode LX800
Message-ID: <20070926213007.GD14877@cosmic.amd.com>
References: <637040.99806.qm@web51411.mail.re2.yahoo.com>
 <46FA6858.5060908@zytor.com> <20070926154106.GG7582@cosmic.amd.com>
 <46FAAFA7.50106@zytor.com> <20070926205825.GA14877@cosmic.amd.com>
 <46FAC958.9000501@zytor.com> <20070926211558.GB14877@cosmic.amd.com>
 <46FACD33.1050503@zytor.com>
MIME-Version: 1.0
In-Reply-To: <46FACD33.1050503@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 26 Sep 2007 21:29:50.0131 (UTC)
 FILETIME=[5E81D830:01C80084]
X-WSS-ID: 6AE410C413S398072-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/09/07 14:20 -0700, H. Peter Anvin wrote:
> Testing this patch now:
> 

> >From 2efa33f81ef56e7700c09a3d8a881c96692149e5 Mon Sep 17 00:00:00 2001
> From: H. Peter Anvin <hpa@zytor.com>
> Date: Wed, 26 Sep 2007 14:11:43 -0700
> Subject: [PATCH] [x86 setup] Handle case of improperly terminated E820 chain
> 
> At least one system (a Geode system with a Digital Logic BIOS) has
> been found which suddenly stops reporting the SMAP signature when
> reading the E820 memory chain.  We can't know what, exactly, broke in
> the BIOS, so if we detect this situation, declare the E820 data
> unusable and fall back to E801.
> 
> Also, revert to original behavior of always probing all memory
> methods; that way all the memory information is available to the
> kernel.
> 
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Cc: Jordan Crouse <jordan.crouse@amd.com>
> Cc: Joerg Pommnitz <pommnitz@yahoo.com>
> ---
>  arch/i386/boot/memory.c |   30 +++++++++++++++++++++++-------
>  1 files changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/i386/boot/memory.c b/arch/i386/boot/memory.c
> index 1a2e62d..bccaa1c 100644
> --- a/arch/i386/boot/memory.c
> +++ b/arch/i386/boot/memory.c
> @@ -20,6 +20,7 @@
>  
>  static int detect_memory_e820(void)
>  {
> +	int count = 0;
>  	u32 next = 0;
>  	u32 size, id;
>  	u8 err;
> @@ -33,14 +34,24 @@ static int detect_memory_e820(void)
>  		      "=m" (*desc)
>  		    : "D" (desc), "a" (0xe820));
>  
> -		if (err || id != SMAP)
> +		/* Some BIOSes stop returning SMAP in the middle of
> +		   the search loop.  We don't know exactly how the BIOS
> +		   screwed up the map at that point, we might have a
> +		   partial map, the full map, or complete garbage, so
> +		   just return failure. */
> +		if (id != SMAP) {
> +			count = 0;
>  			break;
> +		}
>  
> -		boot_params.e820_entries++;
> +		if (err)
> +			break;
> +
> +		count++;
>  		desc++;
> -	} while (next && boot_params.e820_entries < E820MAX);
> +	} while (next && count < E820MAX);
>  
> -	return boot_params.e820_entries;
> +	return boot_params.e820_entries = count;
>  }
>  
>  static int detect_memory_e801(void)
> @@ -89,11 +100,16 @@ static int detect_memory_88(void)
>  
>  int detect_memory(void)
>  {
> +	int err = -1;
> +
>  	if (detect_memory_e820() > 0)
> -		return 0;
> +		err = 0;
>  
>  	if (!detect_memory_e801())
> -		return 0;
> +		err = 0;
> +
> +	if (!detect_memory_88())
> +		err = 0;
>  
> -	return detect_memory_88();
> +	return err;
>  }
> -- 
> 1.5.3.1
> 

Works here with the buggy BIOS.  

Acked-by: Jordan Crouse <jordan.crouse@amd.com>

Thanks.

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


