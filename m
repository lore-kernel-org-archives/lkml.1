Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbYIKVec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbYIKVec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 17:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbYIKVdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 17:33:18 -0400
Received: from gw.goop.org ([64.81.55.164]:44691 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235AbYIKVdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 17:33:17 -0400
Message-ID: <48C98E9C.9090709@goop.org>
Date: Thu, 11 Sep 2008 14:33:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] acpi: remove final __acpi_map_table mapping before setting
 acpi_gbl_permanent_mmap
References: <patchbomb.1220826072@localhost> <944fe7ea3da7707eb90f.1220826078@localhost> <20080907234418.GB26079@one.firstfloor.org> <48C46BCB.2060209@goop.org> <20080908142619.GA10580@elte.hu> <20080910115525.GA31692@elte.hu> <48C7FA91.9050302@goop.org> <20080911125748.GA14698@elte.hu>
In-Reply-To: <20080911125748.GA14698@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86, __acpi_map_table uses early_ioremap() to create the mapping,
replacing the previous mapping with a new one.  Once enough of the
kernel is up an running it switches to using normal ioremap().  At
that point, we need to clean up the final mapping to avoid a warning
from the early_ioremap subsystem.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/acpi/boot.c |    8 +++++---
 drivers/acpi/bus.c          |    6 ++++++
 2 files changed, 11 insertions(+), 3 deletions(-)

===================================================================
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -124,11 +124,13 @@
 	static char *prev_map;
 	static unsigned long prev_size;
 
+	if (prev_map) {
+		early_iounmap(prev_map, prev_size);
+		prev_map = NULL;
+	}
+
 	if (!phys || !size)
 		return NULL;
-
-	if (prev_map)
-		early_iounmap(prev_map, prev_size);
 
 	prev_size = size;
 	prev_map = early_ioremap(phys, size);
===================================================================
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -650,6 +650,12 @@
 	if (!acpi_strict)
 		acpi_gbl_enable_interpreter_slack = TRUE;
 
+	/*
+	 * Doing a zero-sized mapping will clear out the previous
+	 * __acpi_map_table() mapping, if any.
+	 */
+	__acpi_map_table(0, 0);
+
 	acpi_gbl_permanent_mmap = 1;
 
 	status = acpi_reallocate_root_table();


