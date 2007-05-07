Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbXEGAfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbXEGAfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 20:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbXEGAfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 20:35:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbXEGAfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 20:35:44 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 7 May 2007 10:35:21 +1000
Message-Id: <1070507003521.24086@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Cc: stable@kernel.org
Subject: [PATCH 002 of 8] knfsd: rpc: fix server-side wrapping of krb5i replies
References: <20070507103211.23855.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It's not necessarily correct to assume that the xdr_buf used to hold the
server's reply must have page data whenever it has tail data.

And there's no need for us to deal with that case separately anyway.

Acked-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Cc: stable@kernel.org

### Diffstat output
 ./net/sunrpc/auth_gss/svcauth_gss.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff .prev/net/sunrpc/auth_gss/svcauth_gss.c ./net/sunrpc/auth_gss/svcauth_gss.c
--- .prev/net/sunrpc/auth_gss/svcauth_gss.c	2007-05-07 10:30:18.000000000 +1000
+++ ./net/sunrpc/auth_gss/svcauth_gss.c	2007-05-07 10:30:38.000000000 +1000
@@ -1210,13 +1210,7 @@ svcauth_gss_wrap_resp_integ(struct svc_r
 	if (xdr_buf_subsegment(resbuf, &integ_buf, integ_offset,
 				integ_len))
 		BUG();
-	if (resbuf->page_len == 0
-			&& resbuf->head[0].iov_len + RPC_MAX_AUTH_SIZE
-			< PAGE_SIZE) {
-		BUG_ON(resbuf->tail[0].iov_len);
-		/* Use head for everything */
-		resv = &resbuf->head[0];
-	} else if (resbuf->tail[0].iov_base == NULL) {
+	if (resbuf->tail[0].iov_base == NULL) {
 		if (resbuf->head[0].iov_len + RPC_MAX_AUTH_SIZE > PAGE_SIZE)
 			goto out_err;
 		resbuf->tail[0].iov_base = resbuf->head[0].iov_base
