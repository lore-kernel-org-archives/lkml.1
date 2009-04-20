Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbZDTEme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbZDTEme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 00:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZDTEmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 00:42:21 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:38338 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbZDTEmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 00:42:19 -0400
Message-ID: <49EBFD18.4070607@suse.de>
Date: Mon, 20 Apr 2009 10:12:00 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: hooanon05@yahoo.co.jp
CC: Andrew Morton <akpm@linux-foundation.org>, " " <jamagallon@ono.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org,
       Trond.Myklebust@netapp.com, lists@fuchsschwanzdomain.de
Subject: Re: Problems with default ACLs over NFS
References: <20090323222427.00bb24e7@werewolf.home> <20090326170513.4e7d377a.akpm@linux-foundation.org> <18513.1238194255@jrobl>
In-Reply-To: <18513.1238194255@jrobl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hooanon05@yahoo.co.jp wrote:
>> On Mon, 23 Mar 2009 22:24:27 +0100 "J.A. Magall__n" <jamagallon@ono.com> wrote:
>>
>>> Hi all...
>>>
>>> I have a strange problem with 2.6.29-rc8-git3.
>>> It looks like a kernel bug... ?
>>>
>>> I have a box with NFS autofs-mounted home directories. Server is a
>>> Solaris 10 system. This worked in previous kernel versions, so I
>>> don't blame Solaris, at this moment.
>>>
>>> With this acls set in my home:
> 	:::
>>> I get this strange message in the linux client:
>>>
>>> cicely:~> mkdir kk  
>>> mkdir: cannot create directory `kk': Invalid argument

The following patch from Trond should fix this issue, I think.


From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 15 Apr 2009 13:58:45 -0400
Subject: [PATCH] NFS: Fix the XDR iovec calculation in nfs3_xdr_setaclargs

Commit ae46141ff08f1965b17c531b571953c39ce8b9e2 (NFSv3: Fix posix ACL code)
introduces a bug in the calculation of the XDR header iovec. In the case
where we are inlining the acls, we need to adjust the length of the iovec
req->rq_svec, in addition to adjusting the total buffer length.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/nfs3xdr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/nfs3xdr.c b/fs/nfs/nfs3xdr.c
index e6a1932..35869a4 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -713,7 +713,8 @@ nfs3_xdr_setaclargs(struct rpc_rqst *req, __be32 *p,
 	if (args->npages != 0)
 		xdr_encode_pages(buf, args->pages, 0, args->len);
 	else
-		req->rq_slen += args->len;
+		req->rq_slen = xdr_adjust_iovec(req->rq_svec,
+				p + XDR_QUADLEN(args->len));
 
 	err = nfsacl_encode(buf, base, args->inode,
 			    (args->mask & NFS_ACL) ?



> Tracing some kernel functions, I observed several thigs.
> - xdr_buf_subsegment() returned -1 due to 'len' is not 0.
> - xdr_encode_word() call from nfsacl_encode() got this -1, and
>   nfsacl_encode/nfs3_xdr_setaclargs/nfs3_proc_setacls/nfs3_proc_setacl/nfs3_setxattr
>   returned -EINVAL.
> 
> 
> Finally I am afraid this commit might be related to this issue.
> 
> commit ae46141ff08f1965b17c531b571953c39ce8b9e2
> Author: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date:   Tue Mar 10 20:33:18 2009 -0400
> 
>     NFSv3: Fix posix ACL code
>     
>     Fix a memory leak due to allocation in the XDR layer. In cases where the
>     RPC call needs to be retransmitted, we end up allocating new pages without
>     clearing the old ones. Fix this by moving the allocation into
>     nfs3_proc_setacls().
>     
>     Also fix an issue discovered by Kevin Rudd, whereby the amount of memory
>     reserved for the acls in the xdr_buf->head was miscalculated, and causing
>     corruption.
> 
> 
> 
> J. R. Okajima
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Suresh Jayaraman
