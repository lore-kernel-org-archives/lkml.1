Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbYC0HLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbYC0HLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 03:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbYC0HLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 03:11:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:58597 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426AbYC0HLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 03:11:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,562,1199692800"; 
   d="scan'208";a="540795755"
Subject: [PATCH -mm 1/4] x86_64 boot: Add free_early to early reservation
	machanism
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Mar 2008 15:09:06 +0800
Message-Id: <1206601746.3067.21.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 27 Mar 2008 07:06:05.0812 (UTC) FILETIME=[06669340:01C88FD9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add free_early to early reservation mechanism.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/e820_64.c |   17 +++++++++++++++++
 include/asm-x86/e820_64.h |    1 +
 2 files changed, 18 insertions(+)

--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -84,6 +84,23 @@ void __init reserve_early(unsigned long 
 		strncpy(r->name, name, sizeof(r->name) - 1);
 }
 
+void __init free_early(unsigned long start, unsigned long end)
+{
+	int i, j;
+	struct early_res *r;
+	for (i = 0; i < MAX_EARLY_RES && early_res[i].end; i++) {
+		r = &early_res[i];
+		if (start == r->start && end == r->end)
+			break;
+	}
+	if (i >= MAX_EARLY_RES || !early_res[i].end)
+		panic("free_early on not reserved area: %lx-%lx!", start, end);
+	for (j = i+1; j < MAX_EARLY_RES && early_res[j].end; j++) ;
+	memcpy(&early_res[i], &early_res[i+1],
+	       (j-1-i) * sizeof(struct early_res));
+	early_res[j-1].end = 0;
+}
+
 void __init early_res_to_bootmem(void)
 {
 	int i;
--- a/include/asm-x86/e820_64.h
+++ b/include/asm-x86/e820_64.h
@@ -41,6 +41,7 @@ extern struct e820map e820;
 extern void update_e820(void);
 
 extern void reserve_early(unsigned long start, unsigned long end, char *name);
+extern void free_early(unsigned long start, unsigned long end);
 extern void early_res_to_bootmem(void);
 
 #endif/*!__ASSEMBLY__*/

