Return-Path: <linux-kernel-owner+w=401wt.eu-S1763375AbXHVJIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763375AbXHVJIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758875AbXHVIxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:47 -0400
Received: from 1wt.eu ([62.212.114.60]:2163 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757632AbXHVIxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:44 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084032.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:26 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>, Neil Brown <neilb@suse.de>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 42/58] nfsd: fix possible oops on re-insertion of rpcsec_gss modules
Content-Disposition: inline; filename=0042-nfsd-fix-possible-oops-on-re-insertion-of-rpcsec_gs.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The handling of the re-registration case is wrong here; the "test" that was
returned from auth_domain_lookup will not be used again, so that reference
should be put.  And auth_domain_lookup never did anything with "new" in
this case, so we should just clean it up ourself.

Thanks to Akinobu Mita for bug report, analysis, and testing.

Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/sunrpc/auth_gss/svcauth_gss.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 066c64a..6179767 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -760,11 +760,12 @@ svcauth_gss_register_pseudoflavor(u32 pseudoflavor, char * name)
 	new->h.flavour = &svcauthops_gss;
 	new->pseudoflavor = pseudoflavor;
 
+	stat = 0;
 	test = auth_domain_lookup(name, &new->h);
-	if (test != &new->h) { /* XXX Duplicate registration? */
-		auth_domain_put(&new->h);
-		/* dangling ref-count... */
-		goto out;
+	if (test != &new->h) { /* Duplicate registration */
+		auth_domain_put(test);
+		kfree(new->h.name);
+		goto out_free_dom;
 	}
 	return 0;
 
-- 
1.5.2.5

-- 
