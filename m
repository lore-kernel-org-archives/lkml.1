Return-Path: <linux-kernel-owner+w=401wt.eu-S1762840AbYEIMdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762840AbYEIMdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 08:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbYEIMdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 08:33:25 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:53817 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985AbYEIMdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 08:33:24 -0400
Date: Fri, 9 May 2008 09:33:08 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: rtc-cmos.c: Build fix
Message-ID: <20080509123308.GA4180@beyonder.ift.unesp.br>
Mail-Followup-To: akpm@linux-foundation.org, mingo@elte.hu,
	linux-kernel@vger.kernel.org
References: <20080505231016.GA29072@beyonder.ift.unesp.br> <20080506124348.GR32591@elte.hu> <20080506185125.GA12844@beyonder.ift.unesp.br> <20080507143115.ed738026.akpm@linux-foundation.org> <20080509083258.GB2592@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509083258.GB2592@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri  9.May'08 at 10:32:58 +0200, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 6 May 2008 15:51:25 -0300
> > "Carlos R. Mafra" <crmafra2@gmail.com> wrote:
> > 
> > > Subject: [PATCH] rtc-cmos.c: Build fix
> > > 
> > > The function hpet_rtc_interrupt(..) is to be used only if CONFIG_HPET_EMULATE_RTC
> > > is defined (see arch/x86/kernel/hpet.c), so we define it to return 0 when
> > > !CONFIG_HPET_EMULATE_RTC to avoid build failures. 
> > > 
> > > This function will never be used anyways when !CONFIG_HPET_EMULATE_RTC because 
> > > it is inside a if(is_hpet_enabled()) which is never true when
> > > !CONFIG_HPET_EMULATE_RTC.
> > 
> > I've lost the plot on this one.  Could we please have a description of 
> > the problem which is being fixed?  ie, the compiler (or linker?) 
> > output, and a description of why it is occurring?
> 
> dont have the build failure log around anymore, but the config is:
> 
>    http://redhat.com/~mingo/misc/config-Sun_May__4_09_41_21_CEST_2008.bad

The build failure was this one

  CC      drivers/rtc/rtc-cmos.o
drivers/rtc/rtc-cmos.c: In function cmos_do_probe:
drivers/rtc/rtc-cmos.c:661: error: hpet_rtc_interrupt undeclared (first use in this function)
drivers/rtc/rtc-cmos.c:661: error: (Each undeclared identifier is reported only once
drivers/rtc/rtc-cmos.c:661: error: for each function it appears in.)
make[2]: *** [drivers/rtc/rtc-cmos.o] Error 1
make[1]: *** [drivers/rtc] Error 2
make: *** [drivers] Error 2

And that happened with Ingo's config above and your patch (copy & pasted) below,

------------->
From: Andrew Morton <akpm@linux-foundation.org>

Should already be available via the hpet.h inclusion.

Could go further, by defining the do-nothing stub in hpet.h as well, perhaps.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/rtc.c     |    2 --
 drivers/rtc/rtc-cmos.c |    1 -
 2 files changed, 3 deletions(-)

diff -puN drivers/char/rtc.c~rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt \
                drivers/char/rtc.c
--- a/drivers/char/rtc.c~rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt
+++ a/drivers/char/rtc.c
@@ -119,8 +119,6 @@ static irqreturn_t hpet_rtc_interrupt(in
 	return 0;
 }
 #endif
-#else
-extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);
 #endif
 
 /*
diff -puN drivers/rtc/rtc-cmos.c~rtc-remove-unneeded-declarations-of-hpet_rtc_interrup \
                t drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt
+++ a/drivers/rtc/rtc-cmos.c
@@ -52,7 +52,6 @@
 #define hpet_rtc_timer_init() 			do { } while (0)
 #define hpet_register_irq_handler(h) 		0
 #define hpet_unregister_irq_handler(h)		do { } while (0)
-extern irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id);  <-----
 #endif                                                              |
                                                                     |
 struct cmos_rtc {                                                   |
                                                                     |
                                                  This is where the 
                                                  build failure comes
                                                  from. My patch fixed it,
						  but I folded it together
						  with yours.

It's up to you to decide what to do, if you want two patches or only
one (which is the status quo now).
It was an enlightining experience for me anyway :-)



