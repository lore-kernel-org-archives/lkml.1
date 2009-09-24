Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbZIXMel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbZIXMel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbZIXMej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:34:39 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:54403 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbZIXMeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:34:37 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KQH6WG-04-3WD-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <norsk5@yahoo.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 10/10] amd64_edac: beef up DRAM error injection
Date: Thu, 24 Sep 2009 14:32:48 +0200
Message-ID: <1253795568-9877-11-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
References: <1253795568-9877-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 24 Sep 2009 12:33:40.0491 (UTC) FILETIME=[3F0C15B0:01CA3D13]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When injecting DRAM ECC errors (F3xBC_x8), EccVector[15:0] is a bitmask
of which bits should be error injected when written to and holds the
payload of 16-bit DRAM word when read, respectively.

Add /sysfs members to show the DRAM ECC section/word/vector.

Fail wrong injection values entered over /sysfs instead of truncating
them.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.h     |    6 +---
 drivers/edac/amd64_edac_inj.c |   49 ++++++++++++++++++++++++++++++++++++-----
 2 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 6a22b1e..ba9dfbf 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -375,13 +375,11 @@ enum {
 
 #define SET_NB_DRAM_INJECTION_WRITE(word, bits)  \
 					(BIT(((word) & 0xF) + 20) | \
-					BIT(17) |  \
-					((bits) & 0xF))
+					BIT(17) | bits)
 
 #define SET_NB_DRAM_INJECTION_READ(word, bits)  \
 					(BIT(((word) & 0xF) + 20) | \
-					BIT(16) |  \
-					((bits) & 0xF))
+					BIT(16) |  bits)
 
 #define K8_NBCAP			0xE8
 #define K8_NBCAP_CORES			(BIT(12)|BIT(13))
diff --git a/drivers/edac/amd64_edac_inj.c b/drivers/edac/amd64_edac_inj.c
index d3675b7..29f1f7a 100644
--- a/drivers/edac/amd64_edac_inj.c
+++ b/drivers/edac/amd64_edac_inj.c
@@ -1,5 +1,11 @@
 #include "amd64_edac.h"
 
+static ssize_t amd64_inject_section_show(struct mem_ctl_info *mci, char *buf)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	return sprintf(buf, "0x%x\n", pvt->injection.section);
+}
+
 /*
  * store error injection section value which refers to one of 4 16-byte sections
  * within a 64-byte cacheline
@@ -15,12 +21,26 @@ static ssize_t amd64_inject_section_store(struct mem_ctl_info *mci,
 
 	ret = strict_strtoul(data, 10, &value);
 	if (ret != -EINVAL) {
+
+		if (value > 3) {
+			amd64_printk(KERN_WARNING,
+				     "%s: invalid section 0x%lx\n",
+				     __func__, value);
+			return -EINVAL;
+		}
+
 		pvt->injection.section = (u32) value;
 		return count;
 	}
 	return ret;
 }
 
+static ssize_t amd64_inject_word_show(struct mem_ctl_info *mci, char *buf)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	return sprintf(buf, "0x%x\n", pvt->injection.word);
+}
+
 /*
  * store error injection word value which refers to one of 9 16-bit word of the
  * 16-byte (128-bit + ECC bits) section
@@ -37,14 +57,25 @@ static ssize_t amd64_inject_word_store(struct mem_ctl_info *mci,
 	ret = strict_strtoul(data, 10, &value);
 	if (ret != -EINVAL) {
 
-		value = (value <= 8) ? value : 0;
-		pvt->injection.word = (u32) value;
+		if (value > 8) {
+			amd64_printk(KERN_WARNING,
+				     "%s: invalid word 0x%lx\n",
+				     __func__, value);
+			return -EINVAL;
+		}
 
+		pvt->injection.word = (u32) value;
 		return count;
 	}
 	return ret;
 }
 
+static ssize_t amd64_inject_ecc_vector_show(struct mem_ctl_info *mci, char *buf)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	return sprintf(buf, "0x%x\n", pvt->injection.bit_map);
+}
+
 /*
  * store 16 bit error injection vector which enables injecting errors to the
  * corresponding bit within the error injection word above. When used during a
@@ -60,8 +91,14 @@ static ssize_t amd64_inject_ecc_vector_store(struct mem_ctl_info *mci,
 	ret = strict_strtoul(data, 16, &value);
 	if (ret != -EINVAL) {
 
-		pvt->injection.bit_map = (u32) value & 0xFFFF;
+		if (value & 0xFFFF0000) {
+			amd64_printk(KERN_WARNING,
+				     "%s: invalid EccVector: 0x%lx\n",
+				     __func__, value);
+			return -EINVAL;
+		}
 
+		pvt->injection.bit_map = (u32) value;
 		return count;
 	}
 	return ret;
@@ -147,7 +184,7 @@ struct mcidev_sysfs_attribute amd64_inj_attrs[] = {
 			.name = "inject_section",
 			.mode = (S_IRUGO | S_IWUSR)
 		},
-		.show = NULL,
+		.show = amd64_inject_section_show,
 		.store = amd64_inject_section_store,
 	},
 	{
@@ -155,7 +192,7 @@ struct mcidev_sysfs_attribute amd64_inj_attrs[] = {
 			.name = "inject_word",
 			.mode = (S_IRUGO | S_IWUSR)
 		},
-		.show = NULL,
+		.show = amd64_inject_word_show,
 		.store = amd64_inject_word_store,
 	},
 	{
@@ -163,7 +200,7 @@ struct mcidev_sysfs_attribute amd64_inj_attrs[] = {
 			.name = "inject_ecc_vector",
 			.mode = (S_IRUGO | S_IWUSR)
 		},
-		.show = NULL,
+		.show = amd64_inject_ecc_vector_show,
 		.store = amd64_inject_ecc_vector_store,
 	},
 	{
-- 
1.6.3.3


