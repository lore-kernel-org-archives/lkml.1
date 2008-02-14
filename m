Return-Path: <linux-kernel-owner+w=401wt.eu-S1762336AbYBNRjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762336AbYBNRjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 12:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757130AbYBNRjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 12:39:05 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46229 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762099AbYBNRjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 12:39:01 -0500
Date: Thu, 14 Feb 2008 09:38:50 -0800
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/6] fs/direct-io.c: Use DIV_ROUND_UP
Message-ID: <20080214173850.GC14191@us.ibm.com>
References: <Pine.LNX.4.58.0802141614050.1185@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0802141614050.1185@pc-041.diku.dk>
X-Operating-System: Linux 2.6.24-09594-g7cf712d (x86_64)
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.02.2008 [16:14:33 +0100], Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
> (d)) but is perhaps more readable.
> 
> An extract of the semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @haskernel@
> @@
> 
> #include <linux/kernel.h>
> 
> @depends on haskernel@
> expression n,d;
> @@
> 
> (
> - (n + d - 1) / d
> + DIV_ROUND_UP(n,d)
> |
> - (n + (d - 1)) / d
> + DIV_ROUND_UP(n,d)
> )
> 
> @depends on haskernel@
> expression n,d;
> @@
> 
> - DIV_ROUND_UP((n),d)
> + DIV_ROUND_UP(n,d)
> 
> @depends on haskernel@
> expression n,d;
> @@
> 
> - DIV_ROUND_UP(n,(d))
> + DIV_ROUND_UP(n,d)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> 
> diff -u -p a/fs/direct-io.c b/fs/direct-io.c
> --- a/fs/direct-io.c 2008-02-08 08:58:17.000000000 +0100
> +++ b/fs/direct-io.c 2008-02-13 20:58:53.000000000 +0100
> @@ -976,7 +976,7 @@ direct_io_worker(int rw, struct kiocb *i
>  	for (seg = 0; seg < nr_segs; seg++) {
>  		user_addr = (unsigned long)iov[seg].iov_base;
>  		dio->pages_in_io +=
> -			((user_addr+iov[seg].iov_len +PAGE_SIZE-1)/PAGE_SIZE
> +			(DIV_ROUND_UP(user_addr + iov[seg].iov_len, PAGE_SIZE)
>  				- user_addr/PAGE_SIZE);

Is it just me, or does

	((user_addr + iov[seg].iov_len + PAGE_SIZE - 1)/PAGE_SIZE - user_addr/PAGE_SIZE)

not simplify to

	= ((iov[seg].iov_len + PAGE_SIZE - 1)/PAGE_SIZE + user_addr/PAGE_SIZE - user_addr/PAGE_SIZE)

	= ((iov[seg].iov_len + PAGE_SIZE - 1)/PAGE_SIZE)

	= DIV_ROUND_UP(iov[seg].iov_len, PAGE_SIZE)

CMIIW.

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
