Return-Path: <linux-kernel-owner+w=401wt.eu-S1030515AbXBLXpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030515AbXBLXpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030511AbXBLXpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:45:24 -0500
Received: from ns1.suse.de ([195.135.220.2]:53413 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030516AbXBLXpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:45:19 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 13 Feb 2007 10:44:26 +1100
Message-Id: <1070212234426.29285@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 005 of 9] knfsd: nfsd4: fix memory leak on kmalloc failure in savemem
References: <20070213103941.28958.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@snoopy.citi.umich.edu>
The wrong pointer is being kfree'd in savemem() when defer_free
returns with an error.

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfs4xdr.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff .prev/fs/nfsd/nfs4xdr.c ./fs/nfsd/nfs4xdr.c
--- .prev/fs/nfsd/nfs4xdr.c	2007-02-13 10:23:49.000000000 +1100
+++ ./fs/nfsd/nfs4xdr.c	2007-02-13 10:36:40.000000000 +1100
@@ -199,18 +199,16 @@ defer_free(struct nfsd4_compoundargs *ar
 
 static char *savemem(struct nfsd4_compoundargs *argp, __be32 *p, int nbytes)
 {
-	void *new = NULL;
 	if (p == argp->tmp) {
-		new = kmalloc(nbytes, GFP_KERNEL);
-		if (!new) return NULL;
-		p = new;
+		p = kmalloc(nbytes, GFP_KERNEL);
+		if (!p) return NULL;
 		memcpy(p, argp->tmp, nbytes);
 	} else {
 		BUG_ON(p != argp->tmpp);
 		argp->tmpp = NULL;
 	}
 	if (defer_free(argp, kfree, p)) {
-		kfree(new);
+		kfree(p);
 		return NULL;
 	} else
 		return (char *)p;
