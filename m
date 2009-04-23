Return-Path: <linux-kernel-owner+w=401wt.eu-S1760623AbZDWIAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623AbZDWIAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 04:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757736AbZDWHgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:36:44 -0400
Received: from sous-sol.org ([216.99.217.87]:47508 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757727AbZDWHgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:36:43 -0400
Message-Id: <20090423073113.109730239@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:56 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [patch 096/100] NFS: Fix the XDR iovec calculation in nfs3_xdr_setaclargs
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=nfs-fix-the-xdr-iovec-calculation-in-nfs3_xdr_setaclargs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

upstream commit: 8340437210390676f687633a80e3748c40885dc8

Commit ae46141ff08f1965b17c531b571953c39ce8b9e2 (NFSv3: Fix posix ACL code)
introduces a bug in the calculation of the XDR header iovec. In the case
where we are inlining the acls, we need to adjust the length of the iovec
req->rq_svec, in addition to adjusting the total buffer length.

Tested-by: Leonardo Chiquitto <leonardo.lists@gmail.com>
Tested-by: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/nfs/nfs3xdr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -716,7 +716,8 @@ nfs3_xdr_setaclargs(struct rpc_rqst *req
 	if (args->npages != 0)
 		xdr_encode_pages(buf, args->pages, 0, args->len);
 	else
-		req->rq_slen += args->len;
+		req->rq_slen = xdr_adjust_iovec(req->rq_svec,
+				p + XDR_QUADLEN(args->len));
 
 	err = nfsacl_encode(buf, base, args->inode,
 			    (args->mask & NFS_ACL) ?

