Return-Path: <linux-kernel-owner+w=401wt.eu-S1761103AbXK1Ofp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761103AbXK1Ofp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758714AbXK1OfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:35:24 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:62239 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756948AbXK1OfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:35:23 -0500
Message-Id: <20071128143438.201413000@pademelon.sonytel.be>
References: <20071128143142.580732000@pademelon.sonytel.be>
User-Agent: quilt/0.46-1
Date: Wed, 28 Nov 2007 15:31:44 +0100
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linux/PPC Development <linuxppc-dev@ozlabs.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 2/7] ps3: Add ps3_repository_find_device_by_id()
Content-Disposition: inline; filename=ps3-wip/ps3_repository_find_device_by_id.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3: Add ps3_repository_find_device_by_id()

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 arch/powerpc/platforms/ps3/platform.h   |    2 
 arch/powerpc/platforms/ps3/repository.c |   77 ++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

--- a/arch/powerpc/platforms/ps3/platform.h
+++ b/arch/powerpc/platforms/ps3/platform.h
@@ -153,6 +153,8 @@ static inline struct ps3_repository_devi
 	return repo;
 }
 int ps3_repository_find_device(struct ps3_repository_device *repo);
+int ps3_repository_find_device_by_id(struct ps3_repository_device *repo,
+				     u64 bus_id, u64 dev_id);
 int ps3_repository_find_devices(enum ps3_bus_type bus_type,
 	int (*callback)(const struct ps3_repository_device *repo));
 int ps3_repository_find_bus(enum ps3_bus_type bus_type, unsigned int from,
--- a/arch/powerpc/platforms/ps3/repository.c
+++ b/arch/powerpc/platforms/ps3/repository.c
@@ -389,6 +389,83 @@ int ps3_repository_find_device(struct ps
 	return 0;
 }
 
+int ps3_repository_find_device_by_id(struct ps3_repository_device *repo,
+				     u64 bus_id, u64 dev_id)
+{
+	int result = -ENODEV;
+	struct ps3_repository_device tmp;
+	unsigned int num_dev;
+
+	pr_debug(" -> %s:%u: find device by id %lu:%lu\n", __func__, __LINE__,
+		 bus_id, dev_id);
+
+	for (tmp.bus_index = 0; tmp.bus_index < 10; tmp.bus_index++) {
+		result = ps3_repository_read_bus_id(tmp.bus_index,
+						    &tmp.bus_id);
+		if (result) {
+			pr_debug("%s:%u read_bus_id(%u) failed\n", __func__,
+				 __LINE__, tmp.bus_index);
+			return result;
+		}
+
+		if (tmp.bus_id == bus_id)
+			goto found_bus;
+
+		pr_debug("%s:%u: skip, bus_id %lu\n", __func__, __LINE__,
+			 tmp.bus_id);
+	}
+	pr_debug(" <- %s:%u: bus not found\n", __func__, __LINE__);
+	return result;
+
+found_bus:
+	result = ps3_repository_read_bus_type(tmp.bus_index, &tmp.bus_type);
+	if (result) {
+		pr_debug("%s:%u read_bus_type(%u) failed\n", __func__,
+			 __LINE__, tmp.bus_index);
+		return result;
+	}
+
+	result = ps3_repository_read_bus_num_dev(tmp.bus_index, &num_dev);
+	if (result) {
+		pr_debug("%s:%u read_bus_num_dev failed\n", __func__,
+			 __LINE__);
+		return result;
+	}
+
+	for (tmp.dev_index = 0; tmp.dev_index < num_dev; tmp.dev_index++) {
+		result = ps3_repository_read_dev_id(tmp.bus_index,
+						    tmp.dev_index,
+						    &tmp.dev_id);
+		if (result) {
+			pr_debug("%s:%u read_dev_id(%u:%u) failed\n", __func__,
+				 __LINE__, tmp.bus_index, tmp.dev_index);
+			return result;
+		}
+
+		if (tmp.dev_id == dev_id)
+			goto found_dev;
+
+		pr_debug("%s:%u: skip, dev_id %lu\n", __func__, __LINE__,
+			 tmp.dev_id);
+	}
+	pr_debug(" <- %s:%u: dev not found\n", __func__, __LINE__);
+	return result;
+
+found_dev:
+	result = ps3_repository_read_dev_type(tmp.bus_index, tmp.dev_index,
+					      &tmp.dev_type);
+	if (result) {
+		pr_debug("%s:%u read_dev_type failed\n", __func__, __LINE__);
+		return result;
+	}
+
+	pr_debug(" <- %s:%u: found: type (%u:%u) index (%u:%u) id (%lu:%lu)\n",
+		 __func__, __LINE__, tmp.bus_type, tmp.dev_type, tmp.bus_index,
+		 tmp.dev_index, tmp.bus_id, tmp.dev_id);
+	*repo = tmp;
+	return 0;
+}
+
 int __devinit ps3_repository_find_devices(enum ps3_bus_type bus_type,
 	int (*callback)(const struct ps3_repository_device *repo))
 {

-- 
With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619

