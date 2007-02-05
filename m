Return-Path: <linux-kernel-owner+w=401wt.eu-S964852AbXBEWc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852AbXBEWc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 17:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964907AbXBEWc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 17:32:56 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:55522 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964852AbXBEWcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 17:32:53 -0500
Message-ID: <45C7B0A8.50707@gmail.com>
Date: Mon, 05 Feb 2007 23:33:12 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Ondrej Zajicek <santiago@crfreenet.org>
Cc: James Simmons <jsimmons@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] fbdev driver for S3 Trio/Virge
References: <20070205195130.GB5206@localhost.localdomain>
In-Reply-To: <20070205195130.GB5206@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ondrej Zajicek napsal(a):
> This patch adds driver for S3 Trio / S3 Virge. Driver is tested
> with most versions of S3 Trio and S3 Virge, on i386.
> It is tested both as compiled-in and module. It is against
> linux-2.6.20 .
> 
> This is version 2. Version 1 is in -mm tree. Changes from version 1:
> 
>  * proper Virge VX support
>  * suspend/resume support
>  * S3 fasttext support
>  * several minor bugs corrected
> 
> Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
> 
> ---
> 
> diff -uprN -X linux-2.6.20/Documentation/dontdiff linux-2.6.20/Documentation/fb/s3fb.txt linux-2.6.20-s3fb/Documentation/fb/s3fb.txt
> --- linux-2.6.20/Documentation/fb/s3fb.txt	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.20-s3fb/Documentation/fb/s3fb.txt	2007-02-05 14:26:14.000000000 +0100
> @@ -0,0 +1,78 @@
> +
> +	s3fb - fbdev driver for S3 Trio/Virge chips
> +	===========================================
> +
> +
> +Supported Hardware
> +==================
> +
> +	S3 Trio32
> +	S3 Trio64 (and variants V+, UV+, V2/DX, V2/GX)
> +	S3 Virge  (and variants VX, DX, GX and GX2+)
> +	S3 Plato/PX		(completely untested)
> +	S3 Aurora64V+		(completely untested)
> +
> +	- only PCI bus supported
> +	- only BIOS initialized VGA devices supported
> +	- probably not working on big endian
> +
> +I tested s3fb on Trio64 (plain, V+ and V2/DX) and Virge (plain, VX, DX),
> +all on i386.
> +
> +
> +Supported Features
> +==================
> +
> +	*  4 bpp pseudocolor modes (with 18bit palette, two variants)
> +	*  8 bpp pseudocolor mode (with 18bit palette)
> +	* 16 bpp truecolor modes (RGB 555 and RGB 565)
> +	* 24 bpp truecolor mode (RGB 888) on (only on Virge VX)
> +	* 32 bpp truecolor mode (RGB 888) on (not on Virge VX)
> +	* text mode (activated by bpp = 0)
> +	* interlaced mode variant (not available in text mode)
> +	* doublescan mode variant (not available in text mode)
> +	* panning in both directions
> +	* suspend/resume support
> +	* DPMS support
> +
> +Text mode is supported even in higher resolutions, but there is limitation
> +to lower pixclocks (maximum between 50-60 MHz, depending on specific hardware).
> +This limitation is not enforced by driver. Text mode supports 8bit wide fonts
> +only (hardware limitation) and 16bit tall fonts (driver limitation).
> +
> +There are two 4 bpp modes. First mode (selected if nonstd == 0) is mode with
> +packed pixels, high nibble first. Second mode (selected if nonstd == 1) is mode
> +with interleaved planes (1 byte interleave), MSB first. Both modes support
> +8bit wide fonts only (driver limitation).
> +
> +Suspend/resume works on systems that initialize video card during resume and
> +if device is active (for example used by fbcon).
> +
> +
> +Missing Features
> +================
> +(alias TODO list)
> +
> +	* secondary (not initialized by BIOS) device support
> +   	* big endian support
> +	* Zorro bus support
> +	* MMIO support
> +	* 24 bpp mode support on more cards
> +	* support for fontwidths != 8 in 4 bpp modes
> +	* support for fontheight != 16 in text mode
> +	* composite and external sync (is anyone able to test this?)
> +	* hardware cursor
> +	* video overlay support
> +	* vsync synchronization
> +	* feature connector support
> +	* acceleration support (8514-like 2D, Virge 3D, busmaster transfers)
> +	* better values for some magic registers (performance issues)
> +
> +
> +Known bugs
> +==========
> +
> +	* cursor disable in text mode doesn't work
> +
> +--
> +Ondrej Zajicek <santiago@crfreenet.org>
> diff -uprN -X linux-2.6.20/Documentation/dontdiff linux-2.6.20/drivers/video/Kconfig linux-2.6.20-s3fb/drivers/video/Kconfig
> --- linux-2.6.20/drivers/video/Kconfig	2007-02-04 19:44:54.000000000 +0100
> +++ linux-2.6.20-s3fb/drivers/video/Kconfig	2007-02-05 19:05:50.000000000 +0100
> @@ -85,6 +85,14 @@ config FB_CFB_IMAGEBLIT
>  	  blitting. This is used by drivers that don't provide their own
>  	  (accelerated) version.
>  
> +config FB_SVGALIB
> +	tristate
> +	depends on FB
> +	default n
> +	---help---
> +	  Common utility functions useful to fbdev drivers of VGA-based
> +	  cards.
> +
>  config FB_MACMODES
>         tristate
>         depends on FB
> @@ -1147,6 +1155,17 @@ config FB_S3TRIO
>  	help
>  	  If you have a S3 Trio say Y. Say N for S3 Virge.
>  
> +config FB_S3
> +	tristate "S3 Trio/Virge support"
> +	depends on FB && PCI
> +	select FB_CFB_FILLRECT
> +	select FB_CFB_COPYAREA
> +	select FB_CFB_IMAGEBLIT
> +	select FB_TILEBLITTING
> +	select FB_SVGALIB
> +	---help---
> +	  Driver for graphics boards with S3 Trio / S3 Virge chip.
> +
>  config FB_SAVAGE
>  	tristate "S3 Savage support"
>  	depends on FB && PCI && EXPERIMENTAL
> diff -uprN -X linux-2.6.20/Documentation/dontdiff linux-2.6.20/drivers/video/Makefile linux-2.6.20-s3fb/drivers/video/Makefile
> --- linux-2.6.20/drivers/video/Makefile	2007-02-04 19:44:54.000000000 +0100
> +++ linux-2.6.20-s3fb/drivers/video/Makefile	2007-02-05 14:26:14.000000000 +0100
> @@ -17,6 +17,7 @@ obj-$(CONFIG_SYSFS)		  += backlight/
>  obj-$(CONFIG_FB_CFB_FILLRECT)  += cfbfillrect.o
>  obj-$(CONFIG_FB_CFB_COPYAREA)  += cfbcopyarea.o
>  obj-$(CONFIG_FB_CFB_IMAGEBLIT) += cfbimgblt.o
> +obj-$(CONFIG_FB_SVGALIB)       += svgalib.o
>  obj-$(CONFIG_FB_MACMODES)      += macmodes.o
>  obj-$(CONFIG_FB_DDC)           += fb_ddc.o
>  
> @@ -54,6 +55,7 @@ obj-$(CONFIG_FB_S3TRIO)           += S3t
>  obj-$(CONFIG_FB_FM2)              += fm2fb.o
>  obj-$(CONFIG_FB_CYBLA)            += cyblafb.o
>  obj-$(CONFIG_FB_TRIDENT)          += tridentfb.o
> +obj-$(CONFIG_FB_S3)               += s3fb.o vgastate.o
>  obj-$(CONFIG_FB_STI)              += stifb.o
>  obj-$(CONFIG_FB_FFB)              += ffb.o sbuslib.o
>  obj-$(CONFIG_FB_CG6)              += cg6.o sbuslib.o
> diff -uprN -X linux-2.6.20/Documentation/dontdiff linux-2.6.20/drivers/video/s3fb.c linux-2.6.20-s3fb/drivers/video/s3fb.c
> --- linux-2.6.20/drivers/video/s3fb.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.20-s3fb/drivers/video/s3fb.c	2007-02-05 19:08:08.000000000 +0100
> @@ -0,0 +1,1153 @@
> +/*
> + * linux/drivers/video/s3fb.c -- Frame buffer device driver for S3 Trio/Virge
> + *
> + * Copyright (c) 2006 Ondrej Zajicek <santiago@crfreenet.org>

-2007?

> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file COPYING in the main directory of this archive for
> + * more details.
> + *
> + * Code is based on David Boucher's viafb (http://davesdomain.org.uk/viafb/)
> + * which is based on the code of neofb.
> + */
> +
> +#include <linux/version.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/string.h>
> +#include <linux/mm.h>
> +#include <linux/tty.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/fb.h>
> +#include <linux/svga.h>
> +#include <linux/init.h>
> +#include <linux/pci.h>
> +#include <linux/console.h> /* Why should fb driver call console functions? because acquire_console_sem() */
> +#include <video/vga.h>
> +
> +#ifdef CONFIG_MTRR

Why ifdef? It's ifdeffed in the header itself.

> +#include <asm/mtrr.h>
> +#endif
> +
> +struct s3fb_info {
> +	struct fb_info fb;
> +
> +	int chip, rev, mclk_freq;
> +	int mtrr_reg;
> +	struct vgastate state;
> +	atomic_t ref_count;
> +	u32 pseudo_palette[16];
> +};
> +
> +
> +/* ------------------------------------------------------------------------- */
> +
> +static const struct svga_fb_format s3fb_formats[] = {
> +	{ 0,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 0,
> +		FB_TYPE_TEXT, FB_AUX_TEXT_SVGA_STEP4,	FB_VISUAL_PSEUDOCOLOR, 8, 16},
> +	{ 4,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 0,
> +		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_PSEUDOCOLOR, 8, 16},
> +	{ 4,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 1,
> +		FB_TYPE_INTERLEAVED_PLANES, 1,		FB_VISUAL_PSEUDOCOLOR, 8, 16},
> +	{ 8,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 0,
> +		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_PSEUDOCOLOR, 4, 8},
> +	{16,  {10, 5, 0}, {5, 5, 0},  {0, 5, 0}, {0, 0, 0}, 0,
> +		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_TRUECOLOR, 2, 4},
> +	{16,  {11, 5, 0}, {5, 6, 0},  {0, 5, 0}, {0, 0, 0}, 0,
> +		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_TRUECOLOR, 2, 4},
> +	{24,  {16, 8, 0}, {8, 8, 0},  {0, 8, 0}, {0, 0, 0}, 0,
> +		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_TRUECOLOR, 1, 2},
> +	{32,  {16, 8, 0}, {8, 8, 0},  {0, 8, 0}, {0, 0, 0}, 0,
> +		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_TRUECOLOR, 1, 2},
> +	SVGA_FORMAT_END
> +};
> +
> +
> +static const struct svga_pll s3_pll = {3, 129, 3, 33, 0, 3,
> +	60000, 240000, 14318};
> +
> +static const int s3_memsizes[] = {4096, 0, 3072, 8192, 2048, 6144, 1024, 512};
> +
> +static const char * const s3_names[] = {"S3 Unknown", "S3 Trio32", "S3 Trio64", "S3 Trio64V+",
> +			"S3 Trio64UV+", "S3 Trio64V2/DX", "S3 Trio64V2/GX",
> +			"S3 Plato/PX", "S3 Aurora64VP", "S3 Virge",
> +			"S3 Virge/VX", "S3 Virge/DX", "S3 Virge/GX",
> +			"S3 Virge/GX2", "S3 Virge/GX2P", "S3 Virge/GX2P"};
> +
> +#define CHIP_UNKNOWN		0x00
> +#define CHIP_732_TRIO32		0x01
> +#define CHIP_764_TRIO64		0x02
> +#define CHIP_765_TRIO64VP	0x03
> +#define CHIP_767_TRIO64UVP	0x04
> +#define CHIP_775_TRIO64V2_DX	0x05
> +#define CHIP_785_TRIO64V2_GX	0x06
> +#define CHIP_551_PLATO_PX	0x07
> +#define CHIP_M65_AURORA64VP	0x08
> +#define CHIP_325_VIRGE		0x09
> +#define CHIP_988_VIRGE_VX	0x0A
> +#define CHIP_375_VIRGE_DX	0x0B
> +#define CHIP_385_VIRGE_GX	0x0C
> +#define CHIP_356_VIRGE_GX2	0x0D
> +#define CHIP_357_VIRGE_GX2P	0x0E
> +#define CHIP_359_VIRGE_GX2P	0x0F
> +
> +#define CHIP_XXX_TRIO		0x80
> +#define CHIP_XXX_TRIO64V2_DXGX	0x81
> +#define CHIP_XXX_VIRGE_DXGX	0x82
> +
> +#define CHIP_UNDECIDED_FLAG	0x80
> +#define CHIP_MASK		0xFF
> +
> +/* CRT timing register sets */
> +
> +static const struct vga_regset s3_h_total_regs[]        = {{0x00, 0, 7}, {0x5D, 0, 0}, VGA_REGSET_END};
> +static const struct vga_regset s3_h_display_regs[]      = {{0x01, 0, 7}, {0x5D, 1, 1}, VGA_REGSET_END};
> +static const struct vga_regset s3_h_blank_start_regs[]  = {{0x02, 0, 7}, {0x5D, 2, 2}, VGA_REGSET_END};
> +static const struct vga_regset s3_h_blank_end_regs[]    = {{0x03, 0, 4}, {0x05, 7, 7}, VGA_REGSET_END};
> +static const struct vga_regset s3_h_sync_start_regs[]   = {{0x04, 0, 7}, {0x5D, 4, 4}, VGA_REGSET_END};
> +static const struct vga_regset s3_h_sync_end_regs[]     = {{0x05, 0, 4}, VGA_REGSET_END};
> +
> +static const struct vga_regset s3_v_total_regs[]        = {{0x06, 0, 7}, {0x07, 0, 0}, {0x07, 5, 5}, {0x5E, 0, 0}, VGA_REGSET_END};
> +static const struct vga_regset s3_v_display_regs[]      = {{0x12, 0, 7}, {0x07, 1, 1}, {0x07, 6, 6}, {0x5E, 1, 1}, VGA_REGSET_END};
> +static const struct vga_regset s3_v_blank_start_regs[]  = {{0x15, 0, 7}, {0x07, 3, 3}, {0x09, 5, 5}, {0x5E, 2, 2}, VGA_REGSET_END};
> +static const struct vga_regset s3_v_blank_end_regs[]    = {{0x16, 0, 7}, VGA_REGSET_END};
> +static const struct vga_regset s3_v_sync_start_regs[]   = {{0x10, 0, 7}, {0x07, 2, 2}, {0x07, 7, 7}, {0x5E, 4, 4}, VGA_REGSET_END};
> +static const struct vga_regset s3_v_sync_end_regs[]     = {{0x11, 0, 3}, VGA_REGSET_END};
> +
> +static const struct vga_regset s3_line_compare_regs[]   = {{0x18, 0, 7}, {0x07, 4, 4}, {0x09, 6, 6}, {0x5E, 6, 6}, VGA_REGSET_END};
> +static const struct vga_regset s3_start_address_regs[]  = {{0x0d, 0, 7}, {0x0c, 0, 7}, {0x31, 4, 5}, {0x51, 0, 1}, VGA_REGSET_END};
> +static const struct vga_regset s3_offset_regs[]         = {{0x13, 0, 7}, {0x51, 4, 5}, VGA_REGSET_END}; /* set 0x43 bit 2 to 0 */
> +
> +static const struct svga_timing_regs s3_timing_regs     = {
> +	s3_h_total_regs, s3_h_display_regs, s3_h_blank_start_regs,
> +	s3_h_blank_end_regs, s3_h_sync_start_regs, s3_h_sync_end_regs,
> +	s3_v_total_regs, s3_v_display_regs, s3_v_blank_start_regs,
> +	s3_v_blank_end_regs, s3_v_sync_start_regs, s3_v_sync_end_regs,
> +};
> +
> +
> +/* ------------------------------------------------------------------------- */
> +
> +/* Module parameters */
> +
> +
> +static char *mode = "640x480-8@60";
> +
> +#ifdef CONFIG_MTRR
> +static int mtrr = 1;
> +#endif
> +
> +static int fasttext = 1;
> +
> +#ifdef MODULE

This is probably unneeded, since those macros resolves to nothing when !MODULE.

> +
> +MODULE_AUTHOR("(c) 2006 Ondrej Zajicek <santiago@crfreenet.org>");
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("fbdev driver for S3 Trio/Virge");
> +
> +module_param(mode, charp, 0444);
> +MODULE_PARM_DESC(mode, "Default video mode ('640x480-8@60', etc)");
> +
> +#ifdef CONFIG_MTRR
> +module_param(mtrr, int, 0444);
> +MODULE_PARM_DESC(mtrr, "Enable write-combining with MTRR (1=enable, 0=disable, default=1)");
> +#endif
> +
> +module_param(fasttext, int, 0644);
> +MODULE_PARM_DESC(fasttext, "Enable S3 fast text mode (1=enable, 0=disable, default=1)");
> +
> +#endif
> +
> +/* ------------------------------------------------------------------------- */
> +
> +/* Set font in S3 fast text mode */
> +
> +static void s3fb_settile_fast(struct fb_info *info, struct fb_tilemap *map)
> +{
> +	const u8 *font = map->data;
> +	u8* fb = (u8 *) info->screen_base;
> +	int i, c;
> +
> +	if ((map->width != 8) || (map->height != 16) ||
> +	    (map->depth != 1) || (map->length != 256)) {
> +	    	printk(KERN_ERR "fb%d: unsupported font parameters: width %d, height %d, depth %d, length %d\n",
> +			info->node, map->width, map->height, map->depth, map->length);
> +		return;
> +	}
> +
> +	fb += 2;
> +	for (i = 0; i < map->height; i++) {
> +		for (c = 0; c < map->length; c++) {
> +			fb[c * 4] = font[c * map->height + i];
> +		}
> +		fb += 1024;
> +	}
> +}
> +
> +
> +
> +static struct fb_tile_ops s3fb_tile_ops = {
> +	.fb_settile	= svga_settile,
> +	.fb_tilecopy	= svga_tilecopy,
> +	.fb_tilefill    = svga_tilefill,
> +	.fb_tileblit    = svga_tileblit,
> +	.fb_tilecursor  = svga_tilecursor,
> +};
> +
> +static struct fb_tile_ops s3fb_fast_tile_ops = {
> +	.fb_settile	= s3fb_settile_fast,
> +	.fb_tilecopy	= svga_tilecopy,
> +	.fb_tilefill    = svga_tilefill,
> +	.fb_tileblit    = svga_tileblit,
> +	.fb_tilecursor  = svga_tilecursor,
> +};
> +
> +
> +/* ------------------------------------------------------------------------- */
> +
> +/* image data is MSB-first, fb structure is MSB-first too */
> +static inline u32 expand_color(u32 c)
> +{ return ((c & 1) | ((c & 2) << 7) | ((c & 4) << 14) | ((c & 8) << 21)) * 0xFF; }

{
	return xxx;
}
is preferred way

> +
> +/* s3fb_iplan_imageblit silently assumes that almost everything is 8-pixel aligned */
> +static void s3fb_iplan_imageblit(struct fb_info *info, const struct fb_image *image)
> +{
> +	u32 fg = expand_color(image->fg_color);
> +	u32 bg = expand_color(image->bg_color);
> +	const u8 *src1, *src;
> +	u8 __iomem *dst1;
> +	u32 __iomem *dst;
> +	u32 val;
> +	int x, y;
> +
> +	src1 = image->data;
> +        dst1 = info->screen_base + (image->dy * info->fix.line_length)
> +		 + ((image->dx / 8) * 4);
> +
> +	for (y = 0; y < image->height; y++) {
> +		src = src1;
> +		dst = (u32 __iomem *) dst1;
> +		for (x = 0; x < image->width; x += 8) {
> +			val = *(src++) * 0x01010101;
> +			val = (val & fg) | (~val & bg);
> +			fb_writel(val, dst++);
> +		}
> +		src1 += image->width / 8;
> +		dst1 += info->fix.line_length;
> +	}
> +
> +}
> +
> +/* s3fb_iplan_fillrect silently assumes that almost everything is 8-pixel aligned */
> +static void s3fb_iplan_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
> +{
> +	u32 fg = expand_color(rect->color);
> +	u8 __iomem *dst1;
> +	u32 __iomem *dst;
> +	int x, y;
> +
> +        dst1 = info->screen_base + (rect->dy * info->fix.line_length)
> +		 + ((rect->dx / 8) * 4);
> +
> +	for (y = 0; y < rect->height; y++) {
> +		dst = (u32 __iomem *) dst1;
> +		for (x = 0; x < rect->width; x += 8) {
> +			fb_writel(fg, dst++);
> +		}
> +		dst1 += info->fix.line_length;
> +	}
> +
> +}
> +
> +
> +/* image data is MSB-first, fb structure is high-nibble-in-low-byte-first */
> +static inline u32 expand_pixel(u32 c)
> +{
> +	return (((c &  1) << 24) | ((c &  2) << 27) | ((c &  4) << 14) | ((c &   8) << 17) |
> +		((c & 16) <<  4) | ((c & 32) <<  7) | ((c & 64) >>  6) | ((c & 128) >>  3)) * 0xF;
> +}
> +
> +/* s3fb_cfb4_imageblit silently assumes that almost everything is 8-pixel aligned */
> +static void s3fb_cfb4_imageblit(struct fb_info *info, const struct fb_image *image)
> +{
> +	u32 fg = image->fg_color * 0x11111111;
> +	u32 bg = image->bg_color * 0x11111111;
> +	const u8 *src1, *src;
> +	u8 __iomem *dst1;
> +	u32 __iomem *dst;
> +	u32 val;
> +	int x, y;
> +
> +	src1 = image->data;
> +        dst1 = info->screen_base + (image->dy * info->fix.line_length)
> +		 + ((image->dx / 8) * 4);
> +
> +	for (y = 0; y < image->height; y++) {
> +		src = src1;
> +		dst = (u32 __iomem *) dst1;
> +		for (x = 0; x < image->width; x += 8) {
> +			val = expand_pixel(*(src++));
> +			val = (val & fg) | (~val & bg);
> +			fb_writel(val, dst++);
> +		}
> +		src1 += image->width / 8;
> +		dst1 += info->fix.line_length;
> +	}
> +
> +}
> +
> +static void s3fb_imageblit(struct fb_info *info, const struct fb_image *image)
> +{
> +	if ((info->var.bits_per_pixel == 4) && (image->depth == 1)
> +	    && ((image->width % 8) == 0) && ((image->dx % 8) == 0)) {
> +		if (info->fix.type == FB_TYPE_INTERLEAVED_PLANES)
> +			s3fb_iplan_imageblit(info, image);
> +		else
> +			s3fb_cfb4_imageblit(info, image);
> +	} else
> +		cfb_imageblit(info, image);
> +}
> +
> +static void s3fb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
> +{
> +	if ((info->var.bits_per_pixel == 4)
> +	    && ((rect->width % 8) == 0) && ((rect->dx % 8) == 0)
> +	    && (info->fix.type == FB_TYPE_INTERLEAVED_PLANES))
> +		s3fb_iplan_fillrect(info, rect);
> +	 else
> +		cfb_fillrect(info, rect);
> +}
> +
> +
> +
> +/* ------------------------------------------------------------------------- */
> +
> +
> +static void s3_set_pixclock(struct fb_info *info, u32 pixclock)
> +{
> +	u16 m, n, r;
> +	u8 regval;
> +
> +	svga_compute_pll(&s3_pll, 1000000000 / pixclock, &m, &n, &r, info->node);

Did you mean NSEC_PER_SEC?

> +
> +	/* Set VGA misc register  */
> +	regval = vga_r(NULL, VGA_MIS_R);
> +	vga_w(NULL, VGA_MIS_W, regval | VGA_MIS_ENB_PLL_LOAD);
> +
> +	/* Set S3 clock registers */
> +	vga_wseq(NULL, 0x12, ((n - 2) | (r << 5)));
> +	vga_wseq(NULL, 0x13, m - 2);
> +
> +	udelay(1000);
> +
> +	/* Activate clock - write 0, 1, 0 to seq/15 bit 5 */
> +	regval = vga_rseq (NULL, 0x15); /* | 0x80; */
> +	vga_wseq(NULL, 0x15, regval & ~(1<<5));
> +	vga_wseq(NULL, 0x15, regval |  (1<<5));
> +	vga_wseq(NULL, 0x15, regval & ~(1<<5));
> +}
> +
> +
> +/* Open framebuffer */
> +
> +static int s3fb_open(struct fb_info *info, int user)
> +{
> +	struct s3fb_info *par = (struct s3fb_info *) info;
> +	unsigned int count = atomic_read(&(par->ref_count));
> +
> +	if (!count) {

bad

> +		memset(&(par->state), 0, sizeof(struct vgastate));
> +		par->state.flags = VGA_SAVE_MODE | VGA_SAVE_FONTS | VGA_SAVE_CMAP;
> +		par->state.num_crtc = 0x70;
> +		par->state.num_seq = 0x20;
> +		save_vga(&(par->state));
> +	}
> +
> +	atomic_inc(&(par->ref_count));
> +
> +	return 0;
> +}
> +
> +/* Close framebuffer */
> +
> +static int s3fb_release(struct fb_info *info, int user)
> +{
> +	struct s3fb_info *par = (struct s3fb_info *) info;

Use container_of for this (and below/above).

> +	unsigned int count = atomic_read(&(par->ref_count));
> +
> +	if (!count)
> +		return -EINVAL;
> +
> +	if (count == 1)
> +		restore_vga(&(par->state));

This is not atomic.

> +
> +	atomic_dec(&(par->ref_count));
> +
> +	return 0;
> +}
> +
> +/* Validate passed in var */
> +
> +static int s3fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
> +{
> +	struct s3fb_info *par = (struct s3fb_info *) info;
> +	int rv, mem, step;
> +
> +	/* Find appropriate format */
> +	rv = svga_match_format (s3fb_formats, var, NULL);
> +	if ((rv < 0) || ((par->chip == CHIP_988_VIRGE_VX) ? (rv == 7) : (rv == 6)))
> +	{		/* 24bpp on VIRGE VX, 32bpp on others */
> +		printk(KERN_ERR "fb%d: unsupported mode requested\n", info->node);
> +		return rv;
> +	}
> +
> +	/* Do not allow to have real resoulution larger than virtual */
> +	if (var->xres > var->xres_virtual)
> +		var->xres_virtual = var->xres;
> +
> +	if (var->yres > var->yres_virtual)
> +		var->yres_virtual = var->yres;
> +
> +	/* Round up xres_virtual to have proper alignment of lines */
> +	step = s3fb_formats[rv].xresstep - 1;
> +	var->xres_virtual = (var->xres_virtual+step) & ~step;
> +
> +	/* Check whether have enough memory */
> +	mem = ((var->bits_per_pixel * var->xres_virtual) >> 3) * var->yres_virtual;
> +	if (mem > info->screen_size)
> +	{
> +		printk(KERN_ERR "fb%d: not enough framebuffer memory (%d kB requested , %d kB available)\n", info->node, mem >> 10, (unsigned int) (info->screen_size >> 10));

This is sooo long line, split it.

> +		return -EINVAL;
> +	}
> +
> +	rv = svga_check_timings (&s3_timing_regs, var, info->node);
> +	if (rv < 0)
> +	{
> +		printk(KERN_ERR "fb%d: invalid timings requested\n", info->node);
> +		return rv;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Set video mode from par */
> +
> +static int s3fb_set_par(struct fb_info *info)
> +{
> +	struct s3fb_info *par = (struct s3fb_info *) info;
> +	u32 value, mode, hmul, offset_value, screen_size, multiplex;
> +	u32 bpp = info->var.bits_per_pixel;
> +
> +	if (bpp != 0) {
> +		info->fix.ypanstep = 1;
> +		info->fix.line_length = (info->var.xres_virtual * bpp) / 8;
> +
> +		info->flags &= ~FBINFO_MISC_TILEBLITTING;
> +		info->tileops = NULL;
> +
> +		offset_value = (info->var.xres_virtual * bpp) / 64;
> +		screen_size = info->var.yres_virtual * info->fix.line_length;
> +	} else {
> +		info->fix.ypanstep = 16;
> +		info->fix.line_length = 0;
> +
> +		info->flags |= FBINFO_MISC_TILEBLITTING;
> +		info->tileops = fasttext ? &s3fb_fast_tile_ops : &s3fb_tile_ops;
> +
> +		offset_value = info->var.xres_virtual / 16;
> +		screen_size = (info->var.xres_virtual * info->var.yres_virtual) / 64;
> +	}
> +
> +	info->var.xoffset = 0;
> +	info->var.yoffset = 0;
> +	info->var.activate = FB_ACTIVATE_NOW;
> +
> +	/* Unlock registers */
> +	vga_wcrt(NULL, 0x38, 0x48);
> +	vga_wcrt(NULL, 0x39, 0xA5);
> +	vga_wseq(NULL, 0x08, 0x06);
> +	svga_wcrt_mask(0x11, 0x00, 0x80);
> +
> +	/* Blank screen and turn off sync */
> +	svga_wseq_mask(0x01, 0x20, 0x20);
> +	svga_wcrt_mask(0x17, 0x00, 0x80);
> +
> +	/* Set default values */
> +	svga_set_default_gfx_regs();
> +	svga_set_default_atc_regs();
> +	svga_set_default_seq_regs();
> +	svga_set_default_crt_regs();
> +	svga_wcrt_multi(s3_line_compare_regs, 0xFFFFFFFF);
> +	svga_wcrt_multi(s3_start_address_regs, 0);
> +
> +	/* S3 specific initialization */
> +	svga_wcrt_mask(0x58, 0x10, 0x10); /* enable linear framebuffer */
> +	svga_wcrt_mask(0x31, 0x08, 0x08); /* enable sequencer access to framebuffer above 256 kB */
> +
> +/*	svga_wcrt_mask(0x33, 0x08, 0x08); */ /* DDR ?	*/
> +/*	svga_wcrt_mask(0x43, 0x01, 0x01); */ /* DDR ?	*/
> +	svga_wcrt_mask(0x33, 0x00, 0x08); /* no DDR ?	*/
> +	svga_wcrt_mask(0x43, 0x00, 0x01); /* no DDR ?	*/
> +
> +	svga_wcrt_mask(0x5D, 0x00, 0x28); // Clear strange HSlen bits
> +
> +/*	svga_wcrt_mask(0x58, 0x03, 0x03); */
> +
> +/*	svga_wcrt_mask(0x53, 0x12, 0x13); */ /* enable MMIO */
> +/*	svga_wcrt_mask(0x40, 0x08, 0x08); */ /* enable write buffer */
> +
> +
> +	/* Set the offset register */
> +	pr_debug("fb%d: offset register       : %d\n", info->node, offset_value);
> +	svga_wcrt_multi(s3_offset_regs, offset_value);
> +
> +	vga_wcrt(NULL, 0x54, 0x18); /* M parameter */
> +	vga_wcrt(NULL, 0x60, 0xff); /* N parameter */
> +	vga_wcrt(NULL, 0x61, 0xff); /* L parameter */
> +	vga_wcrt(NULL, 0x62, 0xff); /* L parameter */
> +
> +	vga_wcrt(NULL, 0x3A, 0x35);
> +	svga_wattr(0x33, 0x00);
> +
> +	if (info->var.vmode & FB_VMODE_DOUBLE)
> +		svga_wcrt_mask(0x09, 0x80, 0x80);
> +	else
> +		svga_wcrt_mask(0x09, 0x00, 0x80);
> +
> +	if (info->var.vmode & FB_VMODE_INTERLACED)
> +		svga_wcrt_mask(0x42, 0x20, 0x20);
> +	else
> +		svga_wcrt_mask(0x42, 0x00, 0x20);
> +
> +	/* Disable hardware graphics cursor */
> +	svga_wcrt_mask(0x45, 0x00, 0x01);
> +	/* Disable Streams engine */
> +	svga_wcrt_mask(0x67, 0x00, 0x0C);
> +
> +
> +
> +	mode = svga_match_format(s3fb_formats, &(info->var), &(info->fix));
> +
> +	/* S3 virge DX hack */
> +	if (par->chip == CHIP_375_VIRGE_DX) {
> +		vga_wcrt(NULL, 0x86, 0x80);
> +		vga_wcrt(NULL, 0x90, 0x00);
> +	}
> +
> +	/* S3 virge VX hack */
> +	if (par->chip == CHIP_988_VIRGE_VX) {
> +		vga_wcrt(NULL, 0x50, 0x00);
> +		vga_wcrt(NULL, 0x67, 0x50);
> +
> +		vga_wcrt(NULL, 0x63, (mode <= 2) ? 0x90 : 0x09);
> +		vga_wcrt(NULL, 0x66, 0x90);
> +	}
> +
> +	svga_wcrt_mask(0x31, 0x00, 0x40);
> +	multiplex = 0;
> +	hmul = 1;
> +
> +	/* Set mode-specific register values */
> +	switch (mode) {
> +		case 0:

This is not, how we indent switch/case.

> +			pr_debug("fb%d: text mode\n", info->node);
> +			svga_set_textmode_vga_regs();
> +
> +			/* Set additional registers like in 8-bit mode */
> +			svga_wcrt_mask(0x50, 0x00, 0x30);
> +			svga_wcrt_mask(0x67, 0x00, 0xF0);
> +
> +			/* Disable enhanced mode */
> +			svga_wcrt_mask(0x3A, 0x00, 0x30);
> +
> +			if (fasttext) {
> +				pr_debug("fb%d: high speed text mode set\n", info->node);
> +				svga_wcrt_mask(0x31, 0x40, 0x40);
> +			}
> +		break;
> +		case 1:
> +			pr_debug("fb%d: 4 bit pseudocolor\n", info->node);
> +			vga_wgfx(NULL, VGA_GFX_MODE, 0x40);
> +
> +			/* Set additional registers like in 8-bit mode */
> +			svga_wcrt_mask(0x50, 0x00, 0x30);
> +			svga_wcrt_mask(0x67, 0x00, 0xF0);
> +
> +			/* disable enhanced mode */
> +			svga_wcrt_mask(0x3A, 0x00, 0x30);
> +		break;
> +		case 2:
> +			pr_debug("fb%d: 4 bit pseudocolor, planar\n", info->node);
> +
> +			/* Set additional registers like in 8-bit mode */
> +			svga_wcrt_mask(0x50, 0x00, 0x30);
> +			svga_wcrt_mask(0x67, 0x00, 0xF0);
> +
> +			/* disable enhanced mode */
> +			svga_wcrt_mask(0x3A, 0x00, 0x30);
> +		break;
> +		case 3:
> +			pr_debug("fb%d: 8 bit pseudocolor\n", info->node);
> +			if (info->var.pixclock > 20000) {
> +				svga_wcrt_mask(0x50, 0x00, 0x30);
> +				svga_wcrt_mask(0x67, 0x00, 0xF0);
> +			} else {
> +				svga_wcrt_mask(0x50, 0x00, 0x30);
> +				svga_wcrt_mask(0x67, 0x10, 0xF0);
> +				multiplex = 1;
> +			}
> +		break;
> +		case 4:
> +			pr_debug("fb%d: 5/5/5 truecolor\n", info->node);
> +			if (par->chip == CHIP_988_VIRGE_VX) {
> +				if (info->var.pixclock > 20000)
> +					svga_wcrt_mask(0x67, 0x20, 0xF0);
> +				else
> +					svga_wcrt_mask(0x67, 0x30, 0xF0);
> +			} else {
> +				svga_wcrt_mask(0x50, 0x10, 0x30);
> +				svga_wcrt_mask(0x67, 0x30, 0xF0);
> +				hmul = 2;
> +			}
> +		break;
> +		case 5:
> +			pr_debug("fb%d: 5/6/5 truecolor\n", info->node);
> +			if (par->chip == CHIP_988_VIRGE_VX) {
> +				if (info->var.pixclock > 20000)
> +					svga_wcrt_mask(0x67, 0x40, 0xF0);
> +				else
> +					svga_wcrt_mask(0x67, 0x50, 0xF0);
> +			} else {
> +				svga_wcrt_mask(0x50, 0x10, 0x30);
> +				svga_wcrt_mask(0x67, 0x50, 0xF0);
> +				hmul = 2;
> +			}
> +		break;
> +		case 6:
> +			/* VIRGE VX case */
> +			pr_debug("fb%d: 8/8/8 truecolor\n", info->node);
> +			svga_wcrt_mask(0x67, 0xD0, 0xF0);
> +		break;
> +		case 7:
> +			pr_debug("fb%d: 8/8/8/8 truecolor\n", info->node);
> +			svga_wcrt_mask(0x50, 0x30, 0x30);
> +			svga_wcrt_mask(0x67, 0xD0, 0xF0);
> +		break;
> +		default:
> +			printk(KERN_ERR "fb%d: unsupported mode - bug\n", info->node);
> +			return -EINVAL;
> +	}
> +
> +	if (par->chip != CHIP_988_VIRGE_VX) {
> +		svga_wseq_mask(0x15, multiplex ? 0x10 : 0x00, 0x10);
> +		svga_wseq_mask(0x18, multiplex ? 0x80 : 0x00, 0x80);
> +	}
> +
> +	s3_set_pixclock(info, info->var.pixclock);
> +	svga_set_timings(&s3_timing_regs, &(info->var), hmul, 1,
> +			 (info->var.vmode & FB_VMODE_DOUBLE)     ? 2 : 1,
> +			 (info->var.vmode & FB_VMODE_INTERLACED) ? 2 : 1,
> +			 hmul, info->node);
> +
> +
> +
> +	/* Set interlaced mode start/end register */
> +	value = info->var.xres + info->var.left_margin + info->var.right_margin + info->var.hsync_len;
> +	value = ((value * hmul) / 8) - 5;
> +	vga_wcrt(NULL, 0x3C, (value + 1) / 2);
> +
> +	memset((u8*)info->screen_base, 0x00, screen_size);
> +	/* Device and screen back on */
> +	svga_wcrt_mask(0x17, 0x80, 0x80);
> +	svga_wseq_mask(0x01, 0x00, 0x20);
> +
> +	return 0;
> +}
> +
> +/* Set a colour register */
> +
> +static int s3fb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
> +				u_int transp, struct fb_info *fb)
> +{
> +	switch (fb->var.bits_per_pixel) {
> +		case 0:
> +		case 4:
> +			if (regno >= 16) return -EINVAL;
> +
> +			if ((fb->var.bits_per_pixel == 4) &&
> +			    (fb->var.nonstd == 0)) {
> +				outb(0xF0, VGA_PEL_MSK);
> +				outb(regno*16, VGA_PEL_IW);
> +			} else {
> +				outb(0x0F, VGA_PEL_MSK);
> +				outb(regno, VGA_PEL_IW);
> +			}
> +			outb(red >> 10, VGA_PEL_D);
> +			outb(green >> 10, VGA_PEL_D);
> +			outb(blue >> 10, VGA_PEL_D);
> +		break;
> +		case 8:
> +			if (regno >= 256) return -EINVAL;
> +			outb(0xFF, VGA_PEL_MSK);
> +			outb(regno, VGA_PEL_IW);
> +			outb(red >> 10, VGA_PEL_D);
> +			outb(green >> 10, VGA_PEL_D);
> +			outb(blue >> 10, VGA_PEL_D);
> +		break;
> +		case 16:
> +			if (regno >= 16) return -EINVAL;
> +			if (fb->var.green.length == 5)
> +				((u32*)fb->pseudo_palette)[regno] = ((red & 0xF800) >> 1) | ((green & 0xF800) >> 6) | ((blue & 0xF800) >> 11);
> +			else if (fb->var.green.length == 6)
> +				((u32*)fb->pseudo_palette)[regno] = (red & 0xF800) | ((green & 0xFC00) >> 5) | ((blue & 0xF800) >> 11);
> +			else return -EINVAL;
> +		break;
> +
> +		case 24:
> +		case 32:
> +			if (regno >= 16) return -EINVAL;
> +			((u32*)fb->pseudo_palette)[regno] = ((transp & 0xFF00) >> 16 ) | ((blue & 0xFF00) >> 8) |
> +				(green & 0xFF00) | ((red & 0xFF00) << 8);
> +		break;
> +		default:
> +			return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +
> +/* Set the display blanking state */
> +
> +static int s3fb_blank(int blank_mode, struct fb_info *info)
> +{
> +	switch (blank_mode) {
> +		case FB_BLANK_UNBLANK:

...

> +			pr_debug("fb%d: unblank\n", info->node);
> +			svga_wcrt_mask(0x56, 0x00, 0x06);
> +			svga_wseq_mask(0x01, 0x00, 0x20);
> +		break;
> +		case FB_BLANK_NORMAL:
> +			pr_debug("fb%d: blank\n", info->node);
> +			svga_wcrt_mask(0x56, 0x00, 0x06);
> +			svga_wseq_mask(0x01, 0x20, 0x20);
> +		break;
> +		case FB_BLANK_HSYNC_SUSPEND:
> +			pr_debug("fb%d: hsync\n", info->node);
> +			svga_wcrt_mask(0x56, 0x02, 0x06);
> +			svga_wseq_mask(0x01, 0x20, 0x20);
> +		break;
> +		case FB_BLANK_VSYNC_SUSPEND:
> +			pr_debug("fb%d: vsync\n", info->node);
> +			svga_wcrt_mask(0x56, 0x04, 0x06);
> +			svga_wseq_mask(0x01, 0x20, 0x20);
> +		break;
> +		case FB_BLANK_POWERDOWN:
> +			pr_debug("fb%d: sync down\n", info->node);
> +			svga_wcrt_mask(0x56, 0x06, 0x06);
> +			svga_wseq_mask(0x01, 0x20, 0x20);
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +
> +/* Pan the display */
> +
> +static int s3fb_pan_display(struct fb_var_screeninfo *var, struct fb_info *info) {
> +
> +	unsigned int offset;
> +
> +	/* Validate the offsets */
> +	if ((var->xoffset + var->xres) > var->xres_virtual) return -EINVAL;
> +	if ((var->yoffset + var->yres) > var->yres_virtual) return -EINVAL;

No:
if (cond)
	do_this();

> +
> +	/* Calculate the offset */
> +	if (var->bits_per_pixel == 0) {
> +		offset = (var->yoffset / 16) * (var->xres_virtual / 2) + (var->xoffset / 2);
> +		offset = offset >> 2;
> +	} else {
> +		offset = (var->yoffset * info->fix.line_length) +
> +			 (var->xoffset * var->bits_per_pixel / 8);
> +		offset = offset >> 2;
> +	}
> +
> +	/* Set the offset */
> +	svga_wcrt_multi(s3_start_address_regs, offset);
> +
> +	return 0;
> +}
> +
> +/* ------------------------------------------------------------------------- */
> +
> +/* Frame buffer operations */
> +
> +static struct fb_ops s3fb_ops = {
> +	.owner		= THIS_MODULE,
> +	.fb_open	= s3fb_open,
> +	.fb_release	= s3fb_release,
> +	.fb_check_var	= s3fb_check_var,
> +	.fb_set_par	= s3fb_set_par,
> +	.fb_setcolreg	= s3fb_setcolreg,
> +	.fb_blank	= s3fb_blank,
> +	.fb_pan_display	= s3fb_pan_display,
> +	.fb_fillrect	= s3fb_fillrect,
> +	.fb_copyarea	= cfb_copyarea,
> +	.fb_imageblit	= s3fb_imageblit,
> +};
> +
> +/* ------------------------------------------------------------------------- */
> +
> +static int __devinit s3_identification(int chip)
> +{
> +	if (chip == CHIP_XXX_TRIO) {
> +		u8 cr30 = vga_rcrt(NULL, 0x30);
> +		u8 cr2e = vga_rcrt(NULL, 0x2e);
> +		u8 cr2f = vga_rcrt(NULL, 0x2f);
> +
> +		if ((cr30 == 0xE0) || (cr30 == 0xE1)) {
> +			if (cr2e == 0x10)
> +				return CHIP_732_TRIO32;
> +			if (cr2e == 0x11) {
> +				if (! (cr2f & 0x40))
> +					return CHIP_764_TRIO64;
> +				else
> +					return CHIP_765_TRIO64VP;
> +			}
> +		}
> +	}
> +
> +	if (chip == CHIP_XXX_TRIO64V2_DXGX) {
> +		u8 cr6f = vga_rcrt(NULL, 0x6f);
> +
> +		if (! (cr6f & 0x01))
> +			return CHIP_775_TRIO64V2_DX;
> +		else
> +			return CHIP_785_TRIO64V2_GX;
> +	}
> +
> +	if (chip == CHIP_XXX_VIRGE_DXGX) {
> +		u8 cr6f = vga_rcrt(NULL, 0x6f);
> +
> +		if (! (cr6f & 0x01))
> +			return CHIP_375_VIRGE_DX;
> +		else
> +			return CHIP_385_VIRGE_GX;
> +	}
> +
> +	return CHIP_UNKNOWN;
> +}
> +
> +
> +/* PCI probe */
> +
> +static int __devinit s3_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
> +{
> +	struct fb_info *info;
> +	struct s3fb_info *par;
> +	int rc;
> +	u8 regval, cr38, cr39;
> +
> +	/* Ignore secondary VGA device because there is no VGA arbitration */
> +	if (! svga_primary_device(dev)) {
> +		printk(KERN_INFO "s3fb: ignoring secondary device %s\n",  pci_name(dev));

Use dev_info and friends, when you know the device (without pci_name(dev) in 
this case).

> +		return -ENODEV;
> +	}
> +
> +	/* Allocate and fill driver data structure */
> +
> +	info = framebuffer_alloc(sizeof(struct s3fb_info), NULL);
> +	if (!info) return -ENOMEM;

one line -- one expression

> +	par = (struct s3fb_info*) info;

struct s3fb_info<space>*

> +
> +	info->flags = FBINFO_PARTIAL_PAN_OK | FBINFO_HWACCEL_YPAN;
> +	info->fbops = &s3fb_ops;
> +
> +	/* Prepare PCI device */
> +
> +	rc = pci_enable_device(dev);
> +	if (rc < 0) {
> +		printk(KERN_ERR "s3fb: cannot enable PCI device\n");

dev_err

> +		goto err_enable_device;
> +	}
> +
> +	rc = pci_request_regions(dev, "s3fb");
> +	if (rc < 0) {
> +		printk(KERN_ERR "s3fb: cannot reserve framebuffer region\n");
> +		goto err_request_regions;
> +	}
> +
> +	/* Map physical IO memory address into kernel space */
> +
> +	info->fix.smem_start = pci_resource_start(dev, 0);
> +	info->fix.smem_len = pci_resource_len(dev, 0);
> +
> +	info->screen_base = ioremap_nocache(info->fix.smem_start, info->fix.smem_len);

pci_iomap()

> +	if (! info->screen_base) {
> +		rc = -ENOMEM;
> +		printk(KERN_ERR "s3fb: ioremap for framebuffer failed\n");
> +		goto err_ioremap;
> +	}
> +
> +	/* Unlock regs */
> +	cr38 = vga_rcrt(NULL, 0x38);
> +	cr39 = vga_rcrt(NULL, 0x39);
> +	vga_wseq(NULL, 0x08, 0x06);
> +	vga_wcrt(NULL, 0x38, 0x48);
> +	vga_wcrt(NULL, 0x39, 0xA5);
> +
> +	/* Find how many physical memory there is on card */
> +	/* 0x36 register is accessible even if other registers are locked */
> +	regval = vga_rcrt(NULL, 0x36);
> +	info->screen_size = s3_memsizes[regval >> 5] << 10;
> +	info->fix.smem_len = info->screen_size;
> +
> +	par->chip = id->driver_data & CHIP_MASK;
> +	par->rev = vga_rcrt(NULL, 0x2f);
> +	if (par->chip & CHIP_UNDECIDED_FLAG)
> +		par->chip = s3_identification(par->chip);
> +
> +	/* Find MCLK frequency */
> +	regval = vga_rseq(NULL, 0x10);
> +	par->mclk_freq = ((vga_rseq(NULL, 0x11) + 2) * 14318) / ((regval & 0x1F)  + 2);
> +	par->mclk_freq = par->mclk_freq >> (regval >> 5);
> +
> +	/* Restore locks */
> +	vga_wcrt(NULL, 0x38, cr38);
> +	vga_wcrt(NULL, 0x39, cr39);
> +
> +	strcpy(info->fix.id, s3_names [par->chip]);
> +	info->fix.mmio_start = 0;
> +	info->fix.mmio_len = 0;
> +	info->fix.type = FB_TYPE_PACKED_PIXELS;
> +	info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
> +	info->fix.ypanstep = 0;
> +	info->fix.accel = FB_ACCEL_NONE;
> +	info->pseudo_palette = (void*) (par->pseudo_palette);
> +
> +	/* Prepare startup mode */
> +
> +	rc = fb_find_mode(&(info->var), info, mode, NULL, 0, NULL, 8);
> +	if (! ((rc == 1) || (rc == 2))) {
> +		rc = -EINVAL;
> +		printk(KERN_ERR "s3fb: mode %s not found\n", mode);
> +		goto err_find_mode;
> +	}
> +
> +	rc = fb_alloc_cmap(&info->cmap, 256, 0);
> +	if (rc < 0) goto err_alloc_cmap;

...

> +
> +	rc = register_framebuffer(info);
> +	if (rc < 0) goto err_reg_fb;
> +
> +	printk(KERN_INFO "fb%d: %s on %s, %d MB RAM, %d MHz MCLK\n", info->node, info->fix.id,
> +		 pci_name(dev), info->fix.smem_len >> 20, (par->mclk_freq + 500) / 1000);
> +
> +	if (par->chip == CHIP_UNKNOWN)
> +		printk(KERN_INFO "fb%d: unknown chip, CR2D=%x, CR2E=%x, CRT2F=%x, CRT30=%x\n",
> +			info->node, vga_rcrt(NULL, 0x2d), vga_rcrt(NULL, 0x2e),
> +			vga_rcrt(NULL, 0x2f), vga_rcrt(NULL, 0x30));
> +
> +	/* Record a reference to the driver data */
> +	pci_set_drvdata(dev, info);
> +
> +#ifdef CONFIG_MTRR
> +	if (mtrr) {
> +		par->mtrr_reg = -1;
> +		par->mtrr_reg = mtrr_add(info->fix.smem_start, info->fix.smem_len, MTRR_TYPE_WRCOMB, 1);
> +	}
> +#endif
> +
> +	return 0;
> +
> +	/* Error handling */
> +err_reg_fb:
> +	fb_dealloc_cmap(&info->cmap);
> +err_alloc_cmap:
> +err_find_mode:
> +	iounmap(info->screen_base);
> +err_ioremap:
> +	pci_release_regions(dev);
> +err_request_regions:
> +/*	pci_disable_device(dev); */
> +err_enable_device:
> +	framebuffer_release(info);
> +	return rc;
> +}
> +
> +
> +/* PCI remove */
> +
> +static void __devexit s3_pci_remove(struct pci_dev *dev)
> +{
> +	struct fb_info *info = pci_get_drvdata(dev);
> +	struct s3fb_info *par = (struct s3fb_info *) info;
> +
> +	if (info) {
> +
> +#ifdef CONFIG_MTRR
> +		if (par->mtrr_reg >= 0) {
> +			mtrr_del(par->mtrr_reg, 0, 0);
> +			par->mtrr_reg = -1;
> +		}
> +#endif
> +
> +		unregister_framebuffer(info);
> +		fb_dealloc_cmap(&info->cmap);
> +
> +		iounmap(info->screen_base);

pci_iounmap

> +		pci_release_regions(dev);
> +/*		pci_disable_device(dev); */
> +
> +		pci_set_drvdata(dev, NULL);
> +		framebuffer_release(info);
> +	}
> +}
> +
> +/* PCI suspend */
> +
> +static int s3_pci_suspend(struct pci_dev* dev, pm_message_t state)
> +{
> +	struct fb_info *info = pci_get_drvdata(dev);
> +	unsigned int count = atomic_read(&(((struct s3fb_info *) info)->ref_count));
> +
> +	printk(KERN_INFO "fb%d: suspend\n", info->node);

dev_info

> +
> +	if ((state.event == PM_EVENT_FREEZE) || (!count)) {
> +		return 0;
> +	}
> +
> +	acquire_console_sem();
> +	fb_set_suspend(info, 1);
> +
> +	pci_save_state(dev);
> +	pci_disable_device(dev);
> +	pci_set_power_state(dev, pci_choose_state(dev, state));
> +	release_console_sem();
> +
> +	return 0;
> +}
> +
> +
> +/* PCI resume */
> +
> +static int s3_pci_resume(struct pci_dev* dev)
> +{
> +	struct fb_info *info = pci_get_drvdata(dev);
> +	unsigned int count = atomic_read(&(((struct s3fb_info *) info)->ref_count));
> +
> +	printk(KERN_INFO "fb%d: resume\n", info->node);
> +
> +	if (!count) {

not atomic

> +		return 0;
> +	}

unneeded braces

> +
> +	acquire_console_sem();
> +	pci_set_power_state(dev, PCI_D0);
> +	pci_restore_state(dev);
> +	pci_enable_device(dev);
> +	pci_set_master(dev);
> +
> +	s3fb_set_par(info);
> +	fb_set_suspend(info, 0);
> +	release_console_sem();
> +
> +	return 0;
> +}
> +
> +
> +/* List of boards that we are trying to support */
> +
> +static struct pci_device_id s3_devices[] __devinitdata = {
> +	{PCI_VENDOR_ID_S3,	0x8810,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_XXX_TRIO},
> +	{PCI_VENDOR_ID_S3,	0x8811,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_XXX_TRIO},
> +	{PCI_VENDOR_ID_S3,	0x8812,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_M65_AURORA64VP},
> +	{PCI_VENDOR_ID_S3,	0x8814,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_767_TRIO64UVP},
> +	{PCI_VENDOR_ID_S3,	0x8901,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_XXX_TRIO64V2_DXGX},
> +	{PCI_VENDOR_ID_S3,	0x8902,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_551_PLATO_PX},
> +
> +	{PCI_VENDOR_ID_S3,	0x5631,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_325_VIRGE},
> +	{PCI_VENDOR_ID_S3,	0x883D,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_988_VIRGE_VX},
> +	{PCI_VENDOR_ID_S3,	0x8A01,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_XXX_VIRGE_DXGX},
> +	{PCI_VENDOR_ID_S3,	0x8A10,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_356_VIRGE_GX2},
> +	{PCI_VENDOR_ID_S3,	0x8A11,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_357_VIRGE_GX2P},
> +	{PCI_VENDOR_ID_S3,	0x8A12,		PCI_ANY_ID,PCI_ANY_ID,0,0, CHIP_359_VIRGE_GX2P},

{PCI_DEVICE(PCI_VENDOR_ID_S3, 0x8810), .driver_data = CHIP_XXX_TRIO}
is nicer

> +
> +	{0, 0, 0, 0, 0, 0, 0}
> +};
> +
> +
> +MODULE_DEVICE_TABLE(pci, s3_devices);
> +
> +static struct pci_driver s3fb_pci_driver = {
> +	.name		= "s3fb",
> +	.id_table	= s3_devices,
> +	.probe		= s3_pci_probe,
> +	.remove		= __devexit_p(s3_pci_remove),
> +	.suspend	= s3_pci_suspend,
> +	.resume		= s3_pci_resume,
> +};
> +
> +/* Parse user speficied options */
> +
> +#ifndef MODULE
> +static int  __init s3fb_setup(char *options)
> +{
> +	char *opt;
> +
> +	if (!options || !*options)
> +		return 0;
> +
> +	while ((opt = strsep(&options, ",")) != NULL) {
> +
> +		if (!*opt)
> +			continue;
> +#ifdef CONFIG_MTRR
> +		else if (!strcmp(opt, "mtrr:"))
> +			mtrr = simple_strtoul(opt + 5, NULL, 0);
> +#endif
> +		else if (!strcmp(opt, "fasttext:"))
> +			mtrr = simple_strtoul(opt + 9, NULL, 0);
> +		else
> +			mode = opt;
> +	}
> +
> +	return 0;
> +}
> +#endif
> +
> +/* Cleanup */
> +
> +static void __exit s3fb_cleanup(void)
> +{
> +
> +	pr_debug("s3fb: cleaning up\n");
> +	pci_unregister_driver(&s3fb_pci_driver);
> +}
> +
> +/* Driver Initialisation */
> +
> +static int __init s3fb_init(void)
> +{
> +
> +#ifndef MODULE
> +        char *option = NULL;
> +
> +        if (fb_get_options("s3fb", &option))
> +                return -ENODEV;
> +        s3fb_setup(option);
    ^^^^^^^^ not a tab character

> +#endif
> +
> +	pr_debug("s3fb: initializing\n");
> +	return pci_register_driver(&s3fb_pci_driver);
> +}
> +
> +/* ------------------------------------------------------------------------- */
> +
> +/* Modularization */
> +
> +module_init(s3fb_init);
> +module_exit(s3fb_cleanup);
[...]
> diff -uprN -X linux-2.6.20/Documentation/dontdiff linux-2.6.20/include/linux/svga.h linux-2.6.20-s3fb/include/linux/svga.h
> --- linux-2.6.20/include/linux/svga.h	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.20-s3fb/include/linux/svga.h	2007-02-05 14:26:14.000000000 +0100
> @@ -0,0 +1,124 @@
> +#ifndef _LINUX_SVGA_H
> +#define _LINUX_SVGA_H
> +
> +#ifdef __KERNEL__
> +
> +#include <linux/pci.h>
> +#include <video/vga.h>
> +
> +/* Terminator for register set */
> +
> +#define VGA_REGSET_END_VAL	0xFF
> +#define VGA_REGSET_END		{VGA_REGSET_END_VAL, 0, 0}
> +
> +struct vga_regset {
> +	__u8 regnum;
> +	__u8 lowbit;
> +	__u8 highbit;

You use no __ variants, why __u8 here?



-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
