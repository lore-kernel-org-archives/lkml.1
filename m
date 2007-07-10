Return-Path: <linux-kernel-owner+w=401wt.eu-S1763025AbXGJC3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763025AbXGJC3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762707AbXGJC2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:28:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34305 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762600AbXGJC2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:28:14 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 10 Jul 2007 12:28:10 +1000
Message-Id: <1070710022810.13598@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: J "." Bruce Fields <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 018 of 20] knfsd: nfsd4: secinfo handling without secinfo= option
References: <20070710121949.12548.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@citi.umich.edu>

We could return some sort of error in the case where someone asks for
secinfo on an export without the secinfo= option set--that'd be no worse
than what we've been doing.  But it's not really correct.  So, hack up
an approximate secinfo response in that case--it may not be complete,
but it'll tell the client at least one acceptable security flavor.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfs4xdr.c                  |   30 +++++++++++++++++++++++++++---
 ./include/linux/sunrpc/svcauth_gss.h |    1 +
 ./net/sunrpc/auth_gss/svcauth_gss.c  |    9 +++++++++
 3 files changed, 37 insertions(+), 3 deletions(-)

diff .prev/fs/nfsd/nfs4xdr.c ./fs/nfsd/nfs4xdr.c
--- .prev/fs/nfsd/nfs4xdr.c	2007-07-10 11:52:23.000000000 +1000
+++ ./fs/nfsd/nfs4xdr.c	2007-07-10 12:18:53.000000000 +1000
@@ -57,6 +57,7 @@
 #include <linux/nfs4.h>
 #include <linux/nfs4_acl.h>
 #include <linux/sunrpc/gss_api.h>
+#include <linux/sunrpc/svcauth_gss.h>
 
 #define NFSDDBG_FACILITY		NFSDDBG_XDR
 
@@ -2454,15 +2455,38 @@ nfsd4_encode_secinfo(struct nfsd4_compou
 {
 	int i = 0;
 	struct svc_export *exp = secinfo->si_exp;
+	u32 nflavs;
+	struct exp_flavor_info *flavs;
+	struct exp_flavor_info def_flavs[2];
 	ENCODE_HEAD;
 
 	if (nfserr)
 		goto out;
+	if (exp->ex_nflavors) {
+		flavs = exp->ex_flavors;
+		nflavs = exp->ex_nflavors;
+	} else { /* Handling of some defaults in absence of real secinfo: */
+		flavs = def_flavs;
+		if (exp->ex_client->flavour->flavour == RPC_AUTH_UNIX) {
+			nflavs = 2;
+			flavs[0].pseudoflavor = RPC_AUTH_UNIX;
+			flavs[1].pseudoflavor = RPC_AUTH_NULL;
+		} else if (exp->ex_client->flavour->flavour == RPC_AUTH_GSS) {
+			nflavs = 1;
+			flavs[0].pseudoflavor
+					= svcauth_gss_flavor(exp->ex_client);
+		} else {
+			nflavs = 1;
+			flavs[0].pseudoflavor
+					= exp->ex_client->flavour->flavour;
+		}
+	}
+
 	RESERVE_SPACE(4);
-	WRITE32(exp->ex_nflavors);
+	WRITE32(nflavs);
 	ADJUST_ARGS();
-	for (i = 0; i < exp->ex_nflavors; i++) {
-		u32 flav = exp->ex_flavors[i].pseudoflavor;
+	for (i = 0; i < nflavs; i++) {
+		u32 flav = flavs[i].pseudoflavor;
 		struct gss_api_mech *gm = gss_mech_get_by_pseudoflavor(flav);
 
 		if (gm) {

diff .prev/include/linux/sunrpc/svcauth_gss.h ./include/linux/sunrpc/svcauth_gss.h
--- .prev/include/linux/sunrpc/svcauth_gss.h	2007-07-10 11:19:39.000000000 +1000
+++ ./include/linux/sunrpc/svcauth_gss.h	2007-07-10 12:19:19.000000000 +1000
@@ -23,6 +23,7 @@ int gss_svc_init(void);
 void gss_svc_shutdown(void);
 int svcauth_gss_register_pseudoflavor(u32 pseudoflavor, char * name);
 void svcauth_gss_unregister_pseudoflavor(char *name);
+u32 svcauth_gss_flavor(struct auth_domain *dom);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_SUNRPC_SVCAUTH_GSS_H */

diff .prev/net/sunrpc/auth_gss/svcauth_gss.c ./net/sunrpc/auth_gss/svcauth_gss.c
--- .prev/net/sunrpc/auth_gss/svcauth_gss.c	2007-07-10 11:35:37.000000000 +1000
+++ ./net/sunrpc/auth_gss/svcauth_gss.c	2007-07-10 12:18:53.000000000 +1000
@@ -743,6 +743,15 @@ find_gss_auth_domain(struct gss_ctx *ctx
 
 static struct auth_ops svcauthops_gss;
 
+u32 svcauth_gss_flavor(struct auth_domain *dom)
+{
+	struct gss_domain *gd = container_of(dom, struct gss_domain, h);
+
+	return gd->pseudoflavor;
+}
+
+EXPORT_SYMBOL(svcauth_gss_flavor);
+
 int
 svcauth_gss_register_pseudoflavor(u32 pseudoflavor, char * name)
 {
