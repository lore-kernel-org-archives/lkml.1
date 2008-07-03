Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbYGCTcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbYGCTcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 15:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbYGCTch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 15:32:37 -0400
Received: from mail.fieldses.org ([66.93.2.214]:45309 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbYGCTcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 15:32:36 -0400
Date: Thu, 3 Jul 2008 15:32:34 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       Aime Le Rouzic <aime.le-rouzic@bull.net>
Subject: [PATCH] svcrpc: fix handling of garbage args
Message-ID: <20080703193234.GB30918@fieldses.org>
References: <20080703192635.GA30918@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703192635.GA30918@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J. Bruce Fields <bfields@citi.umich.edu>

To return garbage_args, the accept_stat must be 0, and we must have a
verifier.  So we shouldn't be resetting the write pointer as we reject
the call.

Also, we must add the two placeholder words here regardless of success
of the unwrap, to ensure the output buffer is left in a consistent state
for svcauth_gss_release().

This fixes a BUG() in svcauth_gss.c:svcauth_gss_release().

Thanks to Aime Le Rouzic for bug report, debugging help, and testing.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Tested-by: Aime Le Rouzic <aime.le-rouzic@bull.net>
---
 net/sunrpc/auth_gss/svcauth_gss.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

Apologies, resending after I noticed Aime's address was mangled.

As before, also available from

	git://linux-nfs.org/~bfields/linux.git for-2.6.26

--b.

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 5905d56..81ae3d6 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1144,20 +1144,20 @@ svcauth_gss_accept(struct svc_rqst *rqstp, __be32 *authp)
 		case RPC_GSS_SVC_NONE:
 			break;
 		case RPC_GSS_SVC_INTEGRITY:
+			/* placeholders for length and seq. number: */
+			svc_putnl(resv, 0);
+			svc_putnl(resv, 0);
 			if (unwrap_integ_data(&rqstp->rq_arg,
 					gc->gc_seq, rsci->mechctx))
 				goto garbage_args;
+			break;
+		case RPC_GSS_SVC_PRIVACY:
 			/* placeholders for length and seq. number: */
 			svc_putnl(resv, 0);
 			svc_putnl(resv, 0);
-			break;
-		case RPC_GSS_SVC_PRIVACY:
 			if (unwrap_priv_data(rqstp, &rqstp->rq_arg,
 					gc->gc_seq, rsci->mechctx))
 				goto garbage_args;
-			/* placeholders for length and seq. number: */
-			svc_putnl(resv, 0);
-			svc_putnl(resv, 0);
 			break;
 		default:
 			goto auth_err;
@@ -1170,8 +1170,6 @@ svcauth_gss_accept(struct svc_rqst *rqstp, __be32 *authp)
 		goto out;
 	}
 garbage_args:
-	/* Restore write pointer to its original value: */
-	xdr_ressize_check(rqstp, reject_stat);
 	ret = SVC_GARBAGE;
 	goto out;
 auth_err:
-- 
1.5.5.rc1

