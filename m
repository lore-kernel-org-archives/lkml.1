Return-Path: <linux-kernel-owner+w=401wt.eu-S1761403AbXIKXKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761403AbXIKXKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 19:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbXIKXKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 19:10:22 -0400
Received: from 50-178.0-85.cust.bluewin.ch ([85.0.178.50]:46610 "EHLO
	spock.one.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754212AbXIKXKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 19:10:20 -0400
Date: Wed, 12 Sep 2007 01:09:59 +0200
From: Michal Januszewski <spock@gentoo.org>
To: Paul Mundt <lethal@linux-sh.org>, Paulo Marques <pmarques@grupopie.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] uvesafb: Don't access VGA registers directly when
	running on non-x86
Message-ID: <20070911230959.GA16406@spock.one.pl>
Reply-To: spock@gentoo.org
References: <20070911081752.GA19495@linux-sh.org> <46E67EFD.2040902@grupopie.com> <20070911115346.GA23493@linux-sh.org> <46E687ED.9000802@grupopie.com> <20070911123159.GA23692@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20070911123159.GA23692@linux-sh.org>
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The VGA registers are only available at their legacy IO locations on x86.
Don't try to access them when running on other arches.

Note that the code accessing them directly is just an optimization (limits
slow BIOS function calls).  We don't lose any functionality by using
BIOS calls instead of it on non-x86.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
index 853323e..74fa7c7 100644
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -935,6 +935,7 @@ static int uvesafb_setpalette(struct uvesafb_pal_entry *entries, int count,
 	if (start + count > 256)
 		return -EINVAL;
 
+#ifdef CONFIG_X86
 	/* Use VGA registers if mode is VGA-compatible. */
 	if (i >= 0 && i < par->vbe_modes_cnt &&
 	    par->vbe_modes[i].mode_attr & VBE_MODE_VGACOMPAT) {
@@ -957,8 +958,10 @@ static int uvesafb_setpalette(struct uvesafb_pal_entry *entries, int count,
 		  "D" (entries),        /* EDI */
 		  "S" (&par->pmi_pal)); /* ESI */
 	}
-#endif
-	else {
+#endif /* CONFIG_X86_32 */
+	else
+#endif /* CONFIG_X86 */
+	{
 		task = uvesafb_prep();
 		if (!task)
 			return -ENOMEM;
@@ -1102,6 +1105,7 @@ static int uvesafb_blank(int blank, struct fb_info *info)
 	struct uvesafb_ktask *task;
 	int err = 1;
 
+#ifdef CONFIG_X86
 	if (par->vbe_ib.capabilities & VBE_CAP_VGACOMPAT) {
 		int loop = 10000;
 		u8 seq = 0, crtc17 = 0;
@@ -1124,7 +1128,9 @@ static int uvesafb_blank(int blank, struct fb_info *info)
 		while (loop--);
 		vga_wcrt(NULL, 0x17, crtc17);
 		vga_wseq(NULL, 0x00, 0x03);
-	} else {
+	} else
+#endif /* CONFIG_X86 */
+	{
 		task = uvesafb_prep();
 		if (!task)
 			return -ENOMEM;

