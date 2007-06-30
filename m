Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbXF3XTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbXF3XTQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 19:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbXF3XSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 19:18:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:61012 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbXF3XSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 19:18:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=I4vjL3UrTV7ojORIi3wpSahMchvw3nuWo4Ju1Tp1UKeO0kRnk6Kg2QY9V2RBG4eXFh0NtZrSCeF43Fn/U8M+vsWx2fmOWyKhlZO+G5J1F8JQuEV57nSmK8p9AGEv7Mlpl6gyEbapMb+z12jSY1adzdz8G7rDohmGMf89nFCWnMU=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][XFS][resend] memory leak; allocated transaction not freed in xfs_inactive_free_eofblocks() in failure case.
Date: Sun, 1 Jul 2007 01:16:54 +0200
User-Agent: KMail/1.9.7
Cc: David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707010116.54884.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(this is back from May 16 2007, resending since it doesn't look like 
the patch ever made it in anywhere)


Fix XFS memory leak; allocated transaction not freed in xfs_inactive_free_eofblocks() in failure case.

the code allocates a transaction, but in the case where 'truncate' is
!=0 and xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0); happens to return
an error, we'll just return from the function without dealing with the
memory allocated byxfs_trans_alloc() and assigned to 'tp', thus it'll be
orphaned/leaked - not good.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
--- 
 fs/xfs/xfs_vnodeops.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index de17aed..32519cf 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1260,6 +1260,7 @@ xfs_inactive_free_eofblocks(
 		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE,
 				    ip->i_size);
 		if (error) {
+			xfs_trans_cancel(tp, 0);
 			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 			return error;
 		}


