Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbYA3HYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbYA3HYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 02:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbYA3HYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 02:24:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:59030 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbYA3HYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 02:24:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,276,1199692800"; 
   d="scan'208";a="294272598"
Subject: Re: [PATCH 2.6.24] x86: add sysfs interface for cpuid module
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <47A02483.5000606@zytor.com>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
	 <1201043126.3861.5.camel@yangyi-dev.bj.intel.com>
	 <1201562058.12722.9.camel@yangyi-dev.bj.intel.com>
	 <479F4B99.4060701@zytor.com>
	 <1201643817.12722.30.camel@yangyi-dev.bj.intel.com>
	 <47A02483.5000606@zytor.com>
Content-Type: text/plain
Organization: Intel
Date: Wed, 30 Jan 2008 06:13:13 +0800
Message-Id: <1201644793.12722.34.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-29 at 23:17 -0800, H. Peter Anvin wrote:
> Yi Yang wrote:
> >>
> >> It's broken, because it doesn't take into account the fact that Intel 
> >> broke CPUID level 4 and made it "repeating" (neither did the cpuid char 
> >> device, because it predated the Intel braindamage; I've had a patch for 
> >> it privately for a while, but didn't push it upstream because paravirt 
> >> broke it royally and I wanted the situation to settle down.)
> 
> > level 4 doesn't result in repeating on Intel CPU, cpuid module sets
> > file offset to level, so cat /dev/cpu/*/cpuid will run cpuid instruction
> > continuously.
> 
> The issue is that Intel suddenly made CPUID ECX-sensitive, which there 
> is no way to represent.
Function cpuid has reset ecx to 0 immediate before calling to __cpuid,
so this shouldn't be a problem now.

in include/asm-x86/processor_32.h
/*
 * Generic CPUID function
 * clear %ecx since some cpus (Cyrix MII) do not set or clear %ecx
 * resulting in stale register contents being returned.
 */
static inline void cpuid(unsigned int op,
                         unsigned int *eax, unsigned int *ebx,
                         unsigned int *ecx, unsigned int *edx)
{
        *eax = op;
        *ecx = 0;
        __cpuid(eax, ebx, ecx, edx);
}
> 
> As far as cat /dev/cpu/*/cpuid, that's a user error.
> 
> 	-hpa
> 

