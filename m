Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbZKZJ4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbZKZJ4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZKZJ4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:56:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:41429 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759370AbZKZJ4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:56:40 -0500
Date: Thu, 26 Nov 2009 09:55:56 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1259176706-5908-1-git-send-email-brgerst@gmail.com>
References: <1259176706-5908-1-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Optimize loadsegment()
Message-ID: <tip-79b0379cee09b00ef309384aff652e328e438c79@git.kernel.org>
Git-Commit-ID: 79b0379cee09b00ef309384aff652e328e438c79
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79b0379cee09b00ef309384aff652e328e438c79
Gitweb:     http://git.kernel.org/tip/79b0379cee09b00ef309384aff652e328e438c79
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Wed, 25 Nov 2009 14:18:26 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 10:33:58 +0100

x86: Optimize loadsegment()

Zero the input register in the exception handler instead of
using an extra register to pass in a zero value.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1259176706-5908-1-git-send-email-brgerst@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/system.h |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 1a953e2..537395a 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -156,18 +156,19 @@ extern void native_load_gs_index(unsigned);
  * segment if something goes wrong..
  */
 #define loadsegment(seg, value)			\
+do {						\
+	unsigned short __val = value;		\
 	asm volatile("\n"			\
 		     "1:\t"			\
 		     "movl %k0,%%" #seg "\n"	\
-		     "2:\n"			\
 		     ".section .fixup,\"ax\"\n"	\
-		     "3:\t"			\
-		     "movl %k1, %%" #seg "\n\t"	\
-		     "jmp 2b\n"			\
+		     "2:\t"			\
+		     "xorl %k0,%k0\n\t"		\
+		     "jmp 1b\n"			\
 		     ".previous\n"		\
-		     _ASM_EXTABLE(1b,3b)	\
-		     : :"r" (value), "r" (0) : "memory")
-
+		     _ASM_EXTABLE(1b, 2b)	\
+		     : "+r" (__val) : : "memory"); \
+} while (0)
 
 /*
  * Save a segment register away
