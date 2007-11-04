Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbXKDSMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbXKDSMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 13:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbXKDSMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 13:12:23 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:57311 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbXKDSMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 13:12:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=W9ek4piIhQcc2SFA0x55sEcBoeCK7DhJjbmu1Neyo20EQpJk4woGCfVad1uYjREukoNQ3Q1uCGFQ45kYm5DBSOGjcAk0MwQDlcsZLQUt/1HhiYJHVhKuaY8wtpjGkWeBDyIfn4Y84JUhbVolTONK6qltISQmO4y4ptQ4JTPWEQU=
Message-ID: <c0526ddf0711041012x7b41269x12a05ddb6e03a04d@mail.gmail.com>
Date: Sun, 4 Nov 2007 11:12:22 -0700
From: "Michael Marineau" <mike@marineau.org>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [PATCH, RESEND] tmpfs: fix mounts when size is less than the page size
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
In-Reply-To: <Pine.LNX.4.64.0711041202260.4631@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11941279021705-git-send-email-mike@marineau.org>
	 <11941336124117-git-send-email-mike@marineau.org>
	 <Pine.LNX.4.64.0711041202260.4631@blonde.wat.veritas.com>
X-Google-Sender-Auth: 5617079c868eb5bb
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/4/07, Hugh Dickins <hugh@veritas.com> wrote:
> Fair enough, that does match the documentation of "size=0" better.
> Though either way, someone who typos is going to get one kind of surprise
> or another.  Do you mind if we do it slightly differently, achieving the
> same effect without a special case, by rounding up instead of down?

Sounds reasonable to me. I didn't know about DIV_ROUND_UP :-)

>
>
> From: Michael Marineau <mike@marineau.org>
>
> When tmpfs is mounted with a size less than one page, the number of blocks
> is set to 0 which makes the tmpfs mount unlimited. This can lead to a quick
> and surprising death if someone typos a tmpfs mount command and writes too
> much.
>
> tmpfs can still be mounted as unlimited if size or nr_blocks is exactly 0,
> as Documentation/filesystems/tmpfs.txt says.
>
> Hugh: do this by rounding size up instead of down in all cases: which
> slightly expands other odd-sized tmpfs mounts, but in a consistent way.
>
> Signed-off-by: Michael Marineau <mike@marineau.org>
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
>
>  mm/shmem.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- 2.6.24-rc1-git/mm/shmem.c   2007-10-31 06:18:05.000000000 +0000
> +++ linux/mm/shmem.c    2007-11-04 11:46:09.000000000 +0000
> @@ -2137,7 +2137,7 @@ static int shmem_parse_options(char *opt
>                         }
>                         if (*rest)
>                                 goto bad_val;
> -                       *blocks = size >> PAGE_CACHE_SHIFT;
> +                       *blocks = DIV_ROUND_UP(size, PAGE_CACHE_SIZE);
>                 } else if (!strcmp(this_char,"nr_blocks")) {
>                         *blocks = memparse(value,&rest);
>                         if (*rest)
>


-- 
Michael Marineau
Oregon State University
mike@marineau.org
