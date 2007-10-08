Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbXJHXMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbXJHXMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 19:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbXJHXMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 19:12:46 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:44741 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbXJHXMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 19:12:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=n7bxTdiQnKmwDywYvuucjrc+kAz3NWFW/lv3RIVUdVZjhcoI1wkVzC9tVyvL2zvenSHPHkqc9+OxU1bbBFg/YBvcKchFH14NHEXrf0xlBdKM8mmNs2NCBFVSoCSw2p+yZjpWpIsXhsbPAwul5FIRgt/GxPP7ecV42dGF+1IXVOk=
Subject: Re: [PATCH 1/2] Colored kernel output (run3)
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Verych <olecom@flower.upol.cz>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0710062209390.20637@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710062147370.20637@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0710062209390.20637@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Tue, 09 Oct 2007 07:12:36 +0800
Message-Id: <1191885157.5508.27.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-10-06 at 22:09 +0200, Jan Engelhardt wrote: 
> Colored kernel message output (1/2)
> 
> This patch makes it possible to give kernel messages a selectable
> color. It can be chosen at compile time, overridden at boot time,
> and changed at run time.
> 
> References: http://lkml.org/lkml/2007/4/1/162
> 	http://lkml.org/lkml/2007/10/5/199

This is quite a long thread :-)

> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> 
> ---
>  drivers/char/Kconfig |   42 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/char/vt.c    |   23 +++++++++++++++++++++++
>  2 files changed, 65 insertions(+)
> 
> Index: linux-2.6.23/drivers/char/Kconfig
> ===================================================================
> --- linux-2.6.23.orig/drivers/char/Kconfig
> +++ linux-2.6.23/drivers/char/Kconfig
> @@ -58,6 +58,48 @@ config VT_CONSOLE
>  
>  	  If unsure, say Y.
>  
> +config VT_CKO
> +	bool "Colored kernel message output"
> +	depends on VT_CONSOLE
> +	---help---
> +	This option enables kernel messages to be emitted in
> +	colors other than the default.
> +
> +	If unsure, say N.
> +
> +config VT_PRINTK_COLOR
> +	hex "Colored kernel message output"
> +	range 0x00 0xFF
> +	depends on VT_CKO
> +	default 0x07
> +	---help---
> +	This option defines with which color kernel messages will be
> +	printed to the console.
> +
> +	The value you need to enter here is the value is composed

The more correct term for "The value" is probably "The attribute".

> +	(OR-ed) of a foreground and a background color.
> +
> +	Foreground:
> +	0x00 = black,   0x08 = dark gray,
> +	0x01 = red,     0x09 = light red,
> +	0x02 = green,   0x0A = light green,
> +	0x03 = brown,   0x0B = yellow,
> +	0x04 = blue,    0x0C = light blue,
> +	0x05 = magenta, 0x0D = light magenta,
> +	0x06 = cyan,    0x0E = light cyan,
> +	0x07 = gray,    0x0F = white,
> +
> +	(Foreground colors 0x08 to 0x0F do not work when a VGA
> +	console font with 512 glyphs is used.)

You might have to include a warning that those values or attributes are 
interpreted differently depending on the driver used, and the above is
mostly true for 16-color console drivers only.

For 2-colors (we still have quite a few of them) only bit 0 is true for
color (0x00 and 0x01). The rest of the bits are interpreted as
attributes:

	0x02 - italic
	0x04 - underline
	0x08 - bold
	0x80 - blink

The italic, underline and bold attributes will show up in a 2-color
framebuffer console. The blink attribute is ignored.

With a 4-color fb console (4-level grayscale), those values are again
interpreted differently.

	0x00 - 0x00 : black
	0x01 - 0x06 : white
	0x07 - 0x08 : gray  
	the rest    : intense white

(If by mistake 0x0106 is used, it will produce a white on white display)

With an 8-color console, only the first 8 values are considered.

With a 16-color console, that is also not consistent:

With vgacon, it supports 16-color foreground (fg), 8-color
background (bg) at 256 chars. Becomes 8 fg and 8 bg with 512 chars.

With fbcon, it supports 16 fg and 16 bg at 256, 16 fg and 8 bg at
512 chars.

And for drivers that have their own con_build_attr() hook, they will be
interpreted differently again.

> +
> +	Background:
> +	0x00 = black,   0x40 = blue,
> +	0x10 = red,     0x50 = magenta,
> +	0x20 = green,   0x60 = cyan,
> +	0x30 = brown,   0x70 = gray,
> +
> +	For example, 0x1F would yield white on red.
> +

You may need to specify that the values here are the console default,
ie, the default_blue|grn|red boot options are not filled up.

>  config HW_CONSOLE
>  	bool
>  	depends on VT && !S390 && !UML
> Index: linux-2.6.23/drivers/char/vt.c
> ===================================================================
> --- linux-2.6.23.orig/drivers/char/vt.c
> +++ linux-2.6.23/drivers/char/vt.c
> @@ -73,6 +73,7 @@
>   */
>  
>  #include <linux/module.h>
> +#include <linux/moduleparam.h>
>  #include <linux/types.h>
>  #include <linux/sched.h>
>  #include <linux/tty.h>
> @@ -2344,6 +2345,23 @@ struct tty_driver *console_driver;
>  
>  #ifdef CONFIG_VT_CONSOLE
>  
> +static unsigned int printk_color __read_mostly = CONFIG_VT_PRINTK_COLOR;
> +#ifdef CONFIG_VT_CKO
> +module_param(printk_color, uint, S_IRUGO | S_IWUSR);
> +
> +static inline void vc_set_color(struct vc_data *vc, unsigned char color)
> +{
> +	vc->vc_color = color_table[color & 0xF] |
> +	               (color_table[(color >> 4) & 0x7] << 4) |
> +	               (color & 0x80);

You may want to leave out the blink attribute (0x80) from this part.
Otherwise setterm -blink on|off will produce the opposite effect. 

Tony



