Return-Path: <linux-kernel-owner+w=401wt.eu-S1752278AbZGXDWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbZGXDWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 23:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbZGXDWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 23:22:17 -0400
Received: from smtp-out.google.com ([216.239.33.17]:5206 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbZGXDWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 23:22:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:content-transfer-encoding;
	b=A73j6t8zgX/VDeBozH5sg12XLyyJuLhL86wrx1QPqZCN5sNqgf6jWj2D6fgtxOl/x
	aA9ZlYRZbR8TwrKddZotA==
From: Ben Blum <bblum@google.com>
Subject: [PATCH 4/6] Changes css_set freeing mechanism to be under RCU
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, lizf@cn.fujitsu.com,
       menage@google.com, bblum@google.com
Date: Thu, 23 Jul 2009 20:21:55 -0700
Message-ID: <20090724032155.2463.80574.stgit@hastromil.mtv.corp.google.com>
In-Reply-To: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com>
References: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes css_set freeing mechanism to be under RCU

This is a prepatch for making the procs file writable. In order to free the
old css_sets for each task to be moved as they're being moved, the freeing
mechanism must be RCU-protected, or else we would have to have a call to
synchronize_rcu() for each task before freeing its old css_set.

Signed-off-by: Ben Blum <bblum@google.com>

---

 include/linux/cgroup.h |    3 +++
 kernel/cgroup.c        |    8 +++++++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b934b72..24e3f1a 100644
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
index 7e6b183..637a54e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -288,6 +288,12 @@ static void unlink_css_set(struct css_set *cg)
 	}
 }
 
+static void free_css_set_rcu(struct rcu_head *obj)
+{
+	struct css_set *cg = container_of(obj, struct css_set, rcu_head);
+	kfree(cg);
+}
+
 static void __put_css_set(struct css_set *cg, int taskexit)
 {
 	int i;
@@ -317,7 +323,7 @@ static void __put_css_set(struct css_set *cg, int taskexit)
 		}
 	}
 	rcu_read_unlock();
-	kfree(cg);
+	call_rcu(&cg->rcu_head, free_css_set_rcu);
 }
 
 /*

