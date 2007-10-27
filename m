Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbXJ0LrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbXJ0LrT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 07:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbXJ0LrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 07:47:11 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:55901 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbXJ0LrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 07:47:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=pp1bKeaqkB22tAg1wZTnaQOM1ijSTJ7dy5YuB3z5GFI4T6E3KzkiheRylRxtjJi8psG41336txEVVZaa6LHYydLArEtxY7JYrDkb7HfQW88ZM9MD9L6Gu61nWsWUuQJfPMFKAMLFolpKEBKbYRQAmJT9n4hQmTLIoumkIIFJy1A=
Message-ID: <84144f020710270447m6f77848fl1f0c43312d172309@mail.gmail.com>
Date: Sat, 27 Oct 2007 14:47:09 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Cc: "Matthew Wilcox" <matthew@wil.cx>, "Linus Torvalds" <torvalds@osdl.org>,
       "Andrew Morton" <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Matthew Wilcox" <willy@linux.intel.com>
In-Reply-To: <200710261211.01423.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024195847.GE27248@parisc-linux.org>
	 <1193255992-14385-1-git-send-email-matthew@wil.cx>
	 <200710261211.01423.rusty@rustcorp.com.au>
X-Google-Sender-Auth: 5a2742ac25eec7b4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On 10/26/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
>        This just seems like more optimization and complexity that we need.  Interfaces
> using vsnprintf don't seem like good candidates for optimization.
>
> How about this?  It's as simple as I could make it...

FWIW I like this patch better.

On 10/26/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> +void sb_printf_append(struct stringbuf **sb, gfp_t gfp, const char *fmt, ...)
> +{
> +       unsigned int fmtlen, len;
> +       va_list args;
> +       struct stringbuf *oldsb = *sb;
> +
> +       if (oldsb->buf == enomem_string)
> +               return;
> +
> +       va_start(args, fmt);
> +       fmtlen = vsnprintf(NULL, 0, fmt, args);
> +       va_end(args);
> +
> +       len = oldsb ? strlen(oldsb->buf) : 0;
> +       *sb = krealloc(oldsb, len + fmtlen + 1, gfp);
> +       if (!*sb) {
> +               kfree(oldsb);
> +               *sb = (struct stringbuf *)enomem_string;

Why don't we just return -ENOMEM here just like all other APIs in the
kernel? And I wonder if it makes more sense to store gfp_flags in
struct stringbuf and always use that? I mean, why would you want to
sometimes do GFP_ATOMIC and GFP_KERNEL allocations for the same
buffer?

                                  Pekka
