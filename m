Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbXLFACd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbXLFACd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 19:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbXLFACZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 19:02:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53391 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531AbXLFACY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 19:02:24 -0500
Date: Wed, 5 Dec 2007 16:01:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: jengelh@computergmbh.de, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reduce stack used by lib/hexdump.c
Message-Id: <20071205160133.0766c4f5.akpm@linux-foundation.org>
In-Reply-To: <1196378922.22120.72.camel@localhost>
References: <1196359724.22120.22.camel@localhost>
	<20071129102400.dac158d8.randy.dunlap@oracle.com>
	<1196361860.22120.27.camel@localhost>
	<474F0A68.1080809@oracle.com>
	<1196369873.22120.69.camel@localhost>
	<474F28EB.20608@oracle.com>
	<Pine.LNX.4.64.0711292206450.3089@fbirervta.pbzchgretzou.qr>
	<1196378922.22120.72.camel@localhost>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 15:28:42 -0800
Joe Perches <joe@perches.com> wrote:

> On Thu, 2007-11-29 at 22:07 +0100, Jan Engelhardt wrote:
> > I'd add GFP_ATOMIC here. Who knows whether tomorrow, the oops dumper
> > or warn_on will use print_hex_dump.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
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
> +	linebuf = kmalloc(HEX_LINE_SIZE, GFP_ATOMIC);
> +	if (!linebuf) {
> +		WARN_ON(1);
> +		return;
> +	}

No, I think print_hex_dump() is too low-level to be doing allocations. 
For example, one could easily choose to call print_hex_dump() at oops time,
and then what happens if we oops in kmalloc() (as we often do...)?

You could trim linebuf[] to 80 chars or so.  Extra points for making it
very clear when someone tries to exceed that - strcpy(linebuf, "stop being
stupid").

