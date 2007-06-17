Return-Path: <linux-kernel-owner+w=401wt.eu-S1760871AbXFRAN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbXFRAN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 20:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbXFRANW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 20:13:22 -0400
Received: from gateway-b.fh-trier.de ([143.93.54.182]:41843 "EHLO
	gateway-b.fh-trier.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbXFRANW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 20:13:22 -0400
X-Greylist: delayed 1958 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Jun 2007 20:13:21 EDT
Message-ID: <4675C678.3080807@gentoo.org>
Date: Mon, 18 Jun 2007 01:40:40 +0200
From: Alexander Gabert <pappy@gentoo.org>
Organization: Hardened Gentoo Linux
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: libc-alpha@sourceware.org, linux-kernel@vger.kernel.org
CC: hardened@gentoo.org
Subject: AT_ENTROPY1 and AT_ENTROPY2 values for include/linux/auxvec.h
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello glibc and kernel maintainers,

could you please add two AT_ entries to include/linux/auxvec.h in the 
upstream kernel and the respective elf/elf.h definitions in glibc.

#define AT_ENTROPY1 24   /* kernel entropy in auxiliary vector */
#define AT_ENTROPY2 25   /* second field for kernel entropy */

The accompanying kernel patch follows, it is basically a config option 
to give userland entropy.
We are using the appended patch for Gentoo Hardened.
You don't have to put it into the upstream linux kernel, it is only 
there for explaining what i need the AT_ values for.
Also the patch contains a subtle "bug" because the repetive call to 
get_random_int()
seems to yield the same result when done immediately after another:

$$ od -tx8 /proc/self/auxv
0000000 ffffe40000000020 ffffe00000000021
0000020 0383f9ff00000010 0000100000000006
0000040 0000006400000011 8000003400000003
0000060 0000002000000004 0000000a00000005
0000100 b7ef200000000007 0000000000000008
0000120 800013f000000009 000000000000000b
0000140 000000000000000c 000000000000000d
0000160 000000000000000e 0000000000000017
0000200 0c1f4d8100000018 0c1f4d8100000019
0000220 bfa7da8b0000000f 0000000000000000
0000240


However, this is just a proof of concept, all i'm asking for is to get 
the two numbers into the upstream
kernel and glibc auxvec.h to avoid future clashes with the numbers, thx 
in advance.

-- patch --

diff -Nru linux-2.6.21.5.ORIG/fs/binfmt_elf.c linux-2.6.21.5/fs/binfmt_elf.c
--- linux-2.6.21.5.ORIG/fs/binfmt_elf.c	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/fs/binfmt_elf.c	2007-06-18 00:22:59.000000000 +0200
@@ -201,6 +201,13 @@
 	NEW_AUX_ENT(AT_GID, tsk->gid);
 	NEW_AUX_ENT(AT_EGID, tsk->egid);
  	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
+#if defined(CONFIG_AT_ENTROPY1)
+  NEW_AUX_ENT(AT_ENTROPY1, get_random_int());
+#endif
+#if defined(CONFIG_AT_ENTROPY2)
+  NEW_AUX_ENT(AT_ENTROPY2, get_random_int());
+#endif
+
 	if (k_platform) {
 		NEW_AUX_ENT(AT_PLATFORM,
 			    (elf_addr_t)(unsigned long)u_platform);
diff -Nru linux-2.6.21.5.ORIG/include/linux/auxvec.h linux-2.6.21.5/include/linux/auxvec.h
--- linux-2.6.21.5.ORIG/include/linux/auxvec.h	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/include/linux/auxvec.h	2007-06-18 00:19:57.000000000 +0200
@@ -26,6 +26,9 @@
 
 #define AT_SECURE 23   /* secure mode boolean */
 
-#define AT_VECTOR_SIZE  44 /* Size of auxiliary table.  */
+#define AT_ENTROPY1 24   /* kernel entropy in auxiliary vector */
+#define AT_ENTROPY2 25   /* second field for kernel entropy */
+
+#define AT_VECTOR_SIZE  46 /* Size of auxiliary table.  */
 
 #endif /* _LINUX_AUXVEC_H */
diff -Nru linux-2.6.21.5.ORIG/security/Kconfig linux-2.6.21.5/security/Kconfig
--- linux-2.6.21.5.ORIG/security/Kconfig	2007-06-11 20:37:06.000000000 +0200
+++ linux-2.6.21.5/security/Kconfig	2007-06-18 00:32:57.000000000 +0200
@@ -4,6 +4,24 @@
 
 menu "Security options"
 
+config AT_ENTROPY1
+  bool "Enable kernel entropy in the auxiliary vector"
+  help
+    This option provides support for kernel-generated entropy handed
+    to processes via the auxiliary vector table in /proc/self/auxv.
+    Most notably userlands with heavy usage of stack smashing protection
+    benefit from kernel entropy because /dev/urandom is less likely to
+    become depleted due to the extensive need for randomized SSP __guard.
+
+config AT_ENTROPY2
+  bool "Enable additional kernel entropy in the auxiliary vector"
+  depends on AT_ENTROPY1
+  help
+    This option provides support for an additional field of kernel-generated
+    entropy for userland processes.  It can be used for an extension to SSP
+    where a second guard value is necessary for XOR encoding control data
+    residing in the stack frame of userland processes.
+
 config KEYS
 	bool "Enable access key retention support"
 	help

-- /patch --

also available at

http://dev.gentoo.org/~pappy/ssp/AT_ENTROPY/linux-2.6.21.5_AT_ENTROPY.patch


Thanks again,


Alex
