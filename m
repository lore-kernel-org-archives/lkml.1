Return-Path: <linux-kernel-owner+w=401wt.eu-S933490AbYETSMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490AbYETSMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932809AbYETSHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:07:07 -0400
Received: from rn-out-0910.google.com ([64.233.170.188]:36158 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962AbYETSHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:07:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=u3kc9WE5HHo8l7ISkauHoB4uJIomAWyv+EYvYKwHCygJmvjwxNuWGrCK9na8HDeahJlJwCjiQFX0BnP1HlYOahkh2W2mdIwGjBZ3Sy8SxJmU8GwYdUQy43CZaclqfnyng3u0T8mA6N26uACgcpAA7cb7CAKb6q/hPfyBqk8N5j4=
Subject: [PATCH 04/21] drivers/infiniband: use aligned-endian get/put
	helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 11:06:19 -0700
Message-Id: <1211306779.5915.183.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/infiniband/core/packer.c             |   16 ++++++++--------
 drivers/infiniband/core/sysfs.c              |    4 ++--
 drivers/infiniband/core/user_mad.c           |    2 +-
 drivers/infiniband/hw/ipath/ipath_driver.c   |    3 +--
 drivers/infiniband/hw/mlx4/main.c            |   19 +++++++++----------
 drivers/infiniband/hw/mthca/mthca_cmd.c      |    8 ++++----
 drivers/infiniband/hw/mthca/mthca_dev.h      |   12 ++++++------
 drivers/infiniband/hw/mthca/mthca_eq.c       |    2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c |   19 +++++++++----------
 drivers/infiniband/ulp/ipoib/ipoib.h         |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c    |    6 +++---
 drivers/infiniband/ulp/srp/ib_srp.c          |   16 ++++++++--------
 12 files changed, 53 insertions(+), 56 deletions(-)

diff --git a/drivers/infiniband/core/packer.c b/drivers/infiniband/core/packer.c
index c972d72..f00f281 100644
--- a/drivers/infiniband/core/packer.c
+++ b/drivers/infiniband/core/packer.c
@@ -41,9 +41,9 @@ static u64 value_read(int offset, int size, void *structure)
 {
 	switch (size) {
 	case 1: return                *(u8  *) (structure + offset);
-	case 2: return be16_to_cpup((__be16 *) (structure + offset));
-	case 4: return be32_to_cpup((__be32 *) (structure + offset));
-	case 8: return be64_to_cpup((__be64 *) (structure + offset));
+	case 2: return get_be16(structure + offset);
+	case 4: return get_be32(structure + offset);
+	case 8: return get_be64(structure + offset);
 	default:
 		printk(KERN_WARNING "Field size %d bits not handled\n", size * 8);
 		return 0;
@@ -129,9 +129,9 @@ static void value_write(int offset, int size, u64 val, void *structure)
 {
 	switch (size * 8) {
 	case 8:  *(    u8 *) (structure + offset) = val; break;
-	case 16: *(__be16 *) (structure + offset) = cpu_to_be16(val); break;
-	case 32: *(__be32 *) (structure + offset) = cpu_to_be32(val); break;
-	case 64: *(__be64 *) (structure + offset) = cpu_to_be64(val); break;
+	case 16: put_be16(val, structure + offset); break;
+	case 32: put_be32(val, structure + offset); break;
+	case 64: put_be64(val, structure + offset); break;
 	default:
 		printk(KERN_WARNING "Field size %d bits not handled\n", size * 8);
 	}
@@ -167,7 +167,7 @@ void ib_unpack(const struct ib_field        *desc,
 			shift = 32 - desc[i].offset_bits - desc[i].size_bits;
 			mask = ((1ull << desc[i].size_bits) - 1) << shift;
 			addr = (__be32 *) buf + desc[i].offset_words;
-			val = (be32_to_cpup(addr) & mask) >> shift;
+			val = (get_be32(addr) & mask) >> shift;
 			value_write(desc[i].struct_offset_bytes,
 				    desc[i].struct_size_bytes,
 				    val,
@@ -181,7 +181,7 @@ void ib_unpack(const struct ib_field        *desc,
 			shift = 64 - desc[i].offset_bits - desc[i].size_bits;
 			mask = (~0ull >> (64 - desc[i].size_bits)) << shift;
 			addr = (__be64 *) buf + desc[i].offset_words;
-			val = (be64_to_cpup(addr) & mask) >> shift;
+			val = (get_be64(addr) & mask) >> shift;
 			value_write(desc[i].struct_offset_bytes,
 				    desc[i].struct_size_bytes,
 				    val,
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 9575655..042196a 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -343,11 +343,11 @@ static ssize_t show_pma_counter(struct ib_port *p, struct port_attribute *attr,
 		break;
 	case 16:
 		ret = sprintf(buf, "%u\n",
-			      be16_to_cpup((__be16 *)(out_mad->data + 40 + offset / 8)));
+			      get_be16(out_mad->data + 40 + offset / 8));
 		break;
 	case 32:
 		ret = sprintf(buf, "%u\n",
-			      be32_to_cpup((__be32 *)(out_mad->data + 40 + offset / 8)));
+			      get_be32(out_mad->data + 40 + offset / 8));
 		break;
 	default:
 		ret = 0;
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 3aa2db5..b244225 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -558,7 +558,7 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 	if (!ib_response_mad(packet->msg->mad)) {
 		tid = &((struct ib_mad_hdr *) packet->msg->mad)->tid;
 		*tid = cpu_to_be64(((u64) agent->hi_tid) << 32 |
-				   (be64_to_cpup(tid) & 0xffffffff));
+				   (get_be64(tid) & 0xffffffff));
 		rmpp_mad->mad_hdr.tid = *tid;
 	}
 
diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index daad09a..7761cf7 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -1259,8 +1259,7 @@ reloop:
 			 */
 			ipath_cdbg(ERRPKT, "Error Pkt, but no eflags! egrbuf"
 				  " %x, len %x hdrq+%x rhf: %Lx\n",
-				  etail, tlen, l,
-				  le64_to_cpu(*(__le64 *) rhf_addr));
+				  etail, tlen, l, get_le64(rhf_addr));
 			if (ipath_debug & __IPATH_ERRPKTDBG) {
 				u32 j, *d, dw = rsize-2;
 				if (rsize > (tlen>>2))
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 4d61e32..10a6c59 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -104,10 +104,9 @@ static int mlx4_ib_query_device(struct ib_device *ibdev,
 	if (dev->dev->caps.max_gso_sz)
 		props->device_cap_flags |= IB_DEVICE_UD_TSO;
 
-	props->vendor_id	   = be32_to_cpup((__be32 *) (out_mad->data + 36)) &
-		0xffffff;
-	props->vendor_part_id	   = be16_to_cpup((__be16 *) (out_mad->data + 30));
-	props->hw_ver		   = be32_to_cpup((__be32 *) (out_mad->data + 32));
+	props->vendor_id	   = get_be32(out_mad->data + 36) & 0xffffff;
+	props->vendor_part_id	   = get_be16(out_mad->data + 30);
+	props->hw_ver		   = get_be32(out_mad->data + 32);
 	memcpy(&props->sys_image_guid, out_mad->data +	4, 8);
 
 	props->max_mr_size	   = ~0ull;
@@ -165,18 +164,18 @@ static int mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
 	if (err)
 		goto out;
 
-	props->lid		= be16_to_cpup((__be16 *) (out_mad->data + 16));
+	props->lid		= get_be16(out_mad->data + 16);
 	props->lmc		= out_mad->data[34] & 0x7;
-	props->sm_lid		= be16_to_cpup((__be16 *) (out_mad->data + 18));
+	props->sm_lid		= get_be16(out_mad->data + 18);
 	props->sm_sl		= out_mad->data[36] & 0xf;
 	props->state		= out_mad->data[32] & 0xf;
 	props->phys_state	= out_mad->data[33] >> 4;
-	props->port_cap_flags	= be32_to_cpup((__be32 *) (out_mad->data + 20));
+	props->port_cap_flags	= get_be32(out_mad->data + 20);
 	props->gid_tbl_len	= to_mdev(ibdev)->dev->caps.gid_table_len[port];
 	props->max_msg_sz	= to_mdev(ibdev)->dev->caps.max_msg_sz;
 	props->pkey_tbl_len	= to_mdev(ibdev)->dev->caps.pkey_table_len[port];
-	props->bad_pkey_cntr	= be16_to_cpup((__be16 *) (out_mad->data + 46));
-	props->qkey_viol_cntr	= be16_to_cpup((__be16 *) (out_mad->data + 48));
+	props->bad_pkey_cntr	= get_be16(out_mad->data + 46);
+	props->qkey_viol_cntr	= get_be16(out_mad->data + 48);
 	props->active_width	= out_mad->data[31] & 0xf;
 	props->active_speed	= out_mad->data[35] >> 4;
 	props->max_mtu		= out_mad->data[41] & 0xf;
@@ -472,7 +471,7 @@ static int init_node_data(struct mlx4_ib_dev *dev)
 	if (err)
 		goto out;
 
-	dev->dev->rev_id = be32_to_cpup((__be32 *) (out_mad->data + 32));
+	dev->dev->rev_id = get_be32(out_mad->data + 32);
 	memcpy(&dev->ib_dev.node_guid, out_mad->data + 12, 8);
 
 out:
diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
index 54d230e..7bd7b38 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -1215,8 +1215,8 @@ static void get_board_id(void *vsd, char *board_id)
 
 	memset(board_id, 0, MTHCA_BOARD_ID_LEN);
 
-	if (be16_to_cpup(vsd + VSD_OFFSET_SIG1) == VSD_SIGNATURE_TOPSPIN &&
-	    be16_to_cpup(vsd + VSD_OFFSET_SIG2) == VSD_SIGNATURE_TOPSPIN) {
+	if (get_be16(vsd + VSD_OFFSET_SIG1) == VSD_SIGNATURE_TOPSPIN &&
+	    get_be16(vsd + VSD_OFFSET_SIG2) == VSD_SIGNATURE_TOPSPIN) {
 		strlcpy(board_id, vsd + VSD_OFFSET_TS_BOARD_ID, MTHCA_BOARD_ID_LEN);
 	} else {
 		/*
@@ -1759,7 +1759,7 @@ int mthca_MODIFY_QP(struct mthca_dev *dev, enum ib_qp_state cur,
 		if (0 && mailbox) {
 			int i;
 			mthca_dbg(dev, "Dumping QP context:\n");
-			printk(" %08x\n", be32_to_cpup(mailbox->buf));
+			printk(" %08x\n", get_be32(mailbox->buf));
 			for (i = 0; i < 0x100 / 4; ++i) {
 				if (i % 8 == 0)
 					printk("[%02x] ", i * 4);
@@ -1776,7 +1776,7 @@ int mthca_MODIFY_QP(struct mthca_dev *dev, enum ib_qp_state cur,
 		if (0) {
 			int i;
 			mthca_dbg(dev, "Dumping QP context:\n");
-			printk("  opt param mask: %08x\n", be32_to_cpup(mailbox->buf));
+			printk("  opt param mask: %08x\n", get_be32(mailbox->buf));
 			for (i = 0; i < 0x100 / 4; ++i) {
 				if (i % 8 == 0)
 					printk("  [%02x] ", i * 4);
diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index 7bc32f8..0051bf9 100644
--- a/drivers/infiniband/hw/mthca/mthca_dev.h
+++ b/drivers/infiniband/hw/mthca/mthca_dev.h
@@ -390,9 +390,9 @@ extern void __buggy_use_of_MTHCA_PUT(void);
 		void *__p = (char *) (source) + (offset);             \
 		switch (sizeof (dest)) {                              \
 		case 1: (dest) = *(u8 *) __p;       break;	      \
-		case 2: (dest) = be16_to_cpup(__p); break;	      \
-		case 4: (dest) = be32_to_cpup(__p); break;	      \
-		case 8: (dest) = be64_to_cpup(__p); break;	      \
+		case 2: (dest) = get_be16(__p);     break;	      \
+		case 4: (dest) = get_be32(__p);     break;	      \
+		case 8: (dest) = get_be64(__p);     break;	      \
 		default: __buggy_use_of_MTHCA_GET();		      \
 		}                                                     \
 	} while (0)
@@ -402,9 +402,9 @@ extern void __buggy_use_of_MTHCA_PUT(void);
 		void *__d = ((char *) (dest) + (offset));	      \
 		switch (sizeof(source)) {                             \
 		case 1: *(u8 *) __d = (source);                break; \
-		case 2:	*(__be16 *) __d = cpu_to_be16(source); break; \
-		case 4:	*(__be32 *) __d = cpu_to_be32(source); break; \
-		case 8:	*(__be64 *) __d = cpu_to_be64(source); break; \
+		case 2:	put_be16(source, __d);                 break; \
+		case 4:	put_be32(source, __d);                 break; \
+		case 8:	put_be64(source, __d);                 break; \
 		default: __buggy_use_of_MTHCA_PUT();		      \
 		}                                                     \
 	} while (0)
diff --git a/drivers/infiniband/hw/mthca/mthca_eq.c b/drivers/infiniband/hw/mthca/mthca_eq.c
index 8bde7f9..0cce9a3 100644
--- a/drivers/infiniband/hw/mthca/mthca_eq.c
+++ b/drivers/infiniband/hw/mthca/mthca_eq.c
@@ -620,7 +620,7 @@ static void mthca_free_eq(struct mthca_dev *dev,
 		for (i = 0; i < sizeof (struct mthca_eq_context) / 4; ++i) {
 			if (i % 4 == 0)
 				printk("[%02x] ", i * 4);
-			printk(" %08x", be32_to_cpup(mailbox->buf + i * 4));
+			printk(" %08x", get_be32(mailbox->buf + i * 4));
 			if ((i + 1) % 4 == 0)
 				printk("\n");
 		}
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index be34f99..4a797ca 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -89,10 +89,9 @@ static int mthca_query_device(struct ib_device *ibdev,
 	}
 
 	props->device_cap_flags    = mdev->device_cap_flags;
-	props->vendor_id           = be32_to_cpup((__be32 *) (out_mad->data + 36)) &
-		0xffffff;
-	props->vendor_part_id      = be16_to_cpup((__be16 *) (out_mad->data + 30));
-	props->hw_ver              = be32_to_cpup((__be32 *) (out_mad->data + 32));
+	props->vendor_id           = get_be32(out_mad->data + 36) & 0xffffff;
+	props->vendor_part_id      = get_be16(out_mad->data + 30);
+	props->hw_ver              = get_be32(out_mad->data + 32);
 	memcpy(&props->sys_image_guid, out_mad->data +  4, 8);
 
 	props->max_mr_size         = ~0ull;
@@ -165,18 +164,18 @@ static int mthca_query_port(struct ib_device *ibdev,
 		goto out;
 	}
 
-	props->lid               = be16_to_cpup((__be16 *) (out_mad->data + 16));
+	props->lid               = get_be16(out_mad->data + 16);
 	props->lmc               = out_mad->data[34] & 0x7;
-	props->sm_lid            = be16_to_cpup((__be16 *) (out_mad->data + 18));
+	props->sm_lid            = get_be16(out_mad->data + 18);
 	props->sm_sl             = out_mad->data[36] & 0xf;
 	props->state             = out_mad->data[32] & 0xf;
 	props->phys_state        = out_mad->data[33] >> 4;
-	props->port_cap_flags    = be32_to_cpup((__be32 *) (out_mad->data + 20));
+	props->port_cap_flags    = get_be32(out_mad->data + 20);
 	props->gid_tbl_len       = to_mdev(ibdev)->limits.gid_table_len;
 	props->max_msg_sz        = 0x80000000;
 	props->pkey_tbl_len      = to_mdev(ibdev)->limits.pkey_table_len;
-	props->bad_pkey_cntr     = be16_to_cpup((__be16 *) (out_mad->data + 46));
-	props->qkey_viol_cntr    = be16_to_cpup((__be16 *) (out_mad->data + 48));
+	props->bad_pkey_cntr     = get_be16(out_mad->data + 46);
+	props->qkey_viol_cntr    = get_be16(out_mad->data + 48);
 	props->active_width      = out_mad->data[31] & 0xf;
 	props->active_speed      = out_mad->data[35] >> 4;
 	props->max_mtu           = out_mad->data[41] & 0xf;
@@ -1286,7 +1285,7 @@ static int mthca_init_node_data(struct mthca_dev *dev)
 	}
 
 	if (mthca_is_memfree(dev))
-		dev->rev_id = be32_to_cpup((__be32 *) (out_mad->data + 32));
+		dev->rev_id = get_be32(out_mad->data + 32);
 	memcpy(&dev->ib_dev.node_guid, out_mad->data + 12, 8);
 
 out:
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index ca126fc..5125e81 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -732,6 +732,6 @@ extern int ipoib_debug_level;
 
 #define IPOIB_GID_ARG(gid)	IPOIB_GID_RAW_ARG((gid).raw)
 
-#define IPOIB_QPN(ha) (be32_to_cpup((__be32 *) ha) & 0xffffff)
+#define IPOIB_QPN(ha) (get_be32(ha) & 0xffffff)
 
 #endif /* _IPOIB_H */
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 2442090..aad6a6e 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -733,12 +733,12 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		} else {
 			/* unicast GID -- should be ARP or RARP reply */
 
-			if ((be16_to_cpup((__be16 *) skb->data) != ETH_P_ARP) &&
-			    (be16_to_cpup((__be16 *) skb->data) != ETH_P_RARP)) {
+			if ((get_be16(skb->data) != ETH_P_ARP) &&
+			    (get_be16(skb->data) != ETH_P_RARP)) {
 				ipoib_warn(priv, "Unicast, no %s: type %04x, QPN %06x "
 					   IPOIB_GID_FMT "\n",
 					   skb->dst ? "neigh" : "dst",
-					   be16_to_cpup((__be16 *) skb->data),
+					   get_be16(skb->data),
 					   IPOIB_QPN(phdr->hwaddr),
 					   IPOIB_GID_RAW_ARG(phdr->hwaddr + 4));
 				dev_kfree_skb_any(skb);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 4351457..0020ddc 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1893,14 +1893,14 @@ static ssize_t srp_create_target(struct device *dev,
 	       (unsigned long long) be64_to_cpu(target->ioc_guid),
 	       be16_to_cpu(target->path.pkey),
 	       (unsigned long long) be64_to_cpu(target->service_id),
-	       (int) be16_to_cpu(*(__be16 *) &target->path.dgid.raw[0]),
-	       (int) be16_to_cpu(*(__be16 *) &target->path.dgid.raw[2]),
-	       (int) be16_to_cpu(*(__be16 *) &target->path.dgid.raw[4]),
-	       (int) be16_to_cpu(*(__be16 *) &target->path.dgid.raw[6]),
-	       (int) be16_to_cpu(*(__be16 *) &target->path.dgid.raw[8]),
-	       (int) be16_to_cpu(*(__be16 *) &target->path.dgid.raw[10]),
-	       (int) be16_to_cpu(*(__be16 *) &target->path.dgid.raw[12]),
-	       (int) be16_to_cpu(*(__be16 *) &target->path.dgid.raw[14]));
+	       (int)get_be16(&target->path.dgid.raw[0]),
+	       (int)get_be16(&target->path.dgid.raw[2]),
+	       (int)get_be16(&target->path.dgid.raw[4]),
+	       (int)get_be16(&target->path.dgid.raw[6]),
+	       (int)get_be16(&target->path.dgid.raw[8]),
+	       (int)get_be16(&target->path.dgid.raw[10]),
+	       (int)get_be16(&target->path.dgid.raw[12]),
+	       (int)get_be16(&target->path.dgid.raw[14]));
 
 	ret = srp_create_target_ib(target);
 	if (ret)
-- 
1.5.5.1.570.g26b5e


