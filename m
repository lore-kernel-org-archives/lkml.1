Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbXDYLPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbXDYLPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992578AbXDYLPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:15:18 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:47146 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbXDYLPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:15:17 -0400
Subject: [PATCH 2/10] safe_apic_wait_icr_idle - x86_64
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: horms@verge.net.au, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, ak@suse.de, vgoyal@in.ibm.com,
       mbligh@google.com, Keith Owens <kaos@ocs.com.au>,
       akpm@linux-foundation.org
In-Reply-To: <1177498984.16078.37.camel@sebastian.intellilink.co.jp>
References: <1177498984.16078.37.camel@sebastian.intellilink.co.jp>
Content-Type: text/plain; charset=UTF-8
Organization: NTT Open Source Software Center
Date: Wed, 25 Apr 2007 20:15:15 +0900
Message-Id: <1177499715.17974.12.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

apic_wait_icr_idle looks like this:

static __inline__ void apic_wait_icr_idle(void)
{
  while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
    cpu_relax();
}

The busy loop in this function would not be problematic if the
corresponding status bit in the ICR were always updated, but that does
not seem to be the case under certain crash scenarios. Kdump uses an IPI
to stop the other CPUs in the event of a crash, but when any of the
other CPUs are locked-up inside the NMI handler the CPU that sends the
IPI will end up looping forever in the ICR check, effectively
hard-locking the whole system.

Quoting from Intel's "MultiProcessor Specification" (Version 1.4), B-3:

"A local APIC unit indicates successful dispatch of an IPI by
resetting the Delivery Status bit in the Interrupt Command
Register (ICR). The operating system polls the delivery status
bit after sending an INIT or STARTUP IPI until the command has
been dispatched.

A period of 20 microseconds should be sufficient for IPI dispatch
to complete under normal operating conditions. If the IPI is not
successfully dispatched, the operating system can abort the
command. Alternatively, the operating system can retry the IPI by
writing the lower 32-bit double word of the ICR. This “time-out”
mechanism can be implemented through an external interrupt, if
interrupts are enabled on the processor, or through execution of
an instruction or time-stamp counter spin loop."

Intel's documentation suggests the implementation of a time-out
mechanism, which, by the way, is already being open-coded in some parts
of the kernel that tinker with ICR.

Create a apic_wait_icr_idle replacement that implements the time-out
mechanism and that can be used to solve the aforementioned problem.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.21-rc7-orig/include/asm-x86_64/apic.h linux-2.6.21-rc7/include/asm-x86_64/apic.h
--- linux-2.6.21-rc7-orig/include/asm-x86_64/apic.h	2007-04-18 13:47:06.000000000 +0900
+++ linux-2.6.21-rc7/include/asm-x86_64/apic.h	2007-04-18 15:24:30.000000000 +0900
@@ -2,6 +2,7 @@
 #define __ASM_APIC_H
 
 #include <linux/pm.h>
+#include <linux/delay.h>
 #include <asm/fixmap.h>
 #include <asm/apicdef.h>
 #include <asm/system.h>
@@ -49,10 +50,24 @@ static __inline unsigned int apic_read(u
 
 static __inline__ void apic_wait_icr_idle(void)
 {
-	while (apic_read( APIC_ICR ) & APIC_ICR_BUSY)
+	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
 		cpu_relax();
 }
 
+static __inline__ unsigned int safe_apic_wait_icr_idle(void)
+{
+	unsigned int send_status;
+	int timeout;
+
+	timeout = 0;
+	do {
+		udelay(100);
+		send_status = apic_read(APIC_ICR) & APIC_ICR_BUSY;
+	} while (send_status && (timeout++ < 1000));
+
+	return send_status;
+}
+
 static inline void ack_APIC_irq(void)
 {
 	/*


