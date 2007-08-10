Return-Path: <linux-kernel-owner+w=401wt.eu-S935721AbXHJLvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935721AbXHJLvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 07:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759172AbXHJLvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 07:51:09 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:47172 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685AbXHJLvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 07:51:08 -0400
Date: Fri, 10 Aug 2007 15:47:53 +0400
From: xemul@openvz.org
To: akpm@osdl.org
Cc: xemul@openvz.org, devel@openvz.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, oleg@tv-sign.ru, sukadev@us.ibm.com
Subject: [PATCH 2/20] Move exit_task_namespaces()
Message-ID: <46BC5069.mailGIP11AV7A@openvz.org>
User-Agent: nail 11.4 8/29/04
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Makve task release its namespaces after it has reparented all his children
to child_reaper, but before it notifies its parent about its death.

The reason to release namespaces after reparenting is that when task exits
it may send a signal to its parent (SIGCHLD), but if the parent has already
exited its namespaces there will be no way to decide what pid to dever to
him - parent can be from different namespace.

The reason to release namespace before notifying the parent it that when
task sends a SIGCHLD to parent it can call wait() on this taks and release
it. But releasing the mnt namespace implies dropping of all the mounts in
the mnt namespace and NFS expects the task to have valid sighand pointer.

Thanks to Oleg for pointing out some races that can apear and helping with
patches and fixes.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>

---

 exit.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- ./kernel/exit.c.ve2	2007-07-27 12:45:46.000000000 +0400
+++ ./kernel/exit.c	2007-07-27 12:46:08.000000000 +0400
@@ -796,6 +796,7 @@ static void exit_notify(struct task_stru
 	 *	jobs, send them a SIGHUP and then a SIGCONT.  (POSIX 3.2.2.2)
 	 */
 	forget_original_parent(tsk);
+	exit_task_namespaces(tsk);
 
 	write_lock_irq(&tasklist_lock);
 	/*
@@ -1003,7 +1004,6 @@ fastcall NORET_TYPE void do_exit(long co
 
 	tsk->exit_code = code;
 	proc_exit_connector(tsk);
-	exit_task_namespaces(tsk);
 	exit_notify(tsk);
 #ifdef CONFIG_NUMA
 	mpol_free(tsk->mempolicy);
