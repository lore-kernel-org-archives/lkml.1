Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbXKJSwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbXKJSwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 13:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbXKJSwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 13:52:08 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:48317 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbXKJSwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 13:52:07 -0500
Message-ID: <4735FDD0.6000708@schaufler-ca.com>
Date: Sat, 10 Nov 2007 10:52:00 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: akpm@osdl.org, torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       paul.moore@hp.com
Subject: Repost - NetLabel: Introduce a new kernel configuration API for NetLabel
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Moore <paul.moore@hp.com>

Add a new set of configuration functions to the NetLabel/LSM API so that
LSMs can perform their own configuration of the NetLabel subsystem without
relying on assistance from userspace.

Signed-off-by: Paul Moore <paul.moore@hp.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---

Reposting to ensure propriety of sign-offs.


 include/net/netlabel.h             |   47 ++++++++--
 net/ipv4/cipso_ipv4.c              |    4 -
 net/netlabel/netlabel_cipso_v4.c   |    2 
 net/netlabel/netlabel_cipso_v4.h   |    3 +
 net/netlabel/netlabel_domainhash.h |    1 
 net/netlabel/netlabel_kapi.c       |  177 ++++++++++++++++++++++++++++++++++++
 6 files changed, 225 insertions(+), 9 deletions(-)

diff --git a/include/net/netlabel.h b/include/net/netlabel.h
index 2e5b2f6..facaf68 100644
--- a/include/net/netlabel.h
+++ b/include/net/netlabel.h
@@ -36,6 +36,8 @@
 #include <net/netlink.h>
 #include <asm/atomic.h>
 
+struct cipso_v4_doi;
+
 /*
  * NetLabel - A management interface for maintaining network packet label
  *            mapping tables for explicit packet labling protocols.
@@ -99,12 +101,6 @@ struct netlbl_audit {
 	uid_t loginuid;
 };
 
-/* Domain mapping definition struct */
-struct netlbl_dom_map;
-
-/* Domain mapping operations */
-int netlbl_domhsh_remove(const char *domain, struct netlbl_audit *audit_info);
-
 /* LSM security attributes */
 struct netlbl_lsm_cache {
 	atomic_t refcount;
@@ -285,6 +281,19 @@ static inline void netlbl_secattr_free(struct netlbl_lsm_secattr *secattr)
 
 #ifdef CONFIG_NETLABEL
 /*
+ * LSM configuration operations
+ */
+int netlbl_cfg_map_del(const char *domain, struct netlbl_audit *audit_info);
+int netlbl_cfg_unlbl_add_map(const char *domain,
+			     struct netlbl_audit *audit_info);
+int netlbl_cfg_cipsov4_add(struct cipso_v4_doi *doi_def,
+			   struct netlbl_audit *audit_info);
+int netlbl_cfg_cipsov4_add_map(struct cipso_v4_doi *doi_def,
+			       const char *domain,
+			       struct netlbl_audit *audit_info);
+int netlbl_cfg_cipsov4_del(u32 doi, struct netlbl_audit *audit_info);
+
+/*
  * LSM security attribute operations
  */
 int netlbl_secattr_catmap_walk(struct netlbl_lsm_secattr_catmap *catmap,
@@ -318,6 +327,32 @@ void netlbl_cache_invalidate(void);
 int netlbl_cache_add(const struct sk_buff *skb,
 		     const struct netlbl_lsm_secattr *secattr);
 #else
+static inline int netlbl_cfg_map_del(const char *domain,
+				     struct netlbl_audit *audit_info)
+{
+	return -ENOSYS;
+}
+static inline int netlbl_cfg_unlbl_add_map(const char *domain,
+					   struct netlbl_audit *audit_info)
+{
+	return -ENOSYS;
+}
+static inline int netlbl_cfg_cipsov4_add(struct cipso_v4_doi *doi_def,
+					 struct netlbl_audit *audit_info)
+{
+	return -ENOSYS;
+}
+static inline int netlbl_cfg_cipsov4_add_map(struct cipso_v4_doi *doi_def,
+					     const char *domain,
+					     struct netlbl_audit *audit_info)
+{
+	return -ENOSYS;
+}
+static inline int netlbl_cfg_cipsov4_del(u32 doi,
+					 struct netlbl_audit *audit_info)
+{
+	return -ENOSYS;
+}
 static inline int netlbl_secattr_catmap_walk(
 	                              struct netlbl_lsm_secattr_catmap *catmap,
 				      u32 offset)
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index f18e88b..5e97315 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -546,8 +546,8 @@ int cipso_v4_doi_remove(u32 doi,
 		rcu_read_lock();
 		list_for_each_entry_rcu(dom_iter, &doi_def->dom_list, list)
 			if (dom_iter->valid)
-				netlbl_domhsh_remove(dom_iter->domain,
-						     audit_info);
+				netlbl_cfg_map_del(dom_iter->domain,
+						   audit_info);
 		rcu_read_unlock();
 		cipso_v4_cache_invalidate();
 		call_rcu(&doi_def->rcu, callback);
diff --git a/net/netlabel/netlabel_cipso_v4.c b/net/netlabel/netlabel_cipso_v4.c
index ba0ca8d..54f9d1b 100644
--- a/net/netlabel/netlabel_cipso_v4.c
+++ b/net/netlabel/netlabel_cipso_v4.c
@@ -89,7 +89,7 @@ static const struct nla_policy netlbl_cipsov4_genl_policy[NLBL_CIPSOV4_A_MAX + 1
  * safely.
  *
  */
-static void netlbl_cipsov4_doi_free(struct rcu_head *entry)
+void netlbl_cipsov4_doi_free(struct rcu_head *entry)
 {
 	struct cipso_v4_doi *ptr;
 
diff --git a/net/netlabel/netlabel_cipso_v4.h b/net/netlabel/netlabel_cipso_v4.h
index f03cf9b..220cb9d 100644
--- a/net/netlabel/netlabel_cipso_v4.h
+++ b/net/netlabel/netlabel_cipso_v4.h
@@ -163,4 +163,7 @@ enum {
 /* NetLabel protocol functions */
 int netlbl_cipsov4_genl_init(void);
 
+/* Free the memory associated with a CIPSOv4 DOI definition */
+void netlbl_cipsov4_doi_free(struct rcu_head *entry);
+
 #endif
diff --git a/net/netlabel/netlabel_domainhash.h b/net/netlabel/netlabel_domainhash.h
index 3689956..8220990 100644
--- a/net/netlabel/netlabel_domainhash.h
+++ b/net/netlabel/netlabel_domainhash.h
@@ -61,6 +61,7 @@ int netlbl_domhsh_add(struct netlbl_dom_map *entry,
 		      struct netlbl_audit *audit_info);
 int netlbl_domhsh_add_default(struct netlbl_dom_map *entry,
 			      struct netlbl_audit *audit_info);
+int netlbl_domhsh_remove(const char *domain, struct netlbl_audit *audit_info);
 int netlbl_domhsh_remove_default(struct netlbl_audit *audit_info);
 struct netlbl_dom_map *netlbl_domhsh_getentry(const char *domain);
 int netlbl_domhsh_walk(u32 *skip_bkt,
diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 4f50949..2ba5ae8 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -30,6 +30,7 @@
 
 #include <linux/init.h>
 #include <linux/types.h>
+#include <linux/audit.h>
 #include <net/ip.h>
 #include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
@@ -37,10 +38,186 @@
 
 #include "netlabel_domainhash.h"
 #include "netlabel_unlabeled.h"
+#include "netlabel_cipso_v4.h"
 #include "netlabel_user.h"
 #include "netlabel_mgmt.h"
 
 /*
+ * Configuration Functions
+ */
+
+/**
+ * netlbl_cfg_map_del - Remove a NetLabel/LSM domain mapping
+ * @domain: the domain mapping to remove
+ * @audit_info: NetLabel audit information
+ *
+ * Description:
+ * Removes a NetLabel/LSM domain mapping.  A @domain value of NULL causes the
+ * default domain mapping to be removed.  Returns zero on success, negative
+ * values on failure.
+ *
+ */
+int netlbl_cfg_map_del(const char *domain, struct netlbl_audit *audit_info)
+{
+	return netlbl_domhsh_remove(domain, audit_info);
+}
+
+/**
+ * netlbl_cfg_unlbl_add_map - Add an unlabeled NetLabel/LSM domain mapping
+ * @domain: the domain mapping to add
+ * @audit_info: NetLabel audit information
+ *
+ * Description:
+ * Adds a new unlabeled NetLabel/LSM domain mapping.  A @domain value of NULL
+ * causes a new default domain mapping to be added.  Returns zero on success,
+ * negative values on failure.
+ *
+ */
+int netlbl_cfg_unlbl_add_map(const char *domain,
+			     struct netlbl_audit *audit_info)
+{
+	int ret_val = -ENOMEM;
+	struct netlbl_dom_map *entry;
+
+	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
+	if (entry == NULL)
+		goto cfg_unlbl_add_map_failure;
+	if (domain != NULL) {
+		entry->domain = kstrdup(domain, GFP_ATOMIC);
+		if (entry->domain == NULL)
+			goto cfg_unlbl_add_map_failure;
+	}
+	entry->type = NETLBL_NLTYPE_UNLABELED;
+
+	ret_val = netlbl_domhsh_add(entry, audit_info);
+	if (ret_val != 0)
+		goto cfg_unlbl_add_map_failure;
+
+	return 0;
+
+cfg_unlbl_add_map_failure:
+	if (entry != NULL)
+		kfree(entry->domain);
+	kfree(entry);
+	return ret_val;
+}
+
+/**
+ * netlbl_cfg_cipsov4_add - Add a new CIPSOv4 DOI definition
+ * @doi_def: the DOI definition
+ * @audit_info: NetLabel audit information
+ *
+ * Description:
+ * Add a new CIPSOv4 DOI definition to the NetLabel subsystem.  Returns zero on
+ * success, negative values on failure.
+ *
+ */
+int netlbl_cfg_cipsov4_add(struct cipso_v4_doi *doi_def,
+			   struct netlbl_audit *audit_info)
+{
+	int ret_val;
+	const char *type_str;
+	struct audit_buffer *audit_buf;
+
+	ret_val = cipso_v4_doi_add(doi_def);
+
+	audit_buf = netlbl_audit_start_common(AUDIT_MAC_CIPSOV4_ADD,
+					      audit_info);
+	if (audit_buf != NULL) {
+		switch (doi_def->type) {
+		case CIPSO_V4_MAP_STD:
+			type_str = "std";
+			break;
+		case CIPSO_V4_MAP_PASS:
+			type_str = "pass";
+			break;
+		default:
+			type_str = "(unknown)";
+		}
+		audit_log_format(audit_buf,
+				 " cipso_doi=%u cipso_type=%s res=%u",
+				 doi_def->doi,
+				 type_str,
+				 ret_val == 0 ? 1 : 0);
+		audit_log_end(audit_buf);
+	}
+
+	return ret_val;
+}
+
+/**
+ * netlbl_cfg_cipsov4_add_map - Add a new CIPSOv4 DOI definition and mapping
+ * @doi_def: the DOI definition
+ * @domain: the domain mapping to add
+ * @audit_info: NetLabel audit information
+ *
+ * Description:
+ * Add a new CIPSOv4 DOI definition and NetLabel/LSM domain mapping for this
+ * new DOI definition to the NetLabel subsystem.  A @domain value of NULL adds
+ * a new default domain mapping.  Returns zero on success, negative values on
+ * failure.
+ *
+ */
+int netlbl_cfg_cipsov4_add_map(struct cipso_v4_doi *doi_def,
+			       const char *domain,
+			       struct netlbl_audit *audit_info)
+{
+	int ret_val = -ENOMEM;
+	struct netlbl_dom_map *entry;
+
+	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
+	if (entry == NULL)
+		goto cfg_cipsov4_add_map_failure;
+	if (domain != NULL) {
+		entry->domain = kstrdup(domain, GFP_ATOMIC);
+		if (entry->domain == NULL)
+			goto cfg_cipsov4_add_map_failure;
+	}
+	entry->type = NETLBL_NLTYPE_CIPSOV4;
+	entry->type_def.cipsov4 = doi_def;
+
+	/* Grab a RCU read lock here so nothing happens to the doi_def variable
+	 * between adding it to the CIPSOv4 protocol engine and adding a
+	 * domain mapping for it. */
+
+	rcu_read_lock();
+	ret_val = netlbl_cfg_cipsov4_add(doi_def, audit_info);
+	if (ret_val != 0)
+		goto cfg_cipsov4_add_map_failure_unlock;
+	ret_val = netlbl_domhsh_add(entry, audit_info);
+	if (ret_val != 0)
+		goto cfg_cipsov4_add_map_failure_remove_doi;
+	rcu_read_unlock();
+
+	return 0;
+
+cfg_cipsov4_add_map_failure_remove_doi:
+	cipso_v4_doi_remove(doi_def->doi, audit_info, netlbl_cipsov4_doi_free);
+cfg_cipsov4_add_map_failure_unlock:
+	rcu_read_unlock();
+cfg_cipsov4_add_map_failure:
+	if (entry != NULL)
+		kfree(entry->domain);
+	kfree(entry);
+	return ret_val;
+}
+
+/**
+ * netlbl_cfg_cipsov4_del - Removean existing CIPSOv4 DOI definition
+ * @doi: the CIPSO DOI value
+ * @audit_info: NetLabel audit information
+ *
+ * Description:
+ * Removes an existing CIPSOv4 DOI definition from the NetLabel subsystem.
+ * Returns zero on success, negative values on failure.
+ *
+ */
+int netlbl_cfg_cipsov4_del(u32 doi, struct netlbl_audit *audit_info)
+{
+	return cipso_v4_doi_remove(doi, audit_info, netlbl_cipsov4_doi_free);
+}
+
+/*
  * Security Attribute Functions
  */
 

