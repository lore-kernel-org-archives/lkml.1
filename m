Return-Path: <linux-kernel-owner+w=401wt.eu-S1760008AbZF3W56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbZF3W56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbZF3W5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:57:50 -0400
Received: from ru.mvista.com ([213.79.90.228]:22410 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754025AbZF3W5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:57:50 -0400
Date: Wed, 1 Jul 2009 02:57:52 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       richard@laptop.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Fox <pgf@laptop.org>, dsaxena@laptop.org
Subject: Re: [PATCH 2/5] power_supply: fix up olpc_battery's eeprom read
 function
Message-ID: <20090630225752.GA12076@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090630021400.6a9f2482@mycelium.queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20090630021400.6a9f2482@mycelium.queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 02:14:00AM -0400, Andres Salomon wrote:
> 
> The eeprom read function was placing values into the wrong place in
> 'buf'; we were starting from buf[off], rather than buf[0].
> 
> Also, the for loop that we were using was much uglier than it needed to
> be.  This cleans it up a bit.
> 
> Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>

Applied to battery-2.6.31.git w/ some cosmtic changes.
Please ensure that everything is OK.

Thanks!

> ---
>  drivers/power/olpc_battery.c |   14 ++++++--------
>  1 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
> index 0d1928d..d2df0db 100644
> --- a/drivers/power/olpc_battery.c
> +++ b/drivers/power/olpc_battery.c
> @@ -343,21 +343,19 @@ static ssize_t olpc_bat_eeprom_read(struct kobject *kobj,
>  		struct bin_attribute *attr, char *buf, loff_t off, size_t count)
>  {
>  	uint8_t ec_byte;
> -	int ret, end;
> +	int ret, i;
>  
>  	if (off >= EEPROM_SIZE)
>  		return 0;
>  	if (off + count > EEPROM_SIZE)
>  		count = EEPROM_SIZE - off;
>  
> -	end = EEPROM_START + off + count;
> -	for (ec_byte = EEPROM_START + off; ec_byte < end; ec_byte++) {
> -		ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1,
> -				&buf[ec_byte - EEPROM_START], 1);
> +	for (i = 0; i < count; i++) {
> +		ec_byte = EEPROM_START + off + i;
> +		ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1, &buf[i], 1);
>  		if (ret) {
> -			printk(KERN_ERR "olpc-battery:  EC command "
> -					"EC_BAT_EEPROM @ 0x%x failed -"
> -					" %d!\n", ec_byte, ret);
> +			printk(KERN_ERR "olpc-battery:  EC_BAT_EEPROM cmd @ 0x%x failed - %d!\n",
> +					ec_byte, ret);
>  			return -EIO;
>  		}
>  	}
> -- 
> 1.5.6.5
> 

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
