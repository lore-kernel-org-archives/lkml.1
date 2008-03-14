Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbYCNXhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbYCNXhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 19:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbYCNXh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 19:37:29 -0400
Received: from mail.fieldses.org ([66.93.2.214]:42860 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbYCNXh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 19:37:29 -0400
Date: Fri, 14 Mar 2008 19:37:11 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@kernel.org, Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: [PATCH] nfsd: fix oops on access from high-numbered ports
Message-ID: <20080314233711.GN2119@fieldses.org>
References: <20080312122550.GB8141@ics.muni.cz> <20080312160007.GA10015@fieldses.org> <20080313143631.GH27873@ics.muni.cz> <20080314181413.GF2119@fieldses.org> <20080314193350.GK2119@fieldses.org> <20080314195303.GA4390@ics.muni.cz> <20080314200510.GL2119@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080314200510.GL2119@fieldses.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

This bug was always here, but before my commit 6fa02839bf9412e18e77
("recheck for secure ports in fh_verify"), it could only be triggered by
failure of a kmalloc().  After that commit it could be triggered by a
client making a request from a non-reserved port for access to an export
marked "secure".  (Exports are "secure" by default.)

The result is a struct svc_export with a reference count one to low,
resulting in likely oopses next time the export is accessed.

The reference counting here is not straightforward; a later patch will
clean up fh_verify().

Thanks to Lukas Hejtmanek for the bug report and followup.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>
---
 fs/nfsd/nfsfh.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

This is appropriate for 2.6.25, 2.6.24.y, and 2.6.23.y (if it's still
maintained).--b.

diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index 1eb771d..3e6b3f4 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -232,6 +232,7 @@ fh_verify(struct svc_rqst *rqstp, struct svc_fh *fhp, int type, int access)
 		fhp->fh_dentry = dentry;
 		fhp->fh_export = exp;
 		nfsd_nr_verified++;
+		cache_get(&exp->h);
 	} else {
 		/*
 		 * just rechecking permissions
@@ -241,6 +242,7 @@ fh_verify(struct svc_rqst *rqstp, struct svc_fh *fhp, int type, int access)
 		dprintk("nfsd: fh_verify - just checking\n");
 		dentry = fhp->fh_dentry;
 		exp = fhp->fh_export;
+		cache_get(&exp->h);
 		/*
 		 * Set user creds for this exportpoint; necessary even
 		 * in the "just checking" case because this may be a
@@ -252,8 +254,6 @@ fh_verify(struct svc_rqst *rqstp, struct svc_fh *fhp, int type, int access)
 		if (error)
 			goto out;
 	}
-	cache_get(&exp->h);
-
 
 	error = nfsd_mode_check(rqstp, dentry->d_inode->i_mode, type);
 	if (error)
-- 
1.5.4.rc2.60.gb2e62

