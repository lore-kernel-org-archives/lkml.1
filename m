Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490Ab0AHDJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab0AHDJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 22:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408Ab0AHDJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 22:09:14 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:58913 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab0AHDJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 22:09:14 -0500
Date: Fri, 8 Jan 2010 11:08:37 +0800
From: Daniel Mack <daniel@caiaq.de>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-geode@lists.infradead.org" <linux-geode@lists.infradead.org>
Subject: Re: 2.6.33-rc3 regression: leds_alix2: can't allocate I/O for GPIO
Message-ID: <20100108030837.GY28375@buzzloop.caiaq.de>
References: <4B45B6DD.4060903@nets.rwth-aachen.de>
 <1262861484.8493.14.camel@dax.rpnet.com>
 <4B45CC4C.4030603@nets.rwth-aachen.de>
 <4B45CF73.9090304@nets.rwth-aachen.de>
 <20100107124630.GU28375@buzzloop.caiaq.de>
 <4B45E905.7040401@nets.rwth-aachen.de>
 <1262885241.27762.1.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262885241.27762.1.camel@dax.rpnet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 05:27:21PM +0000, Richard Purdie wrote:
> On Thu, 2010-01-07 at 15:00 +0100, Arnd Hannemann wrote:
> > Daniel Mack schrieb:
> > > On Thu, Jan 07, 2010 at 01:11:31PM +0100, Arnd Hannemann wrote:
> > >> Arnd Hannemann schrieb:
> > >> Oh, maybe using cs5535_gpio AND leds_alix2 together was never supposed to work?
> > > 
> > > That is the problem indeed. The problem is that three of these GPIOs are
> > > connected to LEDs, so if both drivers are enabled, they will both alter
> > > the same GPIOs. Hmm, don't know how to handle this. Maybe the LED driver
> > > should use the GPIO interface and that's it?
> > 
> > I'm not sure that this configuration needs to be supported at all,
> > so disallowing that both drivers are configured via Kconfig could be a simple solution.
> 
> Agreed, Kconfig dependencies for this until the code is improved look
> like the best option. Does someone want to send me a patch?

Does the one below look ok?

Thanks,
Daniel


>From ebb89d7d1908e85587f3e64bcea0dd77a92cc744 Mon Sep 17 00:00:00 2001
From: Daniel Mack <daniel@caiaq.de>
Date: Fri, 8 Jan 2010 02:22:10 +0800
Subject: [PATCH] LEDS: ALIX2: Add dependency to !GPIO_CS5335

The ALIX2 LED driver and the CS5535 GPIO driver share the same I/O
range which causes a conflict if they're both enabled. Fix this for now
by adding a Kconfig dependency. While at it, also drop the EXPERIMENTAL
flag, as the code has been around for awhile already.

Note that this is a hack. At some point, a real platform support for
this board should be added which handles the LEDs via the leds-gpio
driver.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
---
 drivers/leds/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 8a0e1ec..7f292ae 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -72,7 +72,7 @@ config LEDS_WRAP
 
 config LEDS_ALIX2
 	tristate "LED Support for ALIX.2 and ALIX.3 series"
-	depends on LEDS_CLASS && X86 && EXPERIMENTAL
+	depends on LEDS_CLASS && X86 && !GPIO_CS5535
 	help
 	  This option enables support for the PCEngines ALIX.2 and ALIX.3 LEDs.
 	  You have to set leds-alix2.force=1 for boards with Award BIOS.
-- 
1.6.3.3

