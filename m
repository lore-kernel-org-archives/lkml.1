Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbYJWE6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbYJWE6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 00:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYJWE6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 00:58:25 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:60939 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbYJWE6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 00:58:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=UvdWuqOgmYwCujw8J301w+nkGaaHNWUC4PFx6D4v3oZjUf4QEPTbFd0FDmo78SEGvz
         Q6WMUbkAYgpSIq7uBOzgklAbfVzzfIrJJQfZLOJr1ktVpjj56CbTnf4rzugu8P54R9ap
         d64rSPuV9BmXUC0XgpumIM5HwY5/TmKGI2aPU=
Subject: [PATCH 1/3] netxen: endian annotation of netxen_nic_write_w1,
 netxen_nic_read_w1
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Dhananjay Phadke <dhananjay@netxen.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 21:58:17 -0700
Message-Id: <1224737897.6823.26.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value parameter was always a le32, mark it as such.  Also a small
fix for the msi vector which is a le16, not a le32.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Patches 1 and 2 are fairly non-controversial, patch 3 is not comprehensive
as it only covers the places sparse warns about, a comprehensive audit
of the struct endianness would be helpful.

Also, once this was all done, it pointed out a possible problem in
netxen_nic_ctx.c:nx_fw_cmd_create_rx_ctx, line 291:

recv_ctx->virt_port = le16_to_cpu(prsp->virt_port);

You should check the definition of prsp->virt_port, as currently it is a u8,
other than the le32/le16 mixup noted in this changelog, this was the only endian
mismatch/oddity I found.

 drivers/net/netxen/netxen_nic.h     |    4 ++--
 drivers/net/netxen/netxen_nic_ctx.c |   10 ++++++----
 drivers/net/netxen/netxen_nic_hw.c  |    4 ++--
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/netxen/netxen_nic.h b/drivers/net/netxen/netxen_nic.h
index f8e601c..18c699d 100644
--- a/drivers/net/netxen/netxen_nic.h
+++ b/drivers/net/netxen/netxen_nic.h
@@ -1411,8 +1411,8 @@ void netxen_nic_reg_write(struct netxen_adapter *adapter, u64 off, u32 val);
 int netxen_nic_reg_read(struct netxen_adapter *adapter, u64 off);
 void netxen_nic_write_w0(struct netxen_adapter *adapter, u32 index, u32 value);
 void netxen_nic_read_w0(struct netxen_adapter *adapter, u32 index, u32 *value);
-void netxen_nic_write_w1(struct netxen_adapter *adapter, u32 index, u32 value);
-void netxen_nic_read_w1(struct netxen_adapter *adapter, u32 index, u32 *value);
+void netxen_nic_write_w1(struct netxen_adapter *adapter, u32 index, __le32 value);
+void netxen_nic_read_w1(struct netxen_adapter *adapter, u32 index, __le32 *value);
 
 int netxen_nic_get_board_info(struct netxen_adapter *adapter);
 
diff --git a/drivers/net/netxen/netxen_nic_ctx.c b/drivers/net/netxen/netxen_nic_ctx.c
index 64b5164..dd1b653 100644
--- a/drivers/net/netxen/netxen_nic_ctx.c
+++ b/drivers/net/netxen/netxen_nic_ctx.c
@@ -76,7 +76,8 @@ netxen_api_unlock(struct netxen_adapter *adapter)
 static u32
 netxen_poll_rsp(struct netxen_adapter *adapter)
 {
-	u32 raw_rsp, rsp = NX_CDRP_RSP_OK;
+	__le32 raw_rsp;
+	u32 rsp = NX_CDRP_RSP_OK;
 	int	timeout = 0;
 
 	do {
@@ -132,8 +133,9 @@ netxen_issue_cmd(struct netxen_adapter *adapter,
 
 		rcode = NX_RCODE_TIMEOUT;
 	} else if (rsp == NX_CDRP_RSP_FAIL) {
-		netxen_nic_read_w1(adapter, NX_ARG1_CRB_OFFSET, &rcode);
-		rcode = le32_to_cpu(rcode);
+		__le32 raw_rcode;
+		netxen_nic_read_w1(adapter, NX_ARG1_CRB_OFFSET, &raw_rcode);
+		rcode = le32_to_cpu(raw_rcode);
 
 		printk(KERN_ERR "%s: failed card response code:0x%x\n",
 				netxen_nic_driver_name, rcode);
@@ -247,7 +249,7 @@ nx_fw_cmd_create_rx_ctx(struct netxen_adapter *adapter)
 		cpu_to_le64(recv_ctx->rcv_status_desc_phys_addr);
 	prq_sds[0].ring_size = cpu_to_le32(adapter->max_rx_desc_count);
 	/* only one msix vector for now */
-	prq_sds[0].msi_index = cpu_to_le32(0);
+	prq_sds[0].msi_index = cpu_to_le16(0);
 
 	/* now byteswap offsets */
 	prq->rds_ring_offset = cpu_to_le32(prq->rds_ring_offset);
diff --git a/drivers/net/netxen/netxen_nic_hw.c b/drivers/net/netxen/netxen_nic_hw.c
index 84978f8..fcba06d 100644
--- a/drivers/net/netxen/netxen_nic_hw.c
+++ b/drivers/net/netxen/netxen_nic_hw.c
@@ -1191,12 +1191,12 @@ void netxen_nic_read_w0(struct netxen_adapter *adapter, u32 index, u32 *value)
 	adapter->hw_read_wx(adapter, index, value, 4);
 }
 
-void netxen_nic_write_w1(struct netxen_adapter *adapter, u32 index, u32 value)
+void netxen_nic_write_w1(struct netxen_adapter *adapter, u32 index, __le32 value)
 {
 	adapter->hw_write_wx(adapter, index, &value, 4);
 }
 
-void netxen_nic_read_w1(struct netxen_adapter *adapter, u32 index, u32 *value)
+void netxen_nic_read_w1(struct netxen_adapter *adapter, u32 index, __le32 *value)
 {
 	adapter->hw_read_wx(adapter, index, value, 4);
 }
-- 
1.6.0.3.723.g757e


