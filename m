Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab0BRU2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 15:28:23 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:59466 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab0BRU2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 15:28:21 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/WJT8O4bG9irCCWtp389OI
Date: Thu, 18 Feb 2010 12:29:11 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] omap fix for 2.6.33-rc8
Message-ID: <20100218202911.GS21755@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull one more omap fix from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Regards,

Tony


The following changes since commit 724e6d3fe8003c3f60bf404bf22e4e331327c596:
  Linus Torvalds (1):
        Linux 2.6.33-rc8

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Ranjith Lohithakshan (1):
      omap: Remove DEBUG_FS dependency for mux name checking

 arch/arm/mach-omap2/mux.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)


From: Ranjith Lohithakshan <ranjithl@ti.com>
Date: Wed, 17 Feb 2010 17:17:01 +0000
Subject: [PATCH] omap: Remove DEBUG_FS dependency for mux name checking

The check for a valid mux name should be performed regardless of whether
DEBUG_FS is enabled or not. Otherwise without DEBUG_FS, we get:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 5 [#1]
last sysfs file:
Modules linked in:
CPU: 0    Not tainted  (2.6.33-rc8 #10)
PC is at strcmp+0x18/0x40
LR is at omap_mux_init_signal+0x68/0x14c
...

This fixes the issue currently seen with boards not booting up
if DEBUG_FS is not enabled in defconfig.

Note that the earlier ifndef + ifdef now becomes simpler ifdef else:
If CONFIG_OMAP_MUX is selected, we use pin names. If it's not selected,
we only want the GPIO to mux register mapping.

Signed-off-by: Ranjith Lohithakshan <ranjithl@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index 5fedc50..5fef73f 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -961,16 +961,14 @@ static void __init omap_mux_init_list(struct omap_mux *superset)
 	while (superset->reg_offset !=  OMAP_MUX_TERMINATOR) {
 		struct omap_mux *entry;
 
-#ifndef CONFIG_OMAP_MUX
-		/* Skip pins that are not muxed as GPIO by bootloader */
-		if (!OMAP_MODE_GPIO(omap_mux_read(superset->reg_offset))) {
+#ifdef CONFIG_OMAP_MUX
+		if (!superset->muxnames || !superset->muxnames[0]) {
 			superset++;
 			continue;
 		}
-#endif
-
-#if defined(CONFIG_OMAP_MUX) && defined(CONFIG_DEBUG_FS)
-		if (!superset->muxnames || !superset->muxnames[0]) {
+#else
+		/* Skip pins that are not muxed as GPIO by bootloader */
+		if (!OMAP_MODE_GPIO(omap_mux_read(superset->reg_offset))) {
 			superset++;
 			continue;
 		}
The following changes since commit 724e6d3fe8003c3f60bf404bf22e4e331327c596:
  Linus Torvalds (1):
        Linux 2.6.33-rc8

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Ranjith Lohithakshan (1):
      omap: Remove DEBUG_FS dependency for mux name checking

 arch/arm/mach-omap2/mux.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)


From: Ranjith Lohithakshan <ranjithl@ti.com>
Date: Wed, 17 Feb 2010 17:17:01 +0000
Subject: [PATCH] omap: Remove DEBUG_FS dependency for mux name checking

The check for a valid mux name should be performed regardless of whether
DEBUG_FS is enabled or not. Otherwise without DEBUG_FS, we get:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 5 [#1]
last sysfs file:
Modules linked in:
CPU: 0    Not tainted  (2.6.33-rc8 #10)
PC is at strcmp+0x18/0x40
LR is at omap_mux_init_signal+0x68/0x14c
...

This fixes the issue currently seen with boards not booting up
if DEBUG_FS is not enabled in defconfig.

Note that the earlier ifndef + ifdef now becomes simpler ifdef else:
If CONFIG_OMAP_MUX is selected, we use pin names. If it's not selected,
we only want the GPIO to mux register mapping.

Signed-off-by: Ranjith Lohithakshan <ranjithl@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index 5fedc50..5fef73f 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -961,16 +961,14 @@ static void __init omap_mux_init_list(struct omap_mux *superset)
 	while (superset->reg_offset !=  OMAP_MUX_TERMINATOR) {
 		struct omap_mux *entry;
 
-#ifndef CONFIG_OMAP_MUX
-		/* Skip pins that are not muxed as GPIO by bootloader */
-		if (!OMAP_MODE_GPIO(omap_mux_read(superset->reg_offset))) {
+#ifdef CONFIG_OMAP_MUX
+		if (!superset->muxnames || !superset->muxnames[0]) {
 			superset++;
 			continue;
 		}
-#endif
-
-#if defined(CONFIG_OMAP_MUX) && defined(CONFIG_DEBUG_FS)
-		if (!superset->muxnames || !superset->muxnames[0]) {
+#else
+		/* Skip pins that are not muxed as GPIO by bootloader */
+		if (!OMAP_MODE_GPIO(omap_mux_read(superset->reg_offset))) {
 			superset++;
 			continue;
 		}
