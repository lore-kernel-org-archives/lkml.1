Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab0BSRIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:08:04 -0500
Received: from kroah.org ([198.145.64.141]:57737 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966Ab0BSRBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:00 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:49 2010
Message-Id: <20100219163249.445415258@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Catalin Marinas <catalin.marinas@arm.com>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [68/93] [libata] Call flush_dcache_page after PIO data transfers in libata-sff.c
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 2d68b7fe55d9e19a8a868224ed0dfd6526568521 upstream.

flush_dcache_page() must be called after (!ATA_TFLAG_WRITE) the
data copying to avoid D-cache aliasing with user space or I-D cache
coherency issues (when reading data from an ATA device using PIO,
the kernel dirties the D-cache but there is no flush_dcache_page()
required on Harvard architectures).

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-sff.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -893,6 +893,9 @@ static void ata_pio_sector(struct ata_qu
 				       do_write);
 	}
 
+	if (!do_write)
+		flush_dcache_page(page);
+
 	qc->curbytes += qc->sect_size;
 	qc->cursg_ofs += qc->sect_size;
 


