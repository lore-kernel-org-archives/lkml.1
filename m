Return-Path: <linux-kernel-owner+w=401wt.eu-S932962AbXBTOui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962AbXBTOui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 09:50:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964958AbXBTOui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 09:50:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932962AbXBTOuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 09:50:37 -0500
Message-ID: <45DB0AAE.3020800@redhat.com>
Date: Tue, 20 Feb 2007 09:50:22 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Zwane Mwaikambo <zwane@infradead.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH]: Change sysenter_setup to __cpuinit & improve __INIT,
 __INITDATA
References: <20070219205012.13934.82952.sendpatchset@prarit.boston.redhat.com> <Pine.LNX.4.64.0702191409470.32172@montezuma.fsmlabs.com>
In-Reply-To: <Pine.LNX.4.64.0702191409470.32172@montezuma.fsmlabs.com>
Content-Type: multipart/mixed;
 boundary="------------060903090406060402080206"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060903090406060402080206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



Zwane Mwaikambo wrote:
> Shouldn't this be __CPUINT/__CPUINITDATA? That way you could also get rid  of things like in x86_64 head.S;
>
> #ifndef CONFIG_HOTPLUG_CPU
>         __INITDATA
> #endif
>   
Zwane -- good point.  New patch.

P.




--------------060903090406060402080206
Content-Type: text/plain;
 name="init-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="init-v2.patch"

Change sysenter_setup to __cpuinit.
Add __CPUINIT & __CPUINITDATA.

Resolve MODPOST warnings similar to:

WARNING: vmlinux - Section mismatch: reference to .init.text:sysenter_setup from
 .text between 'identify_cpu' (at offset 0xc040a380) and 'detect_ht'

and

WARNING: vmlinux - Section mismatch: reference to .init.data:vsyscall_int80_end
from .text between 'sysenter_setup' (at offset 0xc041a269) and 'enable_sep_cpu'
WARNING: vmlinux - Section mismatch: reference to
.init.data:vsyscall_int80_start from .text between 'sysenter_setup' (at offset
0xc041a26e) and 'enable_sep_cpu'
WARNING: vmlinux - Section mismatch: reference to
.init.data:vsyscall_sysenter_end from .text between 'sysenter_setup' (at offset
0xc041a275) and 'enable_sep_cpu'
WARNING: vmlinux - Section mismatch: reference to
.init.data:vsyscall_sysenter_start from .text between 'sysenter_setup' (at
offset 0xc041a27a) and 'enable_sep_cpu'

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/i386/kernel/sysenter.c b/arch/i386/kernel/sysenter.c
index 13ca54a..168f814 100644
--- a/arch/i386/kernel/sysenter.c
+++ b/arch/i386/kernel/sysenter.c
@@ -72,7 +72,7 @@ extern const char vsyscall_int80_start, vsyscall_int80_end;
 extern const char vsyscall_sysenter_start, vsyscall_sysenter_end;
 static struct page *syscall_pages[1];
 
-int __init sysenter_setup(void)
+int __cpuinit sysenter_setup(void)
 {
 	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
 	syscall_pages[0] = virt_to_page(syscall_page);
diff --git a/arch/x86_64/kernel/head.S b/arch/x86_64/kernel/head.S
index 598a4d0..d3e3db3 100644
--- a/arch/x86_64/kernel/head.S
+++ b/arch/x86_64/kernel/head.S
@@ -324,9 +324,7 @@ ENTRY(wakeup_level4_pgt)
 	.quad	phys_level3_kernel_pgt | 0x007
 #endif
 
-#ifndef CONFIG_HOTPLUG_CPU
-	__INITDATA
-#endif
+	__CPUINITDATA
 	/*
 	 * This default setting generates an ident mapping at address 0x100000
 	 * and a mapping for the kernel that precisely maps virtual address
diff --git a/include/linux/init.h b/include/linux/init.h
index e290a01..6592357 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -56,6 +56,14 @@
 #define __FINIT		.previous
 #define __INITDATA	.section	".init.data","aw"
 
+#ifdef CONFIG_HOTPLUG_CPU
+#define __CPUINIT	.section	".text","ax"
+#define __CPUINITDATA	.section	".data","ax"
+#else
+#define __CPUINIT	__INIT
+#define __CPUINITDATA	__INITDATA
+#endif
+
 #ifndef __ASSEMBLY__
 /*
  * Used for initialization calls..

--------------060903090406060402080206--
