Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbZFGSrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbZFGSrv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 14:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbZFGSrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 14:47:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:36860 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbZFGSrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 14:47:43 -0400
Message-ID: <4A2C0B1B.3080502@kernel.org>
Date: Sun, 07 Jun 2009 11:46:51 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Detect use of extended APIC ID for AMD
 CPUs
References: <20090604104016.GT5736@alberich.amd.com> <tip-37f36c1017f0032fa7a1fb85a0cddfc0d526d17f@git.kernel.org>
In-Reply-To: <tip-37f36c1017f0032fa7a1fb85a0cddfc0d526d17f@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Andreas Herrmann wrote:
> Commit-ID:  37f36c1017f0032fa7a1fb85a0cddfc0d526d17f
> Gitweb:     http://git.kernel.org/tip/37f36c1017f0032fa7a1fb85a0cddfc0d526d17f
> Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
> AuthorDate: Thu, 4 Jun 2009 12:40:16 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sun, 7 Jun 2009 16:39:38 +0200
> 
> x86: Detect use of extended APIC ID for AMD CPUs
> 
> Booting a 32-bit kernel on Magny-Cours results in the following panic
> 
>   ...
>   Using APIC driver default
>   ...
>   Overriding APIC driver with bigsmp
>   ...
>   Getting VERSION: 80050010
>   Getting VERSION: 80050010
>   Getting ID: 10000000
>   Getting ID: ef000000
>   Getting LVT0: 700
>   Getting LVT1: 10000
>   Kernel panic - not syncing: Boot APIC ID in local APIC unexpected (16 vs 0)
>   Pid: 1, comm: swapper Not tainted 2.6.30-rcX #2
>   Call Trace:
>    [<c05194da>] ? panic+0x38/0xd3
>    [<c0743102>] ? native_smp_prepare_cpus+0x259/0x31f
>    [<c073b19d>] ? kernel_init+0x3e/0x141
>    [<c073b15f>] ? kernel_init+0x0/0x141
>    [<c020325f>] ? kernel_thread_helper+0x7/0x10
> 
> The reason is that default_get_apic_id handled extension of local APIC
> ID field just in case of XAPIC.
> 
> Thus for this AMD CPU, default_get_apic_id() returns 0 and
> bigsmp_get_apic_id() returns 16 which leads to the respective kernel
> panic.
> 
> This patch introduces a Linux specific feature flag to indicate
> support for extended APIC id (8 bits instead of 4 bits width) and sets
> the flag on AMD CPUs if applicable.
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> Cc: <stable@kernel.org>
> LKML-Reference: <20090604104016.GT5736@alberich.amd.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/include/asm/apic.h       |    2 +-
>  arch/x86/include/asm/cpufeature.h |    1 +
>  arch/x86/kernel/cpu/amd.c         |   10 ++++++++++
>  3 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index 42f2f83..9b2c049 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -410,7 +410,7 @@ static inline unsigned default_get_apic_id(unsigned long x)
>  {
>  	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
>  
> -	if (APIC_XAPIC(ver))
> +	if (APIC_XAPIC(ver) || boot_cpu_has(X86_FEATURE_EXTD_APICID))
>  		return (x >> 24) & 0xFF;
>  	else
>  		return (x >> 24) & 0x0F;

looks like we should fix APIC_XAPIC() or have one global apic_ver.

YH
