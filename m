Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab0CIWs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 17:48:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab0CIWsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 17:48:24 -0500
Date: Tue, 9 Mar 2010 22:45:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, David Howells <dhowells@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 2/3] call_usermodehelper: simplify/fix UMH_NO_WAIT case
Message-ID: <20100309214501.GA32625@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__call_usermodehelper(UMH_NO_WAIT) has 2 problems:

	- if kernel_thread() fails, call_usermodehelper_freeinfo()
	  is not called.

	- for unknown reason UMH_NO_WAIT has UMH_WAIT_PROC logic,
	  we spawn yet another thread which waits until the user
	  mode application exits.

Change the UMH_NO_WAIT code to use ____call_usermodehelper() instead of
wait_for_helper(), and do call_usermodehelper_freeinfo() unconditionally.
We can rely on CLONE_VFORK, do_fork(CLONE_VFORK) until the child exits
or execs.

With or without this patch UMH_NO_WAIT does not report the error if
kernel_thread() fails, this is correct since the caller doesn't wait
for result.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/kmod.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- mm/kernel/kmod.c~2_UMH_NO_WAIT	2010-03-09 21:31:09.000000000 +0100
+++ mm/kernel/kmod.c	2010-03-09 21:56:36.000000000 +0100
@@ -224,10 +224,7 @@ static int wait_for_helper(void *data)
 			sub_info->retval = ret;
 	}
 
-	if (sub_info->wait == UMH_NO_WAIT)
-		call_usermodehelper_freeinfo(sub_info);
-	else
-		complete(sub_info->complete);
+	complete(sub_info->complete);
 	return 0;
 }
 
@@ -236,13 +233,13 @@ static void __call_usermodehelper(struct
 {
 	struct subprocess_info *sub_info =
 		container_of(work, struct subprocess_info, work);
-	pid_t pid;
 	enum umh_wait wait = sub_info->wait;
+	pid_t pid;
 
 	/* CLONE_VFORK: wait until the usermode helper has execve'd
 	 * successfully We need the data structures to stay around
 	 * until that is done.  */
-	if (wait == UMH_WAIT_PROC || wait == UMH_NO_WAIT)
+	if (wait == UMH_WAIT_PROC)
 		pid = kernel_thread(wait_for_helper, sub_info,
 				    CLONE_FS | CLONE_FILES | SIGCHLD);
 	else
@@ -251,6 +248,7 @@ static void __call_usermodehelper(struct
 
 	switch (wait) {
 	case UMH_NO_WAIT:
+		call_usermodehelper_freeinfo(sub_info);
 		break;
 
 	case UMH_WAIT_PROC:

