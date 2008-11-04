Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbYKDQrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbYKDQrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757003AbYKDQqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:46:13 -0500
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:37569 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbYKDQqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:46:06 -0500
From: Boaz Harrosh <bharrosh@panasas.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, open-osd ml <osd-dev@open-osd.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Sami.Iren@seagate.com,
       Pete Wyckoff <pw@padd.com>
Subject: [PATCH 14/18] libosd: OSD version 2 Support
Date: Tue,  4 Nov 2008 18:44:52 +0200
Message-Id: <1225817092-6201-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <491073BB.4000900@panasas.com>
References: <491073BB.4000900@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for OSD2 at run time. It is now possible to run with
both OSDv1 and OSDv2 targets at the same time. The actual detection
should be preformed by the security manager, as the version is encoded
in the capability structure.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   94 ++++++++++++++++++++++++++++++++------
 include/scsi/osd_initiator.h     |   39 ++++++++++++++++
 include/scsi/osd_protocol.h      |   86 +++++++++++++++++++++++++++++++++--
 3 files changed, 201 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 567a2c6..9127fc4 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -57,36 +57,50 @@ static inline void build_test(void)
 {
 	/* structures were not packed */
 	BUILD_BUG_ON(sizeof(struct osd_capability) != OSD_CAP_LEN);
+	BUILD_BUG_ON(sizeof(struct osdv2_cdb) != OSD_TOTAL_CDB_LEN);
 	BUILD_BUG_ON(sizeof(struct osdv1_cdb) != OSDv1_TOTAL_CDB_LEN);
 }
 
 static unsigned _osd_req_cdb_len(struct osd_request *or)
 {
-	return OSDv1_TOTAL_CDB_LEN;
+	return osd_req_is_ver1(or) ? OSDv1_TOTAL_CDB_LEN : OSD_TOTAL_CDB_LEN;
 }
 
 static unsigned _osd_req_alist_elem_size(struct osd_request *or, unsigned len)
 {
-	return osdv1_attr_list_elem_size(len);
+	return osd_req_is_ver1(or) ?
+		osdv1_attr_list_elem_size(len) :
+		osdv2_attr_list_elem_size(len);
 }
 
 static unsigned _osd_req_alist_size(struct osd_request *or, void *list_head)
 {
-	return osdv1_list_size(list_head);
+	return osd_req_is_ver1(or) ?
+		osdv1_list_size(list_head) :
+		osdv2_list_size(list_head);
 }
 
 static unsigned _osd_req_sizeof_alist_header(struct osd_request *or)
 {
-	return sizeof(struct osdv1_attributes_list_header);
+	return osd_req_is_ver1(or) ?
+		sizeof(struct osdv1_attributes_list_header) :
+		sizeof(struct osdv2_attributes_list_header);
 }
 
 static void _osd_req_set_alist_type(struct osd_request *or,
 	void *list, int list_type)
 {
-	struct osdv1_attributes_list_header *attr_list = list;
+	if (osd_req_is_ver1(or)) {
+		struct osdv1_attributes_list_header *attr_list = list;
+
+		memset(attr_list, 0, sizeof(*attr_list));
+		attr_list->type = list_type;
+	} else {
+		struct osdv2_attributes_list_header *attr_list = list;
 
-	memset(attr_list, 0, sizeof(*attr_list));
-	attr_list->type = list_type;
+		memset(attr_list, 0, sizeof(*attr_list));
+		attr_list->type = list_type;
+	}
 }
 
 static bool _osd_req_is_alist_type(struct osd_request *or,
@@ -95,10 +109,14 @@ static bool _osd_req_is_alist_type(struct osd_request *or,
 	if (!list)
 		return false;
 
-	if (1) {
+	if (osd_req_is_ver1(or)) {
 		struct osdv1_attributes_list_header *attr_list = list;
 
 		return attr_list->type == list_type;
+	} else {
+		struct osdv2_attributes_list_header *attr_list = list;
+
+		return attr_list->type == list_type;
 	}
 }
 
@@ -108,15 +126,22 @@ static void _osd_req_encode_olist(struct osd_request *or,
 {
 	struct osd_cdb_head *cdbh = osd_cdb_head(&or->cdb);
 
-	cdbh->v1.list_identifier = list->list_identifier;
-	cdbh->v1.start_address = list->continuation_id;
+	if (osd_req_is_ver1(or)) {
+		cdbh->v1.list_identifier = list->list_identifier;
+		cdbh->v1.start_address = list->continuation_id;
+	} else {
+		cdbh->v2.list_identifier = list->list_identifier;
+		cdbh->v2.start_address = list->continuation_id;
+	}
 }
 
 static osd_cdb_offset osd_req_encode_offset(struct osd_request *or,
 	u64 offset, unsigned *padding)
 {
 	return __osd_encode_offset(offset, padding,
-				  OSDv1_OFFSET_MIN_SHIFT, OSD_OFFSET_MAX_SHIFT);
+			osd_req_is_ver1(or) ?
+				OSDv1_OFFSET_MIN_SHIFT : OSD_OFFSET_MIN_SHIFT,
+			OSD_OFFSET_MAX_SHIFT);
 }
 
 static struct osd_security_parameters *
@@ -124,7 +149,10 @@ _osd_req_sec_params(struct osd_request *or)
 {
 	struct osd_cdb *ocdb = &or->cdb;
 
-	return &ocdb->v1.sec_params;
+	if (osd_req_is_ver1(or))
+		return &ocdb->v1.sec_params;
+	else
+		return &ocdb->v2.sec_params;
 }
 
 void osd_dev_init(struct osd_dev *osdd, struct scsi_device *scsi_dev)
@@ -132,6 +160,9 @@ void osd_dev_init(struct osd_dev *osdd, struct scsi_device *scsi_dev)
 	memset(osdd, 0, sizeof(*osdd));
 	osdd->scsi_dev = scsi_dev;
 	osdd->def_timeout = BLK_DEFAULT_SG_TIMEOUT;
+#ifdef OSD_VER1_SUPPORT
+	osdd->version = OSD_VER2;
+#endif
 	/* TODO: Allocate pools for osd_request attributes ... */
 }
 EXPORT_SYMBOL(osd_dev_init);
@@ -332,10 +363,30 @@ static void _osdv1_req_encode_common(struct osd_request *or,
 	ocdb->h.v1.start_address = cpu_to_be64(offset);
 }
 
+static void _osdv2_req_encode_common(struct osd_request *or,
+	 __be16 act, const struct osd_obj_id *obj, u64 offset, u64 len)
+{
+	struct osdv2_cdb *ocdb = &or->cdb.v2;
+
+	OSD_DEBUG("OSDv2 execute opcode 0x%x\n", be16_to_cpu(act));
+
+	ocdb->h.varlen_cdb.opcode = VARIABLE_LENGTH_CMD;
+	ocdb->h.varlen_cdb.additional_cdb_length = OSD_ADDITIONAL_CDB_LENGTH;
+	ocdb->h.varlen_cdb.service_action = act;
+
+	ocdb->h.partition = cpu_to_be64(obj->partition);
+	ocdb->h.object = cpu_to_be64(obj->id);
+	ocdb->h.v2.length = cpu_to_be64(len);
+	ocdb->h.v2.start_address = cpu_to_be64(offset);
+}
+
 static void _osd_req_encode_common(struct osd_request *or,
 	__be16 act, const struct osd_obj_id *obj, u64 offset, u64 len)
 {
-	_osdv1_req_encode_common(or, act, obj, offset, len);
+	if (osd_req_is_ver1(or))
+		_osdv1_req_encode_common(or, act, obj, offset, len);
+	else
+		_osdv2_req_encode_common(or, act, obj, offset, len);
 }
 
 /*
@@ -544,6 +595,12 @@ void osd_req_flush_object(struct osd_request *or,
 	const struct osd_obj_id *obj, enum osd_options_flush_scope_values op,
 	/*V2*/ u64 offset, /*V2*/ u64 len)
 {
+	if (unlikely(osd_req_is_ver1(or) && (offset || len))) {
+		OSD_DEBUG("OSD Ver1 flush on specific range ignored\n");
+		offset = 0;
+		len = 0;
+	}
+
 	_osd_req_encode_common(or, OSD_ACT_FLUSH, obj, offset, len);
 	_osd_req_encode_flush(or, op);
 }
@@ -1166,6 +1223,10 @@ enum { OSD_SEC_CAP_V1_ALL_CAPS =
 	OSD_SEC_CAP_GLOBAL | OSD_SEC_CAP_DEV_MGMT
 };
 
+enum { OSD_SEC_CAP_V2_ALL_CAPS =
+	OSD_SEC_CAP_V1_ALL_CAPS | OSD_SEC_CAP_QUERY | OSD_SEC_CAP_M_OBJECT
+};
+
 void osd_sec_init_nosec_doall_caps(void *caps,
 	const struct osd_obj_id *obj, bool is_collection, const bool is_v1)
 {
@@ -1207,9 +1268,14 @@ void osd_sec_init_nosec_doall_caps(void *caps,
 }
 EXPORT_SYMBOL(osd_sec_init_nosec_doall_caps);
 
+/* FIXME: Extract version from caps pointer.
+ *        Also Pete's target only supports caps from OSDv1 for now
+ */
 void osd_set_caps(struct osd_cdb *cdb, const void *caps)
 {
-	memcpy(&cdb->v1.caps, caps, OSDv1_CAP_LEN);
+	bool is_ver1 = true;
+	/* NOTE: They start at same address */
+	memcpy(&cdb->v1.caps, caps, is_ver1 ? OSDv1_CAP_LEN : OSD_CAP_LEN);
 }
 
 bool osd_is_sec_alldata(struct osd_security_parameters *sec_parms)
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index 0004df1..738312f 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -21,6 +21,23 @@
 
 /* Note: "NI" in comments below means "Not Implemented yet" */
 
+/* Configure of code:
+ * #undef if you *don't* want OSD v1 support in runtime.
+ * If #defined the initiator will dynamically configure to encode OSD v1
+ * CDB's if the target is detected to be OSD v1 only.
+ * OSD v2 only commands, options, and attributes will be ignored if target
+ * is v1 only.
+ * If #defined will result in bigger/slower code (OK Slower maybe not)
+ * Q: Should this be CONFIG_SCSI_OSD_VER1_SUPPORT and set from Kconfig?
+ */
+#define OSD_VER1_SUPPORT y
+
+enum osd_std_version {
+	OSD_VER_NONE = 0,
+	OSD_VER1 = 1,
+	OSD_VER2 = 2,
+};
+
 /*
  * Object-based Storage Device.
  * This object represents an OSD device.
@@ -31,6 +48,10 @@
 struct osd_dev {
 	struct scsi_device *scsi_dev;
 	unsigned def_timeout;
+
+#ifdef OSD_VER1_SUPPORT
+	enum osd_std_version version;
+#endif
 };
 
 /* Retrieve/return osd_dev(s) for use by Kernel clients */
@@ -41,6 +62,14 @@ void osduld_put_device(struct osd_dev *od);
 void osd_dev_init(struct osd_dev *, struct scsi_device *scsi_dev);
 void osd_dev_fini(struct osd_dev *);
 
+/* we might want to use function vector in the future */
+static inline void osd_dev_set_ver(struct osd_dev *dev, enum osd_std_version v)
+{
+#ifdef OSD_VER1_SUPPORT
+	dev->version = v;
+#endif
+}
+
 struct osd_request;
 typedef void (osd_req_done_fn)(struct osd_request *, void *);
 
@@ -77,6 +106,16 @@ struct osd_request {
 	int async_error;
 };
 
+/* OSD Version control */
+static inline bool osd_req_is_ver1(struct osd_request *or)
+{
+#ifdef OSD_VER1_SUPPORT
+	return or->osd_dev->version == OSD_VER1;
+#else
+	return false;
+#endif
+}
+
 /**
  * How to use the osd library:
  *
diff --git a/include/scsi/osd_protocol.h b/include/scsi/osd_protocol.h
index 77a74a3..ef7505e 100644
--- a/include/scsi/osd_protocol.h
+++ b/include/scsi/osd_protocol.h
@@ -25,9 +25,12 @@ enum {
 	OSDv1_TOTAL_CDB_LEN = OSDv1_ADDITIONAL_CDB_LENGTH + 8,
 	OSDv1_CAP_LEN = 80,
 	/* Latest supported version */
-	OSD_ADDITIONAL_CDB_LENGTH = OSDv1_ADDITIONAL_CDB_LENGTH,
-	OSD_TOTAL_CDB_LEN = OSDv1_TOTAL_CDB_LEN,
-	OSD_CAP_LEN = OSDv1_CAP_LEN,
+/* 	OSD_ADDITIONAL_CDB_LENGTH = 216,*/
+	OSD_ADDITIONAL_CDB_LENGTH =
+		OSDv1_ADDITIONAL_CDB_LENGTH, /* FIXME: Pete rev-001 sup */
+	OSD_TOTAL_CDB_LEN = OSD_ADDITIONAL_CDB_LENGTH + 8,
+/* 	OSD_CAP_LEN = 104,*/
+	OSD_CAP_LEN = OSDv1_CAP_LEN,/* FIXME: Pete rev-001 sup */
 
 	OSD_SYSTEMID_LEN = 20,
 	OSD_CRYPTO_KEYID_SIZE = 20,
@@ -108,6 +111,7 @@ enum {
 	OSD_OFFSET_MAX_BITS = 28,
 
 	OSDv1_OFFSET_MIN_SHIFT = 8,
+	OSD_OFFSET_MIN_SHIFT = 3,
 	OSD_OFFSET_MAX_SHIFT = 16,
 };
 
@@ -129,6 +133,16 @@ static inline osd_cdb_offset osd_encode_offset_v1(u64 offset, unsigned *padding)
 				OSDv1_OFFSET_MIN_SHIFT, OSD_OFFSET_MAX_SHIFT);
 }
 
+/* Minimum 8 bytes alignment
+ * Same as v1 but since exponent can be signed than a less than
+ * 256 alignment can be reached with small offsets (<2GB)
+ */
+static inline osd_cdb_offset osd_encode_offset_v2(u64 offset, unsigned *padding)
+{
+	return __osd_encode_offset(offset, padding,
+				   OSD_OFFSET_MIN_SHIFT, OSD_OFFSET_MAX_SHIFT);
+}
+
 /* osd2r03: 5.2.1 Overview */
 struct osd_cdb_head {
 	struct scsi_varlen_cdb_hdr varlen_cdb;
@@ -144,6 +158,13 @@ struct osd_cdb_head {
 /*36*/			__be64		length;
 /*44*/			__be64		start_address;
 		} __packed v1;
+
+		struct __osdv2_cdb_addr_len {
+			/* called allocation_length in some commands */
+/*32*/			__be64	length;
+/*40*/			__be64	start_address;
+/*48*/			__be32 list_identifier;/* Rarely used */
+		} __packed v2;
 	};
 /*52*/	union { /* selected attributes mode Page/List/Single */
 		struct osd_attributes_page_mode {
@@ -182,6 +203,7 @@ struct osd_cdb_head {
 /*80*/
 
 /*160 v1*/
+/*184 v2*/
 struct osd_security_parameters {
 /*160*/u8	integrity_check_value[OSD_CRYPTO_KEYID_SIZE];
 /*180*/u8	request_nonce[OSD_CRYPTO_NONCE_SIZE];
@@ -189,6 +211,7 @@ struct osd_security_parameters {
 /*196*/osd_cdb_offset	data_out_integrity_check_offset;
 } __packed;
 /*200 v1*/
+/*224 v2*/
 
 struct osdv1_cdb {
 	struct osd_cdb_head h;
@@ -196,9 +219,16 @@ struct osdv1_cdb {
 	struct osd_security_parameters sec_params;
 } __packed;
 
+struct osdv2_cdb {
+	struct osd_cdb_head h;
+	u8 caps[OSD_CAP_LEN];
+	struct osd_security_parameters sec_params;
+} __packed;
+
 struct osd_cdb {
 	union {
 		struct osdv1_cdb v1;
+		struct osdv2_cdb v2;
 		u8 buff[OSD_TOTAL_CDB_LEN];
 	};
 } __packed;
@@ -269,6 +299,7 @@ struct osd_attributes_list_attrid {
 /*
  * osd2r03: 7.1.3.3 List entry format for retrieved attributes and
  *                  for setting attributes
+ * NOTE: v2 is 8-bytes aligned, v1 is not aligned.
  */
 struct osd_attributes_list_element {
 	__be32 page;
@@ -279,6 +310,7 @@ struct osd_attributes_list_element {
 
 enum {
 	OSDv1_ATTRIBUTES_ELEM_ALIGN = 1,
+	OSD_ATTRIBUTES_ELEM_ALIGN = 8,
 };
 
 enum {
@@ -292,6 +324,12 @@ static inline unsigned osdv1_attr_list_elem_size(unsigned len)
 		     OSDv1_ATTRIBUTES_ELEM_ALIGN);
 }
 
+static inline unsigned osdv2_attr_list_elem_size(unsigned len)
+{
+	return ALIGN(len + sizeof(struct osd_attributes_list_element),
+		     OSD_ATTRIBUTES_ELEM_ALIGN);
+}
+
 /*
  * osd2r03: 7.1.3 OSD attributes lists (Table 184) — List type values
  */
@@ -326,6 +364,21 @@ static inline unsigned osdv1_list_size(struct osdv1_attributes_list_header *h)
 	return be16_to_cpu(h->list_bytes);
 }
 
+struct osdv2_attributes_list_header {
+	u8 type;	/* lower 4-bits only */
+	u8 pad[3];
+/*4*/	__be32 list_bytes; /* Initiator shall set to zero. Only set by target */
+	/*
+	 * type=9 followed by struct osd_attributes_list_element's
+	 * type=E followed by struct osd_attributes_list_multi_header's
+	 */
+} __packed;
+
+static inline unsigned osdv2_list_size(struct osdv2_attributes_list_header *h)
+{
+	return be32_to_cpu(h->list_bytes);
+}
+
 /* (osd-r10 6.13)
  * osd2r03: 6.15 LIST (Table 79) LIST command parameter data.
  *	for root_lstchg below
@@ -469,11 +522,36 @@ struct osdv1_cap_object_descriptor {
 } __packed;
 /*80 v1*/
 
-struct osd_capability {
+/*56 v2*/
+struct osd_cap_object_descriptor {
+	union {
+		struct {
+			__be32 allowed_attributes_access;
+/*60*/			__be32 policy_access_tag;
+/*64*/			__be16 boot_epoch;
+/*66*/			u8 reserved[72-66];
+/*72*/			__be64 allowed_partition_id;
+/*80*/			__be64 allowed_object_id;
+/*88*/			__be64 allowed_range_length;
+/*96*/			__be64 allowed_range_start;
+		} __packed obj_desc;
+
+		u8 object_descriptor[104-56]; /*48*/
+	};
+} __packed;
+/*104 v2*/
+
+struct osdv1_capability {
 	struct osd_capability_head h;
 	struct osdv1_cap_object_descriptor od;
 } __packed;
 
+struct osd_capability {
+	struct osd_capability_head h;
+/* 	struct osd_cap_object_descriptor od;*/
+	struct osdv1_cap_object_descriptor od; /* FIXME: Pete rev-001 sup */
+} __packed;
+
 /**
  * osd_sec_set_caps - set cap-bits into the capabilities header
  *
-- 
1.6.0.1

