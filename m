Return-Path: <linux-kernel-owner+w=401wt.eu-S932103AbXGKQ0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbXGKQ0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 12:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbXGKQ0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 12:26:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:40419 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbXGKQ0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 12:26:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=oeNB5ypTh8r7LaoHjFFIjq/ooKljnu3H6hTavcz6NJGqopRLgjUkGU42mMsqOdTlH4MTEKMygdKFM1OJ6L99flTDXwmtLpxvwpdfqQ7MRojtqWqspsubASkS3iaYTZeXq0J5ecBmDu6mD69cIeoC2oCap4TwBkKJDpSCRKy7iIY=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix a potential NULL pointer deref in XFS on failed mount.
Date: Wed, 11 Jul 2007 18:25:50 +0200
User-Agent: KMail/1.9.7
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707111825.51169.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

Back in 2006 (2006-10-31 to be specific, reposted on 2006-11-16), I 
submitted a patch to fix a potential NULL pointer deref in XFS on 
failed mount.

The patch drew some comments and it turned out that my initial 
approach to a fix was wrong.
David Chinner kindly offered some tips on how to implement a proper 
fix, and on 2006-11-20 I submitted a revised fix.  This patch, 
unfortunately, didn't draw any comments, nor did it ever get merged 
anywhere.  
I believe that now sufficient time has passed to warrent a repost ;-)



The Coverity checker spotted (as bug #346) a potential problem in XFS.

The problem is that if, in xfs_mount(), this code triggers:

       ...
       if (!mp->m_logdev_targp)
               goto error0;
       ...

Then we'll end up calling xfs_unmountfs_close() with a NULL
'mp->m_logdev_targp'.
This in turn will result in a call to xfs_free_buftarg() with its 'btp'
argument == NULL. xfs_free_buftarg() dereferences 'btp' leading to
a NULL pointer dereference and crash.

I think this can happen, since the fatal call to xfs_free_buftarg()
happens when 'm_logdev_targp != m_ddev_targp' and due to a check of
'm_ddev_targp' against NULL in xfs_mount() (and subsequent return if it is
NULL) the two will never both be NULL when we hit the error0 label from
the two lines cited above.

This patch fixes the issue by checking mp->m_logdev_targp against NULL 
in xfs_unmountfs_close() and doing the proper xfs_blkdev_put(logdev); 
and xfs_blkdev_put(rtdev); on (!mp->m_rtdev_targp) in xfs_mount().

Compile tested.

Comments and feedback welcome.

Please consider merging.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 fs/xfs/xfs_mount.c  |    2 +-
 fs/xfs/xfs_vfsops.c |   10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index a96bde6..dfe45c3 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1132,7 +1132,7 @@ xfs_unmountfs(xfs_mount_t *mp, struct cred *cr)
 void
 xfs_unmountfs_close(xfs_mount_t *mp, struct cred *cr)
 {
-	if (mp->m_logdev_targp != mp->m_ddev_targp)
+	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_free_buftarg(mp->m_logdev_targp, 1);
 	if (mp->m_rtdev_targp)
 		xfs_free_buftarg(mp->m_rtdev_targp, 1);
diff --git a/fs/xfs/xfs_vfsops.c b/fs/xfs/xfs_vfsops.c
index 65c5612..92fd965 100644
--- a/fs/xfs/xfs_vfsops.c
+++ b/fs/xfs/xfs_vfsops.c
@@ -473,13 +473,19 @@ xfs_mount(
 	}
 	if (rtdev) {
 		mp->m_rtdev_targp = xfs_alloc_buftarg(rtdev, 1);
-		if (!mp->m_rtdev_targp)
+		if (!mp->m_rtdev_targp) {
+			xfs_blkdev_put(logdev);
+			xfs_blkdev_put(rtdev);
 			goto error0;
+		}
 	}
 	mp->m_logdev_targp = (logdev && logdev != ddev) ?
 				xfs_alloc_buftarg(logdev, 1) : mp->m_ddev_targp;
-	if (!mp->m_logdev_targp)
+	if (!mp->m_logdev_targp) {
+		xfs_blkdev_put(logdev);
+		xfs_blkdev_put(rtdev);
 		goto error0;
+	}
 
 	/*
 	 * Setup flags based on mount(2) options and then the superblock



(Please keep me on Cc when replying)


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html


