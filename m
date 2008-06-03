Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbYFCLSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbYFCLSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 07:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756793AbYFCLSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 07:18:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055AbYFCLSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 07:18:09 -0400
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 3/3] sunrpc: change default for pooled services to
	SVC_POOL_AUTO and make settings persistent
To: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       bfields@fieldses.org
Date: Tue, 03 Jun 2008 07:18:07 -0400
Message-ID: <20080603111807.8769.56170.stgit@dantu.usersys.redhat.com>
In-Reply-To: <20080603111757.8769.69366.stgit@dantu.usersys.redhat.com>
References: <20080603111757.8769.69366.stgit@dantu.usersys.redhat.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current default for pooled services is SVC_POOL_GLOBAL, which just
does allocations in whatever pool the current process is running, and
doesn't restrict which CPUs the tasks will run.

Change the default to SVC_POOL_AUTO so that large-scale machines will
automatically choose an allocation and cpu masking scheme that's better
suited to their architecture. Also, change it so that when the pool
refcount goes to zero, that we do not reset the allocation scheme to the
compile-time default. The setting should stick once it's made.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---

 net/sunrpc/svc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index a61e7aa..7238c37 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -39,7 +39,7 @@ enum {
 	SVC_POOL_PERCPU,	/* one pool per cpu */
 	SVC_POOL_PERNODE	/* one pool per numa node */
 };
-#define SVC_POOL_DEFAULT	SVC_POOL_GLOBAL
+#define SVC_POOL_DEFAULT	SVC_POOL_AUTO
 
 /*
  * Structure for mapping cpus to pools and vice versa.
@@ -280,7 +280,6 @@ svc_pool_map_put(void)
 	mutex_lock(&svc_pool_map_mutex);
 
 	if (!--m->count) {
-		m->mode = SVC_POOL_DEFAULT;
 		kfree(m->to_pool);
 		kfree(m->pool_to);
 		m->npools = 0;

