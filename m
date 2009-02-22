Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbZBVVNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbZBVVNK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 16:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbZBVVM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 16:12:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50967 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbZBVVMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 16:12:55 -0500
Date: Sun, 22 Feb 2009 22:12:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 1/2] PM: Split up sysdev_[suspend|resume] from
	device_power_[down|up]
Message-ID: <20090222211205.GA28655@elte.hu>
References: <200902221837.49396.rjw@sisk.pl> <200902221838.51548.rjw@sisk.pl> <20090222205654.GC4485@localhost.pp.htv.fi> <alpine.LFD.2.00.0902221306090.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902221306090.3111@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 22 Feb 2009, Adrian Bunk wrote:
> > ...
> >   MODPOST 2586 modules
> > ERROR: "sysdev_resume" [arch/x86/kernel/apm.ko] undefined!
> > ERROR: "sysdev_suspend" [arch/x86/kernel/apm.ko] undefined!
> > make[2]: *** [__modpost] Error 1
> 
> Ahh. device_power_[down|up] were EXPORT_SYMBOL_GPL, so now that we've 
> split them, so must sysdev_[suspend|resume] be.
> 
> Does this fix it?

I just hit the same issue in -tip testing and did the same fix:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/urgent

	Ingo

------------------>
Ingo Molnar (1):
      PM: Split up sysdev_[suspend|resume] from device_power_[down|up], fix


 drivers/base/sys.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index c98c31e..b428c8c 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -303,7 +303,6 @@ void sysdev_unregister(struct sys_device * sysdev)
  *	is guaranteed by virtue of the fact that child devices are registered
  *	after their parents.
  */
-
 void sysdev_shutdown(void)
 {
 	struct sysdev_class * cls;
@@ -363,7 +362,6 @@ static void __sysdev_resume(struct sys_device *dev)
  *	This is only called by the device PM core, so we let them handle
  *	all synchronization.
  */
-
 int sysdev_suspend(pm_message_t state)
 {
 	struct sysdev_class * cls;
@@ -432,7 +430,7 @@ aux_driver:
 	}
 	return ret;
 }
-
+EXPORT_SYMBOL_GPL(sysdev_suspend);
 
 /**
  *	sysdev_resume - Bring system devices back to life.
@@ -442,7 +440,6 @@ aux_driver:
  *
  *	Note: Interrupts are disabled when called.
  */
-
 int sysdev_resume(void)
 {
 	struct sysdev_class * cls;
@@ -463,7 +460,7 @@ int sysdev_resume(void)
 	}
 	return 0;
 }
-
+EXPORT_SYMBOL_GPL(sysdev_resume);
 
 int __init system_bus_init(void)
 {
