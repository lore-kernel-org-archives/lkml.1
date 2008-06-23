Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbYFWGwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbYFWGwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 02:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYFWGw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 02:52:29 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39356 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbYFWGw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 02:52:28 -0400
Date: Mon, 23 Jun 2008 09:50:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com
Subject: Re: [patch 2.6.26-rc7] <linux/bcd.h> space reduction
Message-ID: <20080623065034.GG20122@cs181140183.pp.htv.fi>
References: <200806221954.37088.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200806221954.37088.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 07:54:36PM -0700, David Brownell wrote:
> This updates <linux/bcd.h> to define the key routines as static
> constant functions, which the macros will then call.
> 
> In effect this lets each user of these BCD routines shrink their
> codespace, when GCC observes that's a win, by using N function calls
> and one copy of the routines, instead of N inlined copies of these
> constant functions.
> 
> These routines aren't used in speed-critical code.  Almost all callers
> are from the RTC framework.  Typical per-driver savings top 200 bytes.
> On one RTC driver that's almost a 20% reduction in runtime I-space
> footprint; for many, closer to 10%; for rtc-cmos it's about 4%.

The patch breaks the compilation:

<--  snip  -->

...
  CC      drivers/rtc/rtc-ds1511.o
In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/rtc/rtc-ds1511.c:17:
/home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/bcd.h:13: error: expected ‘)’ before ‘val’
...
make[3]: *** [drivers/rtc/rtc-ds1511.o] Error 1

<--  snip  -->

Additionally, I'd suggest to make them out-of-line functions 
instead of shipping multiple copies in different object files.

> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  include/linux/bcd.h |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> --- a/include/linux/bcd.h	2008-06-21 22:26:14.000000000 -0700
> +++ b/include/linux/bcd.h	2008-06-21 22:37:48.000000000 -0700
> @@ -10,8 +10,20 @@
>  #ifndef _BCD_H
>  #define _BCD_H
>  
> -#define BCD2BIN(val)	(((val) & 0x0f) + ((val)>>4)*10)
> -#define BIN2BCD(val)	((((val)/10)<<4) + (val)%10)
> +static int __bcd2bin(u8 val) __attribute_const__ __maybe_unused;
> +static int __bcd2bin(u8 val)
> +{
> +	return (val & 0x0f) + (val >> 4) * 10;
> +}
> +
> +static u8 __bin2bcd(unsigned val) __attribute_const__ __maybe_unused;
> +static u8 __bin2bcd(unsigned val)
> +{
> +	return ((val/10) << 4) + val % 10;
> +}
> +
> +#define BCD2BIN(val)	__bcd2bin(val)
> +#define BIN2BCD(val)	__bin2bcd(val)
>  
>  /* backwards compat */
>  #define BCD_TO_BIN(val) ((val)=BCD2BIN(val))

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

