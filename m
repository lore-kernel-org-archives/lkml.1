Return-Path: <linux-kernel-owner+w=401wt.eu-S965521AbXBFVWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965521AbXBFVWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965528AbXBFVWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:22:41 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35890 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965521AbXBFVWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:22:39 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov, jmorris@namei.org,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH 2/2] sysctl: Restore the selinux path based label lookup for sysctls.
References: <200701280106.l0S16CG3019873@shell0.pdx.osdl.net>
	<20070127172410.2b041952.akpm@osdl.org>
	<1169972718.17469.164.camel@localhost.localdomain>
	<20070128003549.2ca38dc8.akpm@osdl.org>
	<20070128093358.GA2071@elte.hu> <20070128095712.GA6485@elte.hu>
	<20070128100627.GA8416@elte.hu>
	<20070128104548.a835d859.akpm@osdl.org>
	<m1r6tfq7nv.fsf_-_@ebiederm.dsl.xmission.com>
	<1170075866.8720.15.camel@moss-spartans.epoch.ncsc.mil>
	<m17iuvrnpk.fsf_-_@ebiederm.dsl.xmission.com>
Date: Tue, 06 Feb 2007 14:21:54 -0700
In-Reply-To: <m17iuvrnpk.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Tue, 06 Feb 2007 14:16:39 -0700")
Message-ID: <m13b5jrngt.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This time instead of generating the generating the paths from proc_dir_entries
generate the labels from the names in the sysctl ctl_tables themselves.  This
removes an unnecessary layer of indirection, allows this to work even when
procfs support is not compiled into the kernel, and especially allows it
to work now that ctl_tables no longer have a proc_dir_entry field.

I continue passing "proc" into genfs sid although that is complete nonsense
to allow existing selinux policies to work without modification.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 security/selinux/hooks.c |   43 +++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 3a36057..c17a8dd 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1424,6 +1424,41 @@ static int selinux_capable(struct task_struct *tsk, int cap)
 	return task_has_capability(tsk,cap);
 }
 
+static int selinux_sysctl_get_sid(ctl_table *table, u16 tclass, u32 *sid)
+{
+	int buflen, rc;
+	char *buffer, *path, *end;
+
+	rc = -ENOMEM;
+	buffer = (char*)__get_free_page(GFP_KERNEL);
+	if (!buffer)
+		goto out;
+
+	buflen = PAGE_SIZE;
+	end = buffer+buflen;
+	*--end = '\0';
+	buflen--;
+	path = end-1;
+	*path = '/';
+	while (table) {
+		const char *name = table->procname;
+		size_t namelen = strlen(name);
+		buflen -= namelen + 1;
+		if (buflen < 0)
+			goto out_free;
+		end -= namelen;
+		memcpy(end, name, namelen);
+		*--end = '/';
+		path = end;
+		table = table->parent;
+	}
+	rc = security_genfs_sid("proc", path, tclass, sid);
+out_free:
+	free_page((unsigned long)buffer);
+out:
+	return rc;
+}
+
 static int selinux_sysctl(ctl_table *table, int op)
 {
 	int error = 0;
@@ -1438,8 +1473,12 @@ static int selinux_sysctl(ctl_table *table, int op)
 
 	tsec = current->security;
 
-	/* Use the well-defined sysctl SID. */
-	tsid = SECINITSID_SYSCTL;
+	rc = selinux_sysctl_get_sid(table, (op == 0001) ?
+				    SECCLASS_DIR : SECCLASS_FILE, &tsid);
+	if (rc) {
+		/* Default to the well-defined sysctl SID. */
+		tsid = SECINITSID_SYSCTL;
+	}
 
 	/* The op values are "defined" in sysctl.c, thereby creating
 	 * a bad coupling between this module and sysctl.c */
-- 
1.4.4.1.g278f

