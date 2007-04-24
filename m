Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbXDXPog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbXDXPog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 11:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbXDXPog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 11:44:36 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:47556 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbXDXPoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 11:44:34 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH] eHCA: Add "Modify Port" verb
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 6092
Date: Tue, 24 Apr 2007 17:44:31 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200704241744.31691.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add "Modify Port" verb support to eHCA driver.
ib_cm needs this to initialize properly.


Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---

This is the shiny new version of this patch with proper locking.
Tested and works.

 ehca_classes.h |    1 +
 ehca_hca.c     |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 ehca_main.c    |    1 +
 hcp_if.c       |   24 ++++++++++++++++++++++++
 hcp_if.h       |    4 ++++
 5 files changed, 83 insertions(+), 2 deletions(-)

diff -urp a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
--- a/drivers/infiniband/hw/ehca/ehca_classes.h	2007-02-04 19:44:54.000000000 +0100
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h	2007-04-24 14:51:38.000000000 +0200
@@ -96,6 +96,7 @@ struct ehca_shca {
 	struct ehca_mr *maxmr;
 	struct ehca_pd *pd;
 	struct h_galpas galpas;
+	struct mutex modify_mutex;
 };
 
 struct ehca_pd {
diff -urp a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
--- a/drivers/infiniband/hw/ehca/ehca_hca.c	2007-02-04 19:44:54.000000000 +0100
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c	2007-04-24 14:50:43.000000000 +0200
@@ -147,6 +147,7 @@ int ehca_query_port(struct ib_device *ib
 		break;
 	}
 
+	props->port_cap_flags  = rblock->capability_mask;
 	props->gid_tbl_len     = rblock->gid_tbl_len;
 	props->max_msg_sz      = rblock->max_msg_sz;
 	props->bad_pkey_cntr   = rblock->bad_pkey_cntr;
@@ -233,10 +234,60 @@ query_gid1:
 	return ret;
 }
 
+const u32 allowed_port_caps = (
+	IB_PORT_SM | IB_PORT_LED_INFO_SUP | IB_PORT_CM_SUP |
+	IB_PORT_SNMP_TUNNEL_SUP | IB_PORT_DEVICE_MGMT_SUP |
+	IB_PORT_VENDOR_CLASS_SUP);
+
 int ehca_modify_port(struct ib_device *ibdev,
 		     u8 port, int port_modify_mask,
 		     struct ib_port_modify *props)
 {
-	/* Not implemented yet */
-	return -EFAULT;
+	int ret = 0;
+	struct ehca_shca *shca = container_of(ibdev, struct ehca_shca, ib_device);
+	struct hipz_query_port *rblock;
+	u32 cap;
+	u64 hret;
+
+	if ((props->set_port_cap_mask | props->clr_port_cap_mask)
+	    & ~allowed_port_caps) {
+		ehca_err(&shca->ib_device, "Non-changeable bits set in masks  "
+			 "set=%x  clr=%x  allowed=%x", props->set_port_cap_mask,
+			 props->clr_port_cap_mask, allowed_port_caps);
+		return -EINVAL;
+	}
+
+	if (mutex_lock_interruptible(&shca->modify_mutex))
+                return -ERESTARTSYS;
+
+	rblock = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
+	if (!rblock) {
+		ehca_err(&shca->ib_device,  "Can't allocate rblock memory.");
+		ret = -ENOMEM;
+		goto modify_port1;
+	}
+
+	if (hipz_h_query_port(shca->ipz_hca_handle, port, rblock) != H_SUCCESS) {
+		ehca_err(&shca->ib_device, "Can't query port properties");
+		ret = -EINVAL;
+		goto modify_port2;
+	}
+
+	cap = (rblock->capability_mask | props->set_port_cap_mask)
+		& ~props->clr_port_cap_mask;
+
+	hret = hipz_h_modify_port(shca->ipz_hca_handle, port,
+				  cap, props->init_type, port_modify_mask);
+	if (hret != H_SUCCESS) {
+		ehca_err(&shca->ib_device, "Modify port failed  hret=%lx", hret);
+		ret = -EINVAL;
+	}
+
+modify_port2:
+	ehca_free_fw_ctrlblock(rblock);
+
+modify_port1:
+        mutex_unlock(&shca->modify_mutex);
+
+	return ret;
 }
diff -urp a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
--- a/drivers/infiniband/hw/ehca/ehca_main.c	2007-02-04 19:44:54.000000000 +0100
+++ b/drivers/infiniband/hw/ehca/ehca_main.c	2007-04-24 14:50:43.000000000 +0200
@@ -583,6 +583,7 @@ static int __devinit ehca_probe(struct i
 		ehca_gen_err("Cannot allocate shca memory.");
 		return -ENOMEM;
 	}
+	mutex_init(&shca->modify_mutex);
 
 	shca->ibmebus_dev = dev;
 	shca->ipz_hca_handle.handle = *handle;
diff -urp a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
--- a/drivers/infiniband/hw/ehca/hcp_if.c	2007-02-04 19:44:54.000000000 +0100
+++ b/drivers/infiniband/hw/ehca/hcp_if.c	2007-04-23 18:06:09.000000000 +0200
@@ -70,6 +70,10 @@
 #define H_ALL_RES_QP_SQUEUE_SIZE_PAGES  EHCA_BMASK_IBM(0, 31)
 #define H_ALL_RES_QP_RQUEUE_SIZE_PAGES  EHCA_BMASK_IBM(32, 63)
 
+#define H_MP_INIT_TYPE                  EHCA_BMASK_IBM(44, 47)
+#define H_MP_SHUTDOWN                   EHCA_BMASK_IBM(48, 48)
+#define H_MP_RESET_QKEY_CTR             EHCA_BMASK_IBM(49, 49)
+
 /* direct access qp controls */
 #define DAQP_CTRL_ENABLE    0x01
 #define DAQP_CTRL_SEND_COMP 0x20
@@ -364,6 +368,26 @@ u64 hipz_h_query_port(const struct ipz_a
 	return ret;
 }
 
+u64 hipz_h_modify_port(const struct ipz_adapter_handle adapter_handle,
+		       const u8 port_id, const u32 port_cap,
+		       const u8 init_type, const int modify_mask)
+{
+	u64 port_attributes = port_cap;
+
+	if (modify_mask & IB_PORT_SHUTDOWN)
+		port_attributes |= EHCA_BMASK_SET(H_MP_SHUTDOWN, 1);
+	if (modify_mask & IB_PORT_INIT_TYPE)
+		port_attributes |= EHCA_BMASK_SET(H_MP_INIT_TYPE, init_type);
+	if (modify_mask & IB_PORT_RESET_QKEY_CNTR)
+		port_attributes |= EHCA_BMASK_SET(H_MP_RESET_QKEY_CTR, 1);
+
+	return ehca_plpar_hcall_norets(H_MODIFY_PORT,
+				       adapter_handle.handle, /* r4 */
+				       port_id,               /* r5 */
+				       port_attributes,       /* r6 */
+				       0, 0, 0, 0);
+}
+
 u64 hipz_h_query_hca(const struct ipz_adapter_handle adapter_handle,
 		     struct hipz_query_hca *query_hca_rblock)
 {
diff -urp a/drivers/infiniband/hw/ehca/hcp_if.h b/drivers/infiniband/hw/ehca/hcp_if.h
--- a/drivers/infiniband/hw/ehca/hcp_if.h	2007-02-04 19:44:54.000000000 +0100
+++ b/drivers/infiniband/hw/ehca/hcp_if.h	2007-04-23 18:06:09.000000000 +0200
@@ -85,6 +85,10 @@ u64 hipz_h_query_port(const struct ipz_a
 		      const u8 port_id,
 		      struct hipz_query_port *query_port_response_block);
 
+u64 hipz_h_modify_port(const struct ipz_adapter_handle adapter_handle,
+		       const u8 port_id, const u32 port_cap,
+		       const u8 init_type, const int modify_mask);
+
 u64 hipz_h_query_hca(const struct ipz_adapter_handle adapter_handle,
 		     struct hipz_query_hca *query_hca_rblock);
 



