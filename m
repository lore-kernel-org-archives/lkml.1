Return-Path: <linux-kernel-owner+w=401wt.eu-S1759551AbZDHO7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551AbZDHO7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbZDHO7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:59:36 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:33334 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629AbZDHO7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:59:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=glcsBPBuVgeYQVgCX8OIhv+3kOft8zUPaxJsCUntOXOCK7G1Ll2gsbLNlOxY9yd9tM
         pq7gV9lUyTp6ldm1VSdg0StAqa1t4Ey1mCT6TCgyBiTbXffUe5Zot9VC0Lj1sio/zFLL
         3QUmXUXfzlISa+hidGSBiUwVT0UYyF6stZt14=
Message-ID: <49DCBBD3.60707@gmail.com>
Date: Wed, 08 Apr 2009 16:59:31 +0200
From: Uros Bizjak <ubizjak@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "Ingo Molnar" <mingo@elte.hu>, x86@kernel.org
Subject: [PATCH v2, x86 CPA]: Add selfsnoop support
Content-Type: multipart/mixed;
 boundary="------------080203090206050105050509"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080203090206050105050509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello!

This is second variant of a selfsnoop support for recent x86 CPUs. The 
patch is effectively a one-liner and avoids calling clflush and wbinvd 
to invalidate caches when CPU supports selfsnoop.

The patch applies to current git and -tip trees. This patch was tested 
on Ubuntu 2.6.29.1 kernel:

processor    : 0
vendor_id    : GenuineIntel
cpu family    : 15
model        : 1
model name    : Intel(R) Pentium(R) 4 CPU 1.60GHz
stepping    : 2
cpu MHz        : 1594.873
cache size    : 256 KB
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 2
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi
 mmx fxsr sse sse2 ss ht tm up pebs bts sync_rdtsc
bogomips    : 3194.10
clflush size    : 64

with CONFIG_CPA_DEBUG. Relevant self-test lines from the boot log are:

Apr  8 14:46:57 ubuntudsp kernel: [    1.861293] Write protecting the 
kernel text: 3988k
Apr  8 14:46:57 ubuntudsp kernel: [    1.861298] Testing CPA: Reverting 
c1000000-c13e5000
Apr  8 14:46:57 ubuntudsp kernel: [    1.861412] Testing CPA: write 
protecting again
Apr  8 14:46:57 ubuntudsp kernel: [    1.861610] Write protecting the 
kernel read-only data: 1776k
Apr  8 14:46:57 ubuntudsp kernel: [    1.861615] Testing CPA: undo 
c13e5000-c15a1000
Apr  8 14:46:57 ubuntudsp kernel: [    1.861665] Testing CPA: write 
protecting again
Apr  8 14:46:57 ubuntudsp kernel: [    1.898397] exe used greatest stack 
depth: 6808 bytes left
...
Apr  8 14:47:03 ubuntudsp kernel: [   30.771018] CPA self-test:
Apr  8 14:47:03 ubuntudsp kernel: [   30.771228]  4k 4992 large 155 gb 0 
x 5147[c0000000-e7f7f000] miss 0
Apr  8 14:47:03 ubuntudsp kernel: [   30.786583]  4k 148352 large 15 gb 
0 x 148367[c0000000-e7f7f000] miss 0
Apr  8 14:47:03 ubuntudsp kernel: [   30.793998]  4k 148352 large 15 gb 
0 x 148367[c0000000-e7f7f000] miss 0
Apr  8 14:47:03 ubuntudsp kernel: [   30.794010] ok.

The patched kernel was used on my workstation for my daily work for 
several days (XWin, heavily compilations, IPTV, internet browsing) and I 
didn't found any problems with the patched kernel.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>


--------------080203090206050105050509
Content-Type: text/plain;
 name="p.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="p.diff"

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 0beba0d..267f3ca 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -242,6 +242,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
 #define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
 #define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)
+#define cpu_has_selfsnoop	boot_cpu_has(X86_FEATURE_SELFSNOOP)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index d71e1b6..bbca9d2 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -875,10 +875,10 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 		goto out;
 
 	/*
-	 * No need to flush, when we did not set any of the caching
-	 * attributes:
+	 * No need to flush when CPU supports self snoop or
+	 * when we did not set any of the caching attributes:
 	 */
-	cache = cache_attr(mask_set);
+	cache = cpu_has_selfsnoop ? 0 : cache_attr(mask_set);
 
 	/*
 	 * On success we use clflush, when the CPU supports it to

--------------080203090206050105050509--
