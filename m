Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbZLDCVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbZLDCVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 21:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZLDCVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 21:21:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:51008 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521AbZLDCVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 21:21:13 -0500
Subject: Re: [PATCH] therm_adt746x: Record pwm invert bit at module load
 time
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: djwong@us.ibm.com
Cc: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20091130234727.GA10295@tux1.beaverton.ibm.com>
References: <20091130234727.GA10295@tux1.beaverton.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 13:20:11 +1100
Message-ID: <1259893211.2076.1243.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 15:47 -0800, Darrick J. Wong wrote:
> In commit 0512a9a8e277a9de2820211eef964473b714ae65, we unilaterally zero the
> "pwm invert" bit in the fan behavior configuration register.  On my PowerBook
> G4, this results in the fans going to full speed at low temperature and
> shutting off at high temperature because the pwm invert bit is supposed to be
> set.
> 
> Therefore, record the pwm invert bit at driver load time, and write the bit
> into the fan behavior control register.  This restores correct behavior on my
> PBG4 and should work around the bit being set to the wrong value after
> suspend/resume (which is what the original patch was trying to fix).  It also
> fixes a minor omission where the pwm invert bit correction is NOT performed
> when switching into automatic mode.

Thanks, I'll apply.

Cheers,
Ben.

> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/macintosh/therm_adt746x.c |   13 +++++++++++--
>  1 files changed, 11 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/drivers/macintosh/therm_adt746x.c b/drivers/macintosh/therm_adt746x.c
> index 556f0fe..386a797 100644
> --- a/drivers/macintosh/therm_adt746x.c
> +++ b/drivers/macintosh/therm_adt746x.c
> @@ -79,6 +79,7 @@ struct thermostat {
>  	u8			limits[3];
>  	int			last_speed[2];
>  	int			last_var[2];
> +	int			pwm_inv[2];
>  };
>  
>  static enum {ADT7460, ADT7467} therm_type;
> @@ -229,19 +230,23 @@ static void write_fan_speed(struct thermostat *th, int speed, int fan)
>  	
>  	if (speed >= 0) {
>  		manual = read_reg(th, MANUAL_MODE[fan]);
> +		manual &= ~INVERT_MASK;
>  		write_reg(th, MANUAL_MODE[fan],
> -			(manual|MANUAL_MASK) & (~INVERT_MASK));
> +			manual | MANUAL_MASK | th->pwm_inv[fan]);
>  		write_reg(th, FAN_SPD_SET[fan], speed);
>  	} else {
>  		/* back to automatic */
>  		if(therm_type == ADT7460) {
>  			manual = read_reg(th,
>  				MANUAL_MODE[fan]) & (~MANUAL_MASK);
> -
> +			manual &= ~INVERT_MASK;
> +			manual |= th->pwm_inv[fan];
>  			write_reg(th,
>  				MANUAL_MODE[fan], manual|REM_CONTROL[fan]);
>  		} else {
>  			manual = read_reg(th, MANUAL_MODE[fan]);
> +			manual &= ~INVERT_MASK;
> +			manual |= th->pwm_inv[fan];
>  			write_reg(th, MANUAL_MODE[fan], manual&(~AUTO_MASK));
>  		}
>  	}
> @@ -418,6 +423,10 @@ static int probe_thermostat(struct i2c_client *client,
>  
>  	thermostat = th;
>  
> +	/* record invert bit status because fw can corrupt it after suspend */
> +	th->pwm_inv[0] = read_reg(th, MANUAL_MODE[0]) & INVERT_MASK;
> +	th->pwm_inv[1] = read_reg(th, MANUAL_MODE[1]) & INVERT_MASK;
> +
>  	/* be sure to really write fan speed the first time */
>  	th->last_speed[0] = -2;
>  	th->last_speed[1] = -2;


