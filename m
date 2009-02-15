Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbZBOJhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbZBOJhV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 04:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbZBOJhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 04:37:08 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:23217 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbZBOJhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 04:37:06 -0500
Date: Sun, 15 Feb 2009 10:36:55 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rlove@rlove.org, protasnb@gmail.com,
       Michael Ruoss <miruoss@student.ethz.ch>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Tim Gardner <tim.gardner@canonical.com>, Frank Seidel <fseidel@suse.de>
Subject: Re: [PATCH] hwmon/hdaps: Fix bug 7154 inversion of separate axis
Message-ID: <20090215103655.00ae92f1@hyperion.delvare>
In-Reply-To: <499569A9.5030202@suse.de>
References: <499569A9.5030202@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

On Fri, 13 Feb 2009 13:38:01 +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> Fix for kernel.org bug #7154:hdaps inversion of
> each axis. This version is based on the work
> from Michael Ruoss <miruoss@student.ethz.ch>.
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  drivers/hwmon/hdaps.c |   49 ++++++++++++++++++++++++++++---------------------
>  1 file changed, 28 insertions(+), 21 deletions(-)
> 
> --- a/drivers/hwmon/hdaps.c
> +++ b/drivers/hwmon/hdaps.c
> @@ -65,6 +65,10 @@
>  #define HDAPS_INPUT_FUZZ	4	/* input event threshold */
>  #define HDAPS_INPUT_FLAT	4
>  
> +#define HDAPS_X_AXIS		1UL
> +#define HDAPS_Y_AXIS		2UL
> +#define HDAPS_BOTH_AXES		3UL

This would me much better defined as:

#define HDAPS_X_AXIS		(1 << 0)
#define HDAPS_Y_AXIS		(1 << 1)
#define HDAPS_BOTH_AXES		(HDAPS_X_AXIS | HDAPS_Y_AXIS)

> +
>  static struct platform_device *pdev;
>  static struct input_polled_dev *hdaps_idev;
>  static unsigned int hdaps_invert;
> @@ -182,11 +186,11 @@ static int __hdaps_read_pair(unsigned in
>  	km_activity = inb(HDAPS_PORT_KMACT);
>  	__device_complete();
>  
> -	/* if hdaps_invert is set, negate the two values */
> -	if (hdaps_invert) {
> +	/* hdaps_invert is a bitvector to negate the axes */
> +	if (hdaps_invert & 1)
>  		*x = -*x;
> +	if (hdaps_invert & 2)
>  		*y = -*y;

And then use these defines here (as Dmitry already suggested)...

> -	}
>  
>  	return 0;
>  }
> @@ -436,7 +440,7 @@ static ssize_t hdaps_invert_store(struct
>  {
>  	int invert;
>  
> -	if (sscanf(buf, "%d", &invert) != 1 || (invert != 1 && invert != 0))
> +	if (sscanf(buf, "%d", &invert) != 1 || invert < 0 || invert > 3)

... and here as well (3 is really HDAPS_BOTH_AXES).

>  		return -EINVAL;
>  
>  	hdaps_invert = invert;
> @@ -483,7 +487,7 @@ static int __init hdaps_dmi_match(const
>  /* hdaps_dmi_match_invert - found an inverted match. */
>  static int __init hdaps_dmi_match_invert(const struct dmi_system_id *id)
>  {
> -	hdaps_invert = 1;
> +	hdaps_invert = (int)id->driver_data;
>  	printk(KERN_INFO "hdaps: inverting axis readings.\n");
>  	return hdaps_dmi_match(id);
>  }
> @@ -491,15 +495,17 @@ static int __init hdaps_dmi_match_invert
>  #define HDAPS_DMI_MATCH_NORMAL(vendor, model) {		\
>  	.ident = vendor " " model,			\
>  	.callback = hdaps_dmi_match,			\
> +	.driver_data = (void *)0UL,			\
>  	.matches = {					\
>  		DMI_MATCH(DMI_BOARD_VENDOR, vendor),	\
>  		DMI_MATCH(DMI_PRODUCT_VERSION, model)	\
>  	}						\
>  }
>  
> -#define HDAPS_DMI_MATCH_INVERT(vendor, model) {		\
> +#define HDAPS_DMI_MATCH_INVERT(vendor, model, axes) {	\
>  	.ident = vendor " " model,			\
>  	.callback = hdaps_dmi_match_invert,		\
> +	.driver_data = (void *)axes,			\
>  	.matches = {					\
>  		DMI_MATCH(DMI_BOARD_VENDOR, vendor),	\
>  		DMI_MATCH(DMI_PRODUCT_VERSION, model)	\

If I'm not mistaken, HDAPS_DMI_MATCH_NORMAL can now be defined as:
#define HDAPS_DMI_MATCH_NORMAL(vendor, model) \
	HDAPS_DMI_MATCH_INVERT(vendor, model, 0)

Either that, or plain get rid of HDAPS_DMI_MATCH_NORMAL, rename
HDAPS_DMI_MATCH_INVERT to HDAPS_DMI_MATCH and use it everywhere.

> @@ -511,28 +517,28 @@ static int __init hdaps_dmi_match_invert
>     If your ThinkPad is not recognized, please update to latest
>     BIOS. This is especially the case for some R52 ThinkPads. */
>  static struct dmi_system_id __initdata hdaps_whitelist[] = {
> -	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad R50p"),
> +	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad R50p", HDAPS_BOTH_AXES),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R50"),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R51"),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R52"),
> -	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61i"),
> -	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61"),
> -	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T41p"),
> +	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61i", HDAPS_BOTH_AXES),
> +	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61", HDAPS_BOTH_AXES),
> +	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T41p", HDAPS_BOTH_AXES),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T41"),
> -	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T42p"),
> +	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T42p", HDAPS_BOTH_AXES),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T42"),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T43"),
> -	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T60"),
> -	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61p"),
> -	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61"),
> +	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T60", HDAPS_BOTH_AXES),
> +	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61p", HDAPS_BOTH_AXES),
> +	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61", HDAPS_BOTH_AXES),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X40"),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X41"),
> -	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X60"),
> -	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61s"),
> -	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61"),
> +	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X60", HDAPS_BOTH_AXES),
> +	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61s", HDAPS_BOTH_AXES),
> +	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61", HDAPS_BOTH_AXES),
>  	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad Z60m"),
> -	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61m"),
> -	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61p"),
> +	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61m", HDAPS_BOTH_AXES),
> +	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61p", HDAPS_BOTH_AXES),
>  	{ .ident = NULL }
>  };
>  
> @@ -627,8 +633,9 @@ static void __exit hdaps_exit(void)
>  module_init(hdaps_init);
>  module_exit(hdaps_exit);
>  
> -module_param_named(invert, hdaps_invert, bool, 0);
> -MODULE_PARM_DESC(invert, "invert data along each axis");
> +module_param_named(invert, hdaps_invert, int, 0);
> +MODULE_PARM_DESC(invert, "invert data along each axis. 1 invert x-axis, "
> +		 "2 invert y-axis, 3 invert both axes.");
>  
>  MODULE_AUTHOR("Robert Love");
>  MODULE_DESCRIPTION("IBM Hard Drive Active Protection System (HDAPS) driver");

But see also my rant elsewhere in this thread: I suspect we don't
really care about this feature and we could get rid of it for a much
simpler driver.

-- 
Jean Delvare
