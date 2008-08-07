Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbYHGRkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbYHGRkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYHGRk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:40:28 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:13629 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYHGRk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:40:28 -0400
Date: Thu, 7 Aug 2008 10:29:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>, Sam Ravnborg <sam@ravnborg.org>,
       "D. Kelly" <user.kernel@gmail.com>,
       "mailing list: linux-kernel" <linux-kernel@vger.kernel.org>,
       Linux I2C <i2c@lm-sensors.org>
Subject: Re: Problem with restricted I2C algorithms in kernel 2.6.26!
Message-Id: <20080807102925.47217ee1.randy.dunlap@oracle.com>
In-Reply-To: <20080807191943.72d1802d@hyperion.delvare>
References: <5ab239b10807161233i6c1c4d0we01ea1b8e6ccaa5b@mail.gmail.com>
	<20080807131357.59399ddf@hyperion.delvare>
	<Pine.LNX.4.58.0808070851310.10341@shell4.speakeasy.net>
	<20080807181416.5de4ce6d@hyperion.delvare>
	<20080807191943.72d1802d@hyperion.delvare>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2008 19:19:43 +0200 Jean Delvare wrote:

> On Thu, 7 Aug 2008 18:14:16 +0200, Jean Delvare wrote:
> > Hi Trent,
> > 
> > On Thu, 7 Aug 2008 09:01:35 -0700 (PDT), Trent Piepho wrote:
> > > Maybe an option to turn i2c algorithms on could do into the Library
> > > Routines menu.  There are already options for things like the crc routines
> > > here so they can be turned on if an out of tree driver needs them but
> > > nothing in the kernel does.
> > 
> > Having I2C-specific options selectable under the Library menu would
> > probably be even more confusing. However, it would be possible to do
> > something similar under the I2C menu. Much like
> > CONFIG_VIDEO_HELPER_CHIPS_AUTO does for the V4L subsystem:
> > CONFIG_I2C_ALGOS_AUTO would default to Y and would hide I2C algo driver
> > selection (as is the case in 2.6.26), changing it to N would present
> > the old menu for users to select the aldo drivers manually (as was the
> > case in 2.6.25.)
> 
> Something like this...
> 
> Subject: i2c: Let users select algorithm drivers manually again
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
>  drivers/i2c/Kconfig       |   14 ++++++++++++++
>  drivers/i2c/algos/Kconfig |   11 ++++++++---
>  2 files changed, 22 insertions(+), 3 deletions(-)
> 
> --- linux-2.6.27-rc2.orig/drivers/i2c/Kconfig	2008-04-17 04:49:44.000000000 +0200
> +++ linux-2.6.27-rc2/drivers/i2c/Kconfig	2008-08-07 19:14:37.000000000 +0200
> @@ -38,6 +38,20 @@ config I2C_CHARDEV
>  	  This support is also available as a module.  If so, the module 
>  	  will be called i2c-dev.
>  
> +config I2C_HELPER_AUTO
> +	bool "Autoselect pertinent helper modules"
> +	default y
> +	help
> +	  Some I2C bus drivers require so-called "I2C algorithm" modules
> +	  to work. These are basically software-only abstractions of generic
> +	  I2C interfaces. This option will autoselect them so that you don't
> +	  have to care.
> +
> +	  Unselect this only if you need to enable additional helper
> +	  modules, for example for use with external I2C bus drivers.
> +
> +	  In doubt, say Y.
> +
>  source drivers/i2c/algos/Kconfig
>  source drivers/i2c/busses/Kconfig
>  source drivers/i2c/chips/Kconfig
> --- linux-2.6.27-rc2.orig/drivers/i2c/algos/Kconfig	2008-07-14 11:14:59.000000000 +0200
> +++ linux-2.6.27-rc2/drivers/i2c/algos/Kconfig	2008-08-07 18:50:43.000000000 +0200
> @@ -2,15 +2,20 @@
>  # I2C algorithm drivers configuration
>  #
>  
> +menu "I2C Algorithms"
> +	depends on !I2C_HELPER_AUTO
> +
>  config I2C_ALGOBIT
> -	tristate
> +	tristate "I2C bit-banging interfaces"
>  
>  config I2C_ALGOPCF
> -	tristate
> +	tristate "I2C PCF 8584 interfaces"
>  
>  config I2C_ALGOPCA
> -	tristate
> +	tristate "I2C PCA 9564 interfaces"
>  
>  config I2C_ALGO_SGI
>  	tristate
>  	depends on SGI_IP22 || SGI_IP32 || X86_VISWS
> +
> +endmenu
> 
> Comment anyone?


Seems reasonable to me.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
