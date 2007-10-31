Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbXJaFrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbXJaFrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 01:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbXJaFrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 01:47:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40166 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbXJaFrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 01:47:22 -0400
Date: Wed, 31 Oct 2007 16:47:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Serge Hallyn <sergeh@us.ibm.com>
Cc: Venkat Yekkirala <vyekkirala@TrustedCS.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, <linux-kernel@vger.kernel.org>,
       <selinux@tycho.nsa.gov>
Subject: [PATCHv2] selinux: suppress a warning for 64k pages.
Message-Id: <20071031164719.77f48d75.sfr@canb.auug.org.au>
In-Reply-To: <20071031145744.6dd02cc7.sfr@canb.auug.org.au>
References: <20071031145744.6dd02cc7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On PowerPC allmodconfig build we get this:

security/selinux/xfrm.c:214: warning: comparison is always false due to limited range of data type

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 security/selinux/xfrm.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

This version suppresses the warning without ugly ifdefs.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 36a191e..e076039 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -211,26 +211,27 @@ static int selinux_xfrm_sec_ctx_alloc(struct xfrm_sec_ctx **ctxp,
 	if (uctx->ctx_doi != XFRM_SC_ALG_SELINUX)
 		return -EINVAL;
 
-	if (uctx->ctx_len >= PAGE_SIZE)
+	str_len = uctx->ctx_len;
+	if (str_len >= PAGE_SIZE)
 		return -ENOMEM;
 
 	*ctxp = ctx = kmalloc(sizeof(*ctx) +
-			      uctx->ctx_len + 1,
+			      str_len + 1,
 			      GFP_KERNEL);
 
 	if (!ctx)
 		return -ENOMEM;
 
 	ctx->ctx_doi = uctx->ctx_doi;
-	ctx->ctx_len = uctx->ctx_len;
+	ctx->ctx_len = str_len;
 	ctx->ctx_alg = uctx->ctx_alg;
 
 	memcpy(ctx->ctx_str,
 	       uctx+1,
-	       ctx->ctx_len);
-	ctx->ctx_str[ctx->ctx_len] = 0;
+	       str_len);
+	ctx->ctx_str[str_len] = 0;
 	rc = security_context_to_sid(ctx->ctx_str,
-				     ctx->ctx_len,
+				     str_len,
 				     &ctx->ctx_sid);
 
 	if (rc)
-- 
1.5.3.4

