Return-Path: <linux-kernel-owner+w=401wt.eu-S1760776AbXITImL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776AbXITImL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbXITIl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:41:56 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:55794 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbXITIlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:41:55 -0400
Message-ID: <46F2324E.9020707@fr.ibm.com>
Date: Thu, 20 Sep 2007 10:41:50 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: 2.6.23-rc6-mm1 - make access to tasks nsproxy ligther (fix) 
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
In-Reply-To: <20070918011841.2381bd93.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello !

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/

make-access-to-tasks-nsproxy-lighter.patch breaks unshare()

when called from unshare(), switch_task_namespaces() takes an 
extra refcount on the nsproxy, leading to a memory leak of 
nsproxy objects. 

Now the problem is that we still need that extra ref when called 
from daemonize(). Here's an ugly fix for it.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
---
 include/linux/nsproxy.h |    5 +++++
 kernel/exit.c           |    2 ++
 kernel/nsproxy.c        |    7 -------
 3 files changed, 7 insertions(+), 7 deletions(-)

Index: 2.6.23-rc6-mm1/kernel/nsproxy.c
===================================================================
--- 2.6.23-rc6-mm1.orig/kernel/nsproxy.c
+++ 2.6.23-rc6-mm1/kernel/nsproxy.c
@@ -25,11 +25,6 @@ static struct kmem_cache *nsproxy_cachep
 
 struct nsproxy init_nsproxy = INIT_NSPROXY(init_nsproxy);
 
-static inline void get_nsproxy(struct nsproxy *ns)
-{
-	atomic_inc(&ns->count);
-}
-
 /*
  * creates a copy of "orig" with refcount 1.
  */
@@ -208,8 +203,6 @@ void switch_task_namespaces(struct task_
 	if (ns == new)
 		return;
 
-	if (new)
-		get_nsproxy(new);
 	rcu_assign_pointer(p->nsproxy, new);
 
 	if (ns && atomic_dec_and_test(&ns->count)) {
Index: 2.6.23-rc6-mm1/kernel/exit.c
===================================================================
--- 2.6.23-rc6-mm1.orig/kernel/exit.c
+++ 2.6.23-rc6-mm1/kernel/exit.c
@@ -408,6 +408,8 @@ void daemonize(const char *name, ...)
 	current->fs = fs;
 	atomic_inc(&fs->count);
 
+	if (current->nsproxy != init_task.nsproxy)
+		get_nsproxy(init_task.nsproxy);
 	switch_task_namespaces(current, init_task.nsproxy);
 
 	exit_files(current);
Index: 2.6.23-rc6-mm1/include/linux/nsproxy.h
===================================================================
--- 2.6.23-rc6-mm1.orig/include/linux/nsproxy.h
+++ 2.6.23-rc6-mm1/include/linux/nsproxy.h
@@ -77,6 +77,11 @@ static inline void put_nsproxy(struct ns
 	}
 }
 
+static inline void get_nsproxy(struct nsproxy *ns)
+{
+	atomic_inc(&ns->count);
+}
+
 #ifdef CONFIG_CONTAINER_NS
 int ns_container_clone(struct task_struct *tsk);
 #else
