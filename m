Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbXCRKDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbXCRKDK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 06:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbXCRKDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 06:03:10 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:48896 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741AbXCRKDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 06:03:07 -0400
Date: Sun, 18 Mar 2007 19:00:05 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: Re: [PATCH]RTC: add rtc-rs5c313 driver
Message-ID: <20070318100005.GA10191@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
References: <20070309120302.e257ee6c.iwamatsu@nigauri.org> <20070318013804.1e7beced.akpm@linux-foundation.org> <20070309120302.e257ee6c.iwamatsu@nigauri.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318013804.1e7beced.akpm@linux-foundation.org> <20070309120302.e257ee6c.iwamatsu@nigauri.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 12:03:02PM +0900, Nobuhiro Iwamatsu wrote:
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index 95826b9..cc3c0b2 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -354,4 +354,10 @@ config RTC_DRV_V3020
>  	  This driver can also be built as a module. If so, the module
>  	  will be called rtc-v3020.
>  
> +config RTC_DRV_RS5C313
> +	tristate "Ricoh RS5C313"
> +	depends on RTC_CLASS
> +	help
> +	  If you say yes here you get support for the Ricoh RS5C313 RTC chips.
> +
>  endmenu

This should also depend on SH_LANDISK if it has any hope of compiling..
however..

> +#ifdef CONFIG_SH_LANDISK
> +/*****************************************************/
> +/* LANDISK dependence part of RS5C313                */
> +/*****************************************************/
> +
[snip]

> +#define RS5C313_CEENABLE    ctrl_outb(RS5C313_CE_RTCCE, RS5C313_CE);
> +#define RS5C313_CEDISABLE   ctrl_outb(0x00, RS5C313_CE)
> +#define RS5C313_MISCOP      ctrl_outb(0x02, 0xB0000008)
> +
> +static void rs5c313_init_port(void)
> +{
> +	/* Set SCK as I/O port and Initialize SCSPTR1 data & I/O port. */
> +	ctrl_outb(ctrl_inb(SCSMR1) & ~SCSMR1_CA, SCSMR1);
> +	ctrl_outb(ctrl_inb(SCSCR1) & ~SCSCR1_CKE, SCSCR1);
> +
> +	/* And Initialize SCL for RS5C313 clock */
> +	scsptr1_data = ctrl_inb(SCSPTR1) | SCL;	/* SCL:H */
> +	ctrl_outb(scsptr1_data, SCSPTR1);
> +	scsptr1_data = ctrl_inb(SCSPTR1) | SCL_OEN;	/* SCL output enable */
> +	ctrl_outb(scsptr1_data, SCSPTR1);
> +	RS5C313_CEDISABLE;	/* CE:L */
> +}
> +
This is all I2C cruft, which should be split out in to a separate driver.
If any other platforms are going to have a hope of using this driver,
it'll be through the generic I2C interfaces (many RTC drivers already do
this).

Of course the SH_LANDISK dependency can be added, but it's preferable to
do this right the first time, before someone ends up inevitably
reimplementing the same thing.

On Sun, Mar 18, 2007 at 01:38:04AM -0800, Andrew Morton wrote:
> drivers/rtc/rtc-rs5c313.c: In function 'rs5c313_read_reg':
> drivers/rtc/rtc-rs5c313.c:186: warning: implicit declaration of function 'rs5c313_write_data'
> drivers/rtc/rtc-rs5c313.c:187: warning: implicit declaration of function 'rs5c313_read_data'
> drivers/rtc/rtc-rs5c313.c: In function 'rs5c313_rtc_read_time':
> drivers/rtc/rtc-rs5c313.c:208: error: 'RS5C313_CEENABLE' undeclared (first use in this function)
> drivers/rtc/rtc-rs5c313.c:208: error: (Each undeclared identifier is reported only once
> drivers/rtc/rtc-rs5c313.c:208: error: for each function it appears in.)
> drivers/rtc/rtc-rs5c313.c:217: error: 'RS5C313_CEDISABLE' undeclared (first use in this function)
> drivers/rtc/rtc-rs5c313.c: In function 'rs5c313_rtc_set_time':
> drivers/rtc/rtc-rs5c313.c:265: error: 'RS5C313_CEENABLE' undeclared (first use in this function)
> drivers/rtc/rtc-rs5c313.c:273: error: 'RS5C313_MISCOP' undeclared (first use in this function)
> drivers/rtc/rtc-rs5c313.c:274: error: 'RS5C313_CEDISABLE' undeclared (first use in this function)
> drivers/rtc/rtc-rs5c313.c: In function 'rs5c313_check_xstp_bit':
> drivers/rtc/rtc-rs5c313.c:315: error: 'RS5C313_CEENABLE' undeclared (first use in this function)
> drivers/rtc/rtc-rs5c313.c:324: error: 'RS5C313_MISCOP' undeclared (first use in this function)
> drivers/rtc/rtc-rs5c313.c:336: error: 'RS5C313_CEDISABLE' undeclared (first use in this function)
> drivers/rtc/rtc-rs5c313.c: In function 'rs5c313_rtc_init':
> drivers/rtc/rtc-rs5c313.c:390: warning: implicit declaration of function 'rs5c313_init_port'
> 
> I think we're missing a header file?

It basically has no hope of compiling for the !SH_LANDISK case at
present, so the options are to either munge the dependencies or to rip
out the platform-specific cruft from the driver.
