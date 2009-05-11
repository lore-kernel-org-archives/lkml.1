Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbZEKNzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbZEKNzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbZEKNzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:55:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:53667 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714AbZEKNzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:55:16 -0400
Date: Mon, 11 May 2009 13:54:29 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, tglx@linutronix.de, gorcunov@gmail.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, gorcunov@gmail.com,
       mingo@elte.hu
In-Reply-To: <20090511134140.GH4624@lenovo>
References: <20090511134140.GH4624@lenovo>
Subject: [tip:x86/apic] x86: apic: Fixmap apic address even if apic disabled
Message-ID: <tip-cec6be6d1069d697beb490bbb40a290d5ff554a2@git.kernel.org>
Git-Commit-ID: cec6be6d1069d697beb490bbb40a290d5ff554a2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 13:54:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cec6be6d1069d697beb490bbb40a290d5ff554a2
Gitweb:     http://git.kernel.org/tip/cec6be6d1069d697beb490bbb40a290d5ff554a2
Author:     Cyrill Gorcunov <gorcunov@gmail.com>
AuthorDate: Mon, 11 May 2009 17:41:40 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 15:50:58 +0200

x86: apic: Fixmap apic address even if apic disabled

In case if apic were disabled by boot option
we still need read_apic operation. So fixmap
a fake apic area if needed.

[ Impact: fix boot crash ]

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: yinghai@kernel.org
Cc: eswierk@aristanetworks.com
LKML-Reference: <20090511134140.GH4624@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/apic.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 0e6543f..07cffc1 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1587,13 +1587,6 @@ void __init init_apic_mappings(void)
 	} else
 		apic_phys = mp_lapic_addr;
 
-	/* lets check if we may NOP'ify apic operations */
-	if (!cpu_has_apic) {
-		pr_info("APIC: disable apic facility\n");
-		apic_disable();
-		return;
-	}
-
 	/*
 	 * acpi lapic path already maps that address in
 	 * acpi_register_lapic_address()
@@ -1602,7 +1595,15 @@ void __init init_apic_mappings(void)
 		set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
 
 	apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
-				APIC_BASE, apic_phys);
+			APIC_BASE, apic_phys);
+
+	/* lets check if we may NOP'ify apic operations */
+	if (!cpu_has_apic) {
+		pr_info("APIC: disable apic facility\n");
+		apic_disable();
+		return;
+	}
+
 	/*
 	 * Fetch the APIC ID of the BSP in case we have a
 	 * default configuration (or the MP table is broken).
