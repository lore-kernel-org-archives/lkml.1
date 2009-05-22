Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbZEVPlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbZEVPlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 11:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756619AbZEVPlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 11:41:07 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:34788 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbZEVPlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 11:41:06 -0400
Message-ID: <4A16C7FE.6090304@oracle.com>
Date: Fri, 22 May 2009 08:42:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hexdump: remove the tailing space
References: <4A1608D0.2030809@cn.fujitsu.com>
In-Reply-To: <4A1608D0.2030809@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4A16C766.001D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> For example:
>         hex_dump_to_buffer("AB", 2, 16, 1, buf, 100, 0);
>         pr_info("[%s]\n", buf);
> 
> I'd expect the output to be "[41 42]", but actually it's "[41 42 ]"

Hm, I would also.

> This patch also makes the required buf to be minimum. To print the hex format
> of "AB", a buf with size 6 should be sufficient, but hex_dump_to_buffer()
> required at least 8.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  lib/hexdump.c |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/hexdump.c b/lib/hexdump.c
> index f07c0db..39af256 100644
> --- a/lib/hexdump.c
> +++ b/lib/hexdump.c
> @@ -65,7 +65,8 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
>  
>  		for (j = 0; j < ngroups; j++)
>  			lx += scnprintf(linebuf + lx, linebuflen - lx,
> -				"%16.16llx ", (unsigned long long)*(ptr8 + j));
> +				"%s%16.16llx", j ? " " : "",
> +				(unsigned long long)*(ptr8 + j));
>  		ascii_column = 17 * ngroups + 2;
>  		break;
>  	}
> @@ -76,7 +77,7 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
>  
>  		for (j = 0; j < ngroups; j++)
>  			lx += scnprintf(linebuf + lx, linebuflen - lx,
> -				"%8.8x ", *(ptr4 + j));
> +				"%s%8.8x", j ? " " : "", *(ptr4 + j));
>  		ascii_column = 9 * ngroups + 2;
>  		break;
>  	}
> @@ -87,19 +88,21 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
>  
>  		for (j = 0; j < ngroups; j++)
>  			lx += scnprintf(linebuf + lx, linebuflen - lx,
> -				"%4.4x ", *(ptr2 + j));
> +				"%s%4.4x", j ? " " : "", *(ptr2 + j));
>  		ascii_column = 5 * ngroups + 2;
>  		break;
>  	}
>  
>  	default:
> -		for (j = 0; (j < rowsize) && (j < len) && (lx + 4) < linebuflen;
> -		     j++) {
> +		for (j = 0; (j < len) && (lx + 3) <= linebuflen; j++) {
>  			ch = ptr[j];
>  			linebuf[lx++] = hex_asc_hi(ch);
>  			linebuf[lx++] = hex_asc_lo(ch);
>  			linebuf[lx++] = ' ';
>  		}
> +		if (j)
> +			lx--;
> +
>  		ascii_column = 3 * rowsize + 2;
>  		break;
>  	}
> @@ -108,7 +111,7 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
>  
>  	while (lx < (linebuflen - 1) && lx < (ascii_column - 1))
>  		linebuf[lx++] = ' ';
> -	for (j = 0; (j < rowsize) && (j < len) && (lx + 2) < linebuflen; j++)
> +	for (j = 0; (j < len) && (lx + 2) < linebuflen; j++)
>  		linebuf[lx++] = (isascii(ptr[j]) && isprint(ptr[j])) ? ptr[j]
>  				: '.';
>  nil:


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
