Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbZHRX6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbZHRX6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZHRX6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:58:42 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10541 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbZHRX6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:58:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Chbh9tiHmcrEFFT2moBl6JZP4tp392uFGgcBxK3FGsDjEYgcdBDGinwrgKYQNbTUW
	6HucpO1NcQ6o9J2S0t7kg==
From: Paul Menage <menage@google.com>
Subject: [PATCH 5/8] Changes css_set freeing mechanism to be under RCU
To: akpm@linux-foundation.org, bblum@andrew.cmu.edu, lizf@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Date: Tue, 18 Aug 2009 16:58:32 -0700
Message-ID: <20090818235832.22531.96610.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Blum <bblum@google.com>


Changes css_set freeing mechanism to be under RCU

This is a prepatch for making the procs file writable. In order to free the
old css_sets for each task to be moved as they're being moved, the freeing
mechanism must be RCU-protected, or else we would have to have a call to
synchronize_rcu() for each task before freeing its old css_set.

Signed-off-by: Ben Blum <bblum@google.com>
Signed-off-by: Paul Menage <menage@google.com>

---

 include/linux/cgroup.h |    3 +++
 kernel/cgroup.c        |    8 +++++++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 88e8634..3ac78a2 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -260,6 +260,9 @@ struct css_set {
 	 * during subsystem registration (at boot time).
 	 */
 	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
+
+	/* For RCU-protected deletion */
+	struct rcu_head rcu_head;
 };
 
 /*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7e2b285..9f9e154 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -267,6 +267,12 @@ static struct hlist_head *css_set_hash(struct cgroup_subsys_state *css[])
 	return &css_set_table[index];
 }
 
+static void free_css_set_rcu(struct rcu_head *obj)
+{
+	struct css_set *cg = container_of(obj, struct css_set, rcu_head);
+	kfree(cg);
+}
+
 /* We don't maintain the lists running through each css_set to its
  * task until after the first call to cgroup_iter_start(). This
  * reduces the fork()/exit() overhead for people who have cgroups
@@ -310,7 +316,7 @@ static void __put_css_set(struct css_set *cg, int taskexit)
 	}
 
 	write_unlock(&css_set_lock);
-	kfree(cg);
+	call_rcu(&cg->rcu_head, free_css_set_rcu);
 }
 
 /*

