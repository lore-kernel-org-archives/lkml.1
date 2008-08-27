Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYH0NqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYH0NqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbYH0NqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:46:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959AbYH0NqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:46:01 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/59] CRED: Wrap task credential accesses in the MIPS arch
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org
Date: Wed, 27 Aug 2008 14:45:52 +0100
Message-ID: <20080827134552.19980.14045.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---

 arch/mips/kernel/mips-mt-fpaff.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/arch/mips/kernel/mips-mt-fpaff.c b/arch/mips/kernel/mips-mt-fpaff.c
index df4d3f2..928c72b 100644
--- a/arch/mips/kernel/mips-mt-fpaff.c
+++ b/arch/mips/kernel/mips-mt-fpaff.c
@@ -51,6 +51,7 @@ asmlinkage long mipsmt_sys_sched_setaffinity(pid_t pid, unsigned int len,
 	int retval;
 	struct task_struct *p;
 	struct thread_info *ti;
+	uid_t euid;
 
 	if (len < sizeof(new_mask))
 		return -EINVAL;
@@ -76,9 +77,9 @@ asmlinkage long mipsmt_sys_sched_setaffinity(pid_t pid, unsigned int len,
 	 */
 	get_task_struct(p);
 
+	euid = current_euid();
 	retval = -EPERM;
-	if ((current->euid != p->euid) && (current->euid != p->uid) &&
-			!capable(CAP_SYS_NICE)) {
+	if (euid != p->euid && euid != p->uid && !capable(CAP_SYS_NICE)) {
 		read_unlock(&tasklist_lock);
 		goto out_unlock;
 	}

