Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbYAONFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbYAONFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 08:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbYAONE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 08:04:56 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:55178 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYAONEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 08:04:55 -0500
Subject: [PATCH for 2.6.24] fix workqueue creation API lockdep interaction
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <1200401245.26045.19.camel@twins>
References: <a8e1da0801140104m2d8dceaayd8cf85466659bbf@mail.gmail.com>
	 <1200302644.7415.6.camel@twins>  <1200306902.5887.39.camel@johannes.berg>
	 <1200307288.7415.11.camel@twins>  <1200307896.5887.42.camel@johannes.berg>
	 <1200393685.5887.113.camel@johannes.berg> <1200399661.26045.13.camel@twins>
	 <1200400787.5887.129.camel@johannes.berg> <1200401245.26045.19.camel@twins>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 14:04:31 +0100
Message-Id: <1200402272.5887.140.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young reported warnings from lockdep that the workqueue API
can sometimes try to register lockdep classes with the same key
but different names. This is not permitted in lockdep.

Unfortunately, I was unaware of that restriction when I wrote
the code to debug workqueue problems with lockdep and used the
workqueue name as the lockdep class name. This can obviously
lead to the problem if the workqueue name is dynamic.

This patch solves the problem by always using a constant name
for the workqueue's lockdep class, namely either the constant
name that was passed in or a string consisting of the variable
name.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Please be careful with this patch, I haven't been able to test it so far
because my powerbook doesn't have lockdep.

 include/linux/workqueue.h |   14 +++++++++++---
 kernel/workqueue.c        |    5 +++--
 2 files changed, 14 insertions(+), 5 deletions(-)

--- everything.orig/include/linux/workqueue.h	2008-01-15 02:10:55.098131131 +0100
+++ everything/include/linux/workqueue.h	2008-01-15 02:26:37.428130426 +0100
@@ -149,19 +149,27 @@ struct execute_work {
 
 extern struct workqueue_struct *
 __create_workqueue_key(const char *name, int singlethread,
-		       int freezeable, struct lock_class_key *key);
+		       int freezeable, struct lock_class_key *key,
+		       const char *lock_name);
 
 #ifdef CONFIG_LOCKDEP
 #define __create_workqueue(name, singlethread, freezeable)	\
 ({								\
 	static struct lock_class_key __key;			\
+	const char *__lock_name;				\
+								\
+	if (__builtin_constant_p(name))				\
+		__lock_name = (name);				\
+	else							\
+		__lock_name = #name;				\
 								\
 	__create_workqueue_key((name), (singlethread),		\
-			       (freezeable), &__key);		\
+			       (freezeable), &__key,		\
+			       __lock_name);			\
 })
 #else
 #define __create_workqueue(name, singlethread, freezeable)	\
-	__create_workqueue_key((name), (singlethread), (freezeable), NULL)
+	__create_workqueue_key((name), (singlethread), (freezeable), NULL, NULL)
 #endif
 
 #define create_workqueue(name) __create_workqueue((name), 0, 0)
--- everything.orig/kernel/workqueue.c	2008-01-15 02:15:13.578132867 +0100
+++ everything/kernel/workqueue.c	2008-01-15 02:18:40.518138455 +0100
@@ -722,7 +722,8 @@ static void start_workqueue_thread(struc
 struct workqueue_struct *__create_workqueue_key(const char *name,
 						int singlethread,
 						int freezeable,
-						struct lock_class_key *key)
+						struct lock_class_key *key,
+						const char *lock_name)
 {
 	struct workqueue_struct *wq;
 	struct cpu_workqueue_struct *cwq;
@@ -739,7 +740,7 @@ struct workqueue_struct *__create_workqu
 	}
 
 	wq->name = name;
-	lockdep_init_map(&wq->lockdep_map, name, key, 0);
+	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	wq->singlethread = singlethread;
 	wq->freezeable = freezeable;
 	INIT_LIST_HEAD(&wq->list);


