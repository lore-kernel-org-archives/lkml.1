Return-Path: <linux-kernel-owner+w=401wt.eu-S936159AbXGTRQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936159AbXGTRQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760460AbXGTRQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:16:37 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:43765 "EHLO
	outbound8-dub-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756801AbXGTRQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:16:35 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Fri, 20 Jul 2007 19:15:32 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [patches] [PATCH] [17/58] i386: Add L3 cache support to AMD
 CPUID4 emulation
Message-ID: <20070720171532.GB5995@alberich.amd.com>
References: <200707191154.642492000@suse.de>
 <20070719095502.1718214E0B@wotan.suse.de>
MIME-Version: 1.0
In-Reply-To: <20070719095502.1718214E0B@wotan.suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 20 Jul 2007 17:15:32.0241 (UTC)
 FILETIME=[94019810:01C7CAF1]
X-WSS-ID: 6ABE32551A42163098-03-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think, Joachim's patch (sent to patches@x86-64.org on June 14) should
be added as well. I have attached his patch below.


Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy
--

This will allow the size field to be reported for all values instead of a 
handful and also fills the shard_cpu_map with meaning full value.

Signed-off-by: Joachim Deguara <joachim.deguara@amd.com>
Index: kernel/arch/i386/kernel/cpu/intel_cacheinfo.c
===================================================================
--- kernel.orig/arch/i386/kernel/cpu/intel_cacheinfo.c
+++ kernel/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -224,12 +224,7 @@ static void __cpuinit amd_cpuid4(int lea
 		assoc = l3.assoc;
 		line_size = l3.line_size;
 		lines_per_tag = l3.lines_per_tag;
-		switch (l3.size_encoded) {
-		case 4:  size_in_kb = 2 * 1024; break;
-		case 8:  size_in_kb = 4 * 1024; break;
-		case 12: size_in_kb = 6 * 1024; break;
-		default: size_in_kb = 0; break;
-		}
+		size_in_kb = l3.size_encoded * 512;
 		break;
 	default:
 		return;
@@ -238,7 +233,10 @@ static void __cpuinit amd_cpuid4(int lea
 	eax->split.is_self_initializing = 1;
 	eax->split.type = types[leaf];
 	eax->split.level = levels[leaf];
-	eax->split.num_threads_sharing = 0;
+	if (leaf == 3)
+		eax->split.num_threads_sharing = current_cpu_data.x86_max_cores - 1;
+	else
+		eax->split.num_threads_sharing = 0;
 	eax->split.num_cores_on_die = current_cpu_data.x86_max_cores - 1;
 
 

_______________________________________________
patches mailing list
patches@x86-64.org
https://www.x86-64.org/mailman/listinfo/patches






