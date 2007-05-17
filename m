Return-Path: <linux-kernel-owner+w=401wt.eu-S1762017AbXEQWw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762017AbXEQWw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757626AbXEQWwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:52:06 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:52519 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbXEQWwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:52:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=q+Ee5akpQ8pJsXKIoUmkzn5UI59+O8YmVEjZEg9vitrI52rQraEKdniq7J54xT3NOc8O22I8I1RFxp/8OWZiLYwhUp7F7SXqkDq01KBz0MRLbJ2zUb1wEu3Gm3D5uCNxwg7IMoLwO38Dky4DcotAeqeFKan7UyIhzrqPTBsRtp4=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: David Chinner <dgc@sgi.com>
Subject: Re: [RFC][PATCH] XFS: memory leak in xfs_inactive() - is xfs_trans_free() enough or do we need xfs_trans_cancel() ?
Date: Fri, 18 May 2007 00:53:55 +0200
User-Agent: KMail/1.9.6
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
References: <200705162331.16429.jesper.juhl@gmail.com> <20070517024024.GT85884050@sgi.com>
In-Reply-To: <20070517024024.GT85884050@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705180053.56070.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 May 2007 04:40:24 David Chinner wrote:
> On Wed, May 16, 2007 at 11:31:16PM +0200, Jesper Juhl wrote:
> > Hi,
> > 
> > The Coverity checker found a memory leak in xfs_inactive().
> ....
> > So, the code allocates a transaction, but in the case where 'truncate' is
> > !=0 and xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0); happens to return
> > an error, we'll just return from the function without dealing with the
> > memory allocated byxfs_trans_alloc() and assigned to 'tp', thus it'll be
> > orphaned/leaked - not good.
> 
> Yeah, introduced by:
> 
> http://git2.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d3cf209476b72c83907a412b6708c5e498410aa7
> 
> Thanks for reporting the problem, Jesper.
> 
You are welcome.

That commit introduces the same problem in xfs_inactive_free_eofblocks(). 
Patch to fix it below.

> > What I'm wondering is this; is it enough, at this point, to call
> > xfs_trans_free(tp); (it would seem to me that would be OK, but I'm not
> > intimite with this code) or do we need a full xfs_trans_cancel(tp, 0);  ???
> 
> xfs_trans_free() is not supposed to be called by anything but the transaction
> code (it's static). So a xfs_trans_cancel() would need to be issued.
> 
Makes sense. Thanks. I completely missed the static nature :-/



Fix XFS memory leak; allocated transaction not freed in xfs_inactive_free_eofblocks() in failure case.

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


