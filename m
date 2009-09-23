Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbZIWHY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbZIWHY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 03:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbZIWHY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 03:24:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35656 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbZIWHY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 03:24:56 -0400
Date: Wed, 23 Sep 2009 09:24:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: david@hardeman.nu, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-kernel@vger.kernel.org
Subject: [origin tree build failure] [PATCH] input: Fix build failures
	caused by Kconfig Winbond WPCD376I Consumer IR hardware driver
	Kconfig entry
Message-ID: <20090923072444.GA27150@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

( ob-sidenote: Andrew, i did not find the patch for commit 16af5bb on 
  lkml and it's now upstream. It would be highly useful if you Cc:-ed 
  lkml with submitted patches like all maintainers do, so that patterns 
  can be grepped for and discussions can be continued quickly instead of 
  created anew. It would also significantly increase the S/N ratio of 
  lkml. Thanks! )

>From 16af5bbc3be6cd9d0861b8ec381df3fe835977c3 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 23 Sep 2009 09:09:32 +0200
Subject: [PATCH] input: Fix build failures caused by Kconfig Winbond WPCD376I Consumer IR hardware driver Kconfig entry

-tip testing found this build failure:

  drivers/built-in.o: In function `apanel_remove':
  apanel.c:(.text+0x56e852): undefined reference to `led_classdev_unregister'
  drivers/built-in.o: In function `apanel_probe':
  apanel.c:(.text+0x56eae3): undefined reference to `led_classdev_register'
  drivers/built-in.o: In function `acpi_fujitsu_hotkey_add':
  fujitsu-laptop.c:(.text+0x5d7647): undefined reference to `led_classdev_register'
  fujitsu-laptop.c:(.text+0x5d76b5): undefined reference to `led_classdev_register'
  drivers/built-in.o: In function `wbcir_probe':
  winbond-cir.c:(.devinit.text+0x5f375): undefined reference to `led_classdev_register'
  winbond-cir.c:(.devinit.text+0x5f663): undefined reference to `led_classdev_unregister'
  drivers/built-in.o: In function `wbcir_remove':
  winbond-cir.c:(.devexit.text+0x7f23): undefined reference to `led_classdev_unregister'
  drivers/built-in.o: In function `fujitsu_cleanup':
  fujitsu-laptop.c:(.exit.text+0xbe37): undefined reference to `led_classdev_unregister'
  fujitsu-laptop.c:(.exit.text+0xbe53): undefined reference to `led_classdev_unregister'

It happens because the new INPUT_WINBOND_CIR driver relies
on new-leds infrastructure - but does not select it in
drivers/input/misc/Kconfig. But it selects LEDS_CLASS,
which confuses a number of other drivers into thinking
that all the leds infrastructure is in place.

Fix this by selecting NEW_LEDS as well, like similar drivers do.

Eventually, this whole leds infrastructure complexity should be
cleaned up, it's been going on for years.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/input/misc/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 76d6751..02f4f8f 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -225,6 +225,7 @@ config INPUT_SGI_BTNS
 config INPUT_WINBOND_CIR
 	tristate "Winbond IR remote control"
 	depends on X86 && PNP
+	select NEW_LEDS
 	select LEDS_CLASS
 	select BITREVERSE
 	help
