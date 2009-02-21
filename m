Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbZBUXIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbZBUXIU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 18:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbZBUXIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 18:08:11 -0500
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:45382 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754154AbZBUXIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 18:08:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=F+DLhIF1s4KTmeLERFgAcph/LUgrALr0IgsSWGPfYftE1EMPpIo1EKLvLczjiGJv;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <49A08953.1010809@earthlink.net>
Date: Sat, 21 Feb 2009 18:08:03 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [WATCHDOG] v2.6.29-rc5 iTCO_wdt regression.
References: <20090217081518.GG30736@infomag.iguana.be>
In-Reply-To: <20090217081518.GG30736@infomag.iguana.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec7948ef386550d6372bf84641e07a0b7288350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.118.36.246
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wim Van Sebroeck wrote:
> Hi Linus,
> 
> This should have gone out more then 2 weeks ago, but a disk crash changed my planning :-(
> 
> Please pull from 'master' branch of
> 	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
> or if master.kernel.org hasn't synced up yet:
> 	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
> 
> This will update the following files:
> 
>  drivers/watchdog/Kconfig               |    2 -
>  drivers/watchdog/iTCO_vendor_support.c |   32 ++++++++++++++++++++++++++----
>  drivers/watchdog/iTCO_wdt.c            |   35 +++++++++++++--------------------
>  3 files changed, 43 insertions(+), 26 deletions(-)
> 
> with these Changes:
> 
> Author: Wim Van Sebroeck <wim@iguana.be>
> Date:   Wed Jan 28 20:51:04 2009 +0000
> 
>     [WATCHDOG] iTCO_wdt: fix SMI_EN regression 2
>     
>     bugzilla: #12363
>     commit 7cd5b08be3c489df11b559fef210b81133764ad4 added a second regression:
>     some Dell's and Compaq's lockup on boot. So we revert most of the code.
>     The ICH9 reboot issue remains in place and will need some more fixing... :-(

Any idea when you could have a fix for the ICH9?

>     
>     Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> 
> The Changes can also be looked at on:
> 	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary
> 
> For completeness, I added the overal diff below.
> 
> Greetings,
> Wim.
> 
> ================================================================================
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 09a3d55..325c10f 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -406,7 +406,7 @@ config ITCO_WDT
>  	---help---
>  	  Hardware driver for the intel TCO timer based watchdog devices.
>  	  These drivers are included in the Intel 82801 I/O Controller
> -	  Hub family (from ICH0 up to ICH8) and in the Intel 6300ESB
> +	  Hub family (from ICH0 up to ICH10) and in the Intel 63xxESB
>  	  controller hub.
>  
>  	  The TCO (Total Cost of Ownership) timer is a watchdog timer
> diff --git a/drivers/watchdog/iTCO_vendor_support.c b/drivers/watchdog/iTCO_vendor_support.c
> index 2474ebc..d8264ad 100644
> --- a/drivers/watchdog/iTCO_vendor_support.c
> +++ b/drivers/watchdog/iTCO_vendor_support.c
> @@ -1,7 +1,7 @@
>  /*
>   *	intel TCO vendor specific watchdog driver support
>   *
> - *	(c) Copyright 2006-2008 Wim Van Sebroeck <wim@iguana.be>.
> + *	(c) Copyright 2006-2009 Wim Van Sebroeck <wim@iguana.be>.
>   *
>   *	This program is free software; you can redistribute it and/or
>   *	modify it under the terms of the GNU General Public License
> @@ -19,7 +19,7 @@
>  
>  /* Module and version information */
>  #define DRV_NAME	"iTCO_vendor_support"
> -#define DRV_VERSION	"1.02"
> +#define DRV_VERSION	"1.03"
>  #define PFX		DRV_NAME ": "
>  
>  /* Includes */
> @@ -77,6 +77,26 @@ MODULE_PARM_DESC(vendorsupport, "iTCO vendor specific support mode, default=0 (n
>   *	    20.6 seconds.
>   */
>  
> +static void supermicro_old_pre_start(unsigned long acpibase)
> +{
> +	unsigned long val32;
> +
> +	/* Bit 13: TCO_EN -> 0 = Disables TCO logic generating an SMI# */
> +	val32 = inl(SMI_EN);
> +	val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
> +	outl(val32, SMI_EN);	/* Needed to activate watchdog */
> +}
> +
> +static void supermicro_old_pre_stop(unsigned long acpibase)
> +{
> +	unsigned long val32;
> +
> +	/* Bit 13: TCO_EN -> 1 = Enables the TCO logic to generate SMI# */
> +	val32 = inl(SMI_EN);
> +	val32 |= 0x00002000;	/* Turn on SMI clearing watchdog */
> +	outl(val32, SMI_EN);	/* Needed to deactivate watchdog */
> +}
> +
>  static void supermicro_old_pre_keepalive(unsigned long acpibase)
>  {
>  	/* Reload TCO Timer (done in iTCO_wdt_keepalive) + */
> @@ -228,14 +248,18 @@ static void supermicro_new_pre_set_heartbeat(unsigned int heartbeat)
>  void iTCO_vendor_pre_start(unsigned long acpibase,
>  			   unsigned int heartbeat)
>  {
> -	if (vendorsupport == SUPERMICRO_NEW_BOARD)
> +	if (vendorsupport == SUPERMICRO_OLD_BOARD)
> +		supermicro_old_pre_start(acpibase);
> +	else if (vendorsupport == SUPERMICRO_NEW_BOARD)
>  		supermicro_new_pre_start(heartbeat);
>  }
>  EXPORT_SYMBOL(iTCO_vendor_pre_start);
>  
>  void iTCO_vendor_pre_stop(unsigned long acpibase)
>  {
> -	if (vendorsupport == SUPERMICRO_NEW_BOARD)
> +	if (vendorsupport == SUPERMICRO_OLD_BOARD)
> +		supermicro_old_pre_stop(acpibase);
> +	else if (vendorsupport == SUPERMICRO_NEW_BOARD)
>  		supermicro_new_pre_stop();
>  }
>  EXPORT_SYMBOL(iTCO_vendor_pre_stop);
> diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
> index 5b395a4..3523349 100644
> --- a/drivers/watchdog/iTCO_wdt.c
> +++ b/drivers/watchdog/iTCO_wdt.c
> @@ -1,7 +1,7 @@
>  /*
> - *	intel TCO Watchdog Driver (Used in i82801 and i6300ESB chipsets)
> + *	intel TCO Watchdog Driver (Used in i82801 and i63xxESB chipsets)
>   *
> - *	(c) Copyright 2006-2008 Wim Van Sebroeck <wim@iguana.be>.
> + *	(c) Copyright 2006-2009 Wim Van Sebroeck <wim@iguana.be>.
>   *
>   *	This program is free software; you can redistribute it and/or
>   *	modify it under the terms of the GNU General Public License
> @@ -63,7 +63,7 @@
>  
>  /* Module and version information */
>  #define DRV_NAME	"iTCO_wdt"
> -#define DRV_VERSION	"1.04"
> +#define DRV_VERSION	"1.05"
>  #define PFX		DRV_NAME ": "
>  
>  /* Includes */
> @@ -236,16 +236,16 @@ MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
>  
>  /* Address definitions for the TCO */
>  /* TCO base address */
> -#define	TCOBASE		iTCO_wdt_private.ACPIBASE + 0x60
> +#define TCOBASE		iTCO_wdt_private.ACPIBASE + 0x60
>  /* SMI Control and Enable Register */
> -#define	SMI_EN		iTCO_wdt_private.ACPIBASE + 0x30
> +#define SMI_EN		iTCO_wdt_private.ACPIBASE + 0x30
>  
>  #define TCO_RLD		TCOBASE + 0x00	/* TCO Timer Reload and Curr. Value */
>  #define TCOv1_TMR	TCOBASE + 0x01	/* TCOv1 Timer Initial Value	*/
> -#define	TCO_DAT_IN	TCOBASE + 0x02	/* TCO Data In Register		*/
> -#define	TCO_DAT_OUT	TCOBASE + 0x03	/* TCO Data Out Register	*/
> -#define	TCO1_STS	TCOBASE + 0x04	/* TCO1 Status Register		*/
> -#define	TCO2_STS	TCOBASE + 0x06	/* TCO2 Status Register		*/
> +#define TCO_DAT_IN	TCOBASE + 0x02	/* TCO Data In Register		*/
> +#define TCO_DAT_OUT	TCOBASE + 0x03	/* TCO Data Out Register	*/
> +#define TCO1_STS	TCOBASE + 0x04	/* TCO1 Status Register		*/
> +#define TCO2_STS	TCOBASE + 0x06	/* TCO2 Status Register		*/
>  #define TCO1_CNT	TCOBASE + 0x08	/* TCO1 Control Register	*/
>  #define TCO2_CNT	TCOBASE + 0x0a	/* TCO2 Control Register	*/
>  #define TCOv2_TMR	TCOBASE + 0x12	/* TCOv2 Timer Initial Value	*/
> @@ -338,7 +338,6 @@ static int iTCO_wdt_unset_NO_REBOOT_bit(void)
>  static int iTCO_wdt_start(void)
>  {
>  	unsigned int val;
> -	unsigned long val32;
>  
>  	spin_lock(&iTCO_wdt_private.io_lock);
>  
> @@ -351,11 +350,6 @@ static int iTCO_wdt_start(void)
>  		return -EIO;
>  	}
>  
> -	/* Bit 13: TCO_EN -> 0 = Disables TCO logic generating an SMI# */
> -	val32 = inl(SMI_EN);
> -	val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
> -	outl(val32, SMI_EN);
> -
>  	/* Force the timer to its reload value by writing to the TCO_RLD
>  	   register */
>  	if (iTCO_wdt_private.iTCO_version == 2)
> @@ -378,7 +372,6 @@ static int iTCO_wdt_start(void)
>  static int iTCO_wdt_stop(void)
>  {
>  	unsigned int val;
> -	unsigned long val32;
>  
>  	spin_lock(&iTCO_wdt_private.io_lock);
>  
> @@ -390,11 +383,6 @@ static int iTCO_wdt_stop(void)
>  	outw(val, TCO1_CNT);
>  	val = inw(TCO1_CNT);
>  
> -	/* Bit 13: TCO_EN -> 1 = Enables the TCO logic to generate SMI# */
> -	val32 = inl(SMI_EN);
> -	val32 |= 0x00002000;
> -	outl(val32, SMI_EN);
> -
>  	/* Set the NO_REBOOT bit to prevent later reboots, just for sure */
>  	iTCO_wdt_set_NO_REBOOT_bit();
>  
> @@ -649,6 +637,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
>  	int ret;
>  	u32 base_address;
>  	unsigned long RCBA;
> +	unsigned long val32;
>  
>  	/*
>  	 *      Find the ACPI/PM base I/O address which is the base
> @@ -695,6 +684,10 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
>  		ret = -EIO;
>  		goto out;
>  	}
> +	/* Bit 13: TCO_EN -> 0 = Disables TCO logic generating an SMI# */
> +	val32 = inl(SMI_EN);
> +	val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
> +	outl(val32, SMI_EN);
>  
>  	/* The TCO I/O registers reside in a 32-byte range pointed to
>  	   by the TCOBASE value */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)


