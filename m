Return-Path: <linux-kernel-owner+w=401wt.eu-S1760925AbXFGNtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925AbXFGNtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 09:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757635AbXFGNtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 09:49:09 -0400
Received: from spatial.ca ([66.11.172.77]:16991 "EHLO fawkes.spatial.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757019AbXFGNtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 09:49:08 -0400
Message-ID: <46680CD2.1000007@spatial.ca>
Date: Thu, 07 Jun 2007 09:49:06 -0400
From: Tom Moore <tmoore@spatial.ca>
Reply-To: tmoore@spatial.ca
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
CC: andi@firstfloor.org
Subject: Re: [RFC][PATCH] Re: 4Gb ram not showing up
References: <Pine.LNX.4.58.0706061356310.2657@be1.lrz>
In-Reply-To: <Pine.LNX.4.58.0706061356310.2657@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Sanitizer: Advosys mail filter
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This looks like it would have probably given me the hint I needed.  Can 
I also suggest that you make a change to arch/i386/kernel/setup.c, line 296:

                if (max_pfn > MAX_NONPAE_PFN) {
                        max_pfn = MAX_NONPAE_PFN;
                        printk(KERN_WARNING "Warning only 4GB will be 
used.\n");
-                        printk(KERN_WARNING "Use a PAE enabled kernel.\n");
+                        printk(KERN_WARNING "Use a PAE enabled kernel 
by selecting the HIGHMEM64G configuration option.\n");
                }

It does not seem that PAE is a configuration option that is exposed 
through make menuconfig.  How else are people supposed to know that PAE 
is a side effect of CONFIG_HIGHMEM64G unless they know the kbuild logic?

Tom

Bodo Eggert wrote:
> Change the description of CONFIG_*HIGHMEM* to reflect "lost" memory due to 
> PCI space and the existence of the NX flag.
>
> Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
> ---
> I made this quick patch using the information from LKML as I remembered 
> it. Please verify.
>
> --- 2.6.21/arch/i386/Kconfig.ori	2007-06-06 13:41:09.000000000 +0200
> +++ 2.6.21/arch/i386/Kconfig	2007-06-06 14:07:40.000000000 +0200
> @@ -495,8 +495,8 @@ config NOHIGHMEM
>  	bool "off"
>  	depends on !X86_NUMAQ
>  	---help---
> -	  Linux can use up to 64 Gigabytes of physical memory on x86 systems.
> -	  However, the address space of 32-bit x86 processors is only 4
> +	  Linux can use up to 64 Gigabytes of physical address space on x86
> +	  systems. However, the address space of 32-bit x86 processors is only 4
>  	  Gigabytes large. That means that, if you have a large amount of
>  	  physical memory, not all of it can be "permanently mapped" by the
>  	  kernel. The physical memory that's not permanently mapped is called
> @@ -510,8 +510,15 @@ config NOHIGHMEM
>  	  by the kernel to permanently map as much physical memory as
>  	  possible.
>  
> -	  If the machine has between 1 and 4 Gigabytes physical RAM, then
> +
> +	  If the machine has between 1 and 3.5 Gigabytes physical RAM, then
>  	  answer "4GB" here.
> +	  
> +	  The PCI address space will usurally take 512 MB or 1 GB of address
> +	  space. This address space is unavailable to RAM, but depending on the
> +	  chipset (and BIOS settings), memory overlapping the PCI address space
> +	  may be mapped beyond the 4 GB limit and be available using "64GB".
> +
>  
>  	  If more than 4 Gigabytes is used then answer "64GB" here. This
>  	  selection turns Intel PAE (Physical Address Extension) mode on.
> @@ -520,6 +527,10 @@ config NOHIGHMEM
>  	  processors (Pentium Pro and better). NOTE: If you say "64GB" here,
>  	  then the kernel will not boot on CPUs that don't support PAE!
>  
> +	  An additional benefit of the 64GB-Mode is the availability of the
> +	  no-execute-pageflag, which can be used to prevent some attacks from
> +	  injecting malicious code into applications.
> +
>  	  The actual amount of total physical memory will either be
>  	  auto detected or can be forced by using a kernel command line option
>  	  such as "mem=256M". (Try "man bootparam" or see the documentation of
> @@ -532,14 +543,14 @@ config HIGHMEM4G
>  	bool "4GB"
>  	depends on !X86_NUMAQ
>  	help
> -	  Select this if you have a 32-bit processor and between 1 and 4
> +	  Select this if you have a 32-bit processor and between 1 and 3.5
>  	  gigabytes of physical RAM.
>  
>  config HIGHMEM64G
> -	bool "64GB"
> +	bool "64GB (enables no-execute memory protection if available)"
>  	depends on X86_CMPXCHG64
>  	help
> -	  Select this if you have a 32-bit processor and more than 4
> +	  Select this if you have a 32-bit processor and more than 3.5
>  	  gigabytes of physical RAM.
>  
>  endchoice
>   

