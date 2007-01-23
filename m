Return-Path: <linux-kernel-owner+w=401wt.eu-S932547AbXAWAWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547AbXAWAWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 19:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932443AbXAWAWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 19:22:52 -0500
Received: from cantor.suse.de ([195.135.220.2]:35098 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522AbXAWAWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 19:22:37 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@osdl.org>
Date: Tue, 23 Jan 2007 11:22:13 +1100
Message-Id: <1070123002213.27830@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 002 of 5] knfsd: Fix setting of ACL server versions.
References: <20070123111558.27683.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Due to silly typos, if the nfs versions are explicitly set,
no NFSACL versions get enabled.

Also improve an error message that would have made this bug
a little easier to find.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfssvc.c |    8 ++++----
 ./net/sunrpc/svc.c |    3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff .prev/fs/nfsd/nfssvc.c ./fs/nfsd/nfssvc.c
--- .prev/fs/nfsd/nfssvc.c	2007-01-23 11:13:46.000000000 +1100
+++ ./fs/nfsd/nfssvc.c	2007-01-23 11:14:49.000000000 +1100
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

diff .prev/net/sunrpc/svc.c ./net/sunrpc/svc.c
--- .prev/net/sunrpc/svc.c	2007-01-23 11:13:46.000000000 +1100
+++ ./net/sunrpc/svc.c	2007-01-23 11:14:49.000000000 +1100
@@ -910,7 +910,8 @@ err_bad_prog:
 
 err_bad_vers:
 #ifdef RPC_PARANOIA
-	printk("svc: unknown version (%d)\n", vers);
+	printk("svc: unknown version (%d for prog %d, %s)\n",
+	       vers, prog, progp->pg_name);
 #endif
 	serv->sv_stats->rpcbadfmt++;
 	svc_putnl(resv, RPC_PROG_MISMATCH);
