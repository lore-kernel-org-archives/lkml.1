Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166Ab0ANW2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab0ANW2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858Ab0ANW23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:28:29 -0500
Received: from kroah.org ([198.145.64.141]:60523 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708Ab0ANW2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:23 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/52] SUNRPC: Fix up an error return value in gss_import_sec_context_kerberos()
Date: Thu, 14 Jan 2010 14:26:48 -0800
Message-Id: <1263508051-7868-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-8-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 14ace024b1e16d2bb9445c8387494fbbd820a738 upstream.

If the context allocation fails, the function currently returns a random
error code, since the variable 'p' still points to a valid memory location.

Ensure that it returns ENOMEM...

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/sunrpc/auth_gss/gss_krb5_mech.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/auth_gss/gss_krb5_mech.c b/net/sunrpc/auth_gss/gss_krb5_mech.c
index ef45eba..2deb0ed 100644
--- a/net/sunrpc/auth_gss/gss_krb5_mech.c
+++ b/net/sunrpc/auth_gss/gss_krb5_mech.c
@@ -131,8 +131,10 @@ gss_import_sec_context_kerberos(const void *p,
 	struct	krb5_ctx *ctx;
 	int tmp;
 
-	if (!(ctx = kzalloc(sizeof(*ctx), GFP_NOFS)))
+	if (!(ctx = kzalloc(sizeof(*ctx), GFP_NOFS))) {
+		p = ERR_PTR(-ENOMEM);
 		goto out_err;
+	}
 
 	p = simple_get_bytes(p, end, &ctx->initiate, sizeof(ctx->initiate));
 	if (IS_ERR(p))
-- 
1.6.6

