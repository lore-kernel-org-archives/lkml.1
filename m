Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbZDWGlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbZDWGlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 02:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZDWGkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 02:40:53 -0400
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:36103 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbZDWGkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 02:40:52 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [PATCH v2] Fix i_mutex handling in nfsd readdir 
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20090422191244.GD9541@fieldses.org>
References: <1237475837.16359.106.camel@macbook.infradead.org> <8913.1237476890@jrobl> <1239960739.3428.33.camel@macbook.infradead.org> <20090417193233.GM26366@ZenIV.linux.org.uk> <1240006620.19059.41.camel@macbook.infradead.org> <20090417224350.GN26366@ZenIV.linux.org.uk> <20090417225306.GO26366@ZenIV.linux.org.uk> <1240013753.21423.86.camel@macbook.infradead.org> <1240144069.3589.156.camel@macbook.infradead.org> <7321.1240375306@jrobl> <20090422191244.GD9541@fieldses.org>
Date: Thu, 23 Apr 2009 15:40:23 +0900
Message-ID: <9180.1240468823@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"J. Bruce Fields":
> > Isn't it better to test it BEFORE fh_compose()?
	:::
> Yes, I think you're right.

Then here you are.

J. R. Okajima

----------------------------------------------------------------------

commit c98c6c4a207d602bd9498ea5f1d2993a00e98445
Author: J. R. Okajima <hooanon05@yahoo.co.jp>
Date:   Thu Apr 23 15:38:43 2009 +0900

    NFSD: test d_inode before fh_compose()
    
    After 2f9092e1020246168b1309b35e085ecd7ff9ff72 "Fix i_mutex vs. readdir
    handling in nfsd" (and 14f7dd63 "Copy XFS readdir hack into nfsd code"),
    an entry may be removed between the first mutex_unlock and the second
    mutex_lock. In this case, lookup_one_len() in compose_entry_fh() will
    return a negative dentry.
    It is better to test inode (positive/negative) BEFORE fh_compose().
    
    Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 17d0dd9..1b5543b 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -851,8 +851,8 @@ compose_entry_fh(struct nfsd3_readdirres *cd, struct svc_fh *fhp,
 	if (IS_ERR(dchild))
 		return 1;
 	if (d_mountpoint(dchild) ||
-	    fh_compose(fhp, exp, dchild, &cd->fh) != 0 ||
-	    !dchild->d_inode)
+	    !dchild->d_inode ||
+	    fh_compose(fhp, exp, dchild, &cd->fh) != 0)
 		rv = 1;
 	dput(dchild);
 	return rv;
