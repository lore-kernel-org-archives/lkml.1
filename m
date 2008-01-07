Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbYAGQCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbYAGQCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYAGQC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:02:26 -0500
Received: from mail1.asahi-net.or.jp ([202.224.39.197]:18448 "EHLO
	mail.asahi-net.or.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753217AbYAGQCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:02:25 -0500
Message-ID: <47824D31.8040104@ak.jp.nec.com>
Date: Tue, 08 Jan 2008 01:02:57 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       KaiGai Kohei <kaigai@ak.jp.nec.com>
Subject: Re: [PATCH] fs/jffs2: Add missing call to posix_acl_release
References: <Pine.LNX.4.64.0801061749490.24950@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0801061749490.24950@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> posix_acl_clone does a memory allocation and sets a reference count, so
> posix_acl_release is needed afterwards to free it.
> 
> 
> The problem was fixed using the following semantic patch.
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> type T;
> identifier E;
> expression E1, E2;
> int ret;
> statement S;
> @@
> 
>   T E;
>   <+...
> (
>   E = \(posix_acl_clone\|posix_acl_alloc\|posix_acl_dup\)(...);
>   if (E == NULL) S
> |
>   if ((E = \(posix_acl_clone\|posix_acl_alloc\|posix_acl_dup\)(...)) == NULL) S
> )
>   ... when != E2 = E
>       when strict
> (
>   posix_acl_release(E);
> |
>   E1 = E;
> |
> + posix_acl_release(E);
>   return;
> |
> + posix_acl_release(E);
>   return ret;
> )
>   ...+>
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---
> 
> diff -u -p a/fs/jffs2/acl.c b/fs/jffs2/acl.c
> --- a/fs/jffs2/acl.c 2008-01-03 09:49:31.000000000 +0100
> +++ b/fs/jffs2/acl.c 2008-01-06 17:38:52.000000000 +0100
> @@ -345,8 +345,10 @@ int jffs2_init_acl_pre(struct inode *dir
>  		if (!clone)
>  			return -ENOMEM;
>  		rc = posix_acl_create_masq(clone, (mode_t *)i_mode);
> -		if (rc < 0)
> +		if (rc < 0) {
> +			posix_acl_release(clone);
>  			return rc;
> +		}
>  		if (rc > 0)
>  			jffs2_iset_acl(inode, &f->i_acl_access, clone);

Indeed, there was a possibility to cause memory leaking.

Acked-by: KaiGai Kohei <kaigai@ak.jp.nec.com>

-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>

