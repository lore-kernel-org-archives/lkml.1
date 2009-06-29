Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbZF2IK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbZF2IK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 04:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZF2IKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 04:10:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46571 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbZF2IKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 04:10:49 -0400
Date: Mon, 29 Jun 2009 10:10:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>, Corentin Chary <corentincj@iksaif.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Matthew Garrett <mjg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: [PATCH, v2] eeepc-laptop: Fix build failure with HOTPLUG_PCI &&
	!SYSFS (was: [git pull request] ACPI & driver patches for
	2.6.31-rc1)
Message-ID: <20090629081016.GA31398@elte.hu>
References: <alpine.LFD.2.00.0906260025380.20608@localhost.localdomain> <20090629080754.GA28336@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629080754.GA28336@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> The patch below fixes the build failure by turning the select 
> lines into a single 'depends on' line. [...]

i did the fix against the bisection point and the patch has a 
conflict against later mainline - below is a merged up patch.

	Ingo

------------------>
>From 85ee49b3ff6608e66122d17d370d0a7e5d008198 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 29 Jun 2009 10:07:54 +0200
Subject: [PATCH] eeepc-laptop: Fix build failure with HOTPLUG_PCI && !SYSFS (was: ACPI & driver patches for 2.6.31-rc1)

FYI, there's a post-rc1 build regression with certain configs:

 drivers/built-in.o: In function `pci_hp_deregister':
 (.text+0xb166): undefined reference to `pci_hp_remove_module_link'
 drivers/built-in.o: In function `pci_hp_deregister':
 (.text+0xb19f): undefined reference to `pci_destroy_slot'
 drivers/built-in.o: In function `__pci_hp_register':
 (.text+0xb583): undefined reference to `pci_create_slot'
 drivers/built-in.o: In function `__pci_hp_register':
 (.text+0xb5b1): undefined reference to `pci_hp_create_module_link'
 make: *** [.tmp_vmlinux1] Error 1

Caused by:

| 2b121bc262fa03c94e653b2d44356c2f86c1bcdc is first bad commit
| commit 2b121bc262fa03c94e653b2d44356c2f86c1bcdc
| Date:   Thu Jun 25 13:25:36 2009 +0200
|
|     eeepc-laptop: Register as a pci-hotplug device

The problem is caused by this portion of the commit:

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/platform/x86/Kconfig |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 4bc72d0..e120be8 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -356,10 +356,11 @@ config EEEPC_LAPTOP
 	depends on INPUT
 	depends on EXPERIMENTAL
 	depends on RFKILL || RFKILL = n
+	depends on HOTPLUG_PCI
 	select BACKLIGHT_CLASS_DEVICE
 	select HWMON
-	select HOTPLUG
-	select HOTPLUG_PCI if PCI
+       select HOTPLUG
+       select HOTPLUG_PCI if PCI
 	---help---
 	  This driver supports the Fn-Fx keys on Eee PC laptops.
 
