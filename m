Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbXGCUDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbXGCUDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758309AbXGCUD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:03:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55828 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757998AbXGCUD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:03:28 -0400
Date: Tue, 3 Jul 2007 13:03:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>
Subject: Re: [PATCH][isapnp] Fix a potential NULL pointer dereference in
 isapnp_read_tag()
Message-Id: <20070703130318.9dbec3ac.akpm@linux-foundation.org>
In-Reply-To: <200707010138.32075.jesper.juhl@gmail.com>
References: <200707010138.32075.jesper.juhl@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jul 2007 01:38:31 +0200
Jesper Juhl <jesper.juhl@gmail.com> wrote:

> The Coverity checker spotted (as bug #809) that we dereference 'type' 
> long before we actually test it against NULL in 
> drivers/pnp/isapnp/core.c::isapnp_read_tag() - both branches of the 
> 'if (tag & 0x80)' dereference type, and since this 'if' is before the test 
> against NULL and the return of -1, this will blow up is ever type is NULL.
> This is easy to fix by simply moving the NULL test to the beginning of 
> the function.
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
>  drivers/pnp/isapnp/core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
> diff --git a/drivers/pnp/isapnp/core.c b/drivers/pnp/isapnp/core.c
> index a0b1587..5696924 100644
> --- a/drivers/pnp/isapnp/core.c
> +++ b/drivers/pnp/isapnp/core.c
> @@ -356,6 +356,8 @@ static int __init isapnp_read_tag(unsigned char *type, unsigned short *size)
>  {
>  	unsigned char tag, tmp[2];
>  
> +	if (!type)	/* wrong type */
> +		return -1;
>  	isapnp_peek(&tag, 1);
>  	if (tag == 0)				/* invalid tag */
>  		return -1;
> @@ -370,8 +372,6 @@ static int __init isapnp_read_tag(unsigned char *type, unsigned short *size)
>  #if 0
>  	printk(KERN_DEBUG "tag = 0x%x, type = 0x%x, size = %i\n", tag, *type, *size);
>  #endif
> -	if (type == 0)				/* wrong type */
> -		return -1;
>  	if (*type == 0xff && *size == 0xffff)	/* probably invalid data */
>  		return -1;
>  	return 0;

dood, look at the callers.  NULL is not possible here.
