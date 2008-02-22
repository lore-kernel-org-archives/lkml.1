Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbYBVVtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbYBVVtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933471AbYBVVni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:43:38 -0500
Received: from ns2.suse.de ([195.135.220.15]:60473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758364AbYBVVng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:43:36 -0500
Date: Fri, 22 Feb 2008 13:40:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mattia Dongili <malattia@linux.it>, Len Brown <len.brown@intel.com>,
       Jeff Mahoney <jeffm@suse.com>, Oliver Pinter <oliver.pntr@gmail.com>
Subject: [patch 12/23] sony-laptop: call sonypi_compat_init earlier
Message-ID: <20080222214035.GM8686@suse.de>
References: <20080222213114.583282464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sony-laptop-call-sonypi_compat_init-earlier.patch"
In-Reply-To: <20080222213927.GA8686@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Mattia Dongili <malattia@linux.it>

mainline: 015a916fbbf105bb15f4bbfd80c3b9b2f2e0d7db

sonypi_compat uses a kfifo that needs to be present before _SRS is
called to be able to cope with the IRQs triggered when setting
resources.

Signed-off-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Len Brown <len.brown@intel.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/sony-laptop.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/misc/sony-laptop.c
+++ b/drivers/misc/sony-laptop.c
@@ -2056,8 +2056,6 @@ static int sony_pic_remove(struct acpi_d
 	struct sony_pic_ioport *io, *tmp_io;
 	struct sony_pic_irq *irq, *tmp_irq;
 
-	sonypi_compat_exit();
-
 	if (sony_pic_disable(device)) {
 		printk(KERN_ERR DRV_PFX "Couldn't disable device.\n");
 		return -ENXIO;
@@ -2067,6 +2065,8 @@ static int sony_pic_remove(struct acpi_d
 	release_region(spic_dev.cur_ioport->io.minimum,
 			spic_dev.cur_ioport->io.address_length);
 
+	sonypi_compat_exit();
+
 	sony_laptop_remove_input();
 
 	/* pf attrs */
@@ -2132,6 +2132,9 @@ static int sony_pic_add(struct acpi_devi
 		goto err_free_resources;
 	}
 
+	if (sonypi_compat_init())
+		goto err_remove_input;
+
 	/* request io port */
 	list_for_each_entry(io, &spic_dev.ioports, list) {
 		if (request_region(io->io.minimum, io->io.address_length,
@@ -2146,7 +2149,7 @@ static int sony_pic_add(struct acpi_devi
 	if (!spic_dev.cur_ioport) {
 		printk(KERN_ERR DRV_PFX "Failed to request_region.\n");
 		result = -ENODEV;
-		goto err_remove_input;
+		goto err_remove_compat;
 	}
 
 	/* request IRQ */
@@ -2186,9 +2189,6 @@ static int sony_pic_add(struct acpi_devi
 	if (result)
 		goto err_remove_pf;
 
-	if (sonypi_compat_init())
-		goto err_remove_pf;
-
 	return 0;
 
 err_remove_pf:
@@ -2204,6 +2204,9 @@ err_release_region:
 	release_region(spic_dev.cur_ioport->io.minimum,
 			spic_dev.cur_ioport->io.address_length);
 
+err_remove_compat:
+	sonypi_compat_exit();
+
 err_remove_input:
 	sony_laptop_remove_input();
 

-- 
