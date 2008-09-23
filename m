Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbYIWUha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbYIWUha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 16:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYIWUhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 16:37:19 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42353 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752425AbYIWUhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 16:37:18 -0400
Date: Tue, 23 Sep 2008 15:37:13 -0500
From: Jack Steiner <steiner@sgi.com>
To: Yinghai Lu <yinghai@kernel.org>, mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] - V2 Add early detection of UV system types
Message-ID: <20080923203713.GA9606@sgi.com>
References: <20080923182817.GA6335@sgi.com> <86802c440809231159x69883d44y26bbd491b6504a0f@mail.gmail.com> <20080923193049.GA21605@sgi.com> <86802c440809231239o207c893ja508a1574bd04706@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809231239o207c893ja508a1574bd04706@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Portions of the ACPI code needs to know if a system is a UV system prior
to genapic initialization. This patch adds a call early_acpi_boot_init()
so that the apic type is discovered earlier.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---

V2 of the patch adding fixes from Yinghai Lu.
Much cleaner and smaller.


 arch/x86/kernel/setup.c |    2 ++
 arch/x86/mm/srat_64.c   |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/setup.c
===================================================================
--- linux.orig/arch/x86/kernel/setup.c	2008-09-23 15:15:16.000000000 -0500
+++ linux/arch/x86/kernel/setup.c	2008-09-23 15:17:16.000000000 -0500
@@ -960,6 +960,8 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	acpi_boot_table_init();
 
+	early_acpi_boot_init();
+
 #ifdef CONFIG_ACPI_NUMA
 	/*
 	 * Parse SRAT to discover nodes.
Index: linux/arch/x86/mm/srat_64.c
===================================================================
--- linux.orig/arch/x86/mm/srat_64.c	2008-09-23 15:12:20.000000000 -0500
+++ linux/arch/x86/mm/srat_64.c	2008-09-23 15:22:44.000000000 -0500
@@ -138,7 +138,7 @@ acpi_numa_processor_affinity_init(struct
 		return;
 	}
 
-	if (is_uv_system())
+	if (get_uv_system_type() >= UV_X2APIC)
 		apic_id = (pa->apic_id << 8) | pa->local_sapic_eid;
 	else
 		apic_id = pa->apic_id;
