Return-Path: <linux-kernel-owner+w=401wt.eu-S1762435AbXEPV32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762435AbXEPV32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759457AbXEPV3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:29:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:23042 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758990AbXEPV3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:29:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=MibFGJhssUmMx5aFil6C43wj1oQ3UUEPcOfC9Jg0GvS35fxjJJz0odY9GX8rE5OgTAmQIRUhxujIzpiRSr9OJBVCluCCh7Rf4K6Zsbmh+FtOwKofJWLfRcC74i4n3xrWl/pCtAItJ7eWXTG093Y4cItOfbY7RIEtBBPjf2QTlFQ=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: xfs-masters@oss.sgi.com
Subject: [RFC][PATCH] XFS: memory leak in xfs_inactive() - is xfs_trans_free() enough or do we need xfs_trans_cancel() ?
Date: Wed, 16 May 2007 23:31:16 +0200
User-Agent: KMail/1.9.6
Cc: xfs@oss.sgi.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705162331.16429.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The Coverity checker found a memory leak in xfs_inactive().

The offending code is this bit : 

1671 		tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);

At conditional (1): "truncate != 0" taking true path

1672 		if (truncate) {
1673 			/*
1674 			 * Do the xfs_itruncate_start() call before
1675 			 * reserving any log space because itruncate_start
1676 			 * will call into the buffer cache and we can't
1677 			 * do that within a transaction.
1678 			 */
1679 			xfs_ilock(ip, XFS_IOLOCK_EXCL);
1680 	
1681 			error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0);

At conditional (2): "error != 0" taking true path

1682 			if (error) {
1683 				xfs_iunlock(ip, XFS_IOLOCK_EXCL);

Event leaked_storage: Returned without freeing storage "tp"
Also see events: [alloc_fn][var_assign]

1684 				return VN_INACTIVE_CACHE;
1685 			}

So, the code allocates a transaction, but in the case where 'truncate' is !=0 and xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0); happens to return an error, we'll just return from the function without dealing with the memory allocated byxfs_trans_alloc() and assigned to 'tp', thus it'll be orphaned/leaked - not good.

What I'm wondering is this; is it enough, at this point, to call xfs_trans_free(tp); (it would seem to me that would be OK, but I'm not intimite with this code) or do we need a full xfs_trans_cancel(tp, 0);  ???

In case I'm right and xfs_trans_free(tp); is all we need, then please consider the patch below. Otherwise please NACK the patch and I'll cook up another one :-)


Fix memory leak on error in xfs_inactive().

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
--- 
 fs/xfs/xfs_vnodeops.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index de17aed..e0d3d51 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1681,6 +1681,7 @@ xfs_inactive(
 		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0);
 		if (error) {
 			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+			xfs_trans_free(tp);
 			return VN_INACTIVE_CACHE;
 		}
 


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

