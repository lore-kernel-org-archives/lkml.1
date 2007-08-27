Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbXH0NRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbXH0NRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 09:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbXH0NRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 09:17:40 -0400
Received: from pat.uio.no ([129.240.10.15]:41589 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbXH0NRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 09:17:39 -0400
Subject: Re: NFS woes again Was: [linux-usb-devel] USB-related oops in
	sysfs with linux v2.6.23-rc3-50-g28e8351
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Florin Iucha <florin@iucha.net>
Cc: Bret Towe <magnade@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <20070823173637.GS10422@iucha.net>
References: <Pine.LNX.4.64.0708151656070.2460@twin.jikos.cz>
	 <20070821115115.GD10422@iucha.net> <20070821125718.GH10422@iucha.net>
	 <Pine.LNX.4.64.0708211502330.2460@twin.jikos.cz>
	 <20070821131759.GI10422@iucha.net> <20070821132704.GJ10422@iucha.net>
	 <Pine.LNX.4.64.0708211536560.2460@twin.jikos.cz>
	 <20070822132200.GO10422@iucha.net> <20070823125210.GQ10422@iucha.net>
	 <dda83e780708231014x66093dafj83263a2a1c8203bb@mail.gmail.com>
	 <20070823173637.GS10422@iucha.net>
Content-Type: multipart/mixed; boundary="=-MSOtyhfndz80M7RobPwx"
Date: Mon, 27 Aug 2007 09:17:31 -0400
Message-Id: <1188220651.6701.32.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.097)
X-UiO-Scanned: 3E6723F2B2BFCEA948A316C45A4D429C741D6FD1
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 575 total 3486374 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MSOtyhfndz80M7RobPwx
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2007-08-23 at 12:36 -0500, Florin Iucha wrote:
> On Thu, Aug 23, 2007 at 10:14:38AM -0700, Bret Towe wrote:
> > this sounds alot like the post i did yesterday titled 'nfs4 hang regression'
> > i tracked it down to commit 3d39c691ff486142dd9aaeac12f553f4476b7a6
> 
> Yes, it certainly does -- all the symptoms match!
> 
> I'm not [alone in] seeing dead keyboards!
> 
> Now, if only somebody could clarify to me the connection between
> the bad NFS4 shooting the keyboard but not the mouse, that would
> be wonderful.
> 
> florin

Could you and Bret please check if the attached patch fixes the hang?

Cheers
  Trond



--=-MSOtyhfndz80M7RobPwx
Content-Disposition: inline; filename=linux-2.6.23-001-fix_cancel_work_hang.dif
Content-Type: message/rfc822; name=linux-2.6.23-001-fix_cancel_work_hang.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Mon, 27 Aug 2007 09:14:56 -0400
NFS: Fix use of cancel_delayed_work_sync in nfs_release_automount_timer
Subject: No Subject
Message-Id: <1188220651.6701.33.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

We need to ensure that nobody adds anything to nfs_automount_list while we
are killing off the work queue entry, or else nfs_expire_automounts will
simply rearm it, and we hang.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/namespace.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index aea76d0..bcd0777 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -22,6 +22,11 @@ static void nfs_expire_automounts(struct work_struct *work);
 
 LIST_HEAD(nfs_automount_list);
 static DECLARE_DELAYED_WORK(nfs_automount_task, nfs_expire_automounts);
+/*
+ * The following mutex prevents nfs_follow_mountpoint from adding new
+ * entries to nfs_automount_list
+ */
+static DEFINE_MUTEX(nfs_automount_mutex);
 int nfs_mountpoint_expiry_timeout = 500 * HZ;
 
 static struct vfsmount *nfs_do_submount(const struct vfsmount *mnt_parent,
@@ -128,18 +133,21 @@ static void * nfs_follow_mountpoint(struct dentry *dentry, struct nameidata *nd)
 		goto out_err;
 
 	mntget(mnt);
+	mutex_lock(&nfs_automount_mutex);
 	err = do_add_mount(mnt, nd, nd->mnt->mnt_flags|MNT_SHRINKABLE, &nfs_automount_list);
 	if (err < 0) {
+		mutex_unlock(&nfs_automount_mutex);
 		mntput(mnt);
 		if (err == -EBUSY)
 			goto out_follow;
 		goto out_err;
 	}
+	schedule_delayed_work(&nfs_automount_task, nfs_mountpoint_expiry_timeout);
+	mutex_unlock(&nfs_automount_mutex);
 	mntput(nd->mnt);
 	dput(nd->dentry);
 	nd->mnt = mnt;
 	nd->dentry = dget(mnt->mnt_root);
-	schedule_delayed_work(&nfs_automount_task, nfs_mountpoint_expiry_timeout);
 out:
 	dprintk("%s: done, returned %d\n", __FUNCTION__, err);
 
@@ -175,8 +183,12 @@ static void nfs_expire_automounts(struct work_struct *work)
 
 void nfs_release_automount_timer(void)
 {
+	if (!list_empty(&nfs_automount_list))
+		return;
+	mutex_lock(&nfs_automount_mutex);
 	if (list_empty(&nfs_automount_list))
 		cancel_delayed_work_sync(&nfs_automount_task);
+	mutex_unlock(&nfs_automount_mutex);
 }
 
 /*

--=-MSOtyhfndz80M7RobPwx--

