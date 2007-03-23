Return-Path: <linux-kernel-owner+w=401wt.eu-S934245AbXCWAq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934245AbXCWAq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 20:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934246AbXCWAq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 20:46:56 -0400
Received: from ns1.suse.de ([195.135.220.2]:41399 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934245AbXCWAqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 20:46:54 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 23 Mar 2007 11:46:48 +1100
Message-Id: <1070323004648.28943@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 001 of 4] knfsd: Allow nfsd READDIR to return 64bit cookies
References: <20070323114512.28822.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


->readdir passes lofft_t offsets (used as nfs cookies) to
nfs3svc_encode_entry{,_plus}, but when they pass it on to
encode_entry it becomes an 'off_t', which isn't good.

So filesystems that returned 64bit offsets would lose.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfs3xdr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff .prev/fs/nfsd/nfs3xdr.c ./fs/nfsd/nfs3xdr.c
--- .prev/fs/nfsd/nfs3xdr.c	2007-03-23 11:13:15.000000000 +1100
+++ ./fs/nfsd/nfs3xdr.c	2007-03-23 11:13:15.000000000 +1100
@@ -887,8 +887,8 @@ compose_entry_fh(struct nfsd3_readdirres
 #define NFS3_ENTRY_BAGGAGE	(2 + 1 + 2 + 1)
 #define NFS3_ENTRYPLUS_BAGGAGE	(1 + 21 + 1 + (NFS3_FHSIZE >> 2))
 static int
-encode_entry(struct readdir_cd *ccd, const char *name,
-	     int namlen, off_t offset, ino_t ino, unsigned int d_type, int plus)
+encode_entry(struct readdir_cd *ccd, const char *name, int namlen,
+	     loff_t offset, ino_t ino, unsigned int d_type, int plus)
 {
 	struct nfsd3_readdirres *cd = container_of(ccd, struct nfsd3_readdirres,
 		       					common);
@@ -908,7 +908,7 @@ encode_entry(struct readdir_cd *ccd, con
 			*cd->offset1 = htonl(offset64 & 0xffffffff);
 			cd->offset1 = NULL;
 		} else {
-			xdr_encode_hyper(cd->offset, (u64) offset);
+			xdr_encode_hyper(cd->offset, offset64);
 		}
 	}
 
