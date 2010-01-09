Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766Ab0AIRet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab0AIRet (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 12:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472Ab0AIRet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 12:34:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841Ab0AIRes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 12:34:48 -0500
Date: Sat, 9 Jan 2010 09:34:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alexander Beregalov <a.beregalov@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/resource.c: fix memory leak
In-Reply-To: <1263048395-14873-1-git-send-email-a.beregalov@gmail.com>
Message-ID: <alpine.LFD.2.00.1001090933040.7821@localhost.localdomain>
References: <1263048395-14873-1-git-send-email-a.beregalov@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 9 Jan 2010, Alexander Beregalov wrote:
>
> Free res before exit.
> Found by cppcheck.
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
>  kernel/resource.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/resource.c b/kernel/resource.c
> index af96c1e..ae2e177 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -545,11 +545,12 @@ static void __init __reserve_region_with_split(struct resource *root,
>  	res->flags = IORESOURCE_BUSY;
>  
>  	conflict = __request_resource(parent, res);
> +	kfree(res);
> +
>  	if (!conflict)
>  		return;
>  
>  	/* failed, split and try again */
> -	kfree(res);

As Amerigo pointed out, this is very wrong indeed.

If we don't have a conflict, then __request_resource() will have inserted 
the resource into the resource tree, and we absolutely must _not_ free it.

So that cppcheck tool is way too simplistic, and wrong.

			Linus
