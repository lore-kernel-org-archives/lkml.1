Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbXC3MEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbXC3MEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 08:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbXC3MEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 08:04:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51972 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbXC3MEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 08:04:41 -0400
Date: Fri, 30 Mar 2007 14:04:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [bug] hung bootup in various drivers, was: "2.6.21-rc5: known regressions"
Message-ID: <20070330120416.GA19373@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070327015929.GY16477@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070327015929.GY16477@stusta.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


i just found a new category of driver regressions in 2.6.21, doing 
allyesconfig bzImage bootup tests: the init methods of various drivers 
hangs in driver_unregister().

It is caused by this problem: the semantics of driver_unregister() [also 
implicitly called in pci_driver_unregister()] has apparently changed 
recently. If a driver does:

	pci_register_driver(&my_driver);
	...
	if (some_failure) {
		pci_unregister_driver(&my_driver);
		...
	}

it will hang the bootup in the following piece of code:

 drivers/base/driver.c:

  void driver_unregister(struct device_driver * drv)
  {
         bus_remove_driver(drv);
         wait_for_completion(&drv->unloaded);

the completion is never done - because nobody removes the bus while the 
init is still happening, obviously. (and bootup is serialized anyway)

now, the majority of drivers does the driver unregistry from its 
module-cleanup function, so it's not affected by this problem. But if 
you apply the debug patch attached further below, and do an allyesconfig 
bzImage bootup, there's 3 hits already:

 BUG: at drivers/base/driver.c:187 driver_unregister()
  [<c0105ff9>] show_trace_log_lvl+0x19/0x2e
  [<c01063e2>] show_trace+0x12/0x14
  [<c01063f8>] dump_stack+0x14/0x16
  [<c063f7e6>] driver_unregister+0x3d/0x43
  [<c0488048>] pci_unregister_driver+0x10/0x5f
  [<c1b5f7c7>] slgt_init+0x9b/0x1ca
  [<c1b31a2d>] init+0x15d/0x2bd
  [<c0105bc3>] kernel_thread_helper+0x7/0x10

 BUG: at drivers/base/driver.c:187 driver_unregister()
  [<c0105ff9>] show_trace_log_lvl+0x19/0x2e
  [<c01063e2>] show_trace+0x12/0x14
  [<c01063f8>] dump_stack+0x14/0x16
  [<c063f7e6>] driver_unregister+0x3d/0x43
  [<c0488048>] pci_unregister_driver+0x10/0x5f
  [<c0619505>] init_ipmi_si+0x70a/0x738
  [<c1b31a2d>] init+0x15d/0x2bd
  [<c0105bc3>] kernel_thread_helper+0x7/0x10

 BUG: at drivers/base/driver.c:187 driver_unregister()
  [<c0105ff9>] show_trace_log_lvl+0x19/0x2e
  [<c01063e2>] show_trace+0x12/0x14
  [<c01063f8>] dump_stack+0x14/0x16
  [<c063f7e6>] driver_unregister+0x3d/0x43
  [<c0488048>] pci_unregister_driver+0x10/0x5f
  [<c1b6d2d8>] tlan_probe+0x2dd/0x30e
  [<c1b31a2d>] init+0x15d/0x2bd
  [<c0105bc3>] kernel_thread_helper+0x7/0x10

possibly more could trigger. Each of these 3 places caused an actual 
bootup hang on my testbox, so these are real regressions and need to be 
fixed.

because there are a good number of drivers that do 
pci_unregister_device() from their init function, and because i cannot 
see anything obviously wrong in doing an unregister call after a 
failure, i think it's driver_unregister() that needs to be fixed. Greg, 
what do you think?

	Ingo

Index: linux/drivers/base/driver.c
===================================================================
--- linux.orig/drivers/base/driver.c
+++ linux/drivers/base/driver.c
@@ -183,7 +183,8 @@ int driver_register(struct device_driver
 void driver_unregister(struct device_driver * drv)
 {
 	bus_remove_driver(drv);
-	wait_for_completion(&drv->unloaded);
+	if (!drv->unloaded.done)
+		WARN_ON(1);
 }
 
 /**
