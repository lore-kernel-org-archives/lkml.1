Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbZKIJKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbZKIJKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbZKIJKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:10:48 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:39536 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbZKIJKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:10:44 -0500
Date: Mon, 9 Nov 2009 10:10:44 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Andrea Righi <righi.andrea@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] fbcon: make cursor display conditional
Message-ID: <20091109091044.GX29442@buzzloop.caiaq.de>
References: <4AF7D439.4030305@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF7D439.4030305@ladisch.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 09:35:05AM +0100, Clemens Ladisch wrote:
> Daniel Mack wrote:
> > > On Fri, Nov 06, 2009 at 09:16:44AM +0100, Clemens Ladisch wrote:
> > > > Wouldn't it be more useful to change the CUR_DEFAULT symbol (see the
> > > > end of <linux/console_struct.h>) into a kernel parameter, instead of
> > > > adding a new flag?
> > 
> > Ok, much better idea, I agree. See the patch below.
> > 
> > Subject: [PATCH] char/console: make default cursor type configurable
> > 
> > --- a/drivers/char/vt.c
> > +++ b/drivers/char/vt.c
> > +#if defined(CONFIG_CONSOLE_DEF_CUR_NONE)
> > +#define CUR_DEFAULT CUR_NONE
> > +
> > +#elif defined(CONFIG_CONSOLE_DEF_CUR_UNDERLINE)
> > +#define CUR_DEFAULT CUR_UNDERLINE
> > +...
> 
> With a separate Kconfig variable, we can avoid having to put the
> parallel list into vt.c.
> 
> Furthermore, we can add options for the software cursor while we're
> at it; something like this:
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

Wonderful, thank you. For my bits, you can add my Signed-off-by if
that's appropriate.

Daniel

> --- linux-2.6/include/linux/console_struct.h
> +++ linux-2.6/include/linux/console_struct.h
> @@ -130,8 +130,6 @@ extern void vc_SAK(struct work_struct *w
>  #define CUR_HWMASK	0x0f
>  #define CUR_SWMASK	0xfff0
>  
> -#define CUR_DEFAULT CUR_UNDERLINE
> -
>  #define CON_IS_VISIBLE(conp) (*conp->vc_display_fg == conp)
>  
>  #endif /* _LINUX_CONSOLE_STRUCT_H */
> --- linux-2.6/drivers/char/vt.c
> +++ linux-2.6/drivers/char/vt.c
> @@ -138,6 +138,11 @@ const struct consw *conswitchp;
>  #define DEFAULT_BELL_PITCH	750
>  #define DEFAULT_BELL_DURATION	(HZ/8)
>  
> +#define CUR_DEFAULT (CONFIG_CUR_DEFAULT_HW | \
> +		     CONFIG_CUR_DEFAULT_SW_FLAGS | \
> +		     (CONFIG_CUR_DEFAULT_SW_ATTR_XOR << 8) | \
> +		     (CONFIG_CUR_DEFAULT_SW_ATTR_SET << 16))
> +
>  struct vc vc_cons [MAX_NR_CONSOLES];
>  
>  #ifndef VT_SINGLE_DRIVER
> --- linux-2.6/drivers/char/Kconfig
> +++ linux-2.6/drivers/char/Kconfig
> @@ -88,6 +88,104 @@ config VT_HW_CONSOLE_BINDING
>  	 information. For framebuffer console users, please refer to
>  	 <file:Documentation/fb/fbcon.txt>.
>  
> +choice
> +	prompt "Default hardware cursor shape"
> +	depends on HW_CONSOLE
> +	default CUR_DEFAULT_UNDERLINE
> +	help
> +	  Select the default shape of the blinking hardware cursor.
> +
> +	config CUR_DEFAULT_DEF
> +		bool "Default"
> +	config CUR_DEFAULT_NONE
> +		bool "None"
> +	config CUR_DEFAULT_UNDERLINE
> +		bool "Underline"
> +	config CUR_DEFAULT_LOWER_THIRD
> +		bool "Lower third"
> +	config CUR_DEFAULT_LOWER_HALF
> +		bool "Lower half"
> +	config CUR_DEFAULT_TWO_THIRDS
> +		bool "Two thirds"
> +	config CUR_DEFAULT_BLOCK
> +		bool "Block"
> +endchoice
> +
> +config CUR_DEFAULT_HW
> +	depends on HW_CONSOLE
> +	int
> +	default 0 if CUR_DEFAULT_DEF
> +	default 1 if CUR_DEFAULT_NONE
> +	default 2 if CUR_DEFAULT_UNDERLINE
> +	default 3 if CUR_DEFAULT_LOWER_THIRD
> +	default 4 if CUR_DEFAULT_LOWER_HALF
> +	default 5 if CUR_DEFAULT_TWO_THIRDS
> +	default 6 if CUR_DEFAULT_BLOCK
> +
> +config CUR_DEFAULT_SW
> +	bool "Use software cursor by default"
> +	depends on HW_CONSOLE
> +	default n
> +	help
> +	  The software cursor allows you to customize the appearance of the
> +	  cursor; this is done by changing the attributes (the color) of the
> +	  character under the cursor.
> +
> +	  See <file:Documentation/VGA-softcursor.txt> for more information.
> +
> +config CUR_DEFAULT_SW_ATTR_XOR
> +	depends on HW_CONSOLE
> +	prompt "Software cursor changed attribute bits" if CUR_DEFAULT_SW
> +	int
> +	range 0 255
> +	default 0
> +	help
> +	  Enter the character attribute bits that are changed by the
> +	  software cursor. This is equivalent to the second parameter
> +	  of the <ESC>[?1;2;3c escape sequence; for more information,
> +	  see <file:Documentation/VGA-softcursor.txt>.
> +
> +config CUR_DEFAULT_SW_ATTR_SET
> +	depends on HW_CONSOLE
> +	prompt "Software cursor set attribute bits" if CUR_DEFAULT_SW
> +	int
> +	range 0 255
> +	default 0
> +	help
> +	  Enter the character attribute bits that are set by the
> +	  software cursor. This is equivalent to the third parameter
> +	  of the <ESC>[?1;2;3c escape sequence; for more information,
> +	  see <file:Documentation/VGA-softcursor.txt>.
> +
> +config CUR_DEFAULT_SW_CHANGE_BKGND
> +	bool "Software cursor always changes background"
> +	depends on CUR_DEFAULT_SW
> +	default y
> +	help
> +	  If you say Y here, the software cursor will ensure that the
> +	  background color of the character under the cursor is changed,
> +	  even if the cursor color is the same as the original character's
> +	  color.
> +
> +config CUR_DEFAULT_SW_BKGND_DIFFERENT
> +	bool "Software cursor makes foreground color different from background"
> +	depends on CUR_DEFAULT_SW
> +	default y
> +	help
> +	  If you say Y here, the software cursor will ensure that the
> +	  foreground color of the character under the cursor is different
> +	  from the background color.
> +
> +config CUR_DEFAULT_SW_FLAGS
> +	depends on HW_CONSOLE
> +	int
> +	default 0 if !CUR_DEFAULT_SW
> +	# 16 + (32 if CHANGE_BKGND) + (64 if BKGND_DIFFERENT):
> +	default 16 if !CUR_DEFAULT_SW_CHANGE_BKGND && !CUR_DEFAULT_SW_BKGND_DIFFERENT
> +	default 48 if CUR_DEFAULT_SW_CHANGE_BKGND && !CUR_DEFAULT_SW_BKGND_DIFFERENT
> +	default 80 if !CUR_DEFAULT_SW_CHANGE_BKGND && CUR_DEFAULT_SW_BKGND_DIFFERENT
> +	default 112 if CUR_DEFAULT_SW_CHANGE_BKGND && CUR_DEFAULT_SW_BKGND_DIFFERENT
> +
>  config DEVKMEM
>  	bool "/dev/kmem virtual device support"
>  	default y
