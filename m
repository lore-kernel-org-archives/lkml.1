Return-Path: <linux-kernel-owner+w=401wt.eu-S1759032AbZEGNuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032AbZEGNuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757334AbZEGNuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:50:08 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:46052
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757076AbZEGNuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:50:01 -0400
X-BigFish: VPS1(zzzz1202hzzz32i66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KJA12Y-02-CL6-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 04/21] amd64_edac: add DRAM error injection logic using sysfs
Date: Thu, 7 May 2009 15:49:26 +0200
Message-ID: <1241704183-29223-5-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 07 May 2009 13:49:49.0703 (UTC) FILETIME=[B0AD8170:01C9CF1A]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac_inj.c |  200 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 200 insertions(+), 0 deletions(-)
 create mode 100644 drivers/edac/amd64_edac_inj.c

diff --git a/drivers/edac/amd64_edac_inj.c b/drivers/edac/amd64_edac_inj.c
new file mode 100644
index 0000000..7f978cb
--- /dev/null
+++ b/drivers/edac/amd64_edac_inj.c
@@ -0,0 +1,200 @@
+#include "amd64_edac.h"
+
+/*
+ * amd64_inject_section_store
+ *
+ *	accept and store error injection section value
+ *	range: 0..3
+ *		value refers to one of 4 16-byte sections
+ *		within a 64-byte cacheline
+ */
+static ssize_t amd64_inject_section_store(struct mem_ctl_info *mci,
+					const char *data, size_t count)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	unsigned long value;
+	int rc;
+
+	rc = strict_strtoul(data, 10, &value);
+	if (rc != -EINVAL) {
+
+		/* save the 16-byte cache section */
+		pvt->injection.section = (u32) value;
+
+		return count;
+	}
+	return 0;
+}
+
+/*
+ * amd64_inject_word_store
+ *
+ *	accept and store error injection word value
+ *	range: 0..8
+ *		value refers to one of 9 16-bit word of the 16-byte section
+ *		128-bit + ECC bits
+ */
+static ssize_t amd64_inject_word_store(struct mem_ctl_info *mci,
+					const char *data, size_t count)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	unsigned long value;
+	int rc;
+
+	rc = strict_strtoul(data, 10, &value);
+	if (rc != -EINVAL) {
+
+		/* save the 16-bit word */
+		value = (value <= 8) ? value : 0;
+		pvt->injection.word = (u32) value;
+
+		return count;
+	}
+	return 0;
+}
+
+/*
+ * amd64_inject_bit_store
+ *
+ *	accept and store error injection hexidecimal bit value
+ *	16-bits of a bit-vector marking which bits to error-out on
+ */
+static ssize_t amd64_inject_bit_store(struct mem_ctl_info *mci,
+					const char *data, size_t count)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	unsigned long value;
+	int rc;
+
+	rc = strict_strtoul(data, 16, &value);
+	if (rc != -EINVAL) {
+
+		/* save the bit within the 16-bit word */
+		pvt->injection.bit_map = (u32) value & 0xFFFF;
+
+		return count;
+	}
+	return 0;
+}
+
+/*
+ * amd64_inject_read_store
+ *
+ *	READ action. When called, assemble staged values in the pvt
+ *	area and format into fields needed by the Injection hardware
+ *	Output to hardware and issue a READ operation
+ */
+static ssize_t amd64_inject_read_store(struct mem_ctl_info *mci,
+					const char *data, size_t count)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	unsigned long value;
+	u32 section, word_bits;
+	int rc;
+
+	rc = strict_strtoul(data, 10, &value);
+	if (rc != -EINVAL) {
+
+		/* Form value to choose 16-byte section of cacheline */
+		section = F10_NB_ARRAY_DRAM_ECC |
+				SET_NB_ARRAY_ADDRESS(pvt->injection.section);
+		pci_write_config_dword(pvt->misc_f3_ctl,
+					F10_NB_ARRAY_ADDR, section);
+
+		word_bits = SET_NB_DRAM_INJECTION_READ(pvt->injection.word,
+						pvt->injection.bit_map);
+
+		/* Issue 'word' and 'bit' along with the READ request now */
+		pci_write_config_dword(pvt->misc_f3_ctl,
+					F10_NB_ARRAY_DATA, word_bits);
+
+		debugf0("%s() section=0x%x word_bits=0x%x\n", __func__,
+			section, word_bits);
+
+		return count;
+	}
+	return 0;
+}
+
+/*
+ * amd64_inject_write_store
+ *
+ *	WRITE action. When called, assemble staged values in the pvt
+ *	area and format into fields needed by the Injection hardware
+ *	Output to hardware and issue a WRITE operation
+ */
+static ssize_t amd64_inject_write_store(struct mem_ctl_info *mci,
+					const char *data, size_t count)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	unsigned long value;
+	u32 section, word_bits;
+	int rc;
+
+	rc = strict_strtoul(data, 10, &value);
+	if (rc != -EINVAL) {
+
+		/* Form value to choose 16-byte section of cacheline */
+		section = F10_NB_ARRAY_DRAM_ECC |
+				SET_NB_ARRAY_ADDRESS(pvt->injection.section);
+		pci_write_config_dword(pvt->misc_f3_ctl,
+					F10_NB_ARRAY_ADDR, section);
+
+		word_bits = SET_NB_DRAM_INJECTION_WRITE(pvt->injection.word,
+						pvt->injection.bit_map);
+
+		/* Issue 'word' and 'bit' along with the READ request now */
+		pci_write_config_dword(pvt->misc_f3_ctl,
+					F10_NB_ARRAY_DATA, word_bits);
+
+		debugf0("%s() section=0x%x word_bits=0x%x\n", __func__,
+			section, word_bits);
+
+		return count;
+	}
+	return 0;
+}
+
+struct mcidev_sysfs_attribute amd64_inj_attrs[] = {
+
+	{
+		.attr = {
+			.name = "z_inject_section",
+			.mode = (S_IRUGO | S_IWUSR)
+		},
+		.show = NULL,
+		.store = amd64_inject_section_store,
+	},
+	{
+		.attr = {
+			.name = "z_inject_word",
+			.mode = (S_IRUGO | S_IWUSR)
+		},
+		.show = NULL,
+		.store = amd64_inject_word_store,
+	},
+	{
+		.attr = {
+			.name = "z_inject_bit_map",
+			.mode = (S_IRUGO | S_IWUSR)
+		},
+		.show = NULL,
+		.store = amd64_inject_bit_store,
+	},
+	{
+		.attr = {
+			.name = "z_inject_write",
+			.mode = (S_IRUGO | S_IWUSR)
+		},
+		.show = NULL,
+		.store = amd64_inject_write_store,
+	},
+	{
+		.attr = {
+			.name = "z_inject_read",
+			.mode = (S_IRUGO | S_IWUSR)
+		},
+		.show = NULL,
+		.store = amd64_inject_read_store,
+	},
+};
-- 
1.6.2.4


