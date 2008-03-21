Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbYCUWqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbYCUWqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762323AbYCUWpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:45:50 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34675 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762059AbYCUWps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:45:48 -0400
Message-Id: <20080321224349.498906037@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:12 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Jeff Garzik <jgarzik@redhat.com>,
       Mark Salyzyn <mark_salyzyn@adaptec.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 22/76] SCSI ips: handle scsi_add_host() failure, and other err cleanups
Content-Disposition: inline; filename=scsi-ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jeff Garzik <jeff@garzik.org>

commit 2551a13e61d3c3df6c2da6de5a3ece78e6d67111

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Acked-by: Mark Salyzyn <mark_salyzyn@adaptec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

FUJITA Tomonori notes:
  It didn't intend to fix a critical bug, however, it turned out that it
  does. Without this patch, the ips driver in 2.6.23 and 2.6.24 doesn't
  work at all. You can find the more details at the following thread:

  http://marc.info/?t=120293911900023&r=1&w=2

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/ips.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -6842,13 +6842,10 @@ ips_register_scsi(int index)
 	if (request_irq(ha->irq, do_ipsintr, IRQF_SHARED, ips_name, ha)) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
 			   "Unable to install interrupt handler\n");
-		scsi_host_put(sh);
-		return -1;
+		goto err_out_sh;
 	}
 
 	kfree(oldha);
-	ips_sh[index] = sh;
-	ips_ha[index] = ha;
 
 	/* Store away needed values for later use */
 	sh->io_port = ha->io_addr;
@@ -6867,10 +6864,21 @@ ips_register_scsi(int index)
 	sh->max_channel = ha->nbus - 1;
 	sh->can_queue = ha->max_cmds - 1;
 
-	scsi_add_host(sh, NULL);
+	if (scsi_add_host(sh, &ha->pcidev->dev))
+		goto err_out;
+
+	ips_sh[index] = sh;
+	ips_ha[index] = ha;
+
 	scsi_scan_host(sh);
 
 	return 0;
+
+err_out:
+	free_irq(ha->pcidev->irq, ha);
+err_out_sh:
+	scsi_host_put(sh);
+	return -1;
 }
 
 /*---------------------------------------------------------------------------*/

-- 
