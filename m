Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZJSMrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZJSMrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 08:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZJSMrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 08:47:24 -0400
Received: from fifo99.com ([67.223.236.141]:48568 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbZJSMrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 08:47:23 -0400
Subject: Re: [PATCH] mb862xxfb: add acceleration support for
 Coral-P/Coral-PA. * imageblt * copyarea * fillrect
From: Daniel Walker <dwalker@fifo99.com>
To: Valentin Sitdikov <valentin.sitdikov@siemens.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, akpm@linux-foundation.org
In-Reply-To: <1255949573-15937-1-git-send-email-valentin.sitdikov@siemens.com>
References: <1255949573-15937-1-git-send-email-valentin.sitdikov@siemens.com>
Content-Type: text/plain
Date: Mon, 19 Oct 2009 05:47:25 -0700
Message-Id: <1255956445.23353.38.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Your code has lots of style issues .. I commented below in some of the
areas of code with some errors messages from scripts/checkpatch.pl

On Mon, 2009-10-19 at 14:52 +0400, Valentin Sitdikov wrote:
> Signed-off-by: Valentin Sitdikov <valentin.sitdikov@siemens.com>
> ---
>  drivers/video/mb862xx/Makefile          |    2 +-
>  drivers/video/mb862xx/mb862xxfb.c       |   16 ++-
>  drivers/video/mb862xx/mb862xxfb.h       |    2 +
>  drivers/video/mb862xx/mb862xxfb_accel.c |  318 +++++++++++++++++++++++++++++++
>  drivers/video/mb862xx/mb862xxfb_accel.h |  203 ++++++++++++++++++++
>  5 files changed, 539 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/video/mb862xx/mb862xxfb_accel.c
>  create mode 100644 drivers/video/mb862xx/mb862xxfb_accel.h
> 
> diff --git a/drivers/video/mb862xx/Makefile b/drivers/video/mb862xx/Makefile
> index 0766481..d777771 100644
> --- a/drivers/video/mb862xx/Makefile
> +++ b/drivers/video/mb862xx/Makefile
> @@ -2,4 +2,4 @@
>  # Makefile for the MB862xx framebuffer driver
>  #
>  
> -obj-$(CONFIG_FB_MB862XX)	:= mb862xxfb.o
> +obj-$(CONFIG_FB_MB862XX)	:= mb862xxfb.o mb862xxfb_accel.o
> diff --git a/drivers/video/mb862xx/mb862xxfb.c b/drivers/video/mb862xx/mb862xxfb.c
> index a28e3cf..2cd7456 100644
> --- a/drivers/video/mb862xx/mb862xxfb.c
> +++ b/drivers/video/mb862xx/mb862xxfb.c
> @@ -214,7 +214,9 @@ static int mb862xxfb_set_par(struct fb_info *fbi)
>  	unsigned long reg, sc;
>  
>  	dev_dbg(par->dev, "%s\n", __func__);
> -
> +	if ( par->type == BT_CORALP ) {
> +		mb862xxfb_init_accel(fbi, fbi->var.xres);
> +	}

ERROR: space prohibited after that open parenthesis '('
#69: FILE: drivers/video/mb862xx/mb862xxfb.c:217:
+       if ( par->type == BT_CORALP ) {

This line should be

	if (par->type == BT_CORALP) {


> +static void mb862xxfb_write_fifo(u32 count, u32 *data, struct fb_info *info)
> +{
> +	struct mb862xxfb_par *par = info->par;
> +	static u32 free = 0;

ERROR: do not initialise statics to 0 or NULL
#143: FILE: drivers/video/mb862xx/mb862xxfb_accel.c:31:
+       static u32 free = 0;

Pretty clean, no need to initialized this.

> +	u32 total = 0;
> +		while ( total < count) {
> +		if ( free ) {
> +			outreg(geo, GDC_GEO_REG_INPUT_FIFO, data[total] );
> +			total++;
> +			free--;
> +		}
> +		else {
> +			 free = (u32)inreg(draw, GDC_REG_FIFO_COUNT);
> +		}

ERROR: else should follow close brace '}'
#152: FILE: drivers/video/mb862xx/mb862xxfb_accel.c:40:
+               }
+               else {

Should be,
		} else {



> +	}
> +}
> +
> +static void mb86290fb_copyarea(struct fb_info *info, const struct fb_copyarea *area)
> +{
> +	__u32 cmd[6];
> +
> +	cmd[0] = (GDC_TYPE_SETREGISTER << 24) | (1 << 16) | GDC_REG_MODE_BITMAP;
> +	cmd[1] = (2 << 7) | (GDC_ROP_COPY << 9); /* Set raster operation */
> +	cmd[2] = GDC_TYPE_BLTCOPYP << 24;
> +
> +	if (area->sx >= area->dx && area->sy >= area->dy)
> +	cmd[2] |= GDC_CMD_BLTCOPY_TOP_LEFT << 16;
> +	else if (area->sx >= area->dx && area->sy <= area->dy)
> +	cmd[2] |= GDC_CMD_BLTCOPY_BOTTOM_LEFT << 16;
> +	else if (area->sx <= area->dx && area->sy >= area->dy)
> +	cmd[2] |= GDC_CMD_BLTCOPY_TOP_RIGHT << 16;
> +	else
> +	cmd[2] |= GDC_CMD_BLTCOPY_BOTTOM_RIGHT << 16;

WARNING: suspect code indent for conditional statements (8, 8)
#166: FILE: drivers/video/mb862xx/mb862xxfb_accel.c:54:
+       if (area->sx >= area->dx && area->sy >= area->dy)
+       cmd[2] |= GDC_CMD_BLTCOPY_TOP_LEFT << 16;

The above lines need tabs added like this,

	if (area->sx >= area->dx && area->sy >= area->dy)
		cmd[2] |= GDC_CMD_BLTCOPY_TOP_LEFT << 16;
	else if (area->sx >= area->dx && area->sy <= area->dy)
		cmd[2] |= GDC_CMD_BLTCOPY_BOTTOM_LEFT << 16;
	else ...

> +	cmd[3] =  (area->sy << 16) | area->sx;
> +	cmd[4] =  (area->dy << 16) | area->dx ;
> +	cmd[5] =  (area->height << 16) | area->width;
> +	mb862xxfb_write_fifo(6, cmd, info);
> +}
> +
> +/* Fill in the cmd array /GDC FIFO commands/ to draw a 1bit image.
> + * Make sure cmd has enough room! */
> +static void mb86290fb_imageblit1(u32 *cmd, u16 step, u16 dx, u16 dy,
> +		u16 width, u16 height, u32 fgcolor, u32 bgcolor,
> +		const struct fb_image *image, struct fb_info *info)
> +{
> +	int i;
> +	unsigned const char *line;
> +	u16 bytes;
> +
> +
> +	/* set colors and raster operation regs */
> +	cmd[0] = (GDC_TYPE_SETREGISTER << 24) | (1 << 16) | GDC_REG_MODE_BITMAP;
> +	cmd[1] = (2 << 7) | (GDC_ROP_COPY << 9); /* Set raster operation */
> +
> +	cmd[2] = (GDC_TYPE_SETCOLORREGISTER << 24) | (GDC_CMD_BODY_FORE_COLOR << 16);
> +	cmd[3] = fgcolor;
> +	cmd[4] = (GDC_TYPE_SETCOLORREGISTER << 24) | (GDC_CMD_BODY_BACK_COLOR << 16);
> +	cmd[5] = bgcolor;
> +
> +	i = 0;
> +	line = image->data;
> +	bytes = (image->width + 7) >> 3;
> +
> +	/* and the image */
> +	cmd[6] = (GDC_TYPE_DRAWBITMAPP << 24) |
> +		(GDC_CMD_BITMAP << 16) |
> +		(2 + (step * height));
> +	cmd[7] = (dy << 16) | dx;
> +	cmd[8] = (height << 16) | width;
> +
> +	while (i < height) {
> +		memcpy(&cmd[9 + i * step], line, step << 2);
> +#ifdef __LITTLE_ENDIAN
> +		{
> +			int k=0;
> +			for (k=0; k<step;k++)

ERROR: spaces required around that '=' (ctx:VxV)
#216: FILE: drivers/video/mb862xx/mb862xxfb_accel.c:104:
+                       int k=0;
                             ^

ERROR: spaces required around that '=' (ctx:VxV)
#217: FILE: drivers/video/mb862xx/mb862xxfb_accel.c:105:
+                       for (k=0; k<step;k++)
                              ^
ERROR: spaces required around that '<' (ctx:VxV)
#217: FILE: drivers/video/mb862xx/mb862xxfb_accel.c:105:
+                       for (k=0; k<step;k++)
                                   ^

ERROR: space required after that ';' (ctx:VxV)
#217: FILE: drivers/video/mb862xx/mb862xxfb_accel.c:105:
+                       for (k=0; k<step;k++)
                                        ^
You just need to add spaces around the equals and other operators like
this,

			for (k = 0; k < step; k++)


Your code has some other errors, 23 total. You can run
scripts/checkpatch.pl for a full list of the errors.

Daniel

