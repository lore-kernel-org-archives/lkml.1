Return-Path: <linux-kernel-owner+w=401wt.eu-S1762762AbZD1PY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762762AbZD1PY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761572AbZD1PV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:21:56 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:21882 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761990AbZD1PVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:21:54 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j)
X-FB-SS: 5,
X-WSS-ID: 0KITGMV-01-UB3-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: akpm@linux-foundation.org, greg@kroah.com
CC: <linux-kernel@vger.kernel.org>, Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 19/21] amd64_edac: add debugging/testing code
Date: Tue, 28 Apr 2009 17:06:11 +0200
Message-ID: <1240931173-17477-20-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>
References: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Apr 2009 15:06:24.0677 (UTC) FILETIME=[E5C72550:01C9C812]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

This is for dumping different registers and testing the address mapping
logic using the ECC syndromes.

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |  216 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 216 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 5484c11..3c04fd6 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -4438,3 +4438,219 @@ static int amd64_check_ecc_enabled(struct amd64_pvt *pvt)
 	return rc;
 }
 
+#ifdef	CONFIG_EDAC_DEBUG
+/*
+ * amd64_nbea_store
+ *
+ * 	Accept a hex value and store it into the virutal error
+ *	register file, field:	nbeal and nbeah
+ *
+ *	Assume virtual error values have already been set for:
+ *		NBSL, NBSH and NBCFG
+ *
+ *	Then proceed to map the error values to a:
+ *		MC, CSROW and CHANNEL
+ */
+static ssize_t amd64_nbea_store(struct mem_ctl_info *mci,
+					const char *data, size_t count)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	unsigned long long value;
+	int rc;
+
+	rc = strict_strtoull(data, 16, &value);
+	if (rc != -EINVAL) {
+		debugf0("%s() received NBEA= 0x%llx\n", __func__, value);
+
+		/* place the value into the virtual error packet */
+		pvt->ctl_error_info.nbeal = (u32) value;
+		value >>= 32;
+		pvt->ctl_error_info.nbeah = (u32) value;
+
+		/* Process the Mapping request */
+		/* TODO: Add race preventation */
+		amd64_process_error_info(mci, &pvt->ctl_error_info, 1);
+
+		return count;
+	}
+	return 0;
+}
+
+/*
+ * amd64_nbea_show
+ *
+ *	display back what the last NBEA address was written
+ */
+static ssize_t amd64_nbea_show(struct mem_ctl_info *mci, char *data)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	u64 value;
+
+	value = pvt->ctl_error_info.nbeah;
+	value <<= 32;
+	value |= pvt->ctl_error_info.nbeal;
+
+	return sprintf(data, "%lx\n", (unsigned long) value);
+}
+
+/*
+ * amd64_nbsl_store
+ *
+ *	accept and store the NBSL value user desires
+ */
+static ssize_t amd64_nbsl_store(struct mem_ctl_info *mci,
+					const char *data, size_t count)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	unsigned long value;
+	int rc;
+
+	rc = strict_strtoul(data, 16, &value);
+	if (rc != -EINVAL) {
+		debugf0("%s() received NBSL= 0x%lx\n", __func__, value);
+
+		/* place the NBSL value into the virtual error packet */
+		pvt->ctl_error_info.nbsl = (u32) value;
+
+		return count;
+	}
+	return 0;
+}
+
+/*
+ * amd64_nbsl_show
+ *
+ *	display back what the last NBSL value written
+ */
+static ssize_t amd64_nbsl_show(struct mem_ctl_info *mci, char *data)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	u32 value;
+
+	value = pvt->ctl_error_info.nbsl;
+
+	return sprintf(data, "%x\n", value);
+}
+
+/*
+ * amd64_nbsh_store
+ *
+ *	accept and store the NBSH value user desires
+ */
+static ssize_t amd64_nbsh_store(struct mem_ctl_info *mci,
+					const char *data, size_t count)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	unsigned long value;
+	int rc;
+
+	rc = strict_strtoul(data, 16, &value);
+	if (rc != -EINVAL) {
+		debugf0("%s() received NBSL= 0x%lx\n", __func__, value);
+
+		/* place the NBSL value into the virtual error packet */
+		pvt->ctl_error_info.nbsh = (u32) value;
+
+		return count;
+	}
+	return 0;
+}
+
+/*
+ * amd64_nbsh_show
+ *
+ *	display back what the last NBSL value written
+ */
+static ssize_t amd64_nbsh_show(struct mem_ctl_info *mci, char *data)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	u32 value;
+
+	value = pvt->ctl_error_info.nbsh;
+
+	return sprintf(data, "%x\n", value);
+}
+
+/*
+ * amd64_nbcfg_store
+ *
+ *	accept and store the NBSL value user desires
+ */
+static ssize_t amd64_nbcfg_store(struct mem_ctl_info *mci,
+					const char *data, size_t count)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+	unsigned long value;
+	int rc;
+
+	rc = strict_strtoul(data, 16, &value);
+	if (rc != -EINVAL) {
+		debugf0("%s() received NBCFG= 0x%lx\n", __func__, value);
+
+		/* place the NBSL value into the virtual error packet */
+		pvt->ctl_error_info.nbcfg = (u32) value;
+
+		return count;
+	}
+	return 0;
+}
+
+/*
+ *	Various show routines for the controls of a MCI
+ */
+static ssize_t amd64_nbcfg_show(struct mem_ctl_info *mci, char *data)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+
+	return sprintf(data, "%x\n",
+		pvt->ctl_error_info.nbcfg);
+}
+
+
+static ssize_t amd64_dhar_show(struct mem_ctl_info *mci, char *data)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+
+	return sprintf(data, "%x\n", pvt->dhar);
+}
+
+
+static ssize_t amd64_dbam_show(struct mem_ctl_info *mci, char *data)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+
+	return sprintf(data, "%x\n", pvt->dbam0);
+}
+
+
+static ssize_t amd64_topmem_show(struct mem_ctl_info *mci, char *data)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+
+	return sprintf(data, "%lx\n", (long unsigned int) pvt->top_mem);
+}
+
+
+static ssize_t amd64_topmem2_show(struct mem_ctl_info *mci, char *data)
+{
+	struct amd64_pvt *pvt = mci->pvt_info;
+
+	return sprintf(data, "%lx\n", (long unsigned int) pvt->top_mem2);
+}
+
+static ssize_t amd64_hole_show(struct mem_ctl_info *mci, char *data)
+{
+	u64 hole_base = 0;
+	u64 hole_offset = 0;
+	u64 hole_size = 0;
+
+	amd64_get_dram_hole_info(mci, &hole_base, &hole_offset, &hole_size);
+
+	return sprintf(data, "%lx %lx %lx\n",
+		(long unsigned int) hole_base,
+		(long unsigned int) hole_offset,
+		(long unsigned int) hole_size);
+}
+
+#endif	/* DEBUG */
+
-- 
1.6.2.4


