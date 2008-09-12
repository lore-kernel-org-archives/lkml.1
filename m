Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbYILS4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbYILS4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 14:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbYILS4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 14:56:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753831AbYILS4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 14:56:07 -0400
Date: Fri, 12 Sep 2008 11:55:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2.6.27 mmotm] rtc-cmos: export second NVRAM bank
Message-Id: <20080912115530.79a3c1a3.akpm@linux-foundation.org>
In-Reply-To: <200809120957.55562.david-b@pacbell.net>
References: <200809120957.55562.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008 09:57:55 -0700
David Brownell <david-b@pacbell.net> wrote:

> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Teach rtc-cmos about the second bank of registers found on most
> modern x86 systems, giving access to 128 bytes more NVRAM.
> 
> This version only sees that extra NVRAM when both register banks
> are provided as part of *one* PNP resource.  Since BIOS on some
> systems presents them using two IO resources, and nothing merges
> them, this can't always show all the NVRAM.  (We're supposed to
> be able to use PNP id PNP0b01 too, but BIOS tables doesn't often
> seem to use that particular option.)
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
> For 2.6.28; applies after other pending patches
> 
>  drivers/rtc/rtc-cmos.c |   70 ++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 63 insertions(+), 7 deletions(-)
> 
> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c
> @@ -153,6 +153,43 @@ static inline int hpet_unregister_irq_ha
>  
>  /*----------------------------------------------------------------*/
>  
> +#ifdef RTC_PORT
> +
> +/* Most newer x86 systems have two register banks, the first used
> + * for RTC and NVRAM and the second only for NVRAM.  Caller must
> + * own rtc_lock ... and we won't worry about access during NMI.
> + */
> +#define can_bank2	true

It would be more idiomatic to make this upper-case: CAN_BANK2.

> +static inline unsigned char cmos_read_bank2(unsigned char addr)
> +{
> +	outb(addr, RTC_PORT(2));
> +	return inb(RTC_PORT(3));
> +}
> +
> +static inline void cmos_write_bank2(unsigned char val, unsigned char addr)
> +{
> +	outb(addr, RTC_PORT(2));
> +	outb(val, RTC_PORT(2));
> +}
> +
> +#else
> +
> +#define can_bank2	false
> +
> +static inline unsigned char cmos_read_bank2(unsigned char addr)
> +{
> +	return 0;
> +}
> +
> +static inline void cmos_write_bank2(unsigned char val, unsigned char addr)
> +{
> +}
> +
> +#endif
> +
> +/*----------------------------------------------------------------*/
> +
>  static int cmos_read_time(struct device *dev, struct rtc_time *t)
>  {
>  	/* REVISIT:  if the clock has a "century" register, use
> @@ -511,12 +548,21 @@ cmos_nvram_read(struct kobject *kobj, st
>  
>  	if (unlikely(off >= attr->size))
>  		return 0;
> +	if (unlikely(off < 0))
> +		return -EINVAL;
>  	if ((off + count) > attr->size)
>  		count = attr->size - off;
> +	off += NVRAM_OFFSET;

hm, now what's happening in here.

: static ssize_t
: cmos_nvram_read(struct kobject *kobj, struct bin_attribute *attr,
: 		char *buf, loff_t off, size_t count)
: {
: 	int	retval;
: 
: 	if (unlikely(off >= attr->size))
: 		return 0;
: 	if (unlikely(off < 0))
: 		return -EINVAL;
: 	if ((off + count) > attr->size)
: 		count = attr->size - off;
: 
: 	off += NVRAM_OFFSET;
: 

The VFS will (hopefully) prevent ->read methods from being called with
a negative file offset.  What prompted the additional test for that?

I did't look at it exhaustively but I suspect that the above code won't
work right if attr->size has a value of around (2^31 - 42) and `offset'
is (2^31 - 54) and NVRAM_OFFSET==54.  Or something like that.  It looks
holey ;)

Of course, the assumption that attr->size is not insanely large is a
good one, but still..

>  	spin_lock_irq(&rtc_lock);
> -	for (retval = 0, off += NVRAM_OFFSET; count--; retval++, off++)
> -		*buf++ = CMOS_READ(off);
> +	for (retval = 0; count; count--, off++, retval++) {
> +		if (off < 128)
> +			*buf++ = CMOS_READ(off);
> +		else if (can_bank2)
> +			*buf++ = cmos_read_bank2(off);
> +		else
> +			break;
> +	}

