Return-Path: <linux-kernel-owner+w=401wt.eu-S1751824AbZG0QhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbZG0QhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbZG0QhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:37:14 -0400
Received: from relay3.sgi.com ([192.48.156.57]:52053 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751097AbZG0QhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:37:13 -0400
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Message-Id: <8470E784-966F-4FFE-BA3A-D9B1A0963FB9@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
To: Julia Lawall <julia@diku.dk>
In-Reply-To: <Pine.LNX.4.64.0907271815060.2682@ask.diku.dk>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 10/12] fs/xfs: Correct redundant test
Date: Mon, 27 Jul 2009 11:37:13 -0500
References: <Pine.LNX.4.64.0907271815060.2682@ask.diku.dk>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 27, 2009, at 11:15 AM, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
>
> bp was tested for NULL a few lines before, followed by a return, and  
> there
> is no intervening modification of its value.
>
> A simplified version of the semantic match that finds this problem  
> is as
> follows: (http://www.emn.fr/x-info/coccinelle/)
>
> // <smpl>
> @r exists@
> local idexpression x;
> expression E;
> position p1,p2;
> @@
>
> if (x == NULL || ...) { ... when forall
>   return ...; }
> ... when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
> (
> *x == NULL
> |
> *x != NULL
> )
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>

Looks good. Thanks. I'll check it in.

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
>
> ---
> fs/xfs/xfs_trans_buf.c              |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 8ee2f8c..218829e 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -307,7 +307,7 @@ xfs_trans_read_buf(
> 			return (flags & XFS_BUF_TRYLOCK) ?
> 					EAGAIN : XFS_ERROR(ENOMEM);
>
> -		if ((bp != NULL) && (XFS_BUF_GETERROR(bp) != 0)) {
> +		if (XFS_BUF_GETERROR(bp) != 0) {
> 			xfs_ioerror_alert("xfs_trans_read_buf", mp,
> 					  bp, blkno);
> 			error = XFS_BUF_GETERROR(bp);
> @@ -315,7 +315,7 @@ xfs_trans_read_buf(
> 			return error;
> 		}
> #ifdef DEBUG
> -		if (xfs_do_error && (bp != NULL)) {
> +		if (xfs_do_error) {
> 			if (xfs_error_target == target) {
> 				if (((xfs_req_num++) % xfs_error_mod) == 0) {
> 					xfs_buf_relse(bp);

