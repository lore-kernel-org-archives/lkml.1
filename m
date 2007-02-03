Return-Path: <linux-kernel-owner+w=401wt.eu-S1946259AbXBCCtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946259AbXBCCtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946255AbXBCCii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:38:38 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52979 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946259AbXBCCiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:38:22 -0500
Message-Id: <20070203024259.386005000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:38 -0800
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
Subject: [patch 34/59] knfsd: fix setting of ACL server versions.
Content-Disposition: inline; filename=knfsd-fix-setting-of-acl-server-versions.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: NeilBrown <neilb@suse.de>

Due to silly typos, if the nfs versions are explicitly set,
no NFSACL versions get enabled.

Also improve an error message that would have made this bug
a little easier to find.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/nfsd/nfssvc.c |    8 ++++----
 net/sunrpc/svc.c |    3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

--- linux-2.6.19.2.orig/fs/nfsd/nfssvc.c
+++ linux-2.6.19.2/fs/nfsd/nfssvc.c
@@ -72,7 +72,7 @@ static struct svc_program	nfsd_acl_progr
 	.pg_prog		= NFS_ACL_PROGRAM,
 	.pg_nvers		= NFSD_ACL_NRVERS,
 	.pg_vers		= nfsd_acl_versions,
-	.pg_name		= "nfsd",
+	.pg_name		= "nfsacl",
 	.pg_class		= "nfsd",
 	.pg_stats		= &nfsd_acl_svcstats,
 	.pg_authenticate	= &svc_set_client,
@@ -118,16 +118,16 @@ int nfsd_vers(int vers, enum vers_op cha
 	switch(change) {
 	case NFSD_SET:
 		nfsd_versions[vers] = nfsd_version[vers];
-		break;
 #if defined(CONFIG_NFSD_V2_ACL) || defined(CONFIG_NFSD_V3_ACL)
 		if (vers < NFSD_ACL_NRVERS)
-			nfsd_acl_version[vers] = nfsd_acl_version[vers];
+			nfsd_acl_versions[vers] = nfsd_acl_version[vers];
 #endif
+		break;
 	case NFSD_CLEAR:
 		nfsd_versions[vers] = NULL;
 #if defined(CONFIG_NFSD_V2_ACL) || defined(CONFIG_NFSD_V3_ACL)
 		if (vers < NFSD_ACL_NRVERS)
-			nfsd_acl_version[vers] = NULL;
+			nfsd_acl_versions[vers] = NULL;
 #endif
 		break;
 	case NFSD_TEST:
--- linux-2.6.19.2.orig/net/sunrpc/svc.c
+++ linux-2.6.19.2/net/sunrpc/svc.c
@@ -910,7 +910,8 @@ err_bad_prog:
 
 err_bad_vers:
 #ifdef RPC_PARANOIA
-	printk("svc: unknown version (%d)\n", vers);
+	printk("svc: unknown version (%d for prog %d, %s)\n",
+	       vers, prog, progp->pg_name);
 #endif
 	serv->sv_stats->rpcbadfmt++;
 	svc_putnl(resv, RPC_PROG_MISMATCH);

--
