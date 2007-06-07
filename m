Return-Path: <linux-kernel-owner+w=401wt.eu-S936065AbXFGTeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936065AbXFGTeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934435AbXFGTed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:34:33 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:50210 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763745AbXFGTeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:34:31 -0400
Subject: Re: [bug] very high non-preempt latency in
	context_struct_compute_av()
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Carter <jwcart2@tycho.nsa.gov>, Paul Moore <paul.moore@hp.com>,
       James Morris <jmorris@namei.org>
In-Reply-To: <20070604112745.GA26350@elte.hu>
References: <20070604112745.GA26350@elte.hu>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 07 Jun 2007 15:34:10 -0400
Message-Id: <1181244850.11979.66.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 13:27 +0200, Ingo Molnar wrote:
> a simple ssh login triggers a ~130 msecs non-preemptible latency even 
> with CONFIG_PREEMPT enabled, on a fast Core2Duo CPU (!).
> 
> the latency is caused by a _very_ long loop in the SELinux code:
> 
>     sshd-4828  0.N.. 465894us : avtab_search_node (context_struct_compute_av)
>     sshd-4828  0.N.. 465895us : cond_compute_av (context_struct_compute_av)
>     sshd-4828  0.N.. 465895us : avtab_search_node (cond_compute_av)
>     sshd-4828  0.N.. 465895us : avtab_search_node (context_struct_compute_av)
>     sshd-4828  0.N.. 465896us : cond_compute_av (context_struct_compute_av)
>     sshd-4828  0.N.. 465896us : avtab_search_node (cond_compute_av)
>     sshd-4828  0.N.. 465896us : avtab_search_node (context_struct_compute_av)
>     sshd-4828  0.N.. 465896us : cond_compute_av (context_struct_compute_av)
>     sshd-4828  0.N.. 465896us : avtab_search_node (cond_compute_av)
> 
> it is triggered like this:
> 
>     sshd-4828  0..s. 462986us : tasklet_action (__do_softirq)
>     sshd-4828  0..s. 462986us : rcu_process_callbacks (tasklet_action)
>     sshd-4828  0..s. 462986us : __rcu_process_callbacks (rcu_process_callbacks)
>     sshd-4828  0..s. 462987us : __rcu_process_callbacks (rcu_process_callbacks)
>     sshd-4828  0D.s. 462987us : _local_bh_enable (__do_softirq)
>     sshd-4828  0DN.. 462987us : idle_cpu (irq_exit)
>     sshd-4828  0.N.. 462988us : avtab_search_node (context_struct_compute_av)
>     sshd-4828  0.N.. 462989us : cond_compute_av (context_struct_compute_av)
> 
> and it ends like this after 130 msecs:
> 
>     sshd-4828  0.N.. 594068us : ebitmap_contains (constraint_expr_eval)
>     sshd-4828  0.N.. 594068us : ebitmap_get_bit (constraint_expr_eval)
>     sshd-4828  0.N.. 594068us : constraint_expr_eval (context_struct_compute_av)
>     sshd-4828  0.N.. 594068us : ebitmap_contains (constraint_expr_eval)
>     sshd-4828  0.N.. 594068us : ebitmap_get_bit (constraint_expr_eval)
>     sshd-4828  0.N.. 594070us : sprintf (sel_write_user)
>     sshd-4828  0.N.. 594070us : vsnprintf (sprintf)
>     sshd-4828  0.N.. 594072us : number (vsnprintf)
>     sshd-4828  0.N.. 594072us : security_sid_to_context (sel_write_user)
>     sshd-4828  0.N.. 594073us : _read_lock (security_sid_to_context)
>     sshd-4828  0.N.. 594073us : sidtab_search (security_sid_to_context)
>     sshd-4828  0.N.. 594073us : context_struct_to_string (security_sid_to_context)
>     sshd-4828  0.N.. 594074us : mls_compute_context_len (context_struct_to_string)
>     sshd-4828  0.N.. 594075us : ebitmap_cmp (mls_compute_context_len)
>     sshd-4828  0.N.. 594075us : __kmalloc (context_struct_to_string)
>     sshd-4828  0.N.. 594076us : sprintf (context_struct_to_string)
>     sshd-4828  0.N.. 594077us : vsnprintf (sprintf)
> 
> i've got the full trace saved away (200 MB ...) and can upload it, but 
> it's just repetitions of the above lines.
> 
> The distribution is Fedora 7, v2.6.21 (but also happens in recent -git) 
> and a simple 'ssh localhost' login is enough to trigger this. It 
> triggers every time and this is causing audio skipping in certain apps. 
> It is even visible in glxgears smoothness: a small 'bump' is visible in 
> the otherwise smooth rotation of glxgears. Enabling CONFIG_PREEMPT does 
> not fix this issue as the function runs under spinlocks. (enabling 
> CONFIG_PREEMPT_RT in -rt fixes the issue - but that still leaves us with 
> the huge 130 msecs cost of that function.)

Can you try the patch below to see whether it helps?

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

Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>

---

 security/selinux/avc.c         |   10 +++++---
 security/selinux/hooks.c       |    9 ++++---
 security/selinux/include/avc.h |    6 +++--
 security/selinux/ss/services.c |   49 +++++++++++++++++++++++++----------------
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
index 40660ff..8ff4033 100644
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
Stephen Smalley
National Security Agency

