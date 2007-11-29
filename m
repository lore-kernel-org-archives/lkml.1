Return-Path: <linux-kernel-owner+w=401wt.eu-S933237AbXK2S03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237AbXK2S03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933210AbXK2S0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:26:09 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:28416 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933181AbXK2S0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:26:08 -0500
Date: Thu, 29 Nov 2007 10:24:00 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove #define hex_asc from kernel.h, update
 lib/hexdump.c
Message-Id: <20071129102400.dac158d8.randy.dunlap@oracle.com>
In-Reply-To: <1196359724.22120.22.camel@localhost>
References: <1196359724.22120.22.camel@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 10:08:44 -0800 Joe Perches wrote:

> It's only use is in lib/hexdump.c
> Instead, use scnprintf in lib/hexdump.c
> 
> Use "%0nx" not "%n.nx" (Smaller kernel, one byte at a time, woohoo!)
> Use true not 1 for print_hex_dump
> A bit of indentation style in lib/hexdump.c

I don't care for the mixed spaces/tabs.

> Size before/after
>    text    data     bss     dec     hex filename
>    1037       0       0    1037     40d lib/hexdump.o
> 
>    text    data     bss     dec     hex filename
>    1019       0       0    1019     3fb lib/hexdump.o
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> ---
> 
>  include/linux/kernel.h |    1 -
>  lib/hexdump.c          |   23 ++++++++++-------------
>  2 files changed, 10 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 94bc996..77b187f 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -256,7 +256,6 @@ extern void print_hex_dump(const char *level, const char *prefix_str,
>  				const void *buf, size_t len, bool ascii);
>  extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
>  			const void *buf, size_t len);
> -#define hex_asc(x)	"0123456789abcdef"[x]
>  
>  #define pr_emerg(fmt, arg...) \
>  	printk(KERN_EMERG fmt, ##arg)
> diff --git a/lib/hexdump.c b/lib/hexdump.c
> index bd5edae..70e23fb 100644
> --- a/lib/hexdump.c
> +++ b/lib/hexdump.c
> @@ -41,7 +41,6 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
>  			bool ascii)
>  {
>  	const u8 *ptr = buf;
> -	u8 ch;
>  	int j, lx = 0;
>  	int ascii_column;
>  
> @@ -62,7 +61,9 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
>  
>  		for (j = 0; j < ngroups; j++)
>  			lx += scnprintf(linebuf + lx, linebuflen - lx,
> -				"%16.16llx ", (unsigned long long)*(ptr8 + j));
> +					"%016llx ",
> +					(unsigned long long)*(ptr8 + j) &
> +					0xffffffffffffffffULL);
>  		ascii_column = 17 * ngroups + 2;
>  		break;
>  	}
> @@ -73,7 +74,7 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
>  
>  		for (j = 0; j < ngroups; j++)
>  			lx += scnprintf(linebuf + lx, linebuflen - lx,
> -				"%8.8x ", *(ptr4 + j));
> +					"%08x ", *(ptr4 + j) & 0xffffffffU);
>  		ascii_column = 9 * ngroups + 2;
>  		break;
>  	}
> @@ -84,19 +85,15 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
>  
>  		for (j = 0; j < ngroups; j++)
>  			lx += scnprintf(linebuf + lx, linebuflen - lx,
> -				"%4.4x ", *(ptr2 + j));
> +					"%04x ", *(ptr2 + j) & 0xffff);
>  		ascii_column = 5 * ngroups + 2;
>  		break;
>  	}
>  
>  	default:
> -		for (j = 0; (j < rowsize) && (j < len) && (lx + 4) < linebuflen;
> -		     j++) {
> -			ch = ptr[j];
> -			linebuf[lx++] = hex_asc(ch >> 4);
> -			linebuf[lx++] = hex_asc(ch & 0x0f);
> -			linebuf[lx++] = ' ';
> -		}
> +		for (j = 0; (j < rowsize) && (j < len) < linebuflen; j++)

What does
					(j < len) < linebuflen;
do?  I don't see that C construct very often.


> +			lx += scnprintf(linebuf + lx, linebuflen - lx,
> +					"%02x ", ptr[j] & 0xff);
>  		ascii_column = 3 * rowsize + 2;
>  		break;
>  	}
> @@ -163,7 +160,7 @@ void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
>  		switch (prefix_type) {
>  		case DUMP_PREFIX_ADDRESS:
>  			printk("%s%s%*p: %s\n", level, prefix_str,
> -				(int)(2 * sizeof(void *)), ptr + i, linebuf);
> +			       (int)(2 * sizeof(void *)), ptr + i, linebuf);
>  			break;
>  		case DUMP_PREFIX_OFFSET:
>  			printk("%s%s%.8x: %s\n", level, prefix_str, i, linebuf);
> @@ -192,6 +189,6 @@ void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
>  			const void *buf, size_t len)
>  {
>  	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, 16, 1,
> -			buf, len, 1);
> +		       buf, len, true);
>  }
>  EXPORT_SYMBOL(print_hex_dump_bytes);


---
~Randy
