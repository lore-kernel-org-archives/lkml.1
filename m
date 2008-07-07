Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbYGGQ4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbYGGQ4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbYGGQuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:50:39 -0400
Received: from aa2005110791d2e6c28a.userreverse.dion.ne.jp ([210.230.194.138]:20574
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753731AbYGGQug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:50:36 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 12:49:54 EDT
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/20] SELinux: open code policy_rwlock
Date: Tue,  8 Jul 2008 01:42:12 +0900
Message-Id: <1215448942-17581-11-git-send-email-jmorris@namei.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1215448942-17581-1-git-send-email-jmorris@namei.org>
References: <1215448942-17581-1-git-send-email-jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Open code policy_rwlock, as suggested by Andrew Morton.

Signed-off-by: James Morris <jmorris@namei.org>
Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>
---
 security/selinux/ss/services.c |  108 +++++++++++++++++++---------------------
 1 files changed, 52 insertions(+), 56 deletions(-)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 0696aad..e8ec54d 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -71,10 +71,6 @@ int selinux_policycap_openperm;
 extern const struct selinux_class_perm selinux_class_perm;
 
 static DEFINE_RWLOCK(policy_rwlock);
-#define POLICY_RDLOCK read_lock(&policy_rwlock)
-#define POLICY_WRLOCK write_lock_irq(&policy_rwlock)
-#define POLICY_RDUNLOCK read_unlock(&policy_rwlock)
-#define POLICY_WRUNLOCK write_unlock_irq(&policy_rwlock)
 
 static DEFINE_MUTEX(load_mutex);
 #define LOAD_LOCK mutex_lock(&load_mutex)
@@ -429,7 +425,7 @@ int security_permissive_sid(u32 sid)
 	u32 type;
 	int rc;
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 
 	context = sidtab_search(&sidtab, sid);
 	BUG_ON(!context);
@@ -441,7 +437,7 @@ int security_permissive_sid(u32 sid)
 	 */
 	rc = ebitmap_get_bit(&policydb.permissive_map, type);
 
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	return rc;
 }
 
@@ -486,7 +482,7 @@ int security_validate_transition(u32 oldsid, u32 newsid, u32 tasksid,
 	if (!ss_initialized)
 		return 0;
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 
 	/*
 	 * Remap extended Netlink classes for old policy versions.
@@ -543,7 +539,7 @@ int security_validate_transition(u32 oldsid, u32 newsid, u32 tasksid,
 	}
 
 out:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	return rc;
 }
 
@@ -578,7 +574,7 @@ int security_compute_av(u32 ssid,
 		return 0;
 	}
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 
 	scontext = sidtab_search(&sidtab, ssid);
 	if (!scontext) {
@@ -598,7 +594,7 @@ int security_compute_av(u32 ssid,
 	rc = context_struct_compute_av(scontext, tcontext, tclass,
 				       requested, avd);
 out:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	return rc;
 }
 
@@ -691,7 +687,7 @@ static int security_sid_to_context_core(u32 sid, char **scontext,
 		rc = -EINVAL;
 		goto out;
 	}
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 	if (force)
 		context = sidtab_search_force(&sidtab, sid);
 	else
@@ -704,7 +700,7 @@ static int security_sid_to_context_core(u32 sid, char **scontext,
 	}
 	rc = context_struct_to_string(context, scontext, scontext_len);
 out_unlock:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 out:
 	return rc;
 
@@ -855,7 +851,7 @@ static int security_context_to_sid_core(const char *scontext, u32 scontext_len,
 		}
 	}
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 	rc = string_to_context_struct(&policydb, &sidtab,
 				      scontext2, scontext_len,
 				      &context, def_sid);
@@ -869,7 +865,7 @@ static int security_context_to_sid_core(const char *scontext, u32 scontext_len,
 	if (rc)
 		context_destroy(&context);
 out:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	kfree(scontext2);
 	kfree(str);
 	return rc;
@@ -981,7 +977,7 @@ static int security_compute_sid(u32 ssid,
 
 	context_init(&newcontext);
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 
 	scontext = sidtab_search(&sidtab, ssid);
 	if (!scontext) {
@@ -1086,7 +1082,7 @@ static int security_compute_sid(u32 ssid,
 	/* Obtain the sid for the context. */
 	rc = sidtab_context_to_sid(&sidtab, &newcontext, out_sid);
 out_unlock:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	context_destroy(&newcontext);
 out:
 	return rc;
@@ -1549,13 +1545,13 @@ int security_load_policy(void *data, size_t len)
 	sidtab_set(&oldsidtab, &sidtab);
 
 	/* Install the new policydb and SID table. */
-	POLICY_WRLOCK;
+	write_lock_irq(&policy_rwlock);
 	memcpy(&policydb, &newpolicydb, sizeof policydb);
 	sidtab_set(&sidtab, &newsidtab);
 	security_load_policycaps();
 	seqno = ++latest_granting;
 	policydb_loaded_version = policydb.policyvers;
-	POLICY_WRUNLOCK;
+	write_unlock_irq(&policy_rwlock);
 	LOAD_UNLOCK;
 
 	/* Free the old policydb and SID table. */
@@ -1588,7 +1584,7 @@ int security_port_sid(u8 protocol, u16 port, u32 *out_sid)
 	struct ocontext *c;
 	int rc = 0;
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 
 	c = policydb.ocontexts[OCON_PORT];
 	while (c) {
@@ -1613,7 +1609,7 @@ int security_port_sid(u8 protocol, u16 port, u32 *out_sid)
 	}
 
 out:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	return rc;
 }
 
@@ -1627,7 +1623,7 @@ int security_netif_sid(char *name, u32 *if_sid)
 	int rc = 0;
 	struct ocontext *c;
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 
 	c = policydb.ocontexts[OCON_NETIF];
 	while (c) {
@@ -1654,7 +1650,7 @@ int security_netif_sid(char *name, u32 *if_sid)
 		*if_sid = SECINITSID_NETIF;
 
 out:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	return rc;
 }
 
@@ -1686,7 +1682,7 @@ int security_node_sid(u16 domain,
 	int rc = 0;
 	struct ocontext *c;
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 
 	switch (domain) {
 	case AF_INET: {
@@ -1741,7 +1737,7 @@ int security_node_sid(u16 domain,
 	}
 
 out:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	return rc;
 }
 
@@ -1780,7 +1776,7 @@ int security_get_user_sids(u32 fromsid,
 	if (!ss_initialized)
 		goto out;
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 
 	context_init(&usercon);
 
@@ -1833,7 +1829,7 @@ int security_get_user_sids(u32 fromsid,
 	}
 
 out_unlock:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	if (rc || !mynel) {
 		kfree(mysids);
 		goto out;
@@ -1886,7 +1882,7 @@ int security_genfs_sid(const char *fstype,
 	while (path[0] == '/' && path[1] == '/')
 		path++;
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 
 	for (genfs = policydb.genfs; genfs; genfs = genfs->next) {
 		cmp = strcmp(fstype, genfs->fstype);
@@ -1923,7 +1919,7 @@ int security_genfs_sid(const char *fstype,
 
 	*sid = c->sid[0];
 out:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	return rc;
 }
 
@@ -1941,7 +1937,7 @@ int security_fs_use(
 	int rc = 0;
 	struct ocontext *c;
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 
 	c = policydb.ocontexts[OCON_FSUSE];
 	while (c) {
@@ -1971,7 +1967,7 @@ int security_fs_use(
 	}
 
 out:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	return rc;
 }
 
@@ -1979,7 +1975,7 @@ int security_get_bools(int *len, char ***names, int **values)
 {
 	int i, rc = -ENOMEM;
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 	*names = NULL;
 	*values = NULL;
 
@@ -2009,7 +2005,7 @@ int security_get_bools(int *len, char ***names, int **values)
 	}
 	rc = 0;
 out:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	return rc;
 err:
 	if (*names) {
@@ -2027,7 +2023,7 @@ int security_set_bools(int len, int *values)
 	int lenp, seqno = 0;
 	struct cond_node *cur;
 
-	POLICY_WRLOCK;
+	write_lock_irq(&policy_rwlock);
 
 	lenp = policydb.p_bools.nprim;
 	if (len != lenp) {
@@ -2061,7 +2057,7 @@ int security_set_bools(int len, int *values)
 	seqno = ++latest_granting;
 
 out:
-	POLICY_WRUNLOCK;
+	write_unlock_irq(&policy_rwlock);
 	if (!rc) {
 		avc_ss_reset(seqno);
 		selnl_notify_policyload(seqno);
@@ -2075,7 +2071,7 @@ int security_get_bool_value(int bool)
 	int rc = 0;
 	int len;
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 
 	len = policydb.p_bools.nprim;
 	if (bool >= len) {
@@ -2085,7 +2081,7 @@ int security_get_bool_value(int bool)
 
 	rc = policydb.bool_val_to_struct[bool]->state;
 out:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	return rc;
 }
 
@@ -2140,7 +2136,7 @@ int security_sid_mls_copy(u32 sid, u32 mls_sid, u32 *new_sid)
 
 	context_init(&newcon);
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 	context1 = sidtab_search(&sidtab, sid);
 	if (!context1) {
 		printk(KERN_ERR "SELinux: %s:  unrecognized SID %d\n",
@@ -2182,7 +2178,7 @@ bad:
 	}
 
 out_unlock:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	context_destroy(&newcon);
 out:
 	return rc;
@@ -2239,7 +2235,7 @@ int security_net_peersid_resolve(u32 nlbl_sid, u32 nlbl_type,
 		return 0;
 	}
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 
 	nlbl_ctx = sidtab_search(&sidtab, nlbl_sid);
 	if (!nlbl_ctx) {
@@ -2258,7 +2254,7 @@ int security_net_peersid_resolve(u32 nlbl_sid, u32 nlbl_type,
 	rc = (mls_context_cmp(nlbl_ctx, xfrm_ctx) ? 0 : -EACCES);
 
 out_slowpath:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	if (rc == 0)
 		/* at present NetLabel SIDs/labels really only carry MLS
 		 * information so if the MLS portion of the NetLabel SID
@@ -2288,7 +2284,7 @@ int security_get_classes(char ***classes, int *nclasses)
 {
 	int rc = -ENOMEM;
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 
 	*nclasses = policydb.p_classes.nprim;
 	*classes = kcalloc(*nclasses, sizeof(*classes), GFP_ATOMIC);
@@ -2305,7 +2301,7 @@ int security_get_classes(char ***classes, int *nclasses)
 	}
 
 out:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	return rc;
 }
 
@@ -2327,7 +2323,7 @@ int security_get_permissions(char *class, char ***perms, int *nperms)
 	int rc = -ENOMEM, i;
 	struct class_datum *match;
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 
 	match = hashtab_search(policydb.p_classes.table, class);
 	if (!match) {
@@ -2355,11 +2351,11 @@ int security_get_permissions(char *class, char ***perms, int *nperms)
 		goto err;
 
 out:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	return rc;
 
 err:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	for (i = 0; i < *nperms; i++)
 		kfree((*perms)[i]);
 	kfree(*perms);
@@ -2390,9 +2386,9 @@ int security_policycap_supported(unsigned int req_cap)
 {
 	int rc;
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 	rc = ebitmap_get_bit(&policydb.policycaps, req_cap);
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 
 	return rc;
 }
@@ -2456,7 +2452,7 @@ int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
 
 	context_init(&tmprule->au_ctxt);
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 
 	tmprule->au_seqno = latest_granting;
 
@@ -2493,7 +2489,7 @@ int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
 		break;
 	}
 
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 
 	if (rc) {
 		selinux_audit_rule_free(tmprule);
@@ -2544,7 +2540,7 @@ int selinux_audit_rule_match(u32 sid, u32 field, u32 op, void *vrule,
 		return -ENOENT;
 	}
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 
 	if (rule->au_seqno < latest_granting) {
 		audit_log(actx, GFP_ATOMIC, AUDIT_SELINUX_ERR,
@@ -2638,7 +2634,7 @@ int selinux_audit_rule_match(u32 sid, u32 field, u32 op, void *vrule,
 	}
 
 out:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	return match;
 }
 
@@ -2726,7 +2722,7 @@ int security_netlbl_secattr_to_sid(struct netlbl_lsm_secattr *secattr,
 		return 0;
 	}
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 
 	if (secattr->flags & NETLBL_SECATTR_CACHE) {
 		*sid = *(u32 *)secattr->cache->data;
@@ -2771,7 +2767,7 @@ int security_netlbl_secattr_to_sid(struct netlbl_lsm_secattr *secattr,
 	}
 
 netlbl_secattr_to_sid_return:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	return rc;
 netlbl_secattr_to_sid_return_cleanup:
 	ebitmap_destroy(&ctx_new.range.level[0].cat);
@@ -2796,7 +2792,7 @@ int security_netlbl_sid_to_secattr(u32 sid, struct netlbl_lsm_secattr *secattr)
 	if (!ss_initialized)
 		return 0;
 
-	POLICY_RDLOCK;
+	read_lock(&policy_rwlock);
 	ctx = sidtab_search(&sidtab, sid);
 	if (ctx == NULL)
 		goto netlbl_sid_to_secattr_failure;
@@ -2807,12 +2803,12 @@ int security_netlbl_sid_to_secattr(u32 sid, struct netlbl_lsm_secattr *secattr)
 	rc = mls_export_netlbl_cat(ctx, secattr);
 	if (rc != 0)
 		goto netlbl_sid_to_secattr_failure;
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 
 	return 0;
 
 netlbl_sid_to_secattr_failure:
-	POLICY_RDUNLOCK;
+	read_unlock(&policy_rwlock);
 	return rc;
 }
 #endif /* CONFIG_NETLABEL */
-- 
1.5.5.1

