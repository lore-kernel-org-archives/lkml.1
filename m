Return-Path: <linux-kernel-owner+w=401wt.eu-S964814AbYBVVxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814AbYBVVxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932862AbYBVVoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:44:07 -0500
Received: from ns1.suse.de ([195.135.220.2]:46644 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764456AbYBVVoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:44:04 -0500
Date: Fri, 22 Feb 2008 13:40:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       Andreas Gruenbacher <agruen@suse.de>,
       Oliver Pinter <oliver.pntr@gmail.com>
Subject: [patch 19/23] knfsd: query filesystem for NFSv4 getattr of
	FATTR4_MAXNAME
Message-ID: <20080222214052.GT8686@suse.de>
References: <20080222213114.583282464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="knfsd-query-filesystem-for-nfsv4-getattr-of-fattr4_maxname.patch"
In-Reply-To: <20080222213927.GA8686@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: J. Bruce Fields <bfields@citi.umich.edu>

mainline: a16e92edcd0a2846455a30823e1bac964e743baa

Without this we always return 2^32-1 as the the maximum namelength.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
CC: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfsd/nfs4xdr.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1453,7 +1453,8 @@ nfsd4_encode_fattr(struct svc_fh *fhp, s
 	err = vfs_getattr(exp->ex_mnt, dentry, &stat);
 	if (err)
 		goto out_nfserr;
-	if ((bmval0 & (FATTR4_WORD0_FILES_FREE | FATTR4_WORD0_FILES_TOTAL)) ||
+	if ((bmval0 & (FATTR4_WORD0_FILES_FREE | FATTR4_WORD0_FILES_TOTAL |
+			FATTR4_WORD0_MAXNAME)) ||
 	    (bmval1 & (FATTR4_WORD1_SPACE_AVAIL | FATTR4_WORD1_SPACE_FREE |
 		       FATTR4_WORD1_SPACE_TOTAL))) {
 		err = vfs_statfs(dentry, &statfs);
@@ -1699,7 +1700,7 @@ out_acl:
 	if (bmval0 & FATTR4_WORD0_MAXNAME) {
 		if ((buflen -= 4) < 0)
 			goto out_resource;
-		WRITE32(~(u32) 0);
+		WRITE32(statfs.f_namelen);
 	}
 	if (bmval0 & FATTR4_WORD0_MAXREAD) {
 		if ((buflen -= 8) < 0)

-- 
