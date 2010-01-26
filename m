Return-Path: <linux-kernel-owner+w=401wt.eu-S1752058Ab0AZIQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab0AZIQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 03:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575Ab0AZIQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 03:16:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61052 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab0AZIQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 03:16:50 -0500
Message-ID: <4B5EA500.5040802@cn.fujitsu.com>
Date: Tue, 26 Jan 2010 16:17:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Ben Blum <bblum@andrew.cmu.edu>, LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>
Subject: [PATCH 2/2] cgroups: Clean up cgroup_pidlist_find() a bit
References: <4B5EA4EC.8020700@cn.fujitsu.com>
In-Reply-To: <4B5EA4EC.8020700@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't Call get_pid_ns() before we locate/alloc the ns.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 cgroup.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/kernel/cgroup.c.orig	2010-01-26 14:24:29.000000000 +0800
+++ a/kernel/cgroup.c	2010-01-26 14:24:44.000000000 +0800
@@ -2643,7 +2643,8 @@ static struct cgroup_pidlist *cgroup_pid
 {
 	struct cgroup_pidlist *l;
 	/* don't need task_nsproxy() if we're looking at ourself */
-	struct pid_namespace *ns = get_pid_ns(current->nsproxy->pid_ns);
+	struct pid_namespace *ns = current->nsproxy->pid_ns;
+
 	/*
 	 * We can't drop the pidlist_mutex before taking the l->mutex in case
 	 * the last ref-holder is trying to remove l from the list at the same
@@ -2653,8 +2654,6 @@ static struct cgroup_pidlist *cgroup_pid
 	mutex_lock(&cgrp->pidlist_mutex);
 	list_for_each_entry(l, &cgrp->pidlists, links) {
 		if (l->key.type == type && l->key.ns == ns) {
-			/* found a matching list - drop the extra refcount */
-			put_pid_ns(ns);
 			/* make sure l doesn't vanish out from under us */
 			down_write(&l->mutex);
 			mutex_unlock(&cgrp->pidlist_mutex);
@@ -2665,13 +2664,12 @@ static struct cgroup_pidlist *cgroup_pid
 	l = kmalloc(sizeof(struct cgroup_pidlist), GFP_KERNEL);
 	if (!l) {
 		mutex_unlock(&cgrp->pidlist_mutex);
-		put_pid_ns(ns);
 		return l;
 	}
 	init_rwsem(&l->mutex);
 	down_write(&l->mutex);
 	l->key.type = type;
-	l->key.ns = ns;
+	l->key.ns = get_pid_ns(ns);
 	l->use_count = 0; /* don't increment here */
 	l->list = NULL;
 	l->owner = cgrp;
