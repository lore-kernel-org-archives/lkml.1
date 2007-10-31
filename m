Return-Path: <linux-kernel-owner+w=401wt.eu-S1760558AbXJaPt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760558AbXJaPt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760056AbXJaPtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:49:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:17345 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760033AbXJaPtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:49:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gG/x7ncu4TL53JjNJWz7tBQsBDrX9+iqrW6TNxQv+XJeqiZCaA7Ok8yUCV/z70OfZvGIeTiygUuk5FSFyM0KxCrvkUDI6jpMi3Jpsql75adkqKJnR4O6/L5v8rbiQ+nz5h8Ka1Lqw7MUwuUklItinVIMmn3fRnUfGGiienEcO+M=
Message-ID: <6101e8c40710310849t1aaecd90mb52597936cb320ae@mail.gmail.com>
Date: Wed, 31 Oct 2007 16:49:20 +0100
From: "=?ISO-8859-1?Q?Oliv=E9r_Pint=E9r?=" <oliver.pntr@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: patch hwmon-w83627hf-don-t-assume-bank-0.patch queued to -stable tree
Cc: khali@linux-fr.org, gregkh@suse.de, mhoffman@lightlink.com,
       stable-commits@vger.kernel.org
In-Reply-To: <20071031154544.3B7DD14540D4@imap.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071015150242.643837b8@hyperion.delvare>
	 <20071031154544.3B7DD14540D4@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

it's fix the sensor type detection (w83627thf)

v2.6.22.10:
Oct 31 16:21:40 pancs sensord:   mb_temp: 21 C (limit = 40 C,
hysteresis = 37 C, sensors = thermistor)
Oct 31 16:21:40 pancs sensord:   cpu_temp: 30.5 C (limit = 54 C,
hysteresis = 47 C, sensor = thermistor)

v2.6.22.10+hwmon_fixes:
Oct 31 16:59:20 pancs sensord:   mb_temp: 26 C (limit = 40 C,
hysteresis = 37 C, sensors = thermistor)
Oct 31 16:59:20 pancs sensord:   cpu_temp: 29.0 C (limit = 54 C,
hysteresis = 47 C, sensor = PII/Celeron diode)
--
Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>


On 10/31/07, gregkh@suse.de <gregkh@suse.de> wrote:
>
> This is a note to let you know that we have just queued up the patch titled
>
>      Subject: hwmon/w83627hf: Don't assume bank 0
>
> to the 2.6.23-stable tree.  Its filename is
>
>      hwmon-w83627hf-don-t-assume-bank-0.patch
>
> A git repo of this tree can be found at
>
> http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>
>
> From khali@linux-fr.org  Wed Oct 31 07:59:11 2007
> From: Jean Delvare <khali@linux-fr.org>
> Date: Mon, 15 Oct 2007 15:02:42 +0200
> Subject: hwmon/w83627hf: Don't assume bank 0
> To: stable@kernel.org
> Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
> Message-ID: <20071015150242.643837b8@hyperion.delvare>
>
> From: Jean Delvare <khali@linux-fr.org>
>
> Already in Linus' tree:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d58df9cd788e6fb4962e1c8d5ba7b8b95d639a44
>
> The bank switching code assumes that the bank selector is set to 0
> when the driver is loaded. This might not be the case. This is exactly
> the same bug as was fixed in the w83627ehf driver two months ago:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0956895aa6f8dc6a33210967252fd7787652537d
>
> In practice, this bug was causing the sensor thermal types to be
> improperly reported for my W83627THF the first time I was loading the
> w83627hf driver. From the driver history, I'd say that it has been
> broken since September 2005 (when we stopped resetting the chip by
> default at driver load.)
>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  drivers/hwmon/w83627hf.c |   44
> ++++++++++++++++++++++----------------------
>  1 file changed, 22 insertions(+), 22 deletions(-)
>
> --- a/drivers/hwmon/w83627hf.c
> +++ b/drivers/hwmon/w83627hf.c
> @@ -1335,6 +1335,24 @@ static int __devexit w83627hf_remove(str
>  }
>
>
> +/* Registers 0x50-0x5f are banked */
> +static inline void w83627hf_set_bank(struct w83627hf_data *data, u16 reg)
> +{
> +	if ((reg & 0x00f0) == 0x50) {
> +		outb_p(W83781D_REG_BANK, data->addr + W83781D_ADDR_REG_OFFSET);
> +		outb_p(reg >> 8, data->addr + W83781D_DATA_REG_OFFSET);
> +	}
> +}
> +
> +/* Not strictly necessary, but play it safe for now */
> +static inline void w83627hf_reset_bank(struct w83627hf_data *data, u16 reg)
> +{
> +	if (reg & 0xff00) {
> +		outb_p(W83781D_REG_BANK, data->addr + W83781D_ADDR_REG_OFFSET);
> +		outb_p(0, data->addr + W83781D_DATA_REG_OFFSET);
> +	}
> +}
> +
>  static int w83627hf_read_value(struct w83627hf_data *data, u16 reg)
>  {
>  	int res, word_sized;
> @@ -1345,12 +1363,7 @@ static int w83627hf_read_value(struct w8
>  		  && (((reg & 0x00ff) == 0x50)
>  		   || ((reg & 0x00ff) == 0x53)
>  		   || ((reg & 0x00ff) == 0x55));
> -	if (reg & 0xff00) {
> -		outb_p(W83781D_REG_BANK,
> -		       data->addr + W83781D_ADDR_REG_OFFSET);
> -		outb_p(reg >> 8,
> -		       data->addr + W83781D_DATA_REG_OFFSET);
> -	}
> +	w83627hf_set_bank(data, reg);
>  	outb_p(reg & 0xff, data->addr + W83781D_ADDR_REG_OFFSET);
>  	res = inb_p(data->addr + W83781D_DATA_REG_OFFSET);
>  	if (word_sized) {
> @@ -1360,11 +1373,7 @@ static int w83627hf_read_value(struct w8
>  		    (res << 8) + inb_p(data->addr +
>  				       W83781D_DATA_REG_OFFSET);
>  	}
> -	if (reg & 0xff00) {
> -		outb_p(W83781D_REG_BANK,
> -		       data->addr + W83781D_ADDR_REG_OFFSET);
> -		outb_p(0, data->addr + W83781D_DATA_REG_OFFSET);
> -	}
> +	w83627hf_reset_bank(data, reg);
>  	mutex_unlock(&data->lock);
>  	return res;
>  }
> @@ -1435,12 +1444,7 @@ static int w83627hf_write_value(struct w
>  		   || ((reg & 0xff00) == 0x200))
>  		  && (((reg & 0x00ff) == 0x53)
>  		   || ((reg & 0x00ff) == 0x55));
> -	if (reg & 0xff00) {
> -		outb_p(W83781D_REG_BANK,
> -		       data->addr + W83781D_ADDR_REG_OFFSET);
> -		outb_p(reg >> 8,
> -		       data->addr + W83781D_DATA_REG_OFFSET);
> -	}
> +	w83627hf_set_bank(data, reg);
>  	outb_p(reg & 0xff, data->addr + W83781D_ADDR_REG_OFFSET);
>  	if (word_sized) {
>  		outb_p(value >> 8,
> @@ -1450,11 +1454,7 @@ static int w83627hf_write_value(struct w
>  	}
>  	outb_p(value & 0xff,
>  	       data->addr + W83781D_DATA_REG_OFFSET);
> -	if (reg & 0xff00) {
> -		outb_p(W83781D_REG_BANK,
> -		       data->addr + W83781D_ADDR_REG_OFFSET);
> -		outb_p(0, data->addr + W83781D_DATA_REG_OFFSET);
> -	}
> +	w83627hf_reset_bank(data, reg);
>  	mutex_unlock(&data->lock);
>  	return 0;
>  }
>
>
> Patches currently in stable-queue which might be from khali@linux-fr.org are
>
> queue-2.6.23/hwmon-lm87-disable-vid-when-it-should-be.patch
> queue-2.6.23/hwmon-lm87-fix-a-division-by-zero.patch
> queue-2.6.23/hwmon-w83627hf-don-t-assume-bank-0.patch
> queue-2.6.23/hwmon-w83627hf-fix-setting-fan-min-right-after-driver-load.patch
> -
> To unsubscribe from this list: send the line "unsubscribe stable-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Thanks,
Oliver
