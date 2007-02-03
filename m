Return-Path: <linux-kernel-owner+w=401wt.eu-S1946263AbXBCCjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946263AbXBCCjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946258AbXBCCjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:39:13 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53073 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946271AbXBCCjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:39:08 -0500
Message-Id: <20070203024332.004436000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:41 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [patch 37/59] knfsd: fix up some bit-rot in exp_export
Content-Disposition: inline; filename=knfsd-fix-up-some-bit-rot-in-exp_export.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: NeilBrown <neilb@suse.de>

The nfsservctl systemcall isn't used but recent nfs-utils releases for
exporting filesystems, and consequently the code that is uses -
exp_export - has suffered some bitrot.

Particular:
  - some newly added fields in 'struct svc_export' are being initialised
    properly.
  - the return value is now always -ENOMEM ...

This patch fixes both these problems.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/nfsd/export.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- linux-2.6.19.2.orig/fs/nfsd/export.c
+++ linux-2.6.19.2/fs/nfsd/export.c
@@ -950,6 +950,8 @@ exp_export(struct nfsctl_export *nxp)
 
 	exp = exp_get_by_name(clp, nd.mnt, nd.dentry, NULL);
 
+	memset(&new, 0, sizeof(new));
+
 	/* must make sure there won't be an ex_fsid clash */
 	if ((nxp->ex_flags & NFSEXP_FSID) &&
 	    (fsid_key = exp_get_fsid_key(clp, nxp->ex_dev)) &&
@@ -980,6 +982,9 @@ exp_export(struct nfsctl_export *nxp)
 
 	new.h.expiry_time = NEVER;
 	new.h.flags = 0;
+	new.ex_path = kstrdup(nxp->ex_path, GFP_KERNEL);
+	if (!new.ex_path)
+		goto finish;
 	new.ex_client = clp;
 	new.ex_mnt = nd.mnt;
 	new.ex_dentry = nd.dentry;
@@ -1000,10 +1005,11 @@ exp_export(struct nfsctl_export *nxp)
 		/* failed to create at least one index */
 		exp_do_unexport(exp);
 		cache_flush();
-		err = -ENOMEM;
-	}
-
+	} else
+		err = 0;
 finish:
+	if (new.ex_path)
+		kfree(new.ex_path);
 	if (exp)
 		exp_put(exp);
 	if (fsid_key && !IS_ERR(fsid_key))

--
