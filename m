Return-Path: <linux-kernel-owner+w=401wt.eu-S933855AbZHEA2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855AbZHEA2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 20:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933846AbZHEA2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 20:28:37 -0400
Received: from n12a.bullet.mail.mud.yahoo.com ([209.191.125.177]:40747 "HELO
	n12a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933830AbZHEA2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 20:28:30 -0400
X-Yahoo-Newman-Id: 138687.81000.bm@omp423.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=y81ViUycSxJB1yi/AKH93LYy9xGiq5jouZZnTtjCNz/8KGfHkHaw79OGvJ2UVV0q7PJl/PQ1gQNchNkXEvFGeHQewy7Dv7C58sNJHOcsmI1T+QiiMZqmWq3+wk9QohG3FxNjuZwMsum+4rQ5DT2DC5rpcHoHnaa8vLJaXSIrZkg=  ;
X-YMail-OSG: isyOiA0VM1l6mej3oINHlSJcABXZx5yhbMDMUbGKLy3cJdb9Zikfp3eENFJK.3BJ2Z1Qavf_axOVAey7u_yESk_0CtN5wLolzBpckHP1BwOTzyw.EuFrfRGfpeAW2nggC013hPowIxJzUIDowh6aGuE5grWx7PD6s5hovKZ8AsiOJKdRBNn.As0vmNsQTlFN4M_M38ZwNy.0v.b6b1p5DD2nTAFERm5p25ZWwabMvxIOoV15eYedIP232w5cMzQE5kmQO1EaNcF.MF_k7.fM9XKpGl8z0c3MhGtYqqlDjvYB6Y2D
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: ben@fluff.org
Subject: Re: gpiolib: add export/unexport by gpio name
Date: Tue, 4 Aug 2009 13:58:29 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20090804105459.960604743@fluff.org>
In-Reply-To: <20090804105459.960604743@fluff.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908041358.29400.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 August 2009, ben@fluff.org wrote:
> Add the facility to export/unexport a gpio by the name assigned to it
> as well as the number.

I guess I'm still a bit puzzled by the notion of adding
second/parallel naming scheme for GPIOs.  As a rule, such
duplication is undesirable ...

But assuming such things are OK, this patch has a couple
technical problems.


> Signed-off-by: Ben Dooks <ben@simtec.co.uk>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> 
> ---
>  drivers/gpio/gpiolib.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 66 insertions(+), 4 deletions(-)
> 
> Index: b/drivers/gpio/gpiolib.c
> ===================================================================
> --- a/drivers/gpio/gpiolib.c	2009-08-04 11:53:53.000000000 +0100
> +++ b/drivers/gpio/gpiolib.c	2009-08-04 11:54:12.000000000 +0100
> @@ -364,6 +364,64 @@ static const struct attribute_group gpio
>  	.attrs = (struct attribute **) gpiochip_attrs,
>  };
>  
> +static int search_names(char **names, const char *match, int ngpio)
> +{
> +	int len = strlen(match);
> +	char *m;
> +	int ptr;
> +
> +	/* if cr terminated, remove */
> +	if (match[len-1] == '\n')
> +		len--;
> +
> +	if (names) {
> +		for (ptr = 0; ptr < ngpio; ptr++) {
> +			m = names[ptr];
> +			if (!m)
> +				continue;
> +
> +			if (strlen(m) != len)
> +				continue;
> +
> +			if (strncmp(m, match, len) == 0)
> +				return ptr;
> +		}
> +	}
> +
> +	return -ENOENT;
> +}
> +
> +static long gpio_from_string(const char *buf)
> +{
> +	struct gpio_chip *chip;
> +	struct gpio_desc *desc;
> +	long status;
> +	long gpio;
> +	int ptr, off;
> +
> +	status = strict_strtol(buf, 0, &gpio);
> +	if (status < 0) {
> +		for (ptr = 0; ptr < ARCH_NR_GPIOS && status < 0;) {

Nothing is guarding against
 (a) duplicate chip->names[] entries within or between chips,
 (b) concurrent addition/removal of gpio_chip instances

For (a) maybe the answer is to detect them at chip registration
time ... then either fail, or else warn then null out the dup.

For (b) it seems that gpio_lock is required.

> +			desc = gpio_desc + ptr;
> +			chip = desc->chip;
> +
> +			if (!chip) {
> +				ptr++;
> +				continue;
> +			}
> +
> +			off = search_names(chip->names, buf, chip->ngpio);
> +			if (off >= 0)
> +				status = ptr + off;
> +
> +			ptr += chip->ngpio;
> +		}
> +	} else
> +		status = gpio;
> +
> +	return status;
> +}
> +
>  /*
>   * /sys/class/gpio/export ... write-only
>   *	integer N ... number of GPIO to export (full access)
> @@ -375,9 +433,11 @@ static ssize_t export_store(struct class
>  	long	gpio;
>  	int	status;
>  
> -	status = strict_strtol(buf, 0, &gpio);
> -	if (status < 0)
> +	gpio = gpio_from_string(buf);
> +	if (gpio < 0) {
> +		status = gpio;
>  		goto done;
> +	}
>  
>  	/* No extra locking here; FLAG_SYSFS just signifies that the
>  	 * request and export were done by on behalf of userspace, so
> @@ -405,9 +465,11 @@ static ssize_t unexport_store(struct cla
>  	long	gpio;
>  	int	status;
>  
> -	status = strict_strtol(buf, 0, &gpio);
> -	if (status < 0)
> +	gpio = gpio_from_string(buf);
> +	if (gpio < 0) {
> +		status = gpio;
>  		goto done;
> +	}
>  
>  	status = -EINVAL;
>  
> 
> -- 
> 
> 



