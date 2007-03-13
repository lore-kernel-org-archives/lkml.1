Return-Path: <linux-kernel-owner+w=401wt.eu-S965742AbXCMOAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965742AbXCMOAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 10:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965768AbXCMOAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 10:00:32 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:40274 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965742AbXCMOAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 10:00:31 -0400
Date: Tue, 13 Mar 2007 15:00:29 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>
cc: James Simmons <jsimmons@infradead.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: const and __initdata (was: Re: [Linux-fbdev-devel] [PATCH 4/7] fbdev:
 move logo externs to header file)
In-Reply-To: <Pine.LNX.4.62.0701311339110.15066@pademelon.sonytel.be>
Message-ID: <Pine.LNX.4.62.0703131455160.27486@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be>
 <Pine.LNX.4.62.0701311339110.15066@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007, Geert Uytterhoeven wrote:
> Move the external declarations for the various linux logo structures to
> <linux/linux_logo.h>. As a consequence, I had to remove the `const', as `const'
> is incompatible with `__initdata'.
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> ---
>  arch/powerpc/kernel/prom_init.c |    3 ---
>  drivers/video/logo/logo.c       |   13 -------------
>  include/linux/linux_logo.h      |   13 +++++++++++++
>  3 files changed, 13 insertions(+), 16 deletions(-)
> 
> --- ps3-linux-2.6.20-rc7.orig/arch/powerpc/kernel/prom_init.c
> +++ ps3-linux-2.6.20-rc7/arch/powerpc/kernel/prom_init.c
> @@ -44,10 +44,7 @@
>  #include <asm/sections.h>
>  #include <asm/machdep.h>
>  
> -#ifdef CONFIG_LOGO_LINUX_CLUT224
>  #include <linux/linux_logo.h>
> -extern const struct linux_logo logo_linux_clut224;
> -#endif
>  
>  /*
>   * Properties whose value is longer than this get excluded from our
> --- ps3-linux-2.6.20-rc7.orig/drivers/video/logo/logo.c
> +++ ps3-linux-2.6.20-rc7/drivers/video/logo/logo.c
> @@ -21,19 +21,6 @@
>  #include <asm/bootinfo.h>
>  #endif
>  
> -extern const struct linux_logo logo_linux_mono;
> -extern const struct linux_logo logo_linux_vga16;
> -extern const struct linux_logo logo_linux_clut224;
> -extern const struct linux_logo logo_dec_clut224;
> -extern const struct linux_logo logo_mac_clut224;
> -extern const struct linux_logo logo_parisc_clut224;
> -extern const struct linux_logo logo_sgi_clut224;
> -extern const struct linux_logo logo_sun_clut224;
> -extern const struct linux_logo logo_superh_mono;
> -extern const struct linux_logo logo_superh_vga16;
> -extern const struct linux_logo logo_superh_clut224;
> -extern const struct linux_logo logo_m32r_clut224;
> -
>  
>  const struct linux_logo *fb_find_logo(int depth)
>  {
> --- ps3-linux-2.6.20-rc7.orig/include/linux/linux_logo.h
> +++ ps3-linux-2.6.20-rc7/include/linux/linux_logo.h
> @@ -32,6 +32,19 @@ struct linux_logo {
>  	const unsigned char *data;
>  };
>  
> +extern struct linux_logo logo_linux_mono;
> +extern struct linux_logo logo_linux_vga16;
> +extern struct linux_logo logo_linux_clut224;
> +extern struct linux_logo logo_dec_clut224;
> +extern struct linux_logo logo_mac_clut224;
> +extern struct linux_logo logo_parisc_clut224;
> +extern struct linux_logo logo_sgi_clut224;
> +extern struct linux_logo logo_sun_clut224;
> +extern struct linux_logo logo_superh_mono;
> +extern struct linux_logo logo_superh_vga16;
> +extern struct linux_logo logo_superh_clut224;
> +extern struct linux_logo logo_m32r_clut224;
> +
>  extern const struct linux_logo *fb_find_logo(int depth);
>  
>  #endif /* _LINUX_LINUX_LOGO_H */

By modifying scripts/pnmtologo.c to add `const' to the declaration of the
linux_logo structs, I could keep the const.

However, this introduced a new conflict w.r.t. to `const' and `__initdata':
  - gcc 3.4.6 20060404 (Red Hat 3.4.6-3) for ia32 needs xxx_data[] and
    xxx_clut[] to be const too, else it complains about a section type conflict
  - ppu-gcc 4.1.0 20060304 (Red Hat 4.1.0-3) for ppc64 needs xxx_data[] and
    xxx_clut[] to be non-const, else it complains about a section type conflict

Anyone with a suggestion how to fix this? Keep everything non-const for now?
Add tests for specific compiler versions (I assume this is a gcc 3.x vs. 4.x
issue?)?

Thanks in advance!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
