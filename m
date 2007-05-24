Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbXEXMD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbXEXMD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbXEXMDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:03:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:46922 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707AbXEXMDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:03:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tImk3Z6aVfqxqyiMaTU/7i1Ch/8+Y+akhk7wxG01bP9Qh+bWmTdCiK4bqERbgCI1d8Lzbet6q0Z0dwriFtkK8GINVL1i29IXlVKbQKkL8LY0ad7WKlMyU4YeGH3vM9cz3m0zZTfR7TI8Oc0S9RpCH8/lZ2KzsPGKhI1q5dmkKck=
Message-ID: <9a8748490705240503u25728daaj1b5ad010953b16a5@mail.gmail.com>
Date: Thu, 24 May 2007 14:03:16 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "David Chinner" <dgc@sgi.com>
Subject: Re: [RFC][PATCH] XFS: memory leak in xfs_inactive() - is xfs_trans_free() enough or do we need xfs_trans_cancel() ?
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>
In-Reply-To: <200705180053.56070.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705162331.16429.jesper.juhl@gmail.com>
	 <20070517024024.GT85884050@sgi.com>
	 <200705180053.56070.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Any chance the patches below that fix two mem leaks in XFS will make
it in in time for 2.6.22? I believe they should...

On 18/05/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> On Thursday 17 May 2007 04:40:24 David Chinner wrote:
> > On Wed, May 16, 2007 at 11:31:16PM +0200, Jesper Juhl wrote:
> > > Hi,
> > >
> > > The Coverity checker found a memory leak in xfs_inactive().
> > ....
> > > So, the code allocates a transaction, but in the case where 'truncate' is
> > > !=0 and xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0); happens to return
> > > an error, we'll just return from the function without dealing with the
> > > memory allocated byxfs_trans_alloc() and assigned to 'tp', thus it'll be
> > > orphaned/leaked - not good.
> >
> > Yeah, introduced by:
> >
> > http://git2.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d3cf209476b72c83907a412b6708c5e498410aa7
> >
> > Thanks for reporting the problem, Jesper.
> >
> You are welcome.
>
> That commit introduces the same problem in xfs_inactive_free_eofblocks().
> Patch to fix it below.
>
> > > What I'm wondering is this; is it enough, at this point, to call
> > > xfs_trans_free(tp); (it would seem to me that would be OK, but I'm not
> > > intimite with this code) or do we need a full xfs_trans_cancel(tp, 0);  ???
> >
> > xfs_trans_free() is not supposed to be called by anything but the transaction
> > code (it's static). So a xfs_trans_cancel() would need to be issued.
> >
> Makes sense. Thanks. I completely missed the static nature :-/
>
>
>
> Fix XFS memory leak; allocated transaction not freed in xfs_inactive_free_eofblocks() in failure case.
>
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
>  fs/xfs/xfs_vnodeops.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index de17aed..32519cf 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -1260,6 +1260,7 @@ xfs_inactive_free_eofblocks(
>                 error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE,
>                                     ip->i_size);
>                 if (error) {
> +                       xfs_trans_cancel(tp, 0);
>                         xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>                         return error;
>                 }
>
>

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
