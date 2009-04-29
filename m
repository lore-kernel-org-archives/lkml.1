Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbZD2JNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbZD2JNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbZD2JMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:12:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57739 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbZD2JMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:12:48 -0400
Date: Wed, 29 Apr 2009 11:07:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] elf_core_dump: use rcu_read_lock() to access ->real_parent
Message-ID: <20090429090746.GA8284@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(on top of ptrace-s-parent-real_parent-in-binfmt_elf_fdpicc.patch)

In theory it is not safe to dereference ->parent/real_parent without
tasklist or rcu lock, we can race with re-parenting.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

 fs/binfmt_elf.c       |    8 ++++++--
 fs/binfmt_elf_fdpic.c |    8 ++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

--- PTRACE/fs/binfmt_elf.c~RCU_PARENT	2009-04-06 00:03:40.000000000 +0200
+++ PTRACE/fs/binfmt_elf.c	2009-04-29 10:46:54.000000000 +0200
@@ -1340,8 +1340,10 @@ static void fill_prstatus(struct elf_prs
 	prstatus->pr_info.si_signo = prstatus->pr_cursig = signr;
 	prstatus->pr_sigpend = p->pending.signal.sig[0];
 	prstatus->pr_sighold = p->blocked.sig[0];
+	rcu_read_lock();
+	prstatus->pr_ppid = task_pid_vnr(rcu_dereference(p->real_parent));
+	rcu_read_unlock();
 	prstatus->pr_pid = task_pid_vnr(p);
-	prstatus->pr_ppid = task_pid_vnr(p->real_parent);
 	prstatus->pr_pgrp = task_pgrp_vnr(p);
 	prstatus->pr_sid = task_session_vnr(p);
 	if (thread_group_leader(p)) {
@@ -1382,8 +1384,10 @@ static int fill_psinfo(struct elf_prpsin
 			psinfo->pr_psargs[i] = ' ';
 	psinfo->pr_psargs[len] = 0;
 
+	rcu_read_lock();
+	psinfo->pr_ppid = task_pid_vnr(rcu_dereference(p->real_parent));
+	rcu_read_unlock();
 	psinfo->pr_pid = task_pid_vnr(p);
-	psinfo->pr_ppid = task_pid_vnr(p->real_parent);
 	psinfo->pr_pgrp = task_pgrp_vnr(p);
 	psinfo->pr_sid = task_session_vnr(p);
 
--- PTRACE/fs/binfmt_elf_fdpic.c~RCU_PARENT	2009-04-28 21:40:49.000000000 +0200
+++ PTRACE/fs/binfmt_elf_fdpic.c	2009-04-29 10:52:31.000000000 +0200
@@ -1387,8 +1387,10 @@ static void fill_prstatus(struct elf_prs
 	prstatus->pr_info.si_signo = prstatus->pr_cursig = signr;
 	prstatus->pr_sigpend = p->pending.signal.sig[0];
 	prstatus->pr_sighold = p->blocked.sig[0];
+	rcu_read_lock();
+	prstatus->pr_ppid = task_pid_vnr(rcu_dereference(p->real_parent));
+	rcu_read_unlock();
 	prstatus->pr_pid = task_pid_vnr(p);
-	prstatus->pr_ppid = task_pid_vnr(p->real_parent);
 	prstatus->pr_pgrp = task_pgrp_vnr(p);
 	prstatus->pr_sid = task_session_vnr(p);
 	if (thread_group_leader(p)) {
@@ -1432,8 +1434,10 @@ static int fill_psinfo(struct elf_prpsin
 			psinfo->pr_psargs[i] = ' ';
 	psinfo->pr_psargs[len] = 0;
 
+	rcu_read_lock();
+	psinfo->pr_ppid = task_pid_vnr(rcu_dereference(p->real_parent));
+	rcu_read_unlock();
 	psinfo->pr_pid = task_pid_vnr(p);
-	psinfo->pr_ppid = task_pid_vnr(p->real_parent);
 	psinfo->pr_pgrp = task_pgrp_vnr(p);
 	psinfo->pr_sid = task_session_vnr(p);
 

