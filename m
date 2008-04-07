Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331AbYDGREG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbYDGREG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 13:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYDGRDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 13:03:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:2712 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbYDGRDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 13:03:55 -0400
Message-ID: <47FA53F1.1030509@colorfullife.com>
Date: Mon, 07 Apr 2008 19:03:45 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: Re: [PATCH] fix SEM_UNDO with namespaces, take 2
References: <47EFFD1C.5020204@colorfullife.com> <47F08ED6.1090103@openvz.org> <47F10DF7.5010702@colorfullife.com> <47F203EC.7090806@openvz.org> <m1od8tiom7.fsf@ebiederm.dsl.xmission.com> <20080403194418.GA11105@sergelap.austin.ibm.com> <20080404043902.GA14177@sergelap.austin.ibm.com> <47F8E824.6090600@colorfullife.com> <47F8F99D.1070701@colorfullife.com> <47F9CB64.8040009@openvz.org>
In-Reply-To: <47F9CB64.8040009@openvz.org>
Content-Type: multipart/mixed;
 boundary="------------060001080508020409040003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060001080508020409040003
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Pavel Emelyanov wrote:
> No, switch_task_namespaces is the wrong place to do this. It is to be 
> done in copy_ipc_ns. If you need a task for which a new namespace is 
> being prepared, then pass one into it.
>
>   
copy_ipc_ns() is also the wrong place:
There are calls after copy_ipc_ns() that can fail (e.g. copy_pid_ns()), 
and if they fail, then the whole syscall is aborted.
But undoing outstanding semaphore operations cannot be undone.
Or simpler: the copy_whatever() functions do not modify current.

Another option would be within sys_unshare():
sys_unshare() first creates all new pointers, and then actual unsharing 
is performed.

What do you think? I that the right place? The implementation could be 
moved into a seperate function, perhaps some of the NULL tests are 
superflous, too.

--
    Manfred

--------------060001080508020409040003
Content-Type: text/plain;
 name="patch-detach-in-sys_unshare"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-detach-in-sys_unshare"

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
diff --git a/kernel/fork.c b/kernel/fork.c
index 9c042f9..a3f3abb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1733,6 +1733,18 @@ asmlinkage long sys_unshare(unsigned long unshare_flags)
 	if (new_fs ||  new_mm || new_fd || new_ulist || new_nsproxy) {
 
 		if (new_nsproxy) {
+			if ((current->nsproxy == NULL && new_nsproxy != NULL) ||
+				(current->nsproxy != NULL && new_nsproxy == NULL) ||
+				(current->nsproxy != NULL && new_nsproxy != NULL && current->nsproxy->ipc_ns != new_nsproxy->ipc_ns)) {
+				/* switching the IPC namespace is considered equivalent to sys_exit() wrt.
+				 * to outstanding SEM_UNDO undos: After switching to the new IPC namespace,
+				 * the semaphore arrays from the old namespace are not accessible anymore.
+				 * 
+				 * Additionally, an implicit sys_unshare(CLONE_SYSVSEM) is performed.
+				 */
+				exit_sem(current);
+			}
+
 			switch_task_namespaces(current, new_nsproxy);
 			new_nsproxy = NULL;
 		}

--------------060001080508020409040003--
