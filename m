Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbXFDUme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbXFDUme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757517AbXFDUmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:42:17 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:60192 "EHLO
	outbound3-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757468AbXFDUmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:42:16 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Mon, 4 Jun 2007 22:41:57 +0200
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: linux-kernel@vger.kernel.org, "Joachim Deguara" <joachim.deguara@amd.com>,
       "Nagendra, Bhavana" <bhavana.nagendra@amd.com>
Subject: Re: [PATCH] x86_64: remove check for CONSTANT_TSC from time.c
Message-ID: <20070604204157.GB22013@amd.com>
References: <20070604174926.GA22013@amd.com>
 <200706042002.41091.ak@suse.de>
MIME-Version: 1.0
In-Reply-To: <200706042002.41091.ak@suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 04 Jun 2007 20:41:58.0591 (UTC)
 FILETIME=[CBD81CF0:01C7A6E8]
X-WSS-ID: 6A7AA6901GC4064069-01-01
Content-Type: multipart/mixed;
 boundary=neYutvxvOLaeuPCA
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--neYutvxvOLaeuPCA
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Mon, Jun 04, 2007 at 08:02:40PM +0200, Andi Kleen wrote:
> On Monday 04 June 2007 19:49, Joerg Roedel wrote:
> > From: Joerg Roedel <joerg.roedel@amd.com>
> >
> > This patch removes the check for the CONSTANT_TSC cpu flag from time.c
> > on the x86_64 architecture. At the time this flag is checked at boot the
> > cpu init code was yet not executed and thus the check fails. At this
> > point the check for VENDOR_AMD and cpu family 0x10 is sufficient.
> 
> Wrong fix. The bit just needs to be set earlier in early cpu detect. Otherwise 
> there is a problem again with the next constant TSC AMD CPU.
> I will do that.
> 
> -Andi

Ok. But I assume you are meaning something like the attached diff?

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

--neYutvxvOLaeuPCA
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: attachment;
 filename=gh-tsc-fix-fix.patch
Content-Transfer-Encoding: 7bit

diff --git a/arch/x86_64/kernel/setup.c b/arch/x86_64/kernel/setup.c
index eb6524f..d16f7c2 100644
--- a/arch/x86_64/kernel/setup.c
+++ b/arch/x86_64/kernel/setup.c
@@ -806,6 +806,7 @@ void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
 			c->x86_model += ((tfms >> 16) & 0xF) << 4;
 		if (c->x86_capability[0] & (1<<19)) 
 			c->x86_clflush_size = ((misc >> 8) & 0xff) * 8;
+		c->extended_cpuid_level = cpuid_eax(0x80000000);
 	} else {
 		/* Have CPUID level 0 only - unheard of */
 		c->x86 = 4;
@@ -814,6 +815,12 @@ void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
 #ifdef CONFIG_SMP
 	c->phys_proc_id = (cpuid_ebx(1) >> 24) & 0xff;
 #endif
+
+	/* power flags are 8000_0007 edx. Bit 8 is constant TSC */
+	if ((c->x86_vendor == X86_VENDOR_AMD) &&
+	    (c->extended_cpuid_level >= 0x80000007) &&
+	    (cpuid_edx(0x80000007) & (1<<8)))
+		set_bit(X86_FEATURE_CONSTANT_TSC, &c->x86_capability);
 }
 
 /*

--neYutvxvOLaeuPCA--


