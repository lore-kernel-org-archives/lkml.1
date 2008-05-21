Return-Path: <linux-kernel-owner+w=401wt.eu-S935457AbYEUPhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935457AbYEUPhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764676AbYEUPg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:36:58 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35704 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764359AbYEUPg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:36:57 -0400
Date: Wed, 21 May 2008 10:39:15 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrea Righi <righiandr@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <prussell@au1.ibm.com>,
       "David J. Kleikamp" <shaggy@us.ibm.com>,
       "SERGE E. HALLYN" <sergeh@us.ibm.com>
Subject: [PATCH] eCryptfs: Remove useless lock
Message-ID: <20080521153915.GA942@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20080520214610.GD32643@halcrowt61p.austin.ibm.com> <48335BBF.2040901@users.sourceforge.net> <20080521151430.GG32643@halcrowt61p.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521151430.GG32643@halcrowt61p.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 10:14:30AM -0500, Michael Halcrow wrote:
> On Wed, May 21, 2008 at 01:16:15AM +0200, Andrea Righi wrote:
> > Michael Halcrow wrote:
> >> +	req = kmem_cache_alloc(ecryptfs_open_req_cache, GFP_KERNEL);
> >> +	if (!req) {
> >> +		rc = -ENOMEM;
> >> +		goto out;
> >> +	}
> >> +	mutex_init(&req->mux);
> >> +	req->lower_file = lower_file;
> >> +	req->lower_dentry = lower_dentry;
> >> +	req->lower_mnt = lower_mnt;
> >> +	req->requesting_task = current;
> >> +	req->flags = 0;
> >> +	mutex_lock(&ecryptfs_kthread_ctl.mux);
> >> +	mutex_lock(&req->mux);
> >> +	if (ecryptfs_kthread_ctl.flags & ECRYPTFS_KTHREAD_ZOMBIE) {
> >> +		rc = -EIO;
> >
> > Isn't a mutex_unlock(&req->mux) missing here?
> 
> Nobody else actually has a reference to req at this point, so the
> unlock is not really necessary. It might not be a bad idea to jump to
> out_unlock anyway just to avoid future bugs.
> 
> >> +		mutex_unlock(&ecryptfs_kthread_ctl.mux);
> >> +		printk(KERN_ERR "%s: We are in the middle of shutting down; "
> >> +		       "aborting privileged request to open lower file\n",
> >> +			__func__);
> >> +		goto out_free;
> >> +	}
> >> +	list_add_tail(&req->kthread_ctl_list, &ecryptfs_kthread_ctl.req_list);
> >> +	mutex_unlock(&req->mux);
> >> +	mutex_unlock(&ecryptfs_kthread_ctl.mux);

Nobody can get a reference to req so long as &ecryptfs_kthread_ctl.mux
is held. Remove lock of req->mux for newly created req.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/kthread.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/kthread.c b/fs/ecryptfs/kthread.c
index dba7c67..3d34327 100644
--- a/fs/ecryptfs/kthread.c
+++ b/fs/ecryptfs/kthread.c
@@ -158,7 +158,6 @@ int ecryptfs_privileged_open(struct file **lower_file,
 	req->requesting_task = current;
 	req->flags = 0;
 	mutex_lock(&ecryptfs_kthread_ctl.mux);
-	mutex_lock(&req->mux);
 	if (ecryptfs_kthread_ctl.flags & ECRYPTFS_KTHREAD_ZOMBIE) {
 		rc = -EIO;
 		mutex_unlock(&ecryptfs_kthread_ctl.mux);
@@ -168,7 +167,6 @@ int ecryptfs_privileged_open(struct file **lower_file,
 		goto out_free;
 	}
 	list_add_tail(&req->kthread_ctl_list, &ecryptfs_kthread_ctl.req_list);
-	mutex_unlock(&req->mux);
 	mutex_unlock(&ecryptfs_kthread_ctl.mux);
 	wake_up(&ecryptfs_kthread_ctl.wait);
 schedule:
-- 
1.5.3.6

