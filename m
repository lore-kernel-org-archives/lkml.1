Return-Path: <linux-kernel-owner+w=401wt.eu-S934208AbXG2TCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208AbXG2TCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 15:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765041AbXG2TCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 15:02:44 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:59837 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764703AbXG2TCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 15:02:43 -0400
Date: Sun, 29 Jul 2007 21:06:15 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: [bug] pcwd_init_module(): WARNING: at lib/kref.c:33 kref_get()
Message-ID: <20070729190615.GA28995@infomag.infomag.iguana.be>
References: <20070722124224.GA20382@elte.hu> <a781481a0707220753q2754f3cfy47941405f92c833d@mail.gmail.com> <20070723093302.2a2bf9d4@gondolin.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723093302.2a2bf9d4@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> On Sun, 22 Jul 2007 20:23:20 +0530,
> "Satyam Sharma" <satyam.sharma@gmail.com> wrote:
> 
> > On 7/22/07, Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > enabling CONFIG_PCWATCHDOG=y crashes bzImage bootup, see below. Tested
> > > on latest -git.
...
> 
> Might be some ordering problem (bus not registered yet). Is the isa bus
> already up? Changing link order or initcall levels might help.

See below fix. Please test it.
Thanks in advance,
Wim.

[WATCHDOG] Fix pcwd_init_module crash

Fix for the problem detected by Ingo Molnar:
enabling CONFIG_PCWATCHDOG=y crashes bzImage bootup.

The reason for this can be found in drivers/makefile
We first do:
obj-y                           += char/
and later we do:
obj-y                           += base/ block/ misc/ mfd/ net/ media/

So if we put a platform or isa or usb bus driver in char/watchdog
(which is called from the Makefile in drivers/char/Makefile)
then we didn't have the different device drivers initialized yet
(they are in drivers/base and drivers/usb and ...)

This fix makes sure that we compile the watchdog drivers after
drivers/base, drivers/misc, drivers/pci and drivers/usb.
We also do the compile after hwmon because in the future the
watchdog temperature support will use the hwmon system.

Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff --git a/drivers/Makefile b/drivers/Makefile
index a9e4c5f..f0878b2 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -66,6 +66,7 @@ obj-y				+= i2c/
 obj-$(CONFIG_W1)		+= w1/
 obj-$(CONFIG_POWER_SUPPLY)	+= power/
 obj-$(CONFIG_HWMON)		+= hwmon/
+obj-$(CONFIG_WATCHDOG)		+= char/watchdog/
 obj-$(CONFIG_PHONE)		+= telephony/
 obj-$(CONFIG_MD)		+= md/
 obj-$(CONFIG_BT)		+= bluetooth/
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 8fecaf4..2bc3a55 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -97,7 +97,6 @@ obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.o
 obj-$(CONFIG_GPIO_TB0219)	+= tb0219.o
 obj-$(CONFIG_TELCLOCK)		+= tlclk.o
 
-obj-$(CONFIG_WATCHDOG)		+= watchdog/
 obj-$(CONFIG_MWAVE)		+= mwave/
 obj-$(CONFIG_AGP)		+= agp/
 obj-$(CONFIG_DRM)		+= drm/
