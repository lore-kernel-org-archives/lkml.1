Return-Path: <linux-kernel-owner+w=401wt.eu-S1753496AbYEDFlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbYEDFlA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 01:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbYEDFkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 01:40:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:2069 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbYEDFkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 01:40:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=p5q1bFXbO2Tw7AekCDckR4ma1S/nHwOaMWD2+8CJbPK2XIJdmJ/bml70Z1fMy+duKERBsiVCEc1PoMqyiMizN80NLtyF4JznvbyGyvlWv/R9abtVl3LnWB09ANmqx0+8K5YJETbciIP0bqK5hvN7YWktX8MnVi1HHoISTyXkIik=
Date: Sun, 4 May 2008 07:40:44 +0200
To: Ingo Molnar <mingo@elte.hu>, Roman Zippel <zippel@linux-m68k.org>,
       Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kconfig: warn about complex selects
Message-ID: <20080504054044.GA32030@damson>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Given recent discussion about kconfig and the "select" feature, I have made
the following quick & dirty patch to detect what I call "complex selects".

For v2.6.25, I get these warnings:
sound/pci/Kconfig:512:error: found complex select: SND_FM801_TEA575X -> VIDEO_V4L1
drivers/ide/Kconfig:890:error: found complex select: ETRAX_IDE -> BLK_DEV_IDEDMA
drivers/acpi/Kconfig:185:error: found complex select: ACPI_HOTPLUG_CPU -> ACPI_CONTAINER

While for v2.6.26-rc1, I get these:
sound/pci/Kconfig:528:error: found complex select: SND_FM801_TEA575X -> VIDEO_V4L1
drivers/media/video/em28xx/Kconfig:2:error: found complex select: VIDEO_EM28XX -> MEDIA_TUNER
drivers/media/video/bt8xx/Kconfig:2:error: found complex select: VIDEO_BT848 -> MEDIA_TUNER
drivers/media/video/saa7134/Kconfig:2:error: found complex select: VIDEO_SAA7134 -> MEDIA_TUNER
drivers/media/video/cx88/Kconfig:2:error: found complex select: VIDEO_CX88 -> MEDIA_TUNER
drivers/media/video/cx23885/Kconfig:2:error: found complex select: VIDEO_CX23885 -> MEDIA_TUNER
drivers/media/video/ivtv/Kconfig:2:error: found complex select: VIDEO_IVTV -> MEDIA_TUNER
drivers/media/video/cx18/Kconfig:2:error: found complex select: VIDEO_CX18 -> MEDIA_TUNER
drivers/media/video/pvrusb2/Kconfig:2:error: found complex select: VIDEO_PVRUSB2 -> MEDIA_TUNER
drivers/media/video/Kconfig:690:error: found complex select: VIDEO_MXB -> MEDIA_TUNER
drivers/media/video/usbvision/Kconfig:2:error: found complex select: VIDEO_USBVISION -> MEDIA_TUNER
drivers/acpi/Kconfig:188:error: found complex select: ACPI_HOTPLUG_CPU -> ACPI_CONTAINER

(In other words, the number of these has increased significantly since the
last release, and these will probably be hit as compile errors at one point
or another.)

I am not a kconfig expert, so I might have missed some things. Roman, is this
even remotely good? I think it's probably a good start anyway.

One other idea that might be feasible in terms of both correctness and
usability: If a symbol foo does "select bar", maybe foo should simply inherit
bar's dependencies? This allows foo to be visible in most cases (when the
dependencies of foo and bar are both satisified), but won't brute-force-enable
any symbols.

Either way, here's my contribution to the discussion.


Vegard


>From 67bd6b970fcca8ba5078ba376131e3669dadfd7b Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sun, 4 May 2008 07:24:04 +0200
Subject: [PATCH] kconfig: warn about complex selects

"Complex selects" are selects that depend on symbols with dependencies. These
are effectively circumventing the rest of the dependency chains of kconfig,
often leading to build errors.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 scripts/kconfig/symbol.c |   31 ++++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 18f3e5c..e5c3c60 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -790,6 +790,24 @@ static struct symbol *sym_check_expr_deps(struct expr *e)
 	return NULL;
 }
 
+bool sym_check_select(struct symbol *sym)
+{
+	struct property *prop;
+
+	for (prop = sym->prop; prop; prop = prop->next) {
+		struct expr *expr = prop->expr;
+
+		if (!expr)
+			continue;
+		if (expr->type == E_SYMBOL)
+			continue;
+
+		return true;
+	}
+
+	return false;
+}
+
 /* return NULL when dependencies are OK */
 static struct symbol *sym_check_sym_deps(struct symbol *sym)
 {
@@ -801,7 +819,18 @@ static struct symbol *sym_check_sym_deps(struct symbol *sym)
 		return sym2;
 
 	for (prop = sym->prop; prop; prop = prop->next) {
-		if (prop->type == P_CHOICE || prop->type == P_SELECT)
+		if (prop->type == P_SELECT) {
+			if (!sym_check_select(prop->expr->left.sym))
+				continue;
+
+			fprintf(stderr, "%s:%d:error: found complex select: "
+				"%s -> %s\n",
+				sym->prop->file->name, sym->prop->lineno,
+				sym->name, prop->expr->left.sym->name);
+			continue;
+		}
+
+		if (prop->type == P_CHOICE)
 			continue;
 		sym2 = sym_check_expr_deps(prop->visible.expr);
 		if (sym2)
-- 
1.5.4.1

