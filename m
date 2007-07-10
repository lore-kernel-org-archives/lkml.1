Return-Path: <linux-kernel-owner+w=401wt.eu-S1758478AbXGJCao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478AbXGJCao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762736AbXGJC21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:28:27 -0400
Received: from mail.suse.de ([195.135.220.2]:38362 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762688AbXGJC20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:28:26 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 10 Jul 2007 12:28:22 +1000
Message-Id: <1070710022822.13650@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: J "." Bruce Fields <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 020 of 20] knfsd: nfsd: enforce per-flavor id squashing
References: <20070710121949.12548.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@citi.umich.edu>

Allow root squashing to vary per-pseudoflavor, so that you can (for
example) allow root access only when sufficiently strong security is in
use.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/auth.c              |   18 ++++++++++++++++--
 ./include/linux/nfsd/export.h |    3 ++-
 2 files changed, 18 insertions(+), 3 deletions(-)

diff .prev/fs/nfsd/auth.c ./fs/nfsd/auth.c
--- .prev/fs/nfsd/auth.c	2007-07-10 12:18:33.000000000 +1000
+++ ./fs/nfsd/auth.c	2007-07-10 12:19:40.000000000 +1000
@@ -12,17 +12,31 @@
 
 #define	CAP_NFSD_MASK (CAP_FS_MASK|CAP_TO_MASK(CAP_SYS_RESOURCE))
 
+static int nfsexp_flags(struct svc_rqst *rqstp, struct svc_export *exp)
+{
+	struct exp_flavor_info *f;
+	struct exp_flavor_info *end = exp->ex_flavors + exp->ex_nflavors;
+
+	for (f = exp->ex_flavors; f < end; f++) {
+		if (f->pseudoflavor == rqstp->rq_flavor)
+			return f->flags;
+	}
+	return exp->ex_flags;
+
+}
+
 int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 {
 	struct svc_cred	cred = rqstp->rq_cred;
 	int i;
+	int flags = nfsexp_flags(rqstp, exp);
 	int ret;
 
-	if (exp->ex_flags & NFSEXP_ALLSQUASH) {
+	if (flags & NFSEXP_ALLSQUASH) {
 		cred.cr_uid = exp->ex_anon_uid;
 		cred.cr_gid = exp->ex_anon_gid;
 		cred.cr_group_info = groups_alloc(0);
-	} else if (exp->ex_flags & NFSEXP_ROOTSQUASH) {
+	} else if (flags & NFSEXP_ROOTSQUASH) {
 		struct group_info *gi;
 		if (!cred.cr_uid)
 			cred.cr_uid = exp->ex_anon_uid;

diff .prev/include/linux/nfsd/export.h ./include/linux/nfsd/export.h
--- .prev/include/linux/nfsd/export.h	2007-07-10 12:18:33.000000000 +1000
+++ ./include/linux/nfsd/export.h	2007-07-10 12:19:40.000000000 +1000
@@ -43,7 +43,8 @@
 #define NFSEXP_ALLFLAGS		0xFE3F
 
 /* The flags that may vary depending on security flavor: */
-#define NFSEXP_SECINFO_FLAGS	NFSEXP_READONLY
+#define NFSEXP_SECINFO_FLAGS	(NFSEXP_READONLY | NFSEXP_ROOTSQUASH \
+					| NFSEXP_ALLSQUASH)
 
 #ifdef __KERNEL__
 
