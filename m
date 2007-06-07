Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbXFGKIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbXFGKIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXFGKIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:08:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:39192 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbXFGKIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:08:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DMxSqEVBfe90JUARdiXTfyEK1DncKSFiNhCMoT01oNQUq2qIb2UKqhiHBg/0eoRCb6T6fszcIznhFzbWNPxcnaVEnxEyh/8+iT7EiWu62ANNAk5j6j2/uXCtjcUg97yCQX0cNyk6q1UlyYlKkSZInvHtFpysxkgQHrZs6E1N8jQ=
Message-ID: <9a8748490706070308m7c2212fq30fe712e26e2463b@mail.gmail.com>
Date: Thu, 7 Jun 2007 12:08:14 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: Surya <surya.prabhakar@wipro.com>
Subject: Re: [PATCH]: complete cleanup of check_region
Cc: emoenke@gwdg.de, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       kernel-janitors <kernel-janitors@lists.osdl.org>,
       trivial <trivial@kernel.org>, hannu@opensound.com
In-Reply-To: <1181209169.2422.12.camel@bluegenie>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1181209169.2422.12.camel@bluegenie>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/07, Surya <surya.prabhakar@wipro.com> wrote:
> Hi all,
>         This patch cleans up all the instances of check_region and
> __check_region and replaces them with request_region and
> __request_region. Applies and compiles clean on latest Linus tree.
>
> Files affected:
>         drivers/cdrom/sbpcd.c
>         drivers/pnp/resource.c
>         include/linux/ioport.h
>         kernel/resource.c
>         sound/oss/pss.c
>
>
> thanks.
>
>
> Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
> ---
>
> diff --git a/drivers/cdrom/sbpcd.c b/drivers/cdrom/sbpcd.c
> index a1283b1..2c1355e 100644
> --- a/drivers/cdrom/sbpcd.c
> +++ b/drivers/cdrom/sbpcd.c
> @@ -358,6 +358,11 @@
>   * Add bio/kdev_t changes for 2.5.x required to make it work again.
>   * Still room for improvement in the request handling here if anyone
>   * actually cares.  Bring your own chainsaw.    Paul G.  02/2002
> + *
> + *
> + * Cleaned up the reference for deprecated check_region to
> + * request_region.
> + * Thu Jun  7 12:14:00 IST 2007 Surya <surya.prabhakar@wipro.com>
>   */
>
>
> @@ -5670,7 +5675,7 @@ int __init sbpcd_init(void)
>         {
>                 addr[1]=sbpcd[port_index];
>                 if (addr[1]==0) break;
> -               if (check_region(addr[1],4))
> +               if (request_region(addr[1],4, "sbpcd driver"))

No!  You can't just swap one for the other.

check_region() simply checks if the region is available, it doesn't
reserve it (well, it does, briefly, but it lets it go again).
request_region() reserves the region. That's different behaviour that
you need to take into account.

Then there's the matter of return values. check_region() returns 0 on
success while request_region returns != 0 on success. I don't see your
patch dealing with that.

And finally, now that you request (and thus reserve) these regions,
where is the code to release them again when they are no longer
needed. just as memory allocated with kmalloc() needs to be freed with
kfree() after use, so regions reserved with request_region() need to
be released again with release_region() when they are no longer
needed. I don't see anything in your patch that releases the requested
regions.

Same comments for the rest of the patch.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
