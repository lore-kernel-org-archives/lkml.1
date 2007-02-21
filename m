Return-Path: <linux-kernel-owner+w=401wt.eu-S1423167AbXBUVXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423167AbXBUVXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423137AbXBUVVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:21:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40430 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423149AbXBUVVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:21:15 -0500
Date: Wed, 21 Feb 2007 22:16:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 13/13] syslets: x86: optimized sys_umem_add()
Message-ID: <20070221211602.GM7579@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221211355.GA7302@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
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
 
