Return-Path: <linux-kernel-owner+w=401wt.eu-S932573AbXAWAXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbXAWAXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 19:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932564AbXAWAWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 19:22:55 -0500
Received: from mx1.suse.de ([195.135.220.2]:35126 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932544AbXAWAWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 19:22:51 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@osdl.org>
Date: Tue, 23 Jan 2007 11:22:26 +1100
Message-Id: <1070123002226.27856@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@stusta.de>
Subject: [PATCH 004 of 5] knfsd: Replace some warning ins nfsfh.h with BUG_ON or WARN_ON
References: <20070123111558.27683.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


A couple of the warning will be followed by an Oops if they ever fire,
so may as well be BUG_ON.  Another isn't obviously fatal but has never
been known to fire, so make it a WARN_ON.

Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./include/linux/nfsd/nfsfh.h |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff .prev/include/linux/nfsd/nfsfh.h ./include/linux/nfsd/nfsfh.h
--- .prev/include/linux/nfsd/nfsfh.h	2007-01-23 11:13:44.000000000 +1100
+++ ./include/linux/nfsd/nfsfh.h	2007-01-23 11:15:00.000000000 +1100
@@ -217,11 +217,7 @@ void	fh_put(struct svc_fh *);
 static __inline__ struct svc_fh *
 fh_copy(struct svc_fh *dst, struct svc_fh *src)
 {
-	if (src->fh_dentry || src->fh_locked) {
-		struct dentry *dentry = src->fh_dentry;
-		printk(KERN_ERR "fh_copy: copying %s/%s, already verified!\n",
-			dentry->d_parent->d_name.name, dentry->d_name.name);
-	}
+	WARN_ON(src->fh_dentry || src->fh_locked);
 			
 	*dst = *src;
 	return dst;
@@ -300,10 +296,8 @@ fh_lock_nested(struct svc_fh *fhp, unsig
 	dfprintk(FILEOP, "nfsd: fh_lock(%s) locked = %d\n",
 			SVCFH_fmt(fhp), fhp->fh_locked);
 
-	if (!fhp->fh_dentry) {
-		printk(KERN_ERR "fh_lock: fh not verified!\n");
-		return;
-	}
+	BUG_ON(!dentry);
+
 	if (fhp->fh_locked) {
 		printk(KERN_WARNING "fh_lock: %s/%s already locked!\n",
 			dentry->d_parent->d_name.name, dentry->d_name.name);
@@ -328,8 +322,7 @@ fh_lock(struct svc_fh *fhp)
 static inline void
 fh_unlock(struct svc_fh *fhp)
 {
-	if (!fhp->fh_dentry)
-		printk(KERN_ERR "fh_unlock: fh not verified!\n");
+	BUG_ON(!fhp->fh_dentry);
 
 	if (fhp->fh_locked) {
 		fill_post_wcc(fhp);
