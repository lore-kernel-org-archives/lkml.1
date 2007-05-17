Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbXEQCkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbXEQCkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 22:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbXEQCke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 22:40:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42183 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755574AbXEQCkd (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 22:40:33 -0400
Date: Thu, 17 May 2007 12:40:24 +1000
From: David Chinner <dgc@sgi.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] XFS: memory leak in xfs_inactive() - is xfs_trans_free() enough or do we need xfs_trans_cancel() ?
Message-ID: <20070517024024.GT85884050@sgi.com>
References: <200705162331.16429.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705162331.16429.jesper.juhl@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 11:31:16PM +0200, Jesper Juhl wrote:
> Hi,
> 
> The Coverity checker found a memory leak in xfs_inactive().
....
> So, the code allocates a transaction, but in the case where 'truncate' is
> !=0 and xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0); happens to return
> an error, we'll just return from the function without dealing with the
> memory allocated byxfs_trans_alloc() and assigned to 'tp', thus it'll be
> orphaned/leaked - not good.

Yeah, introduced by:

http://git2.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d3cf209476b72c83907a412b6708c5e498410aa7

Thanks for reporting the problem, Jesper.

> What I'm wondering is this; is it enough, at this point, to call
> xfs_trans_free(tp); (it would seem to me that would be OK, but I'm not
> intimite with this code) or do we need a full xfs_trans_cancel(tp, 0);  ???

xfs_trans_free() is not supposed to be called by anything but the transaction
code (it's static). So a xfs_trans_cancel() would need to be issued.

> In case I'm right and xfs_trans_free(tp); is all we need, then please
> consider the patch below. Otherwise please NACK the patch and I'll cook up
> another one :-)

NACK ;)

xfs_trans_cancel() is needed. Patch below.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

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
