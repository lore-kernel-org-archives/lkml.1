Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbYJQDjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbYJQDjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 23:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYJQDjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 23:39:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:4936 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbYJQDjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 23:39:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=G6XTYDo8a7QQVn93YfG3ymQl2S71RQrI6tBG2IYGUAqa3QP7C7AtISgGWnBTuqbewM
         msjwzH6pW1yJP6JJWQmpFQ4IbV+Z3bTOStUtg1R8yVYHjDhYBcAJoPuv0uw8jhprqCHB
         y1oieps76Wq8wRMCYQgebG0pnYlRj/NlsbIlE=
Message-ID: <86802c440810162039v7c347888i34e26058b70f37d5@mail.gmail.com>
Date: Thu, 16 Oct 2008 20:39:45 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: benh@kernel.crashing.org
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       "David Miller" <davem@davemloft.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1224212791.7654.63.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48F409E9.3030501@zytor.com>
	 <20081013.223811.174710738.davem@davemloft.net>
	 <Pine.LNX.4.64.0810161030120.9022@vixen.sonytel.be>
	 <20081016.013850.85183428.davem@davemloft.net>
	 <1224212533.7654.60.camel@pasglop> <1224212791.7654.63.camel@pasglop>
X-Google-Sender-Auth: cb5075161e46eb27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 8:06 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
>
> Implement %pR to print struct resource content
>
> Add a %pR option to the kernel vsnprintf that prints the range of
> addresses inside a struct resource passed by pointer.
>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>
> And this one has updated comments.
>
> Index: linux-work/lib/vsprintf.c
> ===================================================================
> --- linux-work.orig/lib/vsprintf.c      2008-10-17 13:30:18.000000000 +1100
> +++ linux-work/lib/vsprintf.c   2008-10-17 14:04:58.000000000 +1100
> @@ -24,6 +24,7 @@
>  #include <linux/kernel.h>
>  #include <linux/kallsyms.h>
>  #include <linux/uaccess.h>
> +#include <linux/ioport.h>
>
>  #include <asm/page.h>          /* for PAGE_SIZE */
>  #include <asm/div64.h>
> @@ -550,18 +551,38 @@ static char *symbol_string(char *buf, ch
>  #endif
>  }
>
> +static char *resource_string(char *buf, char *end, struct resource *res, int field_width, int precision, int flags)
> +{
> +       /* room for the actual numbers, the two "0x", -, [, ] and the final zero */
> +       char sym[4*sizeof(resource_size_t) + 8];
> +       char *p = sym, *pend = sym + sizeof(sym);
> +
> +       *p++ = '[';
> +       p = number(p, pend, res->start, 16, -1, -1, SPECIAL | SMALL);
> +       *p++ = '-';
> +       p = number(p, pend, res->end, 16, -1, -1, SPECIAL | SMALL);
> +       *p++ = ']';
> +       *p = 0;
> +
> +       return string(buf, end, sym, field_width, precision, flags);

so x64 64bit,io ports will be print out 8 digital?

YH
