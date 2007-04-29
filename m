Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbXD2Kzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbXD2Kzq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbXD2Kz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:55:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756347AbXD2Kxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:42 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Eric Dumazet <dada1@cosmosbay.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [43/48] x86_64: fix vtime() vsyscall
Message-Id: <20070429105333.A4FF4147C5@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Eric Dumazet <dada1@cosmosbay.com>

There is a tiny probability that the return value from vtime(time_t *t) is 
Signed-off-by: Andi Kleen <ak@suse.de>

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


---
 arch/x86_64/kernel/vsyscall.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux/arch/x86_64/kernel/vsyscall.c
===================================================================
--- linux.orig/arch/x86_64/kernel/vsyscall.c
+++ linux/arch/x86_64/kernel/vsyscall.c
@@ -156,11 +156,13 @@ int __vsyscall(0) vgettimeofday(struct t
  * unlikely */
 time_t __vsyscall(1) vtime(time_t *t)
 {
+	time_t result;
 	if (unlikely(!__vsyscall_gtod_data.sysctl_enabled))
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
