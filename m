Return-Path: <linux-kernel-owner+w=401wt.eu-S933820AbXK2VEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933820AbXK2VEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761871AbXK2VEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:04:01 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:28865 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761089AbXK2VEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:04:00 -0500
Message-ID: <474F28EB.20608@oracle.com>
Date: Thu, 29 Nov 2007 13:02:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Reduce stack used by lib/hexdump.c
References: <1196359724.22120.22.camel@localhost>	 <20071129102400.dac158d8.randy.dunlap@oracle.com>	 <1196361860.22120.27.camel@localhost>  <474F0A68.1080809@oracle.com> <1196369873.22120.69.camel@localhost>
In-Reply-To: <1196369873.22120.69.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> 200 bytes on stack might be a bit much.
> 
> Size goes up to
>    text    data     bss     dec     hex filename
>    1142       0       0    1142     476 lib/hexdump.o
> Without the WARN_ON
>    1053       0       0    1053     41d lib/hexdump.o
> Before this patch
>    1004       0       0    1004     3ec lib/hexdump.o
> 
> Win some/lose some...
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> diff --git a/lib/hexdump.c b/lib/hexdump.c
> index 70e23fb..be94934 100644
> --- a/lib/hexdump.c
> +++ b/lib/hexdump.c
> @@ -140,13 +140,20 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
>   * Example output using %DUMP_PREFIX_ADDRESS and 4-byte mode:
>   * ffffffff88089af0: 73727170 77767574 7b7a7978 7f7e7d7c  pqrstuvwxyz{|}~.
>   */
> +
> +#define HEX_LINE_SIZE 200
> +
>  void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
>  			int rowsize, int groupsize,
>  			const void *buf, size_t len, bool ascii)
>  {
>  	const u8 *ptr = buf;
>  	int i, linelen, remaining = len;
> -	unsigned char linebuf[200];
> +	unsigned char *linebuf;
> +
> +	linebuf = kmalloc(HEX_LINE_SIZE, GFP_KERNEL);
> +	if (!linebuf) {
> +		WARN_ON(1);
> +		return;
> +	}
>  
>  	if (rowsize != 16 && rowsize != 32)
>  		rowsize = 16;
> @@ -155,7 +162,7 @@ void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
>  		linelen = min(remaining, rowsize);
>  		remaining -= rowsize;
>  		hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
> -				linebuf, sizeof(linebuf), ascii);
> +				linebuf, HEX_LINE_SIZE, ascii);
>  
>  		switch (prefix_type) {
>  		case DUMP_PREFIX_ADDRESS:
> @@ -170,6 +177,7 @@ void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
>  			break;
>  		}
>  	}
> +	kfree(linebuf);
>  }
>  EXPORT_SYMBOL(print_hex_dump);


-- 
~Randy
