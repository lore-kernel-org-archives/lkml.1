Return-Path: <linux-kernel-owner+w=401wt.eu-S1752859AbXJaD54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbXJaD54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 23:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbXJaD5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 23:57:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48838 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbXJaD5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 23:57:46 -0400
Date: Wed, 31 Oct 2007 14:57:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Serge Hallyn <sergeh@us.ibm.com>, Trent Jaeger <jaegert@us.ibm.com>
Cc: Venkat Yekkirala <vyekkirala@TrustedCS.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, <linux-kernel@vger.kernel.org>,
       <selinux@tycho.nsa.gov>
Subject: [PATCH] selinux: suppress a warning for 64k pages.
Message-Id: <20071031145744.6dd02cc7.sfr@canb.auug.org.au>
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
 security/selinux/xfrm.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 36a191e..602beb0 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -211,8 +211,11 @@ static int selinux_xfrm_sec_ctx_alloc(struct xfrm_sec_ctx **ctxp,
 	if (uctx->ctx_doi != XFRM_SC_ALG_SELINUX)
 		return -EINVAL;
 
+	/* ctx_len is __u16 */
+#if PAGE_SIZE < (1 << 16)
 	if (uctx->ctx_len >= PAGE_SIZE)
 		return -ENOMEM;
+#endif
 
 	*ctxp = ctx = kmalloc(sizeof(*ctx) +
 			      uctx->ctx_len + 1,
-- 
1.5.3.4

