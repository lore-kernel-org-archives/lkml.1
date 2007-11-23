Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbXKWQCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbXKWQCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 11:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbXKWQCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 11:02:39 -0500
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41080
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbXKWQCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 11:02:38 -0500
From: Michael Buesch <mb@bu3sch.de>
To: benh@kernel.crashing.org
Subject: Re: radeonfb i2c regression post-2.6.18.
Date: Fri, 23 Nov 2007 17:00:52 +0100
User-Agent: KMail/1.9.6
Cc: Roger Leigh <rleigh@whinlatter.ukfsn.org>,
       Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       Dennis Munsie <dmunsie@cecropia.com>
References: <1195427766.7022.18.camel@pasglop>
In-Reply-To: <1195427766.7022.18.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711231700.53103.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 November 2007 00:16:06 Benjamin Herrenschmidt wrote:
> (Also, Michel, can you check if it fixes your other problem with this
> code ? ie. your "hot crash")

> -------- Forwarded Message --------
> From: Jean Delvare <khali@linux-fr.org>
> To: linux-fbdev-devel@lists.sourceforge.net
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Antonino Daplas
> <adaplas@gmail.com>
> Subject: [PATCH] fb_ddc: Fix DDC lines quirk
> Date: Sun, 18 Nov 2007 14:21:41 +0100
> 
> The code in fb_ddc_read() is said to be based on the implementation
> of the radeon driver:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fc5891c8a3ba284f13994d7bc1f1bfa8283982de
> 
> However, comparing the old radeon driver code with the new fb_ddc code
> reveals some differences. Most notably, the I2C bus lines are held at
> the end of the function, while the original code was releasing them
> (as the comment above correctly says.)
> 
> There are a few other differences, which appear to be responsible for
> read failures on my system. While tracing low-level I2C code in
> i2c-algo-bit, I noticed that the initial attempt to read the EDID
> always failed. It takes one retry for the read to succeed. As we are
> about to remove this automatic retry property from i2c-algo-bit,
> reading the EDID would really fail.
> 
> As a summary, the I2C lines quirk which is supposedly needed to read
> EDID on some older monitors is currently breaking the (first) read on
> all other monitors (and might not even work with older ones - did
> anyone try since October 2006?)
> 
> After applying the patch below, which makes the code in fb_ddc_read()
> really similar to what the radeon driver used to have, the first EDID
> read succeeds again.
> 
> On top of that, as it appears that this code has been broken for one
> year now and nobody seems to have complained, I'm curious if it makes
> sense to keep this quirk in place. It makes the code more complex and
> slower just for the sake of monitors which I guess nobody uses
> anymore. Can't we just get rid of it?

This patch fixes my crash problem.
Thanks a lot guys!

> Signed-off-by: Jean Delvare <khali@linux-fr.org>

Acked-by: Michael Buesch <mb@bu3sch.de>

> ---
>  drivers/video/fb_ddc.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- linux-2.6.24-rc3.orig/drivers/video/fb_ddc.c	2007-11-17 20:23:03.000000000 +0100
> +++ linux-2.6.24-rc3/drivers/video/fb_ddc.c	2007-11-18 12:49:14.000000000 +0100
> @@ -56,13 +56,12 @@ unsigned char *fb_ddc_read(struct i2c_ad
>  	int i, j;
>  
>  	algo_data->setscl(algo_data->data, 1);
> -	algo_data->setscl(algo_data->data, 0);
>  
>  	for (i = 0; i < 3; i++) {
>  		/* For some old monitors we need the
>  		 * following process to initialize/stop DDC
>  		 */
> -		algo_data->setsda(algo_data->data, 0);
> +		algo_data->setsda(algo_data->data, 1);
>  		msleep(13);
>  
>  		algo_data->setscl(algo_data->data, 1);
> @@ -97,14 +96,15 @@ unsigned char *fb_ddc_read(struct i2c_ad
>  		algo_data->setsda(algo_data->data, 1);
>  		msleep(15);
>  		algo_data->setscl(algo_data->data, 0);
> +		algo_data->setsda(algo_data->data, 0);
>  		if (edid)
>  			break;
>  	}
>  	/* Release the DDC lines when done or the Apple Cinema HD display
>  	 * will switch off
>  	 */
> -	algo_data->setsda(algo_data->data, 0);
> -	algo_data->setscl(algo_data->data, 0);
> +	algo_data->setsda(algo_data->data, 1);
> +	algo_data->setscl(algo_data->data, 1);
>  
>  	return edid;
>  }
> 
> 
> 
> 
> 



-- 
Greetings Michael.
