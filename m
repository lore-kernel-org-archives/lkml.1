Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYEWLjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYEWLjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 07:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYEWLi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 07:38:58 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:49448 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYEWLi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 07:38:57 -0400
Message-ID: <4836AC3C.3090005@in.ibm.com>
Date: Fri, 23 May 2008 17:06:28 +0530
From: Sharyathi Nagesh <sharyath@in.ibm.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, fastboot@lists.osdl.org, akpm@osdl.org,
       maneesh@in.ltcfwd.linux.ibm.com, ebiederm@xmission.com,
       mohan@in.ibm.com, sachinp@in.ibm.com
CC: mohd.omar@in.ibm.com, IndhuDurai@in.ibm.com
Subject: correction to compat_sys_kexec_load
Content-Type: multipart/mixed;
 boundary="------------050808000003000302070003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050808000003000302070003
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi
   While testing with kexec tool, I observed some problems. When 
application (kexec) is 32 bit and kernel is 64 bit I observed that 
loading crash kernel works without any issues but unloading crash kernel 
fails.
--------------------------------------------------------
running strace over 'kexec -u -p'
show the problem to be with sys_kexec_load() call

sys_kexec_load(0, 0, 0, 0x1, 0)         = -1 EINVAL (Invalid argument)
write(2, "kexec_load (0 segments) failed: "..., 49
kexec_load (0 segments) failed: Invalid argument
) = 4
--------------------------------------------------------

This is patch to fix the problem, I think kernel code had a typo where in:
if((flags & KEXEC_ARCH_MASK) == KEXEC_ARCH) was used instead of
if((flags & KEXEC_ARCH_MASK) != KEXEC_ARCH)

This patch takes care of that, I have tested the patch it worked fine 
for me. Please review the patch and let me know of your views. This 
patch is based on linux-2.6.26-rc3.

Thanks
Yeehaw



--------------050808000003000302070003
Content-Type: text/x-patch;
 name="compat_sys_kexec_correction.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="compat_sys_kexec_correction.patch"

Index: linux-2.6.25.3-2/kernel/kexec.c
===================================================================
--- linux-2.6.25.3-2.orig/kernel/kexec.c	2008-05-23 14:57:08.000000000 +0530
+++ linux-2.6.25.3-2/kernel/kexec.c	2008-05-23 15:00:41.000000000 +0530
@@ -1068,7 +1068,8 @@
 	/* Don't allow clients that don't understand the native
 	 * architecture to do anything.
 	 */
-	if ((flags & KEXEC_ARCH_MASK) == KEXEC_ARCH_DEFAULT)
+	if (((flags & KEXEC_ARCH_MASK) != KEXEC_ARCH) &&
+		((flags & KEXEC_ARCH_MASK) != KEXEC_ARCH_DEFAULT))
 		return -EINVAL;
 
 	if (nr_segments > KEXEC_SEGMENT_MAX)

--------------050808000003000302070003--
