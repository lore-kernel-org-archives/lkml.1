Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026Ab0ANHgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab0ANHgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 02:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686Ab0ANHg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 02:36:29 -0500
Received: from trinity.fluff.org ([89.16.178.74]:60349 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137Ab0ANHg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 02:36:29 -0500
Date: Thu, 14 Jan 2010 07:36:17 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ben Dooks <ben-linux@fluff.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 2.6.33] s3c-fb: Fix handling of missing refresh in
	platform data
Message-ID: <20100114073617.GT3738@trinity.fluff.org>
References: <1263399402-5912-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263399402-5912-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 04:16:42PM +0000, Mark Brown wrote:
> Commit 600ce1a0faafeed1ce6bcfd421bc040b941cbbc1 ("fix clock setting
> for Samsung SoC Framebuffer") introduced a mandatory refresh parameter
> to the platform data for the S3C framebuffer but did not introduce any
> validation code, causing existing platforms to divide by zero whenever
> the framebuffer is configured, generating warnings and unusable output.

Hmm, having just read 600ce1a0faafeed1ce6bcfd421bc040b941cbbc1 it seems
the the original authour has has missed the point of what is happening
and thus possibly broken the driver.

We get passed the pixclk in the fb settings to produce the required
refresh rate for the given parameters. We do not need to think about
the refresh rate in the driver itself, the caller should have deal with
it!.

Secondly, s3c_fb_calc_pixclk() can only be called from the root fb,
as there is only one divider in the block used to generate the output
pixel clock for the LCD bus. Adding a window id to the s3c_fb_calc_pixclk()
is useless as the subordinate framebuffers for the overlay windows do not
have their own dividers. as noted in the code it only ever uses this
in the case of win_no == 0, so it was unecessarey.

Thirdly he's changed the code to calculate the divider to assume pixclk
is a frequency, and not a time-period. It clearly stats in the docs
that pixclk is in picoseconds. Our clock rate is in Hz.

It seems I wasn't cc'd on the original submission or I'd have said no.

I'd rather see this one reverted.

> Add a WARN_ON(), in line with similar parameters, and check that we
> have a non-zero refresh before we dividing by it. This gets usable
> output on at least the SMDK6410, though without specifying a refresh
> we see visible issues on some boots.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: stable@kernel.org
> ---
> 
> All mainline users of the s3c-fb driver are affected by this, none
> provide refresh.
> 
>  drivers/video/s3c-fb.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
> index adf9632..0f2e8f6 100644
> --- a/drivers/video/s3c-fb.c
> +++ b/drivers/video/s3c-fb.c
> @@ -224,7 +224,8 @@ static int s3c_fb_calc_pixclk(unsigned char id, struct s3c_fb *sfb, unsigned int
>  	unsigned long clk = clk_get_rate(sfb->bus_clk);
>  	unsigned int result;
>  
> -	pixclk *= win->win_mode.refresh;
> +	if (win->win_mode.refresh)
> +		pixclk *= win->win_mode.refresh;
>  	result = clk / pixclk;
>  
>  	dev_dbg(sfb->dev, "pixclk=%u, clk=%lu, div=%d (%lu)\n",
> @@ -766,6 +767,7 @@ static int __devinit s3c_fb_probe_win(struct s3c_fb *sfb, unsigned int win_no,
>  	WARN_ON(windata->max_bpp == 0);
>  	WARN_ON(windata->win_mode.xres == 0);
>  	WARN_ON(windata->win_mode.yres == 0);
> +	WARN_ON(windata->win_mode.refresh == 0);
>  
>  	win = fbinfo->par;
>  	var = &fbinfo->var;
> -- 
> 1.6.6
> 

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

