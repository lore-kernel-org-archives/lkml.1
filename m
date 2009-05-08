Return-Path: <linux-kernel-owner+w=401wt.eu-S1761773AbZEHBJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761773AbZEHBJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 21:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbZEHBJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 21:09:39 -0400
Received: from sandeen.net ([209.173.210.139]:20196 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbZEHBJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 21:09:37 -0400
Message-ID: <4A038651.5010202@sandeen.net>
Date: Thu, 07 May 2009 20:09:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Felix Blyakher <felixb@sgi.com>
CC: Alexander Beregalov <a.beregalov@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com
Subject: Re: 2.6.30-rc4: xfs_fsr hangs
References: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com> <4A036FBC.9020201@sandeen.net> <4A037503.1070904@sandeen.net> <ABCCDF18-5100-4891-AF1C-BA9513C8A334@sgi.com>
In-Reply-To: <ABCCDF18-5100-4891-AF1C-BA9513C8A334@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felix Blyakher wrote:

> I've been chasing this as well, and I found the double xfs iolock
> unlock which is causing xfs_fsr deadlock itself. I have a fix tested.
> The patch is coming.
>
> Felix
>   
Oh :)  I just sent this one to the list ...  :)

XFS: Fix double unlock of inodes in xfs_swap_extents()

commit ef8f7fc549bf345d92f396f5aa7b152b4969cbf7 had an error
where we would try to re-unlock the inodes after they had been
committed in the transaction; this double unlock caused a

=====================================
[ BUG: bad unlock balance detected! ]
-------------------------------------
xfs_fsr/1459 is trying to release lock (&(&ip->i_iolock)->mr_lock) at:
[<e248dedb>] xfs_iunlock+0x2c/0x92 [xfs]
but there are no more locks to release!

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6/fs/xfs/xfs_dfrag.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dfrag.c
+++ linux-2.6/fs/xfs/xfs_dfrag.c
@@ -347,13 +347,15 @@ xfs_swap_extents(
 
 	error = xfs_trans_commit(tp, XFS_TRANS_SWAPEXT);
 
-out_unlock:
-	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 out:
 	kmem_free(tempifp);
 	return error;
 
+out_unlock:
+	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	goto out;
+
 out_trans_cancel:
 	xfs_trans_cancel(tp, 0);
 	goto out_unlock;





