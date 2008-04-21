Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbYDUIG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbYDUIG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbYDUIGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:06:13 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:58536 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYDUIGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:06:11 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 3/5] IB/ehca: Remove mr_largepage parameter
User-Agent: KMail/1.9.1
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200804211003.10695.fenkes@de.ibm.com>
In-Reply-To: <200804211003.10695.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3040
Date: Mon, 21 Apr 2008 09:06:08 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200804211006.08849.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always enable large page support; didn't seem to cause problems for anyone.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_main.c |   22 +++-------------------
 1 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 4379bef..ab02ac8 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -60,7 +60,6 @@ MODULE_VERSION(HCAD_VERSION);
 static int ehca_open_aqp1     = 0;
 static int ehca_hw_level      = 0;
 static int ehca_poll_all_eqs  = 1;
-static int ehca_mr_largepage  = 1;
 
 int ehca_debug_level   = 0;
 int ehca_nr_ports      = 2;
@@ -79,7 +78,6 @@ module_param_named(port_act_time, ehca_port_act_time, int, S_IRUGO);
 module_param_named(poll_all_eqs,  ehca_poll_all_eqs,  int, S_IRUGO);
 module_param_named(static_rate,   ehca_static_rate,   int, S_IRUGO);
 module_param_named(scaling_code,  ehca_scaling_code,  int, S_IRUGO);
-module_param_named(mr_largepage,  ehca_mr_largepage,  int, S_IRUGO);
 module_param_named(lock_hcalls,   ehca_lock_hcalls,   bool, S_IRUGO);
 
 MODULE_PARM_DESC(open_aqp1,
@@ -104,9 +102,6 @@ MODULE_PARM_DESC(static_rate,
 		 "set permanent static rate (default: disabled)");
 MODULE_PARM_DESC(scaling_code,
 		 "set scaling code (0: disabled/default, 1: enabled)");
-MODULE_PARM_DESC(mr_largepage,
-		 "use large page for MR (0: use PAGE_SIZE (default), "
-		 "1: use large page depending on MR size");
 MODULE_PARM_DESC(lock_hcalls,
 		 "serialize all hCalls made by the driver "
 		 "(default: autodetect)");
@@ -357,11 +352,9 @@ static int ehca_sense_attributes(struct ehca_shca *shca)
 
 	/* translate supported MR page sizes; always support 4K */
 	shca->hca_cap_mr_pgsize = EHCA_PAGESIZE;
-	if (ehca_mr_largepage) { /* support extra sizes only if enabled */
-		for (i = 0; i < ARRAY_SIZE(pgsize_map); i += 2)
-			if (rblock->memory_page_size_supported & pgsize_map[i])
-				shca->hca_cap_mr_pgsize |= pgsize_map[i + 1];
-	}
+	for (i = 0; i < ARRAY_SIZE(pgsize_map); i += 2)
+		if (rblock->memory_page_size_supported & pgsize_map[i])
+			shca->hca_cap_mr_pgsize |= pgsize_map[i + 1];
 
 	/* query max MTU from first port -- it's the same for all ports */
 	port = (struct hipz_query_port *)rblock;
@@ -663,14 +656,6 @@ static ssize_t ehca_show_adapter_handle(struct device *dev,
 }
 static DEVICE_ATTR(adapter_handle, S_IRUGO, ehca_show_adapter_handle, NULL);
 
-static ssize_t ehca_show_mr_largepage(struct device *dev,
-				      struct device_attribute *attr,
-				      char *buf)
-{
-	return sprintf(buf, "%d\n", ehca_mr_largepage);
-}
-static DEVICE_ATTR(mr_largepage, S_IRUGO, ehca_show_mr_largepage, NULL);
-
 static struct attribute *ehca_dev_attrs[] = {
 	&dev_attr_adapter_handle.attr,
 	&dev_attr_num_ports.attr,
@@ -687,7 +672,6 @@ static struct attribute *ehca_dev_attrs[] = {
 	&dev_attr_cur_mw.attr,
 	&dev_attr_max_pd.attr,
 	&dev_attr_max_ah.attr,
-	&dev_attr_mr_largepage.attr,
 	NULL
 };
 
-- 
1.5.5


