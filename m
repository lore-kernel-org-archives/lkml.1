Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbZLAIHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbZLAIHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbZLAIHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:07:41 -0500
Received: from darkcity.gna.ch ([195.226.6.51]:33193 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753441AbZLAIHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:07:41 -0500
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Dec 2009 03:07:40 EST
Subject: Re: [PATCH] therm_adt746x: Record pwm invert bit at module load
 time
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: djwong@us.ibm.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20091130234727.GA10295@tux1.beaverton.ibm.com>
References: <20091130234727.GA10295@tux1.beaverton.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 01 Dec 2009 08:59:59 +0100
Message-ID: <1259654399.5488.13238.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
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
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Reviewed-by: Michel Dänzer <michel@daenzer.net>

Looks great, thanks Darrick. Also FWIW, at least loading the patched
driver works as expected on my PowerBook5,8 which has the invert bit
disabled.


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



-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
