Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbYLZKzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYLZKzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 05:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbYLZKzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 05:55:42 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:64284 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbYLZKzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 05:55:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=vUkemfoQe8OO0ATRMkJ/1PepmkaKU3f0pwdm0B3swlb6tCrKQi9K5tHoqvtlJDVbKX
         Hb8tNrpWBVa4pheyL7+x+h2WZqkz6j+hVnc5kFvlaH3+J8HWlfQ4+a2Cn3CWlynxoFAE
         YL/jkL9+TrQyEe++q542HQa5vvcAYuVZhH/10=
Message-ID: <4954B825.7050202@gmail.com>
Date: Fri, 26 Dec 2008 11:55:33 +0100
From: Uros Bizjak <ubizjak@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Uros Bizjak <ubizjak@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH, x86]: Corr: Add selfsnoop support
References: <4954B6AA.1060603@gmail.com>
In-Reply-To: <4954B6AA.1060603@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000606090101080400070609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000606090101080400070609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Uros Bizjak wrote:

> This patch ports the patch that implemented selfsnoop support [1] to 
> 2.6.28-git. Unfortunately, the thread about the implementation died at 
> [2] without any resolution.

Sorry, there was a logic typo in previous version, correct patch is 
attached here.

Uros.


--------------000606090101080400070609
Content-Type: text/plain;
 name="p"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="p"

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index cfdf8c2..bb6740b 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -229,6 +229,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_ds		boot_cpu_has(X86_FEATURE_DS)
 #define cpu_has_pebs		boot_cpu_has(X86_FEATURE_PEBS)
 #define cpu_has_clflush		boot_cpu_has(X86_FEATURE_CLFLSH)
+#define cpu_has_selfsnoop	boot_cpu_has(X86_FEATURE_SELFSNOOP)
 #define cpu_has_bts		boot_cpu_has(X86_FEATURE_BTS)
 #define cpu_has_gbpages		boot_cpu_has(X86_FEATURE_GBPAGES)
 #define cpu_has_arch_perfmon	boot_cpu_has(X86_FEATURE_ARCH_PERFMON)
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index e89d248..07d0518 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -150,7 +150,7 @@ static void __cpa_flush_all(void *arg)
 	 */
 	__flush_tlb_all();
 
-	if (cache && boot_cpu_data.x86_model >= 4)
+	if (cache && boot_cpu_data.x86_model >= 4 && !cpu_has_selfsnoop)
 		wbinvd();
 }
 
@@ -181,7 +181,7 @@ static void cpa_flush_range(unsigned long start, int numpages, int cache)
 
 	on_each_cpu(__cpa_flush_range, NULL, 1);
 
-	if (!cache)
+	if (!cache || cpu_has_selfsnoop)
 		return;
 
 	/*

--------------000606090101080400070609--
