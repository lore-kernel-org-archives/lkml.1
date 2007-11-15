Return-Path: <linux-kernel-owner+w=401wt.eu-S932869AbXKOGvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbXKOGvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932477AbXKOGqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:46:34 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57795 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765938AbXKOGqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:46:33 -0500
Date: Wed, 14 Nov 2007 22:43:55 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [patch 01/40] POWERPC: Fix platinumfb framebuffer
Message-ID: <20071115064355.GB19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-fix-platinumfb-framebuffer.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Patch 4c2a54b09ba35a409afc34bd331a57a994921664 in mailine.

Current kernels have a non-working platinumfb due to some resource
management issues.  This fixes it.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/platinumfb.c |   48 ++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

--- a/drivers/video/platinumfb.c
+++ b/drivers/video/platinumfb.c
@@ -17,6 +17,8 @@
  *  more details.
  */
 
+#undef DEBUG
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -535,33 +537,35 @@ static int __devinit platinumfb_probe(st
 	volatile __u8		*fbuffer;
 	int			bank0, bank1, bank2, bank3, rc;
 
-	printk(KERN_INFO "platinumfb: Found Apple Platinum video hardware\n");
+	dev_info(&odev->dev, "Found Apple Platinum video hardware\n");
 
 	info = framebuffer_alloc(sizeof(*pinfo), &odev->dev);
-	if (info == NULL)
+	if (info == NULL) {
+		dev_err(&odev->dev, "Failed to allocate fbdev !\n");
 		return -ENOMEM;
+	}
 	pinfo = info->par;
 
 	if (of_address_to_resource(dp, 0, &pinfo->rsrc_reg) ||
 	    of_address_to_resource(dp, 1, &pinfo->rsrc_fb)) {
-		printk(KERN_ERR "platinumfb: Can't get resources\n");
-		framebuffer_release(info);
-		return -ENXIO;
-	}
-	if (!request_mem_region(pinfo->rsrc_reg.start,
-				pinfo->rsrc_reg.start -
-				pinfo->rsrc_reg.end + 1,
-				"platinumfb registers")) {
+		dev_err(&odev->dev, "Can't get resources\n");
 		framebuffer_release(info);
 		return -ENXIO;
 	}
+	dev_dbg(&odev->dev, " registers  : 0x%llx...0x%llx\n",
+		(unsigned long long)pinfo->rsrc_reg.start,
+		(unsigned long long)pinfo->rsrc_reg.end);
+	dev_dbg(&odev->dev, " framebuffer: 0x%llx...0x%llx\n",
+		(unsigned long long)pinfo->rsrc_fb.start,
+		(unsigned long long)pinfo->rsrc_fb.end);
+
+	/* Do not try to request register space, they overlap with the
+	 * northbridge and that can fail. Only request framebuffer
+	 */
 	if (!request_mem_region(pinfo->rsrc_fb.start,
-				pinfo->rsrc_fb.start
-				- pinfo->rsrc_fb.end + 1,
+				pinfo->rsrc_fb.end - pinfo->rsrc_fb.start + 1,
 				"platinumfb framebuffer")) {
-		release_mem_region(pinfo->rsrc_reg.start,
-				   pinfo->rsrc_reg.end -
-				   pinfo->rsrc_reg.start + 1);
+		printk(KERN_ERR "platinumfb: Can't request framebuffer !\n");
 		framebuffer_release(info);
 		return -ENXIO;
 	}
@@ -600,7 +604,8 @@ static int __devinit platinumfb_probe(st
 	bank2 = fbuffer[0x200000] == 0x56;
 	bank3 = fbuffer[0x300000] == 0x78;
 	pinfo->total_vram = (bank0 + bank1 + bank2 + bank3) * 0x100000;
-	printk(KERN_INFO "platinumfb: Total VRAM = %dMB (%d%d%d%d)\n", (int) (pinfo->total_vram / 1024 / 1024),
+	printk(KERN_INFO "platinumfb: Total VRAM = %dMB (%d%d%d%d)\n",
+	       (unsigned int) (pinfo->total_vram / 1024 / 1024),
 	       bank3, bank2, bank1, bank0);
 
 	/*
@@ -644,16 +649,15 @@ static int __devexit platinumfb_remove(s
         unregister_framebuffer (info);
 	
 	/* Unmap frame buffer and registers */
+	iounmap(pinfo->frame_buffer);
+	iounmap(pinfo->platinum_regs);
+	iounmap(pinfo->cmap_regs);
+
 	release_mem_region(pinfo->rsrc_fb.start,
 			   pinfo->rsrc_fb.end -
 			   pinfo->rsrc_fb.start + 1);
-	release_mem_region(pinfo->rsrc_reg.start,
-			   pinfo->rsrc_reg.end -
-			   pinfo->rsrc_reg.start + 1);
-	iounmap(pinfo->frame_buffer);
-	iounmap(pinfo->platinum_regs);
+
 	release_mem_region(pinfo->cmap_regs_phys, 0x1000);
-	iounmap(pinfo->cmap_regs);
 
 	framebuffer_release(info);
 

-- 
