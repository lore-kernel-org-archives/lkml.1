Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbXF3XTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbXF3XTd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 19:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbXF3XSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 19:18:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:61012 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbXF3XSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 19:18:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=AFYB9hSc2Sjhzd64uh7BJQ8yfoQWcWGhjRjMLqqN2FXuSWbv1iji4toaMfeiNOGxzrF+Iqtuytyu4JOkp4LGnR2Q/6odDuN5sYOF/5jyKaNn7QuT5yjTrYBDciWfdy0Aekw/Oqeryacv1806bf+VjDgkzJJ15/utm4e7VHiXXaA=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][XFS][resend] fix memory leak in xfs_inactive()
Date: Sun, 1 Jul 2007 01:16:51 +0200
User-Agent: KMail/1.9.7
Cc: David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707010116.52012.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(this is back from May 16 2007, resending since it doesn't look like 
the patch ever made it in anywhere)


The Coverity checker found a memory leak in xfs_inactive().

The offending code is this bit :

1671            tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);

At conditional (1): "truncate != 0" taking true path

1672            if (truncate) {
1673                    /*
1674                     * Do the xfs_itruncate_start() call before
1675                     * reserving any log space because itruncate_start
1676                     * will call into the buffer cache and we can't
1677                     * do that within a transaction.
1678                     */
1679                    xfs_ilock(ip, XFS_IOLOCK_EXCL);
1680
1681                    error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0);

At conditional (2): "error != 0" taking true path

1682                    if (error) {
1683                            xfs_iunlock(ip, XFS_IOLOCK_EXCL);

Event leaked_storage: Returned without freeing storage "tp"
Also see events: [alloc_fn][var_assign]

1684                            return VN_INACTIVE_CACHE;
1685                    }

So, the code allocates a transaction, but in the case where 'truncate' is !=0 and xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0); happens to return an error, we'll just return from the function without dealing with the memory allocated byxfs_trans_alloc() and assigned to 'tp', thus it'll be orphaned/leaked - not good.

The bug was introduced by this commit:
http://git2.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d3cf209476b72c83907a412b6708c5e498410aa7

The patch below is

From: Dave Chinner <dgc@sgi.com>
Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 fs/xfs/xfs_vnodeops.c |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2007-05-11 16:04:03.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2007-05-17 12:37:25.671399078 +1000
@@ -1710,6 +1710,7 @@ xfs_inactive(
 
 		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0);
 		if (error) {
+			xfs_trans_cancel(tp, 0);
 			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 			return VN_INACTIVE_CACHE;
 		}
