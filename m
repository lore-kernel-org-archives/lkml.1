Return-Path: <linux-kernel-owner+w=401wt.eu-S932067AbYCUWvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbYCUWvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762870AbYCUWqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:46:49 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:58934 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762861AbYCUWqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:46:48 -0400
Message-Id: <20080321224444.477482247@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:54 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 64/76] nfsd: fix oops on access from high-numbered ports
Content-Disposition: inline; filename=nfsd-fix-oops-on-access-from-high-numbered-ports.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: J. Bruce Fields <bfields@citi.umich.edu>

This bug was always here, but before my commit 6fa02839bf9412e18e77
("recheck for secure ports in fh_verify"), it could only be triggered by
failure of a kmalloc().  After that commit it could be triggered by a
client making a request from a non-reserved port for access to an export
marked "secure".  (Exports are "secure" by default.)

The result is a struct svc_export with a reference count one too low,
resulting in likely oopses next time the export is accessed.

The reference counting here is not straightforward; a later patch will
clean up fh_verify().

Thanks to Lukas Hejtmanek for the bug report and followup.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/nfsd/nfsfh.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -231,6 +231,7 @@ fh_verify(struct svc_rqst *rqstp, struct
 		fhp->fh_dentry = dentry;
 		fhp->fh_export = exp;
 		nfsd_nr_verified++;
+		cache_get(&exp->h);
 	} else {
 		/*
 		 * just rechecking permissions
@@ -240,6 +241,7 @@ fh_verify(struct svc_rqst *rqstp, struct
 		dprintk("nfsd: fh_verify - just checking\n");
 		dentry = fhp->fh_dentry;
 		exp = fhp->fh_export;
+		cache_get(&exp->h);
 		/*
 		 * Set user creds for this exportpoint; necessary even
 		 * in the "just checking" case because this may be a
@@ -251,8 +253,6 @@ fh_verify(struct svc_rqst *rqstp, struct
 		if (error)
 			goto out;
 	}
-	cache_get(&exp->h);
-
 
 	error = nfsd_mode_check(rqstp, dentry->d_inode->i_mode, type);
 	if (error)

-- 
