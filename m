Return-Path: <linux-kernel-owner+w=401wt.eu-S1759560AbXGIDC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560AbXGIDC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 23:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758370AbXGIDCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 23:02:22 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:50880 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758616AbXGIDCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 23:02:21 -0400
Date: Sun, 8 Jul 2007 23:02:19 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] SELinux: allow preemption between transition permission
 checks
In-Reply-To: <Line.LNX.4.64.0707082253040.12256@d.namei>
Message-ID: <Line.LNX.4.64.0707082301540.12310@d.namei>
References: <Line.LNX.4.64.0707082253040.12256@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Smalley <sds@tycho.nsa.gov>

In security_get_user_sids, move the transition permission checks
outside of the section holding the policy rdlock, and use the AVC to
perform the checks, calling cond_resched after each one.  These
changes should allow preemption between the individual checks and
enable caching of the results.  It may however increase the overall
time spent in the function in some cases, particularly in the cache
miss case.

The long term fix will be to take much of this logic to userspace by
exporting additional state via selinuxfs, and ultimately deprecating
and eliminating this interface from the kernel.

Tested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/avc.c         |   10 +++++---
 security/selinux/hooks.c       |    9 ++++---
 security/selinux/include/avc.h |    6 +++-
 security/selinux/ss/services.c |   49 ++++++++++++++++++++++++---------------
 4 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index e4396a8..cc5fcef 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -832,6 +832,7 @@ int avc_ss_reset(u32 seqno)
  * @tsid: target security identifier
  * @tclass: target security class
  * @requested: requested permissions, interpreted based on @tclass
+ * @flags:  AVC_STRICT or 0
  * @avd: access vector decisions
  *
  * Check the AVC to determine whether the @requested permissions are granted
@@ -846,8 +847,9 @@ int avc_ss_reset(u32 seqno)
  * should be released for the auditing.
  */
 int avc_has_perm_noaudit(u32 ssid, u32 tsid,
-                         u16 tclass, u32 requested,
-                         struct av_decision *avd)
+			 u16 tclass, u32 requested,
+			 unsigned flags,
+			 struct av_decision *avd)
 {
 	struct avc_node *node;
 	struct avc_entry entry, *p_ae;
@@ -874,7 +876,7 @@ int avc_has_perm_noaudit(u32 ssid, u32 tsid,
 	denied = requested & ~(p_ae->avd.allowed);
 
 	if (!requested || denied) {
-		if (selinux_enforcing)
+		if (selinux_enforcing || (flags & AVC_STRICT))
 			rc = -EACCES;
 		else
 			if (node)
@@ -909,7 +911,7 @@ int avc_has_perm(u32 ssid, u32 tsid, u16 tclass,
 	struct av_decision avd;
 	int rc;
 
-	rc = avc_has_perm_noaudit(ssid, tsid, tclass, requested, &avd);
+	rc = avc_has_perm_noaudit(ssid, tsid, tclass, requested, 0, &avd);
 	avc_audit(ssid, tsid, tclass, requested, &avd, rc, auditdata);
 	return rc;
 }
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ad8dd4e..b29059e 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1592,9 +1592,10 @@ static int selinux_vm_enough_memory(long pages)
 	rc = secondary_ops->capable(current, CAP_SYS_ADMIN);
 	if (rc == 0)
 		rc = avc_has_perm_noaudit(tsec->sid, tsec->sid,
-					SECCLASS_CAPABILITY,
-					CAP_TO_MASK(CAP_SYS_ADMIN),
-					NULL);
+					  SECCLASS_CAPABILITY,
+					  CAP_TO_MASK(CAP_SYS_ADMIN),
+					  0,
+					  NULL);
 
 	if (rc == 0)
 		cap_sys_admin = 1;
@@ -4626,7 +4627,7 @@ static int selinux_setprocattr(struct task_struct *p,
 		if (p->ptrace & PT_PTRACED) {
 			error = avc_has_perm_noaudit(tsec->ptrace_sid, sid,
 						     SECCLASS_PROCESS,
-						     PROCESS__PTRACE, &avd);
+						     PROCESS__PTRACE, 0, &avd);
 			if (!error)
 				tsec->sid = sid;
 			task_unlock(p);
diff --git a/security/selinux/include/avc.h b/security/selinux/include/avc.h
index 6ed10c3..e145f6e 100644
--- a/security/selinux/include/avc.h
+++ b/security/selinux/include/avc.h
@@ -102,9 +102,11 @@ void avc_audit(u32 ssid, u32 tsid,
                u16 tclass, u32 requested,
                struct av_decision *avd, int result, struct avc_audit_data *auditdata);
 
+#define AVC_STRICT 1 /* Ignore permissive mode. */
 int avc_has_perm_noaudit(u32 ssid, u32 tsid,
-                         u16 tclass, u32 requested,
-                         struct av_decision *avd);
+			 u16 tclass, u32 requested,
+			 unsigned flags,
+			 struct av_decision *avd);
 
 int avc_has_perm(u32 ssid, u32 tsid,
                  u16 tclass, u32 requested,
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index e4249ad..b5f017f 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -1587,19 +1587,18 @@ int security_get_user_sids(u32 fromsid,
 			   u32 *nel)
 {
 	struct context *fromcon, usercon;
-	u32 *mysids, *mysids2, sid;
+	u32 *mysids = NULL, *mysids2, sid;
 	u32 mynel = 0, maxnel = SIDS_NEL;
 	struct user_datum *user;
 	struct role_datum *role;
-	struct av_decision avd;
 	struct ebitmap_node *rnode, *tnode;
 	int rc = 0, i, j;
 
-	if (!ss_initialized) {
-		*sids = NULL;
-		*nel = 0;
+	*sids = NULL;
+	*nel = 0;
+
+	if (!ss_initialized)
 		goto out;
-	}
 
 	POLICY_RDLOCK;
 
@@ -1635,17 +1634,9 @@ int security_get_user_sids(u32 fromsid,
 			if (mls_setup_user_range(fromcon, user, &usercon))
 				continue;
 
-			rc = context_struct_compute_av(fromcon, &usercon,
-						       SECCLASS_PROCESS,
-						       PROCESS__TRANSITION,
-						       &avd);
-			if (rc ||  !(avd.allowed & PROCESS__TRANSITION))
-				continue;
 			rc = sidtab_context_to_sid(&sidtab, &usercon, &sid);
-			if (rc) {
-				kfree(mysids);
+			if (rc)
 				goto out_unlock;
-			}
 			if (mynel < maxnel) {
 				mysids[mynel++] = sid;
 			} else {
@@ -1653,7 +1644,6 @@ int security_get_user_sids(u32 fromsid,
 				mysids2 = kcalloc(maxnel, sizeof(*mysids2), GFP_ATOMIC);
 				if (!mysids2) {
 					rc = -ENOMEM;
-					kfree(mysids);
 					goto out_unlock;
 				}
 				memcpy(mysids2, mysids, mynel * sizeof(*mysids2));
@@ -1664,11 +1654,32 @@ int security_get_user_sids(u32 fromsid,
 		}
 	}
 
-	*sids = mysids;
-	*nel = mynel;
-
 out_unlock:
 	POLICY_RDUNLOCK;
+	if (rc || !mynel) {
+		kfree(mysids);
+		goto out;
+	}
+
+	mysids2 = kcalloc(mynel, sizeof(*mysids2), GFP_KERNEL);
+	if (!mysids2) {
+		rc = -ENOMEM;
+		kfree(mysids);
+		goto out;
+	}
+	for (i = 0, j = 0; i < mynel; i++) {
+		rc = avc_has_perm_noaudit(fromsid, mysids[i],
+					  SECCLASS_PROCESS,
+					  PROCESS__TRANSITION, AVC_STRICT,
+					  NULL);
+		if (!rc)
+			mysids2[j++] = mysids[i];
+		cond_resched();
+	}
+	rc = 0;
+	kfree(mysids);
+	*sids = mysids2;
+	*nel = j;
 out:
 	return rc;
 }
-- 
1.5.0.6

