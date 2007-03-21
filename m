Return-Path: <linux-kernel-owner+w=401wt.eu-S964896AbXCUUxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964896AbXCUUxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964931AbXCUUxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:53:53 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:59781 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964896AbXCUUxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:53:52 -0400
Date: Wed, 21 Mar 2007 21:53:53 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] reject taskset for kernel threads
Message-ID: <20070321205353.GA32529@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Do not allow taskset for kernel threads.
These commands will cause oopses due to stack corruption:

ls /proc/*/task | grep -v ^/ | xargs echo | xargs -n1 taskset -pc 2-9
taskset -pc 1 $$
taskset -pc 0 $((pidof john))

Possible fix in userland:

for i in ` ls /proc/*/task | grep -v ^/ `
do
	e=/proc/*/task/$i/exe
	if test -e $e
	then
		taskset -pc 2-9	$i
	fi
done


Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 kernel/sched.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.20/kernel/sched.c
===================================================================
--- linux-2.6.20.orig/kernel/sched.c
+++ linux-2.6.20/kernel/sched.c
@@ -4310,6 +4310,8 @@ long sched_setaffinity(pid_t pid, cpumas
 	read_unlock(&tasklist_lock);
 
 	retval = -EPERM;
+	if (!p->mm)
+		goto out_unlock;
 	if ((current->euid != p->euid) && (current->euid != p->uid) &&
 			!capable(CAP_SYS_NICE))
 		goto out_unlock;
