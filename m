Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYLZKtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYLZKtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 05:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbYLZKtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 05:49:24 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:51424 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbYLZKtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 05:49:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=puH7yblNXEvMVU+DnCvnsz/czwaIefmvy8hFkueXULvYfBTnIv11o1cOmYDO7RoZxU
         4pJK9M+xKrFtaDTWhq1o2uT4h8okMZj88w+rQ2rQ6fSP05BXL7x/OlQKRaEtmQoVdQrn
         bMRIrCD8Y1OEC9+zEHKHQYNGJZZ46CA0cy4rU=
Message-ID: <4954B6AA.1060603@gmail.com>
Date: Fri, 26 Dec 2008 11:49:14 +0100
From: Uros Bizjak <ubizjak@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: x86@kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH, x86]: Add selfsnoop support
Content-Type: multipart/mixed;
 boundary="------------020809080303020704000307"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020809080303020704000307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello!

This patch ports the patch that implemented selfsnoop support [1] to 
2.6.28-git. Unfortunately, the thread about the implementation died at 
[2] without any resolution.

The patch works OK on my x86_64, but I don't think this qualifies as a 
thorough test...

This is actually Andi Kleen's patch, his signed-off-by: signature is at [1].

[1] http://lkml.indiana.edu/hypermail/linux/kernel/0802.1/1331.html
[2] http://lkml.indiana.edu/hypermail/linux/kernel/0802.1/1891.html

Uros.



--------------020809080303020704000307
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
+	if (cache && boot_cpu_data.x86_model >= 4 && cpu_has_selfsnoop)
 		wbinvd();
 }
 
@@ -181,7 +181,7 @@ static void cpa_flush_range(unsigned long start, int numpages, int cache)
 
 	on_each_cpu(__cpa_flush_range, NULL, 1);
 
-	if (!cache)
+	if (!cache || cpu_has_selfsnoop)
 		return;
 
 	/*

--------------020809080303020704000307--
