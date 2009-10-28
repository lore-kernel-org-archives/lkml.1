Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbZJ1Qh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbZJ1Qh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 12:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbZJ1QhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 12:37:25 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:12346 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbZJ1QhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 12:37:19 -0400
X-SpamScore: 10
X-BigFish: VPS10(zza4b1ozz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KS8GTT-03-9BQ-02
X-M-MSG: 
Date: Wed, 28 Oct 2009 17:37:06 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>
CC: Doug Thompson <norsk5@yahoo.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] amd64_edac: load syndrome table through firmware API
Message-ID: <20091028163706.GB625@aftab>
References: <20091028163534.GA625@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20091028163534.GA625@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 28 Oct 2009 16:37:04.0396 (UTC) FILETIME=[E1B2A4C0:01CA57EC]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8fd92e05c26d5d086990e356297c8e69c2325cc6 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Wed, 28 Oct 2009 13:24:34 +0100
Subject: [PATCH 1/2] amd64_edac: load syndrome table through firmware API

Add a facility for loading binary syndrome tables using the
request_firmware API instead of carrying static tables with the driver
code (esp. the x8 monster).

Not-Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   32 ++++++++++++++++++++++++++++++++
 drivers/edac/amd64_edac.h |   14 ++++++++++++++
 2 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index c492721..6222a2c 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1,4 +1,5 @@
 #include "amd64_edac.h"
+#include <linux/firmware.h>
 #include <asm/k8.h>
 
 static struct edac_pci_ctl_info *amd64_ctl_pci;
@@ -1982,6 +1983,37 @@ static const unsigned short ecc_chipkill_syndromes[NUMBER_ECC_ROWS][16] = {
 	   0x6f88, 0x19a9, 0xf4ba, 0x829b, 0xb5cc, 0xc3ed, 0x2efe, 0x58df }
 };
 
+static int amd64_load_syndrome_binary(char *fw_name, struct syndrome_table *s,
+				      struct device *dev)
+{
+	const struct firmware *fw;
+	struct syndrome_table tmp_s;
+
+	if (request_firmware(&fw, fw_name, dev)) {
+		amd64_printk(KERN_ERR, "Failure loading %s syndromes\n",
+			     fw_name);
+		return -EINVAL;
+	}
+
+	/* copy only the header */
+	memcpy(&tmp_s, fw->data, sizeof(*s) - sizeof(s->data));
+
+	if (tmp_s.magic != 0x00414d44 ||
+	    tmp_s.type  != s->type ||
+	    tmp_s.rows  != s->rows ||
+	    tmp_s.cols  != s->cols) {
+		amd64_printk(KERN_ERR, "Invalid syndromes binary!\n");
+		return -EINVAL;
+	}
+
+	memcpy(s->data,
+	       fw->data + offsetof(struct syndrome_table, data),
+	       s->rows * s->cols * sizeof(u16));
+
+	release_firmware(fw);
+	return 0;
+}
+
 /*
  * Given the syndrome argument, scan each of the channel tables for a syndrome
  * match. Depending on which table it is found, return the channel number.
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index db6c0a1..94f58d7 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -409,6 +409,20 @@ struct error_injection {
 	u32	bit_map;
 };
 
+enum syndrome_type {
+	SYNDROME_ECC			= (1 << 0),
+	SYNDROME_X4			= (1 << 1),
+	SYNDROME_X8			= (1 << 2),
+};
+
+struct syndrome_table {
+	 u32 magic;			/* should be 0x00414d44 */
+	 enum syndrome_type type;	/* ECC, X4, X8, etc */
+	 u32 rows;			/* dimensions of the syndromes table */
+	 u32 cols;
+	 u16 *data;			/* the actual syndrome table */
+} __attribute__((packed));
+
 struct amd64_pvt {
 	/* pci_device handles which we utilize */
 	struct pci_dev *addr_f1_ctl;
-- 
1.6.4.3

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

