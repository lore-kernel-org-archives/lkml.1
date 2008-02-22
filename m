Return-Path: <linux-kernel-owner+w=401wt.eu-S1764101AbYBVLXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764101AbYBVLXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 06:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbYBVLXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 06:23:15 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:24115 "EHLO
	outbound3-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991AbYBVLXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 06:23:14 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0JWN0TV-04-VK2-01
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
Date: Fri, 22 Feb 2008 12:18:04 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] X86: don't print a warning when MTRR are blank and
 running in KVM
Message-ID: <20080222111804.GB6504@amd.com>
References: <1203605414-4958-1-git-send-email-joerg.roedel@amd.com>
 <86802c440802211154h28ef0170m59c42bdd8de76358@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <86802c440802211154h28ef0170m59c42bdd8de76358@mail.gmail.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Feb 2008 11:18:04.0411 (UTC)
 FILETIME=[97BE34B0:01C87544]
X-WSS-ID: 6BA070782IW12860791-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 11:54:00AM -0800, Yinghai Lu wrote:
> On Thu, Feb 21, 2008 at 6:50 AM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> > Inside a KVM virtual machine the MTRRs are usually blank. This confuses Linux
> >  and causes a warning message at boot. This patch removes that warning message
> >  when running Linux as a KVM guest.
> >
> >  Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> >  ---
> >   arch/x86/kernel/cpu/mtrr/main.c |    7 +++++--
> >   1 files changed, 5 insertions(+), 2 deletions(-)
> >
> >  diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
> >  index b6e136f..47e624c 100644
> >  --- a/arch/x86/kernel/cpu/mtrr/main.c
> >  +++ b/arch/x86/kernel/cpu/mtrr/main.c
> >  @@ -43,6 +43,7 @@
> >   #include <asm/uaccess.h>
> >   #include <asm/processor.h>
> >   #include <asm/msr.h>
> >  +#include <asm/kvm_para.h>
> >   #include "mtrr.h"
> >
> >   u32 num_var_ranges = 0;
> >  @@ -687,12 +688,14 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
> >         }
> >
> >         /* kvm/qemu doesn't have mtrr set right, don't trim them all */
> >  -       if (!highest_pfn) {
> >  +       if (!highest_pfn && !kvm_para_available()) {
> >                 printk(KERN_WARNING "WARNING: strange, CPU MTRRs all blank?\n");
> >                 WARN_ON(1);
> >  -               return 0;
> >         }
> >
> >  +       if (!highest_pfn)
> >  +               return 0;
> >  +
> >         if (highest_pfn < end_pfn) {
> >                 printk(KERN_WARNING "WARNING: BIOS bug: CPU MTRRs don't cover"
> >                         " all of memory, losing %luMB of RAM.\n",
> >  --
> >  1.5.3.7
> >
> 
> Doest that WARN_ON(1) hurt?

Yes. It inidicates a problem where there isn't one. In a virtual machine
MTRRs make absolutly no sense and so they should all be blank there.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


