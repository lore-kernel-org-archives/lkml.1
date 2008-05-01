Return-Path: <linux-kernel-owner+w=401wt.eu-S1765897AbYEATnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765897AbYEATnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762338AbYEATnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:43:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761365AbYEATnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:43:19 -0400
Date: Thu, 1 May 2008 12:43:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: add helpers for ascii character conversion
Message-Id: <20080501124317.089a0d02.akpm@linux-foundation.org>
In-Reply-To: <1209669780.24729.151.camel@brick>
References: <1209669780.24729.151.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 May 2008 12:23:00 -0700
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Add helpers for getting an ascii hex char for the high and low
> nibble of a byte.  Also add a small helper to get an integer
> value from a given hex char.
> 
> Included here are a few of the current places that roll their
> own versions being moved to the common helper.

ahh, someone cares ;)

Does this mean that

y:/usr/src/linux-2.6.25> grep -ri '"0123456789abcdef"' . | wc -l
40

will decrease?

> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -277,6 +277,21 @@ extern void print_hex_dump(const char *level, const char *prefix_str,
>  extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
>  			const void *buf, size_t len);
>  #define hex_asc(x)	"0123456789abcdef"[x]
> +#define hex_asc_lo(x)	hex_asc(((x) & 0x0f))
> +#define hex_asc_hi(x)	hex_asc(((x) & 0xf0) >> 4)

umm, this might mean that each .c file which uses hex_asc_lo/hi gets
its own copy of "0123456789abcdef".  I believe that gcc/ld are getting
better at handling this, but I haven't checked, and I don't know which
versions get it right nor in which way.  etc.

So it might be better to give the kernel the One True Digitstring in
lib/something.c and export that to modules.

> +static inline u8 hex_to_int(char ch)
> +{
> +	/*
> +	 * Make ch lower-case, works only for digits and letters
> +	 */
> +	ch |= 0x20;
> +	if ((ch >= 'a') && (ch <= 'f'))
> +		return (ch - 'a' + 10);
> +	if ((ch >= '0') && (ch <= '9'))
> +		return (ch - '0');
> +	return (-1);
> +}

probably should be uninlined.

return-is-not-a-function ;)

>  #define pr_emerg(fmt, arg...) \
>  	printk(KERN_EMERG fmt, ##arg)
> diff --git a/lib/hexdump.c b/lib/hexdump.c
> index 3435465..32b0bd7 100644
> --- a/lib/hexdump.c
> +++ b/lib/hexdump.c
> @@ -93,8 +93,8 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
>  		for (j = 0; (j < rowsize) && (j < len) && (lx + 4) < linebuflen;
>  		     j++) {
>  			ch = ptr[j];
> -			linebuf[lx++] = hex_asc(ch >> 4);
> -			linebuf[lx++] = hex_asc(ch & 0x0f);
> +			linebuf[lx++] = hex_asc_hi(ch);
> +			linebuf[lx++] = hex_asc_lo(ch);
>  			linebuf[lx++] = ' ';
>  		}
>  		ascii_column = 3 * rowsize + 2;

