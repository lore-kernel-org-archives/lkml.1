Return-Path: <linux-kernel-owner+w=401wt.eu-S1752088AbZDESBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbZDESBf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 14:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbZDESB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 14:01:26 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:34545 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbZDESB0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 14:01:26 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Apr 2009 14:01:25 EDT
Date: Sun, 5 Apr 2009 13:51:26 -0400
From: Andres Salomon <dilinger@queued.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] [OLPC] force GENERIC_GPIO to be defined when OLPC is
 selected
Message-ID: <20090405135126.2ea187b1@ephemeral>
In-Reply-To: <49B93FB1.7030408@oracle.com>
References: <200903112325.n2BNP9nt016602@imap1.linux-foundation.org>
	<49B93FB1.7030408@oracle.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the report, and sorry for the late response.  The patch below
*should* fix this, but I'm having trouble compiling generic gpio support in
with the config that you supplied.


  CC      drivers/i2c/busses/i2c-pca-platform.o
In file included from /home/dilinger/git/linux-2.6/arch/x86/include/asm/gpio.h:19,
                 from include/linux/gpio.h:7,
                 from drivers/i2c/busses/i2c-pca-platform.c:24:
include/asm-generic/gpio.h: In function ‘gpio_get_value_cansleep’:
include/asm-generic/gpio.h:163: error: implicit declaration of function ‘gpio_get_value’
include/asm-generic/gpio.h: In function ‘gpio_set_value_cansleep’:
include/asm-generic/gpio.h:169: error: implicit declaration of function ‘gpio_set_value’

This is, however, on a different kernel tree (2.6.29 + cs553x patches).



On Thu, 12 Mar 2009 10:00:33 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-03-11-16-06 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> > 
> > It contains the following patches against 2.6.29-rc7:
> 
> > cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
> > cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch
> > alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch
> 
> 
> With these kconfig options:
> CONFIG_SND_CS5535AUDIO=m
> CONFIG_OLPC=y
> 
> build fails with:
> ERROR: "olpc_mic_bias" [sound/pci/cs5535audio/snd-cs5535audio.ko]
> undefined! ERROR:
> "olpc_quirks" [sound/pci/cs5535audio/snd-cs5535audio.ko] undefined!
> ERROR:
> "olpc_quirks_cleanup" [sound/pci/cs5535audio/snd-cs5535audio.ko]
> undefined! ERROR:
> "olpc_prequirks" [sound/pci/cs5535audio/snd-cs5535audio.ko]
> undefined! ERROR:
> "olpc_analog_input" [sound/pci/cs5535audio/snd-cs5535audio.ko]
> undefined!
> 
> 
> full .config is attached.
> 





We've begun using the generic GPIO stuff for geodes, so OLPC implicitly
depends upon this.  This patch forces selection of it.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 arch/x86/Kconfig               |    1 +
 sound/pci/cs5535audio/Makefile |    2 --
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bc2fbad..588ec18 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1925,6 +1925,7 @@ config GEODE_MFGPT_TIMER
 config OLPC
 	bool "One Laptop Per Child support"
 	default n
+	select GENERIC_GPIO
 	help
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.
diff --git a/sound/pci/cs5535audio/Makefile b/sound/pci/cs5535audio/Makefile
index 9b5c689..ccc6422 100644
--- a/sound/pci/cs5535audio/Makefile
+++ b/sound/pci/cs5535audio/Makefile
@@ -4,9 +4,7 @@
 
 snd-cs5535audio-y := cs5535audio.o cs5535audio_pcm.o
 snd-cs5535audio-$(CONFIG_PM) += cs5535audio_pm.o
-ifdef CONFIG_GENERIC_GPIO
 snd-cs5535audio-$(CONFIG_OLPC) += cs5535audio_olpc.o
-endif
 
 # Toplevel Module Dependency
 obj-$(CONFIG_SND_CS5535AUDIO) += snd-cs5535audio.o
-- 
1.5.6.5

