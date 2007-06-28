Return-Path: <linux-kernel-owner+w=401wt.eu-S1765930AbXF1Suq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765930AbXF1Suq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765251AbXF1Std
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:49:33 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4288 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765045AbXF1Stb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:49:31 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Rik van Riel <riel@redhat.com>, Andy Isaacson <adi@hexapodia.org>
Date: Thu, 28 Jun 2007 11:49:24 -0700
Subject: [patch 4/4] MAP_NOZERO v2 - avoid ptrace/setuid+exec races
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.5792.1183056570.4>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It can happen that a root application doing:

     setuid(newuid);
                         <- ptrace_attach();
     exec(...);
     exit(1);

is raced by an application running under "newuid" and is ptrace-attached
and its memory is peek/poke.
The patch add a new "exec uid" that is set only after the complete detach
from the old process context is done. The ptrace's may_attach() function
is also changed to check that the attacher xuid matches the attached xuid.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/exec.c             |    2 ++
 include/linux/sched.h |    2 +-
 kernel/ptrace.c       |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.mod/fs/exec.c
===================================================================
--- linux-2.6.mod.orig/fs/exec.c	2007-06-28 11:45:06.000000000 -0700
+++ linux-2.6.mod/fs/exec.c	2007-06-28 11:45:20.000000000 -0700
@@ -905,6 +905,8 @@
 	flush_signal_handlers(current, 0);
 	flush_old_files(current->files);
 
+	current->xuid = current->uid;
+
 	return 0;
 
 mmap_failed:
Index: linux-2.6.mod/include/linux/sched.h
===================================================================
--- linux-2.6.mod.orig/include/linux/sched.h	2007-06-28 11:45:20.000000000 -0700
+++ linux-2.6.mod/include/linux/sched.h	2007-06-28 11:45:20.000000000 -0700
@@ -917,7 +917,7 @@
 	struct list_head cpu_timers[3];
 
 /* process credentials */
-	uid_t uid,euid,suid,fsuid;
+	uid_t uid,euid,suid,fsuid,xuid;
 	gid_t gid,egid,sgid,fsgid;
 	struct group_info *group_info;
 	kernel_cap_t   cap_effective, cap_inheritable, cap_permitted;
Index: linux-2.6.mod/kernel/ptrace.c
===================================================================
--- linux-2.6.mod.orig/kernel/ptrace.c	2007-06-28 11:45:06.000000000 -0700
+++ linux-2.6.mod/kernel/ptrace.c	2007-06-28 11:45:20.000000000 -0700
@@ -135,6 +135,7 @@
 		return 0;
 	if (((current->uid != task->euid) ||
 	     (current->uid != task->suid) ||
+	     (current->xuid != task->xuid) ||
 	     (current->uid != task->uid) ||
 	     (current->gid != task->egid) ||
 	     (current->gid != task->sgid) ||

