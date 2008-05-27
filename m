Return-Path: <linux-kernel-owner+w=401wt.eu-S1759581AbYE0XPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581AbYE0XPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 19:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYE0XO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 19:14:58 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:32121 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750975AbYE0XO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 19:14:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PHmkTPP8b1oNPqDSc3I2eO7UzNSDswASJrIykguV9hyOwAR+Lj7vS2PD5oX8wpgB9MKV+dAxWVa+MX7LjshCAQ5jfu05buR15oEvAVl8qjcquH30+8SdvGSHzJWJxF/X8MC9NKKOvFGFTvwI+9YNUM25p1Z2aakbuIVTKuVxckY=  ;
X-YMail-OSG: G2EFTsUVM1lLz.IAhRTehDPRHs_CbBEvKz4ub3O.4Brgj9mmSdCesRVwfkZCJC3bwkYnDCVbs3.k73xeQ2EVi19MIMzb8Dr77wU4HbRycwLrgRI1aDb4BT9SWX3oySZIIcc-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Felipe Balbi <felipe.balbi@nokia.com>
Subject: HAVE_CLK (for <linux/clk.h> support)
Date: Tue, 27 May 2008 16:14:55 -0700
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200805231044.59969.david-b@pacbell.net> <1211879340-22013-1-git-send-email-felipe.balbi@nokia.com>
In-Reply-To: <1211879340-22013-1-git-send-email-felipe.balbi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805271614.55233.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2008, Felipe Balbi wrote:
> This patch adds support for MUSB and TUSB controllers
> integrated into omap2430 and davinci. It also adds support
> for external tusb6010 controller.

The most significant issue I know of with this patch [0] is actually
an arch issue.  On ones like x86, with no support for the clock API,
this driver will build but not link:

ERROR: "clk_enable" [drivers/usb/musb/musb_hdrc.ko] undefined!
ERROR: "clk_disable" [drivers/usb/musb/musb_hdrc.ko] undefined!
ERROR: "clk_put" [drivers/usb/musb/musb_hdrc.ko] undefined!
ERROR: "clk_get" [drivers/usb/musb/musb_hdrc.ko] undefined!

I don't know of any other drivers with this particular issue,
but nonetheless ... I think the following is an appropriate
resolution.

Comments from anyone else?

- Dave

[0] Posted this AM on linux-usb but evidently too big for any
    of the archives I know about ... 450 KB, which includes
    host, gadget, and OTG functionality.  Previous versions
    are archived, in the one-file-added-per-patch style.


--- g26.orig/drivers/usb/musb/Kconfig	2008-05-27 16:02:41.000000000 -0700
+++ g26/drivers/usb/musb/Kconfig	2008-05-27 16:01:09.000000000 -0700
@@ -8,7 +8,7 @@ comment "Enable Host or Gadget support t
 
 # (M)HDRC = (Multipoint) Highspeed Dual-Role Controller
 config USB_MUSB_HDRC
-	depends on USB || USB_GADGET
+	depends on HAVE_CLK && (USB || USB_GADGET)
 	select TWL4030_USB if MACH_OMAP_3430SDP
 	tristate 'Inventra Highspeed Dual Role Controller (TI, ...)'
 	help
--- g26.orig/arch/Kconfig	2008-05-27 16:00:14.000000000 -0700
+++ g26/arch/Kconfig	2008-05-27 16:00:41.000000000 -0700
@@ -39,3 +39,6 @@ config HAVE_KRETPROBES
 
 config HAVE_DMA_ATTRS
 	def_bool n
+
+config HAVE_CLK
+	def_bool n
--- g26.orig/arch/arm/Kconfig	2008-05-27 16:01:15.000000000 -0700
+++ g26/arch/arm/Kconfig	2008-05-27 16:02:33.000000000 -0700
@@ -458,12 +458,14 @@ config ARCH_DAVINCI
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
+	select HAVE_CLK
 	help
 	  Support for TI's DaVinci platform.
 
 config ARCH_OMAP
 	bool "TI OMAP"
 	select GENERIC_GPIO
+	select HAVE_CLK
 	select HAVE_GPIO_LIB
 	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
