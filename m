Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbXEGAiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbXEGAiF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 20:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbXEGAgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 20:36:14 -0400
Received: from ns2.suse.de ([195.135.220.15]:57792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbXEGAgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 20:36:00 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 7 May 2007 10:35:27 +1000
Message-Id: <1070507003527.24108@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Frank Filz <ffilzlnx@us.ibm.com>
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 003 of 8] knfsd: Fix resource leak resulting in module refcount leak for	rpcsec_gss_krb5.ko
References: <20070507103211.23855.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Frank Filz <ffilzlnx@us.ibm.com>

I have been investigating a module reference count leak on the server
for rpcsec_gss_krb5.ko. It turns out the problem is a reference count
leak for the security context in net/sunrpc/auth_gss/svcauth_gss.c.

The problem is that gss_write_init_verf() calls gss_svc_searchbyctx()
which does a rsc_lookup() but never releases the reference to the
context. There is another issue that rpc.svcgssd sets an "end of time"
expiration for the context

By adding a cache_put() call in gss_svc_searchbyctx(), and setting an
expiration timeout in the downcall, cache_clean() does clean up the
context and the module reference count now goes to zero after unmount.

I also verified that if the context expires and then the client makes a
new request, a new context is established.

Here is the patch to fix the kernel, I will start a separate thread to
discuss what expiration time should be set by rpc.svcgssd.

Acked-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Frank Filz <ffilzlnx@us.ibm.com>

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c
b/net/sunrpc/auth_gss/svcauth_gss.c
index db298b5..eb16e30 100644
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./net/sunrpc/auth_gss/svcauth_gss.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff .prev/net/sunrpc/auth_gss/svcauth_gss.c ./net/sunrpc/auth_gss/svcauth_gss.c
--- .prev/net/sunrpc/auth_gss/svcauth_gss.c	2007-05-07 10:30:38.000000000 +1000
+++ ./net/sunrpc/auth_gss/svcauth_gss.c	2007-05-07 10:31:03.000000000 +1000
@@ -938,6 +938,7 @@ static inline int
 gss_write_init_verf(struct svc_rqst *rqstp, struct rsi *rsip)
 {
 	struct rsc *rsci;
+	int        rc;
 
 	if (rsip->major_status != GSS_S_COMPLETE)
 		return gss_write_null_verf(rqstp);
@@ -946,7 +947,9 @@ gss_write_init_verf(struct svc_rqst *rqs
 		rsip->major_status = GSS_S_NO_CONTEXT;
 		return gss_write_null_verf(rqstp);
 	}
-	return gss_write_verf(rqstp, rsci->mechctx, GSS_SEQ_WIN);
+	rc = gss_write_verf(rqstp, rsci->mechctx, GSS_SEQ_WIN);
+	cache_put(&rsci->h, &rsc_cache);
+	return rc;
 }
 
 /*
