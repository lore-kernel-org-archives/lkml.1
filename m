Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbYHRTUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbYHRTUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbYHRTUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:20:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475AbYHRTUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:20:43 -0400
Date: Mon, 18 Aug 2008 12:19:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       johnstul@us.ibm.com, hirofumi@mail.parknet.co.jp,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, andi@lisas.de
Subject: Re: [git pull?] clocksource: ACPI pmtmr bugfixes [Was: Re: ACPI
 PM-Timer on K6-3 SiS5591: Houston...]
Message-Id: <20080818121924.6b61f7af.akpm@linux-foundation.org>
In-Reply-To: <20080818190325.GA12581@comet.dominikbrodowski.net>
References: <20080810101730.GA10024@rhlx01.hs-esslingen.de>
	<20080810162920.GA9860@comet.dominikbrodowski.net>
	<20080810190759.GA1879@rhlx01.hs-esslingen.de>
	<20080818190325.GA12581@comet.dominikbrodowski.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008 21:03:25 +0200
Dominik Brodowski <linux@dominikbrodowski.net> wrote:

> Hi,
> 
> anyone willing to take these two patches? Possibly 2.6.27 material; hasn't
> been in -next or -mm.
> 
> Best,
> 	Dominik
> 
> 
> The following changes since commit 796aadeb1b2db9b5d463946766c5bbfd7717158c:
>   Linus Torvalds (1):
>         Merge branch 'fixes' of git://git.kernel.org/.../davej/cpufreq
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git clocksource
> 
> Dominik Brodowski (2):
>       acpi_pm.c: use proper read function also in errata mode.
>       acpi_pm.c: check for monotonicity
> 
>  drivers/clocksource/acpi_pm.c |   50 +++++++++++++++++++++++-----------------
>  1 files changed, 29 insertions(+), 21 deletions(-)

A bare git URL is somewhat user-unfriendly.

<fiddle, fiddle>

: commit b985f0517e31c1204b5aafb94f86202948f00e16
: Author: Dominik Brodowski <linux@dominikbrodowski.net>
: Date:   Sun Aug 10 21:24:21 2008 +0200
: 
:     acpi_pm.c: use proper read function also in errata mode.
:     
:     When acpi_pm is used in errata mode (three reads instead of one), also the
:     acpi_pm init functions need to use three reads instead of just one.

hm, why?  Was there some observeable problem which this change improved?

:     Thanks to Andreas Mohr for spotting this issue.
:     
:     CC: John Stultz <johnstul@us.ibm.com>
:     CC: Thomas Gleixner <tglx@linutronix.de>
:     CC: Ingo Molnar <mingo@elte.hu>
:     Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
: 
: diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
: index 5ca1d80..2c00edd 100644
: --- a/drivers/clocksource/acpi_pm.c
: +++ b/drivers/clocksource/acpi_pm.c
: @@ -151,13 +151,13 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_LE,
:   */
:  static int verify_pmtmr_rate(void)
:  {
: -	u32 value1, value2;
: +	cycle_t value1, value2;
:  	unsigned long count, delta;
:  
:  	mach_prepare_counter();
: -	value1 = read_pmtmr();
: +	value1 = clocksource_acpi_pm.read()
:  	mach_countup(&count);
: -	value2 = read_pmtmr();
: +	value2 = clocksource_acpi_pm.read()
:  	delta = (value2 - value1) & ACPI_PM_MASK;
:  
:  	/* Check that the PMTMR delta is within 5% of what we expect */
: @@ -177,7 +177,7 @@ static int verify_pmtmr_rate(void)
:  
:  static int __init init_acpi_pm_clocksource(void)
:  {
: -	u32 value1, value2;
: +	cycle_t value1, value2;
:  	unsigned int i;
:  
:  	if (!pmtmr_ioport)
: @@ -187,9 +187,9 @@ static int __init init_acpi_pm_clocksource(void)
:  						clocksource_acpi_pm.shift);
:  
:  	/* "verify" this timing source: */
: -	value1 = read_pmtmr();
: +	value1 = clocksource_acpi_pm.read();
:  	for (i = 0; i < 10000; i++) {
: -		value2 = read_pmtmr();
: +		value2 = clocksource_acpi_pm.read();
:  		if (value2 == value1)
:  			continue;
:  		if (value2 > value1)
: @@ -197,11 +197,11 @@ static int __init init_acpi_pm_clocksource(void)
:  		if ((value2 < value1) && ((value2) < 0xFFF))
:  			goto pm_good;
:  		printk(KERN_INFO "PM-Timer had inconsistent results:"
: -			" 0x%#x, 0x%#x - aborting.\n", value1, value2);
: +			" 0x%#llx, 0x%#llx - aborting.\n", value1, value2);
:  		return -EINVAL;
:  	}
:  	printk(KERN_INFO "PM-Timer had no reasonable result:"
: -			" 0x%#x - aborting.\n", value1);
: +			" 0x%#llx - aborting.\n", value1);
:  	return -ENODEV;
:  
:  pm_good:
: 


and

: commit a44299593315e055f28fe96b4767a85c46b2955f
: Author: Dominik Brodowski <linux@dominikbrodowski.net>
: Date:   Sun Aug 10 21:34:54 2008 +0200
: 
:     acpi_pm.c: check for monotonicity
:     
:     Expand the check for monotonicity by doing ten tests instead of one.

Why?

:     Applies on top of "acpi_pm.c: use proper read function also in errata mode."
:     
:     CC: John Stultz <johnstul@us.ibm.com>
:     CC: Thomas Gleixner <tglx@linutronix.de>
:     CC: Ingo Molnar <mingo@elte.hu>
:     Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
: 
: diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
: index 2c00edd..f05c4fb 100644
: --- a/drivers/clocksource/acpi_pm.c
: +++ b/drivers/clocksource/acpi_pm.c
: @@ -178,7 +178,7 @@ static int verify_pmtmr_rate(void)
:  static int __init init_acpi_pm_clocksource(void)
:  {
:  	cycle_t value1, value2;
: -	unsigned int i;
: +	unsigned int i, j, good = 0;
:  
:  	if (!pmtmr_ioport)
:  		return -ENODEV;
: @@ -187,24 +187,32 @@ static int __init init_acpi_pm_clocksource(void)
:  						clocksource_acpi_pm.shift);
:  
:  	/* "verify" this timing source: */
: -	value1 = clocksource_acpi_pm.read();
: -	for (i = 0; i < 10000; i++) {
: -		value2 = clocksource_acpi_pm.read();
: -		if (value2 == value1)
: -			continue;
: -		if (value2 > value1)
: -			goto pm_good;
: -		if ((value2 < value1) && ((value2) < 0xFFF))
: -			goto pm_good;
: -		printk(KERN_INFO "PM-Timer had inconsistent results:"
: -			" 0x%#llx, 0x%#llx - aborting.\n", value1, value2);
: -		return -EINVAL;
: +	for (j = 0; j < 10; j++) {
: +		value1 = clocksource_acpi_pm.read();
: +		for (i = 0; i < 10000; i++) {
: +			value2 = clocksource_acpi_pm.read();
: +			if (value2 == value1)
: +				continue;
: +			if (value2 > value1)
: +				good++;
: +				break;
: +			if ((value2 < value1) && ((value2) < 0xFFF))
: +				good++;
: +				break;
: +			printk(KERN_INFO "PM-Timer had inconsistent results:"
: +			       " 0x%#llx, 0x%#llx - aborting.\n",
: +			       value1, value2);
: +			return -EINVAL;
: +		}
: +		udelay(300 * i);
: +	}
: +
: +	if (good != 10) {
: +		printk(KERN_INFO "PM-Timer had no reasonable result:"
: +		       " 0x%#llx - aborting.\n", value1);
: +		return -ENODEV;
:  	}
: -	printk(KERN_INFO "PM-Timer had no reasonable result:"
: -			" 0x%#llx - aborting.\n", value1);
: -	return -ENODEV;
:  
: -pm_good:
:  	if (verify_pmtmr_rate() != 0)
:  		return -ENODEV;
:  


I guess this file falls under Thomas's git-hrt tree.  I can queue the
patches up and spam Thomas with them, but I'm at a bit of a loss
regarding their priority due to the above questions.
