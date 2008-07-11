Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbYGKDjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbYGKDjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 23:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYGKDjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 23:39:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:43817 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbYGKDjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 23:39:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=pbKlzYmOhQ2b03OFr1M4ZfTGcAuVI/7HkGuK46AiHQr2wS/ppW759fdC4wYxzts0J+
         IuMLI45FNtnBph03MVjXcN6btqMDvXL1/rtFrUz5aU0B08WDNtOLmStpCl+nOr8Hb3nH
         C2yhQuhwKDiwC6dj/kw7c3XNddLZq7QkFUvOw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86: save slit
Date: Thu, 10 Jul 2008 20:36:37 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807092016.36490.yhlu.kernel@gmail.com> <200807092017.51004.yhlu.kernel@gmail.com>
In-Reply-To: <200807092017.51004.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807102036.37697.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


in case we are using fixmap to read it. and that fixmap could be clearred by others.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/mm/srat_64.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -100,7 +100,19 @@ static __init inline int srat_disabled(v
 /* Callback for SLIT parsing */
 void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
 {
-	acpi_slit = slit;
+	unsigned length;
+	unsigned long phys;
+
+	length = slit->header.length;
+	phys = find_e820_area(0, max_pfn_mapped<<PAGE_SHIFT, length,
+		 PAGE_SIZE);
+
+	if (phys == -1L)
+		panic(" Can not save slit!\n");
+
+	acpi_slit = __va(phys);
+	memcpy(acpi_slit, slit, length);
+	reserve_early(phys, phys + length, "ACPI SLIT");
 }
 
 /* Callback for Proximity Domain -> LAPIC mapping */
