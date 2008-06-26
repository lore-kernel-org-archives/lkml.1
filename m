Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbYFZQAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbYFZQAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 12:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbYFZQAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 12:00:24 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46137 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbYFZQAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 12:00:23 -0400
Date: Thu, 26 Jun 2008 11:03:20 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] eCryptfs: Remove unnecessary mux from
	ecryptfs_init_ecryptfs_miscdev()
Message-ID: <20080626160320.GA7408@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20080626135904.GC7018@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626135904.GC7018@cvg>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 05:59:04PM +0400, Cyrill Gorcunov wrote:
> Some analisys shows the following interesting things -
> 
> Call chain (if being compiled into the kernel)
> ----------------------------------------------
> 
> ecryptfs_init
> 	ecryptfs_init_messaging
> 		ecryptfs_init_ecryptfs_miscdev
> 			mutex_lock(&ecryptfs_daemon_hash_mux);
> 			misc_register(&ecryptfs_miscdev);
> 				mutex_lock(&misc_mtx);
> 				mutex_unlock(&misc_mtx);
> 1 --->
> 			mutex_unlock(&ecryptfs_daemon_hash_mux);
> 
> As only we have misc device registered it is valid to open it.
> And that is happened by another proccess
> 
> chrdev_open
> 	misc_open
> 		mutex_lock(&misc_mtx);
> 			ecryptfs_miscdev_open
> 				mutex_lock(&ecryptfs_daemon_hash_mux);
> 			
> 
> If this happens at point (1) /ie chrdev_open called at this point/
> we are getting to circular warning as on top.

It appears to be only a warning and that deadlock cannot occur due to
the fact that ecryptfs_miscdev_open() cannot be called until after
mutex_unlock(&misc_mtx) occurs while under
ecryptfs_init_ecryptfs_miscdev(). However, on second glance, given the
call sequence detail you provided here, I think I am being
over-zealous in my hash table locking with ecryptfs_daemon_hash_mux in
ecryptfs_init_ecryptfs_miscdev(). The misc_mtx should provide all the
protection required to keep the daemon hash table sane during miscdev
registration.

---

The misc_mtx should provide all the protection required to keep the
daemon hash table sane during miscdev registration. Since this mutex
is causing gratuitous lockdep warnings, this patch removes it.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/miscdev.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/miscdev.c b/fs/ecryptfs/miscdev.c
index 6560da1..a9926a4 100644
--- a/fs/ecryptfs/miscdev.c
+++ b/fs/ecryptfs/miscdev.c
@@ -577,13 +577,11 @@ int ecryptfs_init_ecryptfs_miscdev(void)
 	int rc;
 
 	atomic_set(&ecryptfs_num_miscdev_opens, 0);
-	mutex_lock(&ecryptfs_daemon_hash_mux);
 	rc = misc_register(&ecryptfs_miscdev);
 	if (rc)
 		printk(KERN_ERR "%s: Failed to register miscellaneous device "
 		       "for communications with userspace daemons; rc = [%d]\n",
 		       __func__, rc);
-	mutex_unlock(&ecryptfs_daemon_hash_mux);
 	return rc;
 }
 
-- 
1.5.3.7

