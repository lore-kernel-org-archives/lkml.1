Return-Path: <linux-kernel-owner+w=401wt.eu-S1758888AbYFDLSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbYFDLSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 07:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbYFDLSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 07:18:36 -0400
Received: from burp.tkv.asdf.org ([212.16.99.49]:46400 "EHLO burp.tkv.asdf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbYFDLSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 07:18:35 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: in_group_p test for another process?
References: <aytzW-rV-23@gated-at.bofh.it>
From: Markku Savela <msa@moth.iki.fi>
Date: Wed, 04 Jun 2008 14:18:32 +0300
In-Reply-To: <aytzW-rV-23@gated-at.bofh.it> (Markku Savela's message of "Wed\, 28 May 2008 15\:10\:16 +0200")
Message-ID: <87bq2hcut3.fsf@burp.tkv.asdf.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some time ago, I asked...

Markku Savela <msa@moth.iki.fi> writes:
> If I have a PID and some GID at hand, how do I find whether the OHTER
> process identified by PID has the GID in its supplementary set of
> groups?
>
> I can find the "in_group_p" test, but that does it only for current process.
>
> Do I have to write my own function that uses the "tasklist_lock",
> finds task by "find_task_by_pid", and then calls
> "groups_search(task->group_info, gid)"?
>
> Can I do this in a module, or do I have to patch the "kernel/sys.c"
> myself for a privately modified version of the kernel?

Well, I've wrote a modification to the kernel/sys.c and it seems to
work for me. As I'm not really a hard core kernel expert, I'm not
quite sure the solution is bullet proof. Thus, here is my added
function that I use in my privately modified kernel for comments, if
any:


--- include/linux/sched-orig.h	2008-05-01 16:53:02.000000000 +0300
+++ include/linux/sched.h	2008-05-30 11:18:35.000000000 +0300
@@ -1582,6 +1582,7 @@
 
 extern int in_group_p(gid_t);
 extern int in_egroup_p(gid_t);
+extern int pid_in_egroup_p(gid_t, pid_t);
 
 extern void proc_caches_init(void);
 extern void flush_signals(struct task_struct *);
--- kernel/sys-orig.c	2008-02-11 07:51:11.000000000 +0200
+++ kernel/sys.c	2008-05-30 11:17:52.000000000 +0300
@@ -1338,6 +1338,29 @@
 
 EXPORT_SYMBOL(in_egroup_p);
 
+int pid_in_egroup_p(gid_t grp, pid_t pid)
+{
+	int retval = 1;
+	struct task_struct *p;
+
+	if (pid <= 0)
+		return 0;
+
+	read_lock(&tasklist_lock);
+	p = find_task_by_vpid(pid);
+	if (p) {
+		task_lock(p);
+		if (grp != p->egid)
+			retval = groups_search(p->group_info, grp);
+		task_unlock(p);
+	}
+	else
+		retval = 0;
+	read_unlock(&tasklist_lock);
+	return retval;
+}
+EXPORT_SYMBOL(pid_in_egroup_p);
+
 DECLARE_RWSEM(uts_sem);
 
 EXPORT_SYMBOL(uts_sem);


-- 
Markku Savela
