Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbYHRSrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbYHRSrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755839AbYHRSrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:47:09 -0400
Received: from ns2.suse.de ([195.135.220.15]:34588 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbYHRSrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:47:08 -0400
Date: Mon, 18 Aug 2008 11:41:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ondrej Zajicek <santiago@crfreenet.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Antonino A. Daplas" <adaplas@pol.net>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: [patch 06/60] vt8623fb: fix kernel oops
Message-ID: <20080818184136.GG29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="vt8623fb-fix-kernel-oops.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ondrej Zajicek <santiago@crfreenet.org>

commit 594a8819774b09ee5bf72d23300489459ff1f882 upstream

commit 20e061fb750d36ec0ffcb2e44ed7dafa9018223b
  Author: Ondrej Zajicek <santiago@crfreenet.org>
  Date:   Mon Apr 28 02:15:18 2008 -0700

      fbdev: framebuffer_alloc() fixes

      Correct the dev arg of framebuffer_alloc() in arkfb, s3fb and vt8623fb.

causes a null-pointer deref because "info->dev is NULL, info was just
kzallocated".

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
Reported-by: "MadLoisae@gmx.net" <MadLoisae@gmx.net>
Tested-by: "MadLoisae@gmx.net" <MadLoisae@gmx.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/arkfb.c    |   18 +++++++++---------
 drivers/video/s3fb.c     |   18 +++++++++---------
 drivers/video/vt8623fb.c |   20 ++++++++++----------
 3 files changed, 28 insertions(+), 28 deletions(-)

--- a/drivers/video/arkfb.c
+++ b/drivers/video/arkfb.c
@@ -958,20 +958,20 @@ static int __devinit ark_pci_probe(struc
 	/* Prepare PCI device */
 	rc = pci_enable_device(dev);
 	if (rc < 0) {
-		dev_err(info->dev, "cannot enable PCI device\n");
+		dev_err(info->device, "cannot enable PCI device\n");
 		goto err_enable_device;
 	}
 
 	rc = pci_request_regions(dev, "arkfb");
 	if (rc < 0) {
-		dev_err(info->dev, "cannot reserve framebuffer region\n");
+		dev_err(info->device, "cannot reserve framebuffer region\n");
 		goto err_request_regions;
 	}
 
 	par->dac = ics5342_init(ark_dac_read_regs, ark_dac_write_regs, info);
 	if (! par->dac) {
 		rc = -ENOMEM;
-		dev_err(info->dev, "RAMDAC initialization failed\n");
+		dev_err(info->device, "RAMDAC initialization failed\n");
 		goto err_dac;
 	}
 
@@ -982,7 +982,7 @@ static int __devinit ark_pci_probe(struc
 	info->screen_base = pci_iomap(dev, 0, 0);
 	if (! info->screen_base) {
 		rc = -ENOMEM;
-		dev_err(info->dev, "iomap for framebuffer failed\n");
+		dev_err(info->device, "iomap for framebuffer failed\n");
 		goto err_iomap;
 	}
 
@@ -1004,19 +1004,19 @@ static int __devinit ark_pci_probe(struc
 	rc = fb_find_mode(&(info->var), info, mode_option, NULL, 0, NULL, 8);
 	if (! ((rc == 1) || (rc == 2))) {
 		rc = -EINVAL;
-		dev_err(info->dev, "mode %s not found\n", mode_option);
+		dev_err(info->device, "mode %s not found\n", mode_option);
 		goto err_find_mode;
 	}
 
 	rc = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (rc < 0) {
-		dev_err(info->dev, "cannot allocate colormap\n");
+		dev_err(info->device, "cannot allocate colormap\n");
 		goto err_alloc_cmap;
 	}
 
 	rc = register_framebuffer(info);
 	if (rc < 0) {
-		dev_err(info->dev, "cannot register framebugger\n");
+		dev_err(info->device, "cannot register framebugger\n");
 		goto err_reg_fb;
 	}
 
@@ -1090,7 +1090,7 @@ static int ark_pci_suspend (struct pci_d
 	struct fb_info *info = pci_get_drvdata(dev);
 	struct arkfb_info *par = info->par;
 
-	dev_info(info->dev, "suspend\n");
+	dev_info(info->device, "suspend\n");
 
 	acquire_console_sem();
 	mutex_lock(&(par->open_lock));
@@ -1121,7 +1121,7 @@ static int ark_pci_resume (struct pci_de
 	struct fb_info *info = pci_get_drvdata(dev);
 	struct arkfb_info *par = info->par;
 
-	dev_info(info->dev, "resume\n");
+	dev_info(info->device, "resume\n");
 
 	acquire_console_sem();
 	mutex_lock(&(par->open_lock));
--- a/drivers/video/s3fb.c
+++ b/drivers/video/s3fb.c
@@ -903,13 +903,13 @@ static int __devinit s3_pci_probe(struct
 	/* Prepare PCI device */
 	rc = pci_enable_device(dev);
 	if (rc < 0) {
-		dev_err(info->dev, "cannot enable PCI device\n");
+		dev_err(info->device, "cannot enable PCI device\n");
 		goto err_enable_device;
 	}
 
 	rc = pci_request_regions(dev, "s3fb");
 	if (rc < 0) {
-		dev_err(info->dev, "cannot reserve framebuffer region\n");
+		dev_err(info->device, "cannot reserve framebuffer region\n");
 		goto err_request_regions;
 	}
 
@@ -921,7 +921,7 @@ static int __devinit s3_pci_probe(struct
 	info->screen_base = pci_iomap(dev, 0, 0);
 	if (! info->screen_base) {
 		rc = -ENOMEM;
-		dev_err(info->dev, "iomap for framebuffer failed\n");
+		dev_err(info->device, "iomap for framebuffer failed\n");
 		goto err_iomap;
 	}
 
@@ -965,19 +965,19 @@ static int __devinit s3_pci_probe(struct
 	rc = fb_find_mode(&(info->var), info, mode_option, NULL, 0, NULL, 8);
 	if (! ((rc == 1) || (rc == 2))) {
 		rc = -EINVAL;
-		dev_err(info->dev, "mode %s not found\n", mode_option);
+		dev_err(info->device, "mode %s not found\n", mode_option);
 		goto err_find_mode;
 	}
 
 	rc = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (rc < 0) {
-		dev_err(info->dev, "cannot allocate colormap\n");
+		dev_err(info->device, "cannot allocate colormap\n");
 		goto err_alloc_cmap;
 	}
 
 	rc = register_framebuffer(info);
 	if (rc < 0) {
-		dev_err(info->dev, "cannot register framebuffer\n");
+		dev_err(info->device, "cannot register framebuffer\n");
 		goto err_reg_fb;
 	}
 
@@ -1053,7 +1053,7 @@ static int s3_pci_suspend(struct pci_dev
 	struct fb_info *info = pci_get_drvdata(dev);
 	struct s3fb_info *par = info->par;
 
-	dev_info(info->dev, "suspend\n");
+	dev_info(info->device, "suspend\n");
 
 	acquire_console_sem();
 	mutex_lock(&(par->open_lock));
@@ -1085,7 +1085,7 @@ static int s3_pci_resume(struct pci_dev*
 	struct s3fb_info *par = info->par;
 	int err;
 
-	dev_info(info->dev, "resume\n");
+	dev_info(info->device, "resume\n");
 
 	acquire_console_sem();
 	mutex_lock(&(par->open_lock));
@@ -1102,7 +1102,7 @@ static int s3_pci_resume(struct pci_dev*
 	if (err) {
 		mutex_unlock(&(par->open_lock));
 		release_console_sem();
-		dev_err(info->dev, "error %d enabling device for resume\n", err);
+		dev_err(info->device, "error %d enabling device for resume\n", err);
 		return err;
 	}
 	pci_set_master(dev);
--- a/drivers/video/vt8623fb.c
+++ b/drivers/video/vt8623fb.c
@@ -677,13 +677,13 @@ static int __devinit vt8623_pci_probe(st
 
 	rc = pci_enable_device(dev);
 	if (rc < 0) {
-		dev_err(info->dev, "cannot enable PCI device\n");
+		dev_err(info->device, "cannot enable PCI device\n");
 		goto err_enable_device;
 	}
 
 	rc = pci_request_regions(dev, "vt8623fb");
 	if (rc < 0) {
-		dev_err(info->dev, "cannot reserve framebuffer region\n");
+		dev_err(info->device, "cannot reserve framebuffer region\n");
 		goto err_request_regions;
 	}
 
@@ -696,14 +696,14 @@ static int __devinit vt8623_pci_probe(st
 	info->screen_base = pci_iomap(dev, 0, 0);
 	if (! info->screen_base) {
 		rc = -ENOMEM;
-		dev_err(info->dev, "iomap for framebuffer failed\n");
+		dev_err(info->device, "iomap for framebuffer failed\n");
 		goto err_iomap_1;
 	}
 
 	par->mmio_base = pci_iomap(dev, 1, 0);
 	if (! par->mmio_base) {
 		rc = -ENOMEM;
-		dev_err(info->dev, "iomap for MMIO failed\n");
+		dev_err(info->device, "iomap for MMIO failed\n");
 		goto err_iomap_2;
 	}
 
@@ -714,7 +714,7 @@ static int __devinit vt8623_pci_probe(st
 	if ((16 <= memsize1) && (memsize1 <= 64) && (memsize1 == memsize2))
 		info->screen_size = memsize1 << 20;
 	else {
-		dev_err(info->dev, "memory size detection failed (%x %x), suppose 16 MB\n", memsize1, memsize2);
+		dev_err(info->device, "memory size detection failed (%x %x), suppose 16 MB\n", memsize1, memsize2);
 		info->screen_size = 16 << 20;
 	}
 
@@ -731,19 +731,19 @@ static int __devinit vt8623_pci_probe(st
 	rc = fb_find_mode(&(info->var), info, mode_option, NULL, 0, NULL, 8);
 	if (! ((rc == 1) || (rc == 2))) {
 		rc = -EINVAL;
-		dev_err(info->dev, "mode %s not found\n", mode_option);
+		dev_err(info->device, "mode %s not found\n", mode_option);
 		goto err_find_mode;
 	}
 
 	rc = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (rc < 0) {
-		dev_err(info->dev, "cannot allocate colormap\n");
+		dev_err(info->device, "cannot allocate colormap\n");
 		goto err_alloc_cmap;
 	}
 
 	rc = register_framebuffer(info);
 	if (rc < 0) {
-		dev_err(info->dev, "cannot register framebugger\n");
+		dev_err(info->device, "cannot register framebugger\n");
 		goto err_reg_fb;
 	}
 
@@ -817,7 +817,7 @@ static int vt8623_pci_suspend(struct pci
 	struct fb_info *info = pci_get_drvdata(dev);
 	struct vt8623fb_info *par = info->par;
 
-	dev_info(info->dev, "suspend\n");
+	dev_info(info->device, "suspend\n");
 
 	acquire_console_sem();
 	mutex_lock(&(par->open_lock));
@@ -848,7 +848,7 @@ static int vt8623_pci_resume(struct pci_
 	struct fb_info *info = pci_get_drvdata(dev);
 	struct vt8623fb_info *par = info->par;
 
-	dev_info(info->dev, "resume\n");
+	dev_info(info->device, "resume\n");
 
 	acquire_console_sem();
 	mutex_lock(&(par->open_lock));

-- 
