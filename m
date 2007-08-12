Return-Path: <linux-kernel-owner+w=401wt.eu-S936561AbXHLRxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936561AbXHLRxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 13:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933285AbXHLRxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 13:53:38 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:5161 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880AbXHLRxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 13:53:37 -0400
Date: Sun, 12 Aug 2007 13:49:56 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1 regression: hwmon/w83627ehf: wrong fan speed
Message-ID: <20070812174956.GA7411@jupiter.solarsys.private>
References: <46B5B290.4040907@s5r6.in-berlin.de> <20070805162141.GI6221@jupiter.solarsys.private> <46B6053E.2050708@s5r6.in-berlin.de> <20070810230831.59cbc50f@hyperion.delvare> <46BCE6D0.7060300@s5r6.in-berlin.de> <20070811135705.0d0688d7@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070811135705.0d0688d7@hyperion.delvare>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean:

* Jean Delvare <khali@linux-fr.org> [2007-08-11 13:57:05 +0200]:
> Don't assume that the default bank is 0. For one thing, we don't even
> set it to 0 when the driver is loaded, so the initial state might be
> different. For another, something (say, the BIOS) might access the chip
> and leave with the bank set to something different, so assuming that
> the bank value is 0 is not safe.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
>  drivers/hwmon/w83627ehf.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> --- linux-2.6.23-rc2.orig/drivers/hwmon/w83627ehf.c	2007-07-23 16:44:35.000000000 +0200
> +++ linux-2.6.23-rc2/drivers/hwmon/w83627ehf.c	2007-08-11 12:55:58.000000000 +0200
> @@ -309,18 +309,16 @@ static inline int is_word_sized(u16 reg)
>  	      || (reg & 0x00ff) == 0x55));
>  }
>  
> -/* We assume that the default bank is 0, thus the following two functions do
> -   nothing for registers which live in bank 0. For others, they respectively
> -   set the bank register to the correct value (before the register is
> -   accessed), and back to 0 (afterwards). */
> +/* Registers 0x50-0x5f are banked */
>  static inline void w83627ehf_set_bank(struct w83627ehf_data *data, u16 reg)
>  {
> -	if (reg & 0xff00) {
> +	if ((reg & 0x00f0) == 0x50) {
>  		outb_p(W83627EHF_REG_BANK, data->addr + ADDR_REG_OFFSET);
>  		outb_p(reg >> 8, data->addr + DATA_REG_OFFSET);
>  	}
>  }
>  
> +/* Not strictly necessary, but play it safe for now */
>  static inline void w83627ehf_reset_bank(struct w83627ehf_data *data, u16 reg)
>  {
>  	if (reg & 0xff00) {

Applied to hwmon-2.6.git/testing, thanks.

-- 
Mark M. Hoffman
mhoffman@lightlink.com

