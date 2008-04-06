Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYDFQ0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYDFQ0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 12:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbYDFQ0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 12:26:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:33473 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbYDFQ0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 12:26:09 -0400
Message-ID: <47F8F99D.1070701@colorfullife.com>
Date: Sun, 06 Apr 2008 18:26:05 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: [PATCH] fix SEM_UNDO with namespaces, take 2
References: <47EFFD1C.5020204@colorfullife.com> <47F08ED6.1090103@openvz.org> <47F10DF7.5010702@colorfullife.com> <47F203EC.7090806@openvz.org> <m1od8tiom7.fsf@ebiederm.dsl.xmission.com> <20080403194418.GA11105@sergelap.austin.ibm.com> <20080404043902.GA14177@sergelap.austin.ibm.com> <47F8E824.6090600@colorfullife.com>
In-Reply-To: <47F8E824.6090600@colorfullife.com>
Content-Type: multipart/mixed;
 boundary="------------010409080908030808020607"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010409080908030808020607
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

below is the second attempt to fix SEM_UNDO + unshare():
lookup_undo (in ipc/sem.c) is not namespace-aware, thus all entries in 
sysvsem.undo_list must be from the same namespace.
The patch enforces that by detaching the current thread from 
sysvsem.undo_list in switch_task_namespaces() if the ipc namespace is 
changed.

The patch boots and passes simple sysvsem+unshare tests.

Signed-Off-By: Manfred Spraul <manfred@colorfullife.com>

--------------010409080908030808020607
Content-Type: text/plain;
 name="patch-namespace-detach"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-namespace-detach"

diff --git a/ipc/sem.c b/ipc/sem.c
index 0b45a4d..35841bd 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1298,6 +1298,7 @@ void exit_sem(struct task_struct *tsk)
 	undo_list = tsk->sysvsem.undo_list;
 	if (!undo_list)
 		return;
+	tsk->sysvsem.undo_list = NULL;
 
 	if (!atomic_dec_and_test(&undo_list->refcnt))
 		return;
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index f5d332c..ddeb9d1 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -211,6 +211,18 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
 
 	might_sleep();
 
+	if ((p->nsproxy == NULL && new != NULL) ||
+		(p->nsproxy != NULL && new == NULL) ||
+		(p->nsproxy != NULL && new != NULL && p->nsproxy->ipc_ns != new->ipc_ns)) {
+		/* switching the IPC namespace is considered equivalent to sys_exit() wrt.
+		 * to outstanding SEM_UNDO undos: After switching to the new IPC namespace,
+		 * the semaphore arrays from the old namespace are not accessible anymore.
+		 * 
+		 * Additionally, an implicit sys_unshare(CLONE_SYSVSEM) is performed.
+		 */
+		exit_sem(p);
+	}
+
 	ns = p->nsproxy;
 
 	rcu_assign_pointer(p->nsproxy, new);

--------------010409080908030808020607--
