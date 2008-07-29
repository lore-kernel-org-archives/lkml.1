Return-Path: <linux-kernel-owner+w=401wt.eu-S1759067AbYG2UGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067AbYG2UGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbYG2UGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:06:09 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:21070 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752050AbYG2UGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:06:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0ZEjP+f37ppgNHxZnV5kiJ7Th+5z87bXJCb4dM5foT6dNEJwtcrWnGhmL/0vNphvKI32BOSfFlpQlwQBxfjDFHcVS7woXNGaP9T5TEyXnuhDfTfD7mKFThTQUICPDPtYn/D/emahixiAu1IpGyhCJsZGm+vDDb4Sfa+4oixixMc=  ;
X-YMail-OSG: WfZWFzEVM1nwpk3aQ3bjpx2qwu91lQN7tRI8cW4C4Knnlr7UmbzFL1k8613uwWBtSbxtA.slIChEB5cDl5eO3yCCSPIScbkH4F7CHMvFh.n7pCv7RY8AcZXZk1HN0fU-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.27-rc1] legacy rtc:  remove needless/confusing HPET_RTC_IRQ option
Date: Tue, 29 Jul 2008 12:35:12 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291235.13011.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

HPET_RTC_IRQ is no longer needed; HPET_EMULATE_RTC suffices and is
more correct.  (http://bugzilla.kernel.org/show_bug.cgi?id=11111)

Note that when using the legacy RTC driver, platforms don't really do
a dynamic switch between HPET and non-HPET modes based on whether HPET
hardware actually exists ...  only rtc-cmos (using the new RTC framework)
currently switches that way.

So this reflects bitrot in that legacy code, for x86/ia64:  kernels with
HPET support configured (e.g. for a clocksource) can't get IRQs from the
legacy RTC driver unless they really have HPET hardware.  (The obvious
workaround is to not use the legacy RTC driver on those platforms when
you configure HPET ... unless you know the target really has a HPET.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/char/Kconfig |    9 ---------
 drivers/char/rtc.c   |    2 +-
 2 files changed, 1 insertion(+), 10 deletions(-)

--- a/drivers/char/Kconfig	2008-07-26 17:28:58.000000000 -0700
+++ b/drivers/char/Kconfig	2008-07-26 17:39:37.000000000 -0700
@@ -1043,15 +1043,6 @@ config HPET
 	  open selects one of the timers supported by the HPET.  The timers are
 	  non-periodic and/or periodic.
 
-config HPET_RTC_IRQ
-	bool
-	default HPET_EMULATE_RTC
-	depends on RTC && HPET
-	help
-	  If you say Y here, you will disable RTC_IRQ in drivers/char/rtc.c. It
-	  is assumed the platform called hpet_alloc with the RTC IRQ values for
-	  the HPET timers.
-
 config HPET_MMAP
 	bool "Allow mmap of HPET"
 	default y
--- a/drivers/char/rtc.c	2008-07-26 17:28:58.000000000 -0700
+++ b/drivers/char/rtc.c	2008-07-26 17:39:37.000000000 -0700
@@ -97,7 +97,7 @@ static unsigned long rtc_port;
 static int rtc_irq = PCI_IRQ_NONE;
 #endif
 
-#ifdef	CONFIG_HPET_RTC_IRQ
+#ifdef	CONFIG_HPET_EMULATE_RTC
 #undef	RTC_IRQ
 #endif
 
