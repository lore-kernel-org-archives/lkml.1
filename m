Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab0BDRVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:21:34 -0500
Received: from kroah.org ([198.145.64.141]:34589 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932831Ab0BDRVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:30 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:14:50 2010
Message-Id: <20100204171449.885707829@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [06/74] S390: fix single stepped svcs with TRACE_IRQFLAGS=y
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 21ec7f6dbf10492ce9a21718040677d3e68bd57d upstream.

If irq flags tracing is enabled the TRACE_IRQS_ON macros expands to
a function call which clobbers registers %r0-%r5. The macro is used
in the code path for single stepped system calls. The argument
registers %r2-%r6 need to be restored from the stack before the system
call function is called.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/s390/kernel/entry.S   |    1 +
 arch/s390/kernel/entry64.S |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -549,6 +549,7 @@ pgm_svcper:
 	mvc	__THREAD_per+__PER_access_id(1,%r8),__LC_PER_ACCESS_ID
 	oi	__TI_flags+7(%r9),_TIF_SINGLE_STEP # set TIF_SINGLE_STEP
 	TRACE_IRQS_ON
+	lmg	%r2,%r6,SP_R2(%r15)	# load svc arguments
 	stosm	__SF_EMPTY(%r15),0x03	# reenable interrupts
 	j	sysc_do_svc
 
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -571,6 +571,7 @@ pgm_svcper:
 	mvc	__THREAD_per+__PER_access_id(1,%r8),__LC_PER_ACCESS_ID
 	oi	__TI_flags+3(%r9),_TIF_SINGLE_STEP # set TIF_SINGLE_STEP
 	TRACE_IRQS_ON
+	lm	%r2,%r6,SP_R2(%r15)	# load svc arguments
 	stosm	__SF_EMPTY(%r15),0x03	# reenable interrupts
 	b	BASED(sysc_do_svc)
 


