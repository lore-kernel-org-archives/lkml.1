Return-Path: <linux-kernel-owner+w=401wt.eu-S933209AbXK2Sx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209AbXK2Sx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761809AbXK2SxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:53:17 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:29599 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761934AbXK2SxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:53:16 -0500
Message-ID: <474F0A68.1080809@oracle.com>
Date: Thu, 29 Nov 2007 10:52:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove #define hex_asc from kernel.h, update	lib/hexdump.c
References: <1196359724.22120.22.camel@localhost>	 <20071129102400.dac158d8.randy.dunlap@oracle.com> <1196361860.22120.27.camel@localhost>
In-Reply-To: <1196361860.22120.27.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Thu, 2007-11-29 at 10:24 -0800, Randy Dunlap wrote:
>> I don't care for the mixed spaces/tabs.
> 
> I like myself, but I removed it just for you...

Thanks.  Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

but needs an S-O-B:


>> What does (j < len) < linebuflen; do?
> 
> Nothing good.  It's a silly mistake.  I fixed it.
> 
> Size before/after:
> 
>    text    data     bss     dec     hex filename
>    1037       0       0    1037     40d lib/hexdump.o
>    1004       0       0    1004     3ec lib/hexdump.o
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
> index bd5edae..125c137 100644
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
> +		for (j = 0; j < rowsize; j++)
> +			lx += scnprintf(linebuf + lx, linebuflen - lx,
> +					"%02x ", ptr[j] & 0xff);
>  		ascii_column = 3 * rowsize + 2;
>  		break;
>  	}
> @@ -192,6 +189,6 @@ void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
>  			const void *buf, size_t len)
>  {
>  	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, 16, 1,
> -			buf, len, 1);
> +			buf, len, true);
>  }
>  EXPORT_SYMBOL(print_hex_dump_bytes);
> 
> 


-- 
~Randy
