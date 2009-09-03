Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZICR0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZICR0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 13:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZICR0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 13:26:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZICR0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 13:26:01 -0400
Date: Thu, 3 Sep 2009 19:21:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] sys_setrlimit: make sure ->rlim_max never grows
Message-ID: <20090903172145.GB27161@redhat.com>
References: <1251884703-14523-1-git-send-email-jirislaby@gmail.com> <1251884703-14523-2-git-send-email-jirislaby@gmail.com> <20090902135024.GA6452@redhat.com> <4A9EBCF8.1020609@gmail.com> <20090902215101.GA4767@redhat.com> <4A9FC8DA.4090001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9FC8DA.4090001@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly preparation for Jiri's changes, but probably makes sense anyway.

sys_setrlimit() checks new_rlim.rlim_max <= old_rlim->rlim_max, but when
it takes task_lock() old_rlim->rlim_max can be already lowered. Move this
check under task_lock().

Currently this is not important, we can only race with our sub-thread,
this means the application is stupid. But when we change the code to allow
the update of !current task's limits, it becomes important to make sure
->rlim_max can be lowered "reliably" even if we race with the application
doing sys_setrlimit().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/sys.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- WAIT/kernel/sys.c~SETRLIMIT	2009-06-17 14:11:26.000000000 +0200
+++ WAIT/kernel/sys.c	2009-09-03 19:01:48.000000000 +0200
@@ -1247,10 +1247,6 @@ SYSCALL_DEFINE2(setrlimit, unsigned int,
 		return -EFAULT;
 	if (new_rlim.rlim_cur > new_rlim.rlim_max)
 		return -EINVAL;
-	old_rlim = current->signal->rlim + resource;
-	if ((new_rlim.rlim_max > old_rlim->rlim_max) &&
-	    !capable(CAP_SYS_RESOURCE))
-		return -EPERM;
 	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
 		return -EPERM;
 
@@ -1268,13 +1264,17 @@ SYSCALL_DEFINE2(setrlimit, unsigned int,
 		new_rlim.rlim_cur = 1;
 	}
 
+	old_rlim = current->signal->rlim + resource;
 	task_lock(current->group_leader);
-	*old_rlim = new_rlim;
+	if ((new_rlim.rlim_max <= old_rlim->rlim_max) ||
+				capable(CAP_SYS_RESOURCE))
+		*old_rlim = new_rlim;
+	else
+		retval = -EPERM;
 	task_unlock(current->group_leader);
 
-	if (resource != RLIMIT_CPU)
+	if (retval || resource != RLIMIT_CPU)
 		goto out;
-
 	/*
 	 * RLIMIT_CPU handling.   Note that the kernel fails to return an error
 	 * code if it rejected the user's attempt to set RLIMIT_CPU.  This is a
@@ -1286,7 +1286,7 @@ SYSCALL_DEFINE2(setrlimit, unsigned int,
 
 	update_rlimit_cpu(new_rlim.rlim_cur);
 out:
-	return 0;
+	return retval;
 }
 
 /*

