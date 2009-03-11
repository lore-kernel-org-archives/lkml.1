Return-Path: <linux-kernel-owner+w=401wt.eu-S1755054AbZCKOtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbZCKOtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbZCKOtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:49:23 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:42645 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbZCKOtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:49:22 -0400
Message-ID: <49B7CF67.5070604@davidnewall.com>
Date: Thu, 12 Mar 2009 01:19:11 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_hawking.rebel.net.au-8946-1236782958-0001-2"
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix off-by-one in __iterator_load_balance
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hawking.rebel.net.au-8946-1236782958-0001-2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

An off-by-one bug in __iterator_load_balance causes it to erroneously
return NULL if the next task on the list is also the last entry in the
list.  This patch corrects that fault.

--=_hawking.rebel.net.au-8946-1236782958-0001-2
Content-Type: text/x-patch; name="sched_fair.patch"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sched_fair.patch"

--- sched_fair.c	2009-02-21 09:09:34.000000000 +1030
+++ sched_fair.c.dn	2009-03-12 01:09:46.000000000 +1030
@@ -1439,27 +1439,18 @@
 static struct task_struct *
 __load_balance_iterator(struct cfs_rq *cfs_rq, struct list_head *next)
 {
-	struct task_struct *p = NULL;
 	struct sched_entity *se;
-
-	if (next == &cfs_rq->tasks)
-		return NULL;
-
-	/* Skip over entities that are not tasks */
-	do {
+	while (next != &cfs_rq->tasks)
+	{
 		se = list_entry(next, struct sched_entity, group_node);
 		next = next->next;
-	} while (next != &cfs_rq->tasks && !entity_is_task(se));
-
-	if (next == &cfs_rq->tasks)
-		return NULL;
-
-	cfs_rq->balance_iterator = next;
-
-	if (entity_is_task(se))
-		p = task_of(se);
-
-	return p;
+		if (entity_is_task(se))
+		{
+			cfs_rq->balance_iterator = next;
+			return task_of(se);
+		}
+	}
+	return NULL;
 }
 
 static struct task_struct *load_balance_start_fair(void *arg)

--=_hawking.rebel.net.au-8946-1236782958-0001-2--
