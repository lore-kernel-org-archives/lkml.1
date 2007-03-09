Return-Path: <linux-kernel-owner+w=401wt.eu-S2992928AbXCIDdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992928AbXCIDdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 22:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992939AbXCIDdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 22:33:54 -0500
Received: from ozlabs.org ([203.10.76.45]:46185 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992928AbXCIDdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 22:33:53 -0500
Subject: [PATCH 9/9] lguest: don't crash host on NMI
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@osdl.org>
Cc: Andi Kleen <ak@muc.de>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1173411000.32234.90.camel@localhost.localdomain>
References: <1173409524.32234.67.camel@localhost.localdomain>
	 <1173409696.32234.69.camel@localhost.localdomain>
	 <1173409939.32234.73.camel@localhost.localdomain>
	 <1173410210.32234.76.camel@localhost.localdomain>
	 <1173410264.32234.78.camel@localhost.localdomain>
	 <1173410348.32234.81.camel@localhost.localdomain>
	 <1173410611.32234.84.camel@localhost.localdomain>
	 <1173411000.32234.90.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 14:32:56 +1100
Message-Id: <1173411176.32234.94.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"handle" NMI by ignoring it.  Can't have been important, right?  As the
lguest64 hackers explained, handling NMI is a PITA.  Now oprofile does
not crash machine.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 5beeb29ed3a3 arch/i386/lguest/hypervisor.S
--- a/arch/i386/lguest/hypervisor.S	Wed Feb 28 09:59:23 2007 +1100
+++ b/arch/i386/lguest/hypervisor.S	Wed Feb 28 09:59:47 2007 +1100
@@ -116,6 +116,11 @@ deliver_to_host:
 	orl	%eax, %edx
 	jmp	*%edx
 
+/* We ignore NMI and return. */
+handle_nmi:
+	addl	$8, %esp
+	iret
+
 /* Real hardware interrupts are delivered straight to the host.  Others
    cause us to return to run_guest_once so it can decide what to do.  Note
    that some of these are overridden by the guest to deliver directly, and
@@ -148,8 +153,7 @@ default_idt_entries:
 default_idt_entries:
 .text
 	IRQ_STUBS 0 1 return_to_host		/* First two traps */
-/* FIXME: NMI needs something completely different.  Don't SWITCH_TO_HOST. */
-	IRQ_STUB 2 deliver_to_host		/* NMI */
+	IRQ_STUB 2 handle_nmi			/* NMI */
 	IRQ_STUBS 3 31 return_to_host		/* Rest of traps */
 	IRQ_STUBS 32 127 deliver_to_host	/* Real interrupts */
 	IRQ_STUB 128 return_to_host		/* System call (overridden) */


