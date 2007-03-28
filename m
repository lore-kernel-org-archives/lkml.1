Return-Path: <linux-kernel-owner+w=401wt.eu-S933637AbXC1GWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637AbXC1GWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 02:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933673AbXC1GWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 02:22:10 -0400
Received: from sp604003mt.neufgp.fr ([84.96.92.56]:34918 "EHLO smTp.neuf.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933641AbXC1GWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 02:22:09 -0400
Date: Wed, 28 Mar 2007 08:22:01 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
Subject: [PATCH] x86_64 : fix vtime() vsyscall
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Linux kernel <linux-kernel@vger.kernel.org>
Message-id: <460A0989.9000106@cosmosbay.com>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_jJZGPudX5/RPT6sojp3ROQ)"
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_jJZGPudX5/RPT6sojp3ROQ)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT

There is a tiny probability that the return value from vtime(time_t *t) is 
different than the value stored in *t

Using a temporary variable solves the problem and gives a faster code.

   17:   48 85 ff                test   %rdi,%rdi
   1a:   48 8b 05 00 00 00 00    mov    0(%rip),%rax        # 
__vsyscall_gtod_data.wall_time_tv.tv_sec
   21:   74 03                   je     26
   23:   48 89 07                mov    %rax,(%rdi)
   26:   c9                      leaveq
   27:   c3                      retq

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

--Boundary_(ID_jJZGPudX5/RPT6sojp3ROQ)
Content-type: text/plain; name=vtime_fix.patch
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=vtime_fix.patch

--- linux-2.6.21-rc5-mm1/arch/x86_64/kernel/vsyscall.c
+++ linux-2.6.21-rc5-mm1-ed/arch/x86_64/kernel/vsyscall.c
@@ -147,15 +147,15 @@ int __vsyscall(0) vgettimeofday(struct t
 	return 0;
 }
 
-/* This will break when the xtime seconds get inaccurate, but that is
- * unlikely */
 time_t __vsyscall(1) vtime(time_t *t)
 {
+	time_t result;
 	if (!__vsyscall_gtod_data.sysctl_enabled)
 		return time_syscall(t);
-	else if (t)
-		*t = __vsyscall_gtod_data.wall_time_tv.tv_sec;
-	return __vsyscall_gtod_data.wall_time_tv.tv_sec;
+	result = __vsyscall_gtod_data.wall_time_tv.tv_sec;
+	if (t)
+		*t = result;
+	return result;
 }
 
 /* Fast way to get current CPU and node.

--Boundary_(ID_jJZGPudX5/RPT6sojp3ROQ)--
