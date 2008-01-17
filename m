Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYAQQNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYAQQNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 11:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbYAQQNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 11:13:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:9506 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbYAQQNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 11:13:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=HNCnnQnNokGpTrTMw7KgMOTJatTgbt/UmohnuiCnGOMiYipOzD/GHxMgMgoPx0k0v8ZckpTwCGe+NyR7G45SlZmhjzhfSNKOTND1Qulq20IpuIqVbttO+E9hdKjmzi8yGgZuAycjXV0q8f5TCPixNOwJhm84hX+xufP28cTZ+DM=
Message-ID: <519a8b110801170813h96b8f2by795e6d8b72a00ba4@mail.gmail.com>
Date: Thu, 17 Jan 2008 17:13:02 +0100
From: xming <xmingske@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Cannot boot xen DomU > 2.6.23.1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I finally found the piece of code that prevents me from booting Xen DomU
with vallina kernel > 2.6.23.1.

The problem is that with every kernel (> 2.6.32.1 including 2.6.24 RCs)
will just hang with "too much" console activity. Sometimes (well most
of the time) boot msg is too much. When I can boot into the kernel,
generating a lots of cosole out it will hang, no oops, no more
console/network. Generating with the same way through ssh will not
hang the domU.

When I reverse the following patch, things work as before, tried this
with 2.6.23.14 and 2.6.14-rc8. But I don't have the knowledge to
understand the reason behind this.

BTW, I am not subscribed.

--- a/include/xen/interface/vcpu.h
+++ b/include/xen/interface/vcpu.h
@@ -160,8 +160,9 @@ struct vcpu_set_singleshot_timer {
  */
 #define VCPUOP_register_vcpu_info   10  /* arg == struct vcpu_info */
 struct vcpu_register_vcpu_info {
-    uint32_t mfn;               /* mfn of page to place vcpu_info */
-    uint32_t offset;            /* offset within page */
+    uint64_t mfn;    /* mfn of page to place vcpu_info */
+    uint32_t offset; /* offset within page */
+    uint32_t rsvd;   /* unused */
 };

 #endif /* __XEN_PUBLIC_VCPU_H__ */

I am running Xen 3.1.2 PAE

# uname -a
Linux builder 2.6.24-rc8 #2 SMP Thu Jan 17 16:37:19 CET 2008 i686
AMD Athlon(tm) X2 Dual Core Processor BE-2300 AuthenticAMD GNU/Linux

# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 107
model name      : AMD Athlon(tm) X2 Dual Core Processor BE-2300
stepping        : 1
cpu MHz         : 1899.930
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu tsc msr pae mce cx8 mca cmov pat pse36 clflush
mmx fxsr sse sse2 ht nx mmxext fxsr_opt lm 3dnowext 3dnow pni cx16
lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch ts fid vid ttp
tm stc 100mhzsteps
bogomips        : 3829.72
clflush size    : 64

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 107
model name      : AMD Athlon(tm) X2 Dual Core Processor BE-2300
stepping        : 1
cpu MHz         : 1899.930
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu tsc msr pae mce cx8 mca cmov pat pse36 clflush
mmx fxsr sse sse2 ht nx mmxext fxsr_opt lm 3dnowext 3dnow pni cx16
lahf_lm cmp_legacy svm extapic cr8_legacy 3dnowprefetch ts fid vid ttp
tm stc 100mhzsteps
bogomips        : 3829.72
clflush size    : 64
