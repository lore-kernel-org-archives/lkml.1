Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbXGTKJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbXGTKJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 06:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbXGTKJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 06:09:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:28353 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbXGTKJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 06:09:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k7ENADqDsyWNjjC+rQka5x4qktKoAIa/m/rUNHo+ighmUYXJVNum9kBWoqL2EZvZl0Q8XC1/lm3307ecpW3hTvpF37aE7t2haPZ4NFQUrmsPhnu5P8wggCSOM1chRQtYgEApv2dh1ZVE21jpICZhCrjNxJqN3zRYafUmjysub2s=
Message-ID: <a8e1da0707200309n377eca1fwa640eeceb920959b@mail.gmail.com>
Date: Fri, 20 Jul 2007 10:09:10 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Denis Cheng" <crquan@gmail.com>
Subject: Re: [PATCH] fs/fuse/dev.c: use zero_user_page instead
Cc: "Miklos Szeredi" <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <11849242706-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11849242706-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 7/20/07, Denis Cheng <crquan@gmail.com> wrote:
> Signed-off-by: Denis Cheng <crquan@gmail.com>
> ---
> I'm not very sure zero_user_page is correctly used here,
> so please feel free to give comments.
>
> and why here it uses KM_USER1 not KM_USER0, What are the differences?
>
>  fs/fuse/dev.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 3ad22be..e55b5e8 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -533,11 +533,9 @@ static int fuse_copy_do(struct fuse_copy_state *cs, void **val, unsigned *size)
>  static int fuse_copy_page(struct fuse_copy_state *cs, struct page *page,
>                           unsigned offset, unsigned count, int zeroing)
>  {
> -       if (page && zeroing && count < PAGE_SIZE) {
> -               void *mapaddr = kmap_atomic(page, KM_USER1);
> -               memset(mapaddr, 0, PAGE_SIZE);
> -               kunmap_atomic(mapaddr, KM_USER1);
> -       }
> +       if (page && zeroing && count < PAGE_SIZE)
> +               zero_user_page(page, 0, PAGE_SIZE, KM_USER1);
Why clear all page? IMHO,only count bytes need to be cleared.
> +
>         while (count) {
>                 int err;
>                 if (!cs->len && (err = fuse_copy_fill(cs)))
