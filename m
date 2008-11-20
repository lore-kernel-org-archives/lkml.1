Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYKTVHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYKTVHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 16:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbYKTVH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 16:07:27 -0500
Received: from mx2.netapp.com ([216.240.18.37]:50786 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbYKTVH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 16:07:27 -0500
X-IronPort-AV: E=Sophos;i="4.33,639,1220252400"; 
   d="scan'208";a="90771529"
Subject: [PATCH] SUNRPC: Fix a performance regression in the RPC
 authentication code
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Thu, 20 Nov 2008 16:06:21 -0500
Message-Id: <1227215181.7150.18.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
X-OriginalArrivalTime: 20 Nov 2008 21:07:16.0914 (UTC) FILETIME=[F7D61120:01C94B53]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a regression reported by Max Kellermann whereby kernel profiling
showed that his clients were spending 45% of their time in
rpcauth_lookup_credcache.

It turns out that although his processes had identical uid/gid/groups,
generic_match() was failing to detect this, because the task->group_info
pointers were not shared. This again lead to the creation of a huge number
of identical credentials at the RPC layer.

The regression is fixed by comparing the contents of task->group_info
if the actual pointers are not identical.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 net/sunrpc/auth_generic.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)


diff --git a/net/sunrpc/auth_generic.c b/net/sunrpc/auth_generic.c
index 744b79f..4028502 100644
--- a/net/sunrpc/auth_generic.c
+++ b/net/sunrpc/auth_generic.c
@@ -133,13 +133,29 @@ static int
 generic_match(struct auth_cred *acred, struct rpc_cred *cred, int flags)
 {
 	struct generic_cred *gcred = container_of(cred, struct generic_cred, gc_base);
+	int i;
 
 	if (gcred->acred.uid != acred->uid ||
 	    gcred->acred.gid != acred->gid ||
-	    gcred->acred.group_info != acred->group_info ||
 	    gcred->acred.machine_cred != acred->machine_cred)
-		return 0;
+		goto out_nomatch;
+
+	/* Optimisation in the case where pointers are identical... */
+	if (gcred->acred.group_info == acred->group_info)
+		goto out_match;
+
+	/* Slow path... */
+	if (gcred->acred.group_info->ngroups != acred->group_info->ngroups)
+		goto out_nomatch;
+	for (i = 0; i < gcred->acred.group_info->ngroups; i++) {
+		if (GROUP_AT(gcred->acred.group_info, i) !=
+				GROUP_AT(acred->group_info, i))
+			goto out_nomatch;
+	}
+out_match:
 	return 1;
+out_nomatch:
+	return 0;
 }
 
 void __init rpc_init_generic_auth(void)

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
