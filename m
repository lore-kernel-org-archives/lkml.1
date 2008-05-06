Return-Path: <linux-kernel-owner+w=401wt.eu-S1764129AbYEFSxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764129AbYEFSxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 14:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbYEFSxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 14:53:07 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:40856 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbYEFSxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 14:53:03 -0400
Date: Tue, 6 May 2008 15:51:25 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: rtc-cmos.c: Build fix
Message-ID: <20080506185125.GA12844@beyonder.ift.unesp.br>
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20080505231016.GA29072@beyonder.ift.unesp.br> <20080506124348.GR32591@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506124348.GR32591@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> since you seem to be interested in HPET topics, what do you think about 
> the patch below from akpm? It had a build failure with this config:
> 
>   http://redhat.com/~mingo/misc/config-Sun_May__4_09_41_21_CEST_2008.bad

I think I've found the problem. After fixing the rtc-cmos.o build your
.config produced yet another failure later on:

  LD      .tmp_vmlinux1
drivers/built-in.o: In function `v4l2_i2c_drv_attach_legacy':
tuner-core.c:(.text+0xc5a31): undefined reference to `v4l2_i2c_attach'
drivers/built-in.o: In function `tuner_command':
tuner-core.c:(.text+0xc6dc2): undefined reference to `v4l_printk_ioctl'
make: *** [.tmp_vmlinux1] Error 1

But this one I left untouched for the moment.

> ------------->
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Should already be available via the hpet.h inclusion.

With the inclusion of hpet.h we don't have the "do-nothing stubs" for
the case !HPET_EMULATE_RTC as they are defined inside rtc.c
and rtc-cmos.c. However hpet_rtc_interrupt() is missing in those
stubs because it was removed with akpm's patch. So I added it.

My explanation for the build failure is as follows.

Your .config did not have HPET_EMULATE_RTC enabled but the code
in rtc-cmos.c wanted to use hpet_rtc_interrupt() anyways. But
looking in arch/x86/kernel/hpet.c this function is inside a

#ifdef CONFIG_HPET_EMULATE_RTC <-- line 465
hpet_rtc_interrupt() <--- line 679
#endif <--- line 716

so it should be used if and only if HPET_EMULATE_RTC is defined.

And the code in question which makes the build fail is inside a 
  if(is_hpet_enabled()) {
  ...
  rtc_cmos_int_handler = hpet_rtc_interrupt;
  ...
  }
and this would never be executed because with !HPET_EMULATE_RTC (as
in your .config) is_hpet_enabled() is defined to return 0.

So I think Andrew's patch should be the one below (I've folded
my correction into his patch, so I am Cc:ing him also), where my
modification is the adition inside the #ifndef CONFIG_HPET_EMULATE_RTC
(which I took from rtc.c)

> Could go further, by defining the do-nothing stub in hpet.h as well, perhaps.

I think one could do that too as a cleanup (to remove the do-nothing stubs
from rtc.c and rtc-cmos.c), but I am afraid to make a mistake which would
cause other build failures afterwards. So now I just wanted to understand
and fix the issue you suggested to me (for which I thank you).

Furthermore, the modification in rtc.c is ok because it was used only
if CONFIG_HPET_EMULATE_RTC is defined, but that can only happen if
CONFIG_HPET_TIMER is also defined (due to 'depends on HPET_TIMER' in 
the Kconfig), in which case the inclusion of hpet.h is effective.

I hope this is ok for now.


>From a9852384bcf423493ecdf8be83c3fc72d4b9959d Mon Sep 17 00:00:00 2001
From: Carlos R. Mafra <crmafra@ift.unesp.br>
Date: Tue, 6 May 2008 13:58:04 -0300
Subject: [PATCH] rtc-cmos.c: Build fix

The function hpet_rtc_interrupt(..) is to be used only if CONFIG_HPET_EMULATE_RTC
is defined (see arch/x86/kernel/hpet.c), so we define it to return 0 when
!CONFIG_HPET_EMULATE_RTC to avoid build failures. 

This function will never be used anyways when !CONFIG_HPET_EMULATE_RTC because 
it is inside a if(is_hpet_enabled()) which is never true when
!CONFIG_HPET_EMULATE_RTC.

Signed-off-by: Carlos R. Mafra <crmafra@ift.unesp.br>
---
 drivers/char/rtc.c     |    2 --
 drivers/rtc/rtc-cmos.c |    5 ++++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index 5f80a9d..31d09ea 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -119,8 +119,6 @@ static irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
 	return 0;
 }
 #endif
-#else
-extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
 #endif
 
 /*
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index d060a06..12046bb 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -52,7 +52,10 @@
 #define hpet_rtc_timer_init() 			do { } while (0)
 #define hpet_register_irq_handler(h) 		0
 #define hpet_unregister_irq_handler(h)		do { } while (0)
-extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
+static irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
+{
+	return 0;
+}
 #endif
 
 struct cmos_rtc {
-- 
1.5.4.3


