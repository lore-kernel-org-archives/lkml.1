Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbYCRFbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbYCRFbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYCRFY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:27 -0400
Received: from gw.goop.org ([64.81.55.164]:37847 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbYCRFYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:10 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 21 of 31] xen: make sure iret faults are trapped
X-Mercurial-Node: 5a051635b17ef15744a68441bffc235ac42518cb
Message-Id: <5a051635b17ef15744a6.1205797032@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/entry_32.S |    2 +-
 arch/x86/xen/xen-asm.S     |    6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -411,7 +411,7 @@
 irq_return:
 	INTERRUPT_RETURN
 .section .fixup,"ax"
-iret_exc:
+ENTRY(iret_exc)
 	pushl $0			# no error code
 	pushl $do_iret_error
 	jmp error_code
diff --git a/arch/x86/xen/xen-asm.S b/arch/x86/xen/xen-asm.S
--- a/arch/x86/xen/xen-asm.S
+++ b/arch/x86/xen/xen-asm.S
@@ -184,8 +184,12 @@
 	   region is OK. */
 	je xen_hypervisor_callback
 
-	iret
+1:	iret
 xen_iret_end_crit:
+.section __ex_table,"a"
+	.align 4
+	.long 1b,iret_exc
+.previous
 
 hyper_iret:
 	/* put this out of line since its very rarely used */


