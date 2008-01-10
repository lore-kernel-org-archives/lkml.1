Return-Path: <linux-kernel-owner+w=401wt.eu-S1759180AbYAJSCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180AbYAJSCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbYAJSCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:02:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491AbYAJSCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:02:21 -0500
From: Jeff Layton <jlayton@redhat.com>
To: akpm@linux-foundation.org, neilb@suse.de
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] NLM: have nlm_shutdown_hosts kill off all NLM RPC tasks
Date: Thu, 10 Jan 2008 13:01:36 -0500
Message-Id: <1199988096-19700-6-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1199988096-19700-5-git-send-email-jlayton@redhat.com>
References: <1199988096-19700-1-git-send-email-jlayton@redhat.com>
 <1199988096-19700-2-git-send-email-jlayton@redhat.com>
 <1199988096-19700-3-git-send-email-jlayton@redhat.com>
 <1199988096-19700-4-git-send-email-jlayton@redhat.com>
 <1199988096-19700-5-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main problem is this:

When a lock that a client is blocking on comes free, lockd does this in
nlmsvc_grant_blocked():

    nlm_async_call(block->b_call, NLMPROC_GRANTED_MSG, &nlmsvc_grant_ops);

the callback from this call is nlmsvc_grant_callback(). That function
does this at the end to wake up lockd:

    svc_wake_up(block->b_daemon);

However there is no guarantee that lockd will be up when this happens.
If someone shuts down or restarts lockd before the async call completes,
then the b_daemon pointer will point to freed memory and the kernel may
oops.

If we're shutting down all the nlm_hosts anyway, then it doesn't make
sense to allow RPC calls to linger. Allowing them to do so can mean
that the RPC calls can outlive the currently running lockd and can lead
to the above use after free situation and possibly others.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/lockd/host.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/lockd/host.c b/fs/lockd/host.c
index 572601e..8771484 100644
--- a/fs/lockd/host.c
+++ b/fs/lockd/host.c
@@ -377,8 +377,10 @@ nlm_shutdown_hosts(void)
 	/* First, make all hosts eligible for gc */
 	dprintk("lockd: nuking all hosts...\n");
 	for (chain = nlm_hosts; chain < nlm_hosts + NLM_HOST_NRHASH; ++chain) {
-		hlist_for_each_entry(host, pos, chain, h_hash)
+		hlist_for_each_entry(host, pos, chain, h_hash) {
 			host->h_expires = jiffies - 1;
+			rpc_killall_tasks(host->h_rpcclnt);
+		}
 	}
 
 	/* Then, perform a garbage collection pass */
-- 
1.5.3.7

