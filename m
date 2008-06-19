Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbYFSALZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbYFSALZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbYFSALR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:11:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35518 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbYFSALQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:11:16 -0400
From: NeilBrown <neilb@suse.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Date: Thu, 19 Jun 2008 10:11:09 +1000
Message-Id: <1080619001109.24338@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH - take 2] knfsd: nfsd: Handle ERESTARTSYS from syscalls.
References: <20080619101025.24263.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OCFS2 can return -ERESTARTSYS from write requests (and possibly
elsewhere) if there is a signal pending.

If nfsd is shutdown (by sending a signal to each thread) while there
is still an IO load from the client, each thread could handle one last
request with a signal pending.  This can result in -ERESTARTSYS
which is not understood by nfserrno() and so is reflected back to
the client as nfserr_io aka -EIO.  This is wrong.

Instead, interpret ERESTARTSYS to mean "try again later" by returning
nfserr_jukebox.  The client will resend and - if the server is
restarted - the write will (hopefully) be successful and everyone will
be happy.

 The symptom that I narrowed down to this was:
    copy a large file via NFS to an OCFS2 filesystem, and restart
    the nfs server during the copy.
    The 'cp' might get an -EIO, and the file will be corrupted -
    presumably holes in the middle where writes appeared to fail.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfsproc.c |    1 +
 1 file changed, 1 insertion(+)

diff .prev/fs/nfsd/nfsproc.c ./fs/nfsd/nfsproc.c
--- .prev/fs/nfsd/nfsproc.c	2008-06-19 10:06:36.000000000 +1000
+++ ./fs/nfsd/nfsproc.c	2008-06-19 10:07:58.000000000 +1000
@@ -614,6 +614,7 @@ nfserrno (int errno)
 #endif
 		{ nfserr_stale, -ESTALE },
 		{ nfserr_jukebox, -ETIMEDOUT },
+		{ nfserr_jukebox, -ERESTARTSYS },
 		{ nfserr_dropit, -EAGAIN },
 		{ nfserr_dropit, -ENOMEM },
 		{ nfserr_badname, -ESRCH },
