Return-Path: <linux-kernel-owner+w=401wt.eu-S932126AbXBMOZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbXBMOZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932141AbXBMOY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:24:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33288 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139AbXBMOYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:24:13 -0500
Date: Tue, 13 Feb 2007 15:21:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 11/11] syslets: x86: optimized sys_umem_add()
Message-ID: <20070213142133.GL638@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

provide an optimized assembly version of sys_umem_add().
It is about 2 times faster than the C version.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/i386/lib/getuser.S |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

Index: linux/arch/i386/lib/getuser.S
===================================================================
--- linux.orig/arch/i386/lib/getuser.S
+++ linux/arch/i386/lib/getuser.S
@@ -11,6 +11,33 @@
 #include <asm/thread_info.h>
 
 /*
+ * Optimized user-memory arithmetics system-call:
+ */
+
+.text
+.align 4
+.globl sys_umem_add
+sys_umem_add:
+	movl 0x4(%esp), %ecx			# uptr
+	movl 0x8(%esp), %edx			# inc
+
+	cmpl $__PAGE_OFFSET, %ecx		# access_ok(uptr)
+	jae bad_sys_umem_add
+
+1:	addl %edx, (%ecx)			# *uptr += inc
+2:	movl (%ecx), %eax			# return *uptr
+	ret
+
+bad_sys_umem_add:
+	movl $-14, %eax
+	ret
+
+.section __ex_table,"a"
+	.long 1b, bad_sys_umem_add
+	.long 2b, bad_sys_umem_add
+.previous
+
+/*
  * copy_uatom() - copy a syslet_atom from user-space into kernel-space:
  */
 
