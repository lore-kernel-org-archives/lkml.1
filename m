Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753609AbYLPV4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbYLPV4W (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 16:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbYLPV4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:56:09 -0500
Received: from smtp-out.google.com ([216.239.45.13]:52575 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbYLPV4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:56:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=UqwVPvopPaaSp0eQk0GzOGuZSrUd8dNqlVuK0h2yfLQclWiMjh49E+CXBj5kXmQQU
	5S6H1Jb6VP6vIxOfCT/nA==
Message-ID: <49482394.10006@google.com>
Date: Tue, 16 Dec 2008 13:54:28 -0800
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Oren Laadan <orenl@cs.columbia.edu>
CC: jeremy@goop.org, arnd@arndb.de, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Linux Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC v11][PATCH 03/13] General infrastructure for checkpoint
 restart
References: <1228498282-11804-1-git-send-email-orenl@cs.columbia.edu> <1228498282-11804-4-git-send-email-orenl@cs.columbia.edu>
In-Reply-To: <1228498282-11804-4-git-send-email-orenl@cs.columbia.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.75
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oren Laadan wrote:
> diff --git a/checkpoint/sys.c b/checkpoint/sys.c
> index 375129c..bd14ef9 100644
> --- a/checkpoint/sys.c
> +++ b/checkpoint/sys.c

> +/*
> + * During checkpoint and restart the code writes outs/reads in data
> + * to/from the checkpoint image from/to a temporary buffer (ctx->hbuf).
> + * Because operations can be nested, use cr_hbuf_get() to reserve space
> + * in the buffer, then cr_hbuf_put() when you no longer need that space.
> + */

This seems a bit over-kill for buffer management no?  The only large 
header seems to be cr_hdr_head and the blowup comes from utsinfo string 
data (which could easily be moved out to be in it's own CR_HDR_STRING 
blocks).

Wouldn't it be easier to use stack-local storage than balancing the 
cr_hbuf_get/put routines?

> +
> +/*
> + * ctx->hbuf is used to hold headers and data of known (or bound),
> + * static sizes. In some cases, multiple headers may be allocated in
> + * a nested manner. The size should accommodate all headers, nested
> + * or not, on all archs.
> + */
> +#define CR_HBUF_TOTAL  (8 * 4096)
> +
> +/**
> + * cr_hbuf_get - reserve space on the hbuf
> + * @ctx: checkpoint context
> + * @n: number of bytes to reserve
> + *
> + * Returns pointer to reserved space
> + */
> +void *cr_hbuf_get(struct cr_ctx *ctx, int n)
> +{
> +	void *ptr;
> +
> +	/*
> +	 * Since requests depend on logic and static header sizes (not on
> +	 * user data), space should always suffice, unless someone either
> +	 * made a structure bigger or call path deeper than expected.
> +	 */
> +	BUG_ON(ctx->hpos + n > CR_HBUF_TOTAL);
> +	ptr = ctx->hbuf + ctx->hpos;
> +	ctx->hpos += n;
> +	return ptr;
> +}
> +
> +/**
> + * cr_hbuf_put - unreserve space on the hbuf
> + * @ctx: checkpoint context
> + * @n: number of bytes to reserve
> + */
> +void cr_hbuf_put(struct cr_ctx *ctx, int n)
> +{
> +	BUG_ON(ctx->hpos < n);
> +	ctx->hpos -= n;
> +}
> +
