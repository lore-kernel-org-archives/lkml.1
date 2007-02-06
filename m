Return-Path: <linux-kernel-owner+w=401wt.eu-S965502AbXBFVRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965502AbXBFVRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965507AbXBFVRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:17:49 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57364 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965502AbXBFVRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:17:48 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov, jmorris@namei.org,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH 1/2] sysctl: Add a parent entry to ctl_table and set the parent entry.
References: <200701280106.l0S16CG3019873@shell0.pdx.osdl.net>
	<20070127172410.2b041952.akpm@osdl.org>
	<1169972718.17469.164.camel@localhost.localdomain>
	<20070128003549.2ca38dc8.akpm@osdl.org>
	<20070128093358.GA2071@elte.hu> <20070128095712.GA6485@elte.hu>
	<20070128100627.GA8416@elte.hu>
	<20070128104548.a835d859.akpm@osdl.org>
	<m1r6tfq7nv.fsf_-_@ebiederm.dsl.xmission.com>
	<1170075866.8720.15.camel@moss-spartans.epoch.ncsc.mil>
Date: Tue, 06 Feb 2007 14:16:39 -0700
In-Reply-To: <1170075866.8720.15.camel@moss-spartans.epoch.ncsc.mil> (Stephen
	Smalley's message of "Mon, 29 Jan 2007 08:04:26 -0500")
Message-ID: <m17iuvrnpk.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Add a parent entry into the ctl_table so you can walk the list of
parents and find the entire path to a ctl_table entry.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---

This is an incremental patch on top of my previous sysctl work.

 include/linux/sysctl.h |    1 +
 kernel/sysctl.c        |   10 ++++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 286e723..24f36f1 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -1024,6 +1024,7 @@ struct ctl_table
 	int maxlen;
 	mode_t mode;
 	ctl_table *child;
+	ctl_table *parent;		/* Automatically set */
 	proc_handler *proc_handler;	/* Callback for text formatting */
 	ctl_handler *strategy;		/* Callback function for all r/w */
 	void *extra1;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ae6a424..0a5499f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1232,6 +1232,15 @@ int do_sysctl_strategy (ctl_table *table,
 }
 #endif /* CONFIG_SYSCTL_SYSCALL */
 
+static void sysctl_set_parent(struct ctl_table *parent, struct ctl_table *table)
+{
+	for (; table->ctl_name || table->procname; table++) {
+		table->parent = parent;
+		if (table->child)
+			sysctl_set_parent(table, table->child);
+	}
+}
+
 /**
  * register_sysctl_table - register a sysctl hierarchy
  * @table: the top-level table structure
@@ -1311,6 +1320,7 @@ static struct ctl_table_header *__register_sysctl_table(
 	INIT_LIST_HEAD(&tmp->ctl_entry);
 	tmp->used = 0;
 	tmp->unregistering = NULL;
+	sysctl_set_parent(NULL, table);
 	spin_lock(&sysctl_lock);
 	list_add_tail(&tmp->ctl_entry, &root->ctl_entry);
 	spin_unlock(&sysctl_lock);
-- 
1.4.4.1.g278f

