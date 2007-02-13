Return-Path: <linux-kernel-owner+w=401wt.eu-S932127AbXBMO0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbXBMO0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932137AbXBMOYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:24:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33374 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142AbXBMOYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:24:24 -0500
Date: Tue, 13 Feb 2007 15:21:29 +0100
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
Subject: [patch 10/11] syslets: x86: optimized copy_uatom()
Message-ID: <20070213142129.GK638@elte.hu>
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

provide an optimized assembly version of the copy_uatom() method.
This is about 3 times faster than the C version.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/i386/lib/getuser.S |  115 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 115 insertions(+)

Index: linux/arch/i386/lib/getuser.S
===================================================================
--- linux.orig/arch/i386/lib/getuser.S
+++ linux/arch/i386/lib/getuser.S
@@ -10,6 +10,121 @@
  */
 #include <asm/thread_info.h>
 
+/*
+ * copy_uatom() - copy a syslet_atom from user-space into kernel-space:
+ */
+
+.text
+.align 4
+.globl copy_uatom
+copy_uatom:
+	#
+	# regparm(2) call, %eax: atom, %edx: uatom
+	#
+	movl %eax, %ecx                 # %ecx is atom, %edx remains uatom
+
+	cmpl $__PAGE_OFFSET-40, %edx	# access_ok(uatom-sizeof(*uatom))
+	jae bad_copy_uatom
+
+
+1:	movl (%edx), %eax		# atom->flags = uatom->flags
+	movl %eax, (%ecx)
+
+2:	movl 4(%edx), %eax		# atom->nr = uatom->nr
+	movl %eax, 4(%ecx)
+
+3:	movl 8(%edx), %eax		# atom->ret_ptr = uatom->ret_ptr
+	movl %eax, 8(%ecx)
+
+4:	movl 12(%edx), %eax		# atom->next = uatom->next
+	movl %eax, 12(%ecx)
+
+
+10:	movl 16(%edx), %eax		# atom->arg_ptr[0] = uatom->arg_ptr[0]
+	testl %eax, %eax
+	jz 20f				# NULL ptr - zero out remaining args
+	cmpl $__PAGE_OFFSET, %eax	# access_ok(arg_ptr)
+	jae bad_copy_uatom
+100:	movl (%eax), %eax
+	movl %eax, 16(%ecx)
+
+11:	movl 20(%edx), %eax		# atom->arg_ptr[1] = uatom->arg_ptr[1]
+	testl %eax, %eax
+	jz 21f				# NULL ptr - zero out remaining args
+	cmpl $__PAGE_OFFSET, %eax	# access_ok(arg_ptr)
+	jae bad_copy_uatom
+110:	movl (%eax), %eax
+	movl %eax, 20(%ecx)
+
+12:	movl 24(%edx), %eax		# atom->arg_ptr[2] = uatom->arg_ptr[2]
+	testl %eax, %eax
+	jz 22f				# NULL ptr - zero out remaining args
+	cmpl $__PAGE_OFFSET, %eax	# access_ok(arg_ptr)
+	jae bad_copy_uatom
+120:	movl (%eax), %eax
+	movl %eax, 24(%ecx)
+
+13:	movl 28(%edx), %eax		# atom->arg_ptr[3] = uatom->arg_ptr[3]
+	testl %eax, %eax
+	jz 23f				# NULL ptr - zero out remaining args
+	cmpl $__PAGE_OFFSET, %eax	# access_ok(arg_ptr)
+	jae bad_copy_uatom
+130:	movl (%eax), %eax
+	movl %eax, 28(%ecx)
+
+14:	movl 32(%edx), %eax		# atom->arg_ptr[4] = uatom->arg_ptr[4]
+	testl %eax, %eax
+	jz 24f				# NULL ptr - zero out remaining args
+	cmpl $__PAGE_OFFSET, %eax	# access_ok(arg_ptr)
+	jae bad_copy_uatom
+140:	movl (%eax), %eax
+	movl %eax, 32(%ecx)
+
+15:	movl 36(%edx), %eax		# atom->arg_ptr[5] = uatom->arg_ptr[5]
+	testl %eax, %eax
+	jz 25f				# NULL ptr - zero out remaining args
+	cmpl $__PAGE_OFFSET, %eax	# access_ok(arg_ptr)
+	jae bad_copy_uatom
+150:	movl (%eax), %eax
+	movl %eax, 36(%ecx)
+
+	xorl %eax, %eax			# return 0
+	ret
+
+	#
+	# Zero out arg values. Since ptr was NULL, %eax is zero:
+	#
+20:	movl %eax, 16(%ecx)		# atom->args[0] = 0
+21:	movl %eax, 20(%ecx)		# atom->args[1] = 0
+22:	movl %eax, 24(%ecx)		# atom->args[2] = 0
+23:	movl %eax, 28(%ecx)		# atom->args[3] = 0
+24:	movl %eax, 32(%ecx)		# atom->args[4] = 0
+25:	movl %eax, 36(%ecx)		# atom->args[5] = 0
+
+	ret				# return 0
+
+bad_copy_uatom:
+	movl $-14, %eax
+	ret
+
+.section __ex_table,"a"
+	.long 1b,   bad_copy_uatom
+	.long 2b,   bad_copy_uatom
+	.long 3b,   bad_copy_uatom
+	.long 4b,   bad_copy_uatom
+	.long 10b,  bad_copy_uatom
+	.long 100b, bad_copy_uatom
+	.long 11b,  bad_copy_uatom
+	.long 110b, bad_copy_uatom
+	.long 12b,  bad_copy_uatom
+	.long 120b, bad_copy_uatom
+	.long 13b,  bad_copy_uatom
+	.long 130b, bad_copy_uatom
+	.long 14b,  bad_copy_uatom
+	.long 140b, bad_copy_uatom
+	.long 15b,  bad_copy_uatom
+	.long 150b, bad_copy_uatom
+.previous
 
 /*
  * __get_user_X
