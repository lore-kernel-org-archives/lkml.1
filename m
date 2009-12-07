Return-Path: <linux-kernel-owner+w=401wt.eu-S934412AbZLGMA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934412AbZLGMA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 07:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934291AbZLGMA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 07:00:27 -0500
Received: from www.tglx.de ([62.245.132.106]:57801 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934269AbZLGMA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 07:00:27 -0500
Date: Mon, 7 Dec 2009 12:59:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: x86@kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] x86: Fix bogus warning in apic_noop.apic_write()
Message-ID: <alpine.LFD.2.00.0912071255420.3089@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apic_noop is used to provide dummy apic functions. It's installed when
the CPU has no APIC or when the APIC is disabled on the kernel command
line.

The apic_noop implementation of apic_write() warns when the CPU has an
APIC or when the APIC is not disabled.

That's bogus. The warning should only happen when the CPU has an APIC
_AND_ the APIC is not disabled. apic_noop.apic_read() has the correct
check.

[ @stable: in <= .32 this typo resides in native_apic_write_dummy(). ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@kernel.org
---
 arch/x86/kernel/apic/apic_noop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/apic/apic_noop.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic_noop.c
+++ linux-2.6/arch/x86/kernel/apic/apic_noop.c
@@ -127,7 +127,7 @@ static u32 noop_apic_read(u32 reg)
 
 static void noop_apic_write(u32 reg, u32 v)
 {
-	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
+	WARN_ON_ONCE((cpu_has_apic && !disable_apic));
 }
 
 struct apic apic_noop = {
