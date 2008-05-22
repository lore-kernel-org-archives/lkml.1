Return-Path: <linux-kernel-owner+w=401wt.eu-S933413AbYEVVnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbYEVVnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758839AbYEVVmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:42:49 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52442 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757942AbYEVVms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:42:48 -0400
Date: Thu, 22 May 2008 16:44:54 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, prussell@au1.ibm.com, shaggy@us.ibm.com,
       sergeh@us.ibm.com
Subject: [PATCH] eCryptfs: Use kthread_should_stop() instead of the
	non-empty list hack
Message-ID: <20080522214454.GB942@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20080520214610.GD32643@halcrowt61p.austin.ibm.com> <20080521160000.717fb1ef.akpm@linux-foundation.org> <20080522193155.GB4057@halcrowt61p.ibm.com> <20080522124142.a850ab0e.akpm@linux-foundation.org> <20080522211625.GC4057@halcrowt61p.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522211625.GC4057@halcrowt61p.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 04:16:25PM -0500, Michael Halcrow wrote:
> This is what gets woken up:
> 
> ---
>                 wait_event_freezable(
>                         ecryptfs_kthread_ctl.wait,
>                         !list_empty(&ecryptfs_kthread_ctl.req_list));
>                 mutex_lock(&ecryptfs_kthread_ctl.mux);
>                 if (ecryptfs_kthread_ctl.flags &
>                         ECRYPTFS_KTHREAD_ZOMBIE) {
>                         mutex_unlock(&ecryptfs_kthread_ctl.mux);
>                         goto out;
>                 }
> ---
> 
> So the flag causes the kthread to just quit, ignoring the list
> altogether.

The code for shutting down the kthread is ugly. This patch uses the
kthread_stop() call to shut down the kthread instead.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/kthread.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/ecryptfs/kthread.c b/fs/ecryptfs/kthread.c
index 4295296..c440c6b 100644
--- a/fs/ecryptfs/kthread.c
+++ b/fs/ecryptfs/kthread.c
@@ -55,7 +55,8 @@ static int ecryptfs_threadfn(void *ignored)
 
 		wait_event_freezable(
 			ecryptfs_kthread_ctl.wait,
-			!list_empty(&ecryptfs_kthread_ctl.req_list));
+			(!list_empty(&ecryptfs_kthread_ctl.req_list)
+			 || kthread_should_stop()));
 		mutex_lock(&ecryptfs_kthread_ctl.mux);
 		if (ecryptfs_kthread_ctl.flags & ECRYPTFS_KTHREAD_ZOMBIE) {
 			mutex_unlock(&ecryptfs_kthread_ctl.mux);
@@ -103,7 +104,6 @@ int ecryptfs_init_kthread(void)
 
 void ecryptfs_destroy_kthread(void)
 {
-	struct ecryptfs_open_req tmp_req;
 	struct ecryptfs_open_req *req;
 
 	mutex_lock(&ecryptfs_kthread_ctl.mux);
@@ -115,12 +115,8 @@ void ecryptfs_destroy_kthread(void)
 		wake_up(&req->wait);
 		mutex_unlock(&req->mux);
 	}
-	memset(&tmp_req, 0, sizeof(tmp_req));
-	tmp_req.flags = ECRYPTFS_REQ_ZOMBIE;
-	/* Both the list and dummy entry are entirely defunct at this point */
-	list_add_tail(&tmp_req.kthread_ctl_list,
-		      &ecryptfs_kthread_ctl.req_list);
 	mutex_unlock(&ecryptfs_kthread_ctl.mux);
+	kthread_stop(ecryptfs_kthread);
 	wake_up(&ecryptfs_kthread_ctl.wait);
 }
 
-- 
1.5.3.6

