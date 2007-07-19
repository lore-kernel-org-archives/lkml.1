Return-Path: <linux-kernel-owner+w=401wt.eu-S1762139AbXGSJ5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139AbXGSJ5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbXGSJyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:54:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:33029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbXGSJyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:54:49 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/58] x86_64: Don't rely on a unique IO-APIC ID
Message-Id: <20070719095448.043CA14E04@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:54:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linux 64bit only uses the IO-APIC ID as an internal cookie. In the future
there could be some cases where the IO-APIC IDs are not unique because
they share an 8 bit space with CPUs and if there are enough CPUs 
it is difficult to get them that. But Linux needs the io apic ID
internally for its data structures. Assign unique IO APIC ids on 
table parsing.

TBD do for 32bit too

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/mpparse.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/kernel/mpparse.c
===================================================================
--- linux.orig/arch/x86_64/kernel/mpparse.c
+++ linux/arch/x86_64/kernel/mpparse.c
@@ -649,6 +649,20 @@ static int mp_find_ioapic(int gsi)
 	return -1;
 }
 
+static u8 uniq_ioapic_id(u8 id)
+{
+	int i;
+	DECLARE_BITMAP(used, 256);
+	bitmap_zero(used, 256);
+	for (i = 0; i < nr_ioapics; i++) {
+		struct mpc_config_ioapic *ia = &mp_ioapics[i];
+		__set_bit(ia->mpc_apicid, used);
+	}
+	if (!test_bit(id, used))
+		return id;
+	return find_first_zero_bit(used, 256);
+}
+
 void __init mp_register_ioapic(u8 id, u32 address, u32 gsi_base)
 {
 	int idx = 0;
@@ -656,14 +670,14 @@ void __init mp_register_ioapic(u8 id, u3
 	if (bad_ioapic(address))
 		return;
 
-	idx = nr_ioapics++;
+	idx = nr_ioapics;
 
 	mp_ioapics[idx].mpc_type = MP_IOAPIC;
 	mp_ioapics[idx].mpc_flags = MPC_APIC_USABLE;
 	mp_ioapics[idx].mpc_apicaddr = address;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
-	mp_ioapics[idx].mpc_apicid = id;
+	mp_ioapics[idx].mpc_apicid = uniq_ioapic_id(id);
 	mp_ioapics[idx].mpc_apicver = 0;
 	
 	/* 
@@ -680,6 +694,8 @@ void __init mp_register_ioapic(u8 id, u3
 		mp_ioapics[idx].mpc_apicaddr,
 		mp_ioapic_routing[idx].gsi_start,
 		mp_ioapic_routing[idx].gsi_end);
+
+	nr_ioapics++;
 }
 
 void __init
