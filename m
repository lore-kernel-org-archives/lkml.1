Return-Path: <linux-kernel-owner+w=401wt.eu-S1759359AbZD2V43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359AbZD2V43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZD2V4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:56:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:58505 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbZD2V4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:56:17 -0400
Subject: [PATCH] x86: x86_32 kdump boot on cpu != 0
From: Ed Swierk <eswierk@aristanetworks.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 29 Apr 2009 14:56:12 -0700
Message-Id: <1241042172.13036.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting an x86_32 SMP kernel via kdump fails if the boot CPU has local
APIC ID != 0, with a panic:

  Boot APIC ID in local APIC unexpected (1 vs 0)

MP_processor_info() sets boot_cpu_physical_apicid to 0 based on the
mptable.  But this variable needs to be set to 1 later on to reflect the
actual local APIC ID.  (Setting it to 1 right off the bat causes
generic_processor_info() to complain about an "apic version mismatch",
which I don't understand.)

This change restores the apic_64.c logic, which existed prior to the
merge with apic_32.c, and allows the kdump kernel to boot.
 
Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>
---
 arch/x86/kernel/apic/apic.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f287092..b45c764 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1563,8 +1563,7 @@ void __init init_apic_mappings(void)
 	 * Fetch the APIC ID of the BSP in case we have a
 	 * default configuration (or the MP table is broken).
 	 */
-	if (boot_cpu_physical_apicid == -1U)
-		boot_cpu_physical_apicid = read_apic_id();
+	boot_cpu_physical_apicid = read_apic_id();
 }
 
 /*


