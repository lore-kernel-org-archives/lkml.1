Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935889Ab0CMAzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:55:53 -0500
Received: from kroah.org ([198.145.64.141]:46908 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935414Ab0CMAba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:30 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:10 2010
Message-Id: <20100313002709.946796447@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>
Subject: [054/145] tpm_tis: TPM_STS_DATA_EXPECT workaround
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

commit 3507d612366a4e81226295f646410130a1f62a5c upstream.

Some newer Lenovo models are shipped with a TPM that doesn't seem to set the TPM_STS_DATA_EXPECT status bit
when sending it a burst of data, so the code understands it as a failure and doesn't proceed sending the chip
the intended data. In this patch we bypass this bit check in case the itpm module parameter was set.

This patch is based on Andy Isaacson's one:

http://marc.info/?l=linux-kernel&m=124650185023495&w=2

It was heavily discussed how should we deal with identifying the chip in kernel space, but the required
patch to do so was NACK'd:

http://marc.info/?l=linux-kernel&m=124650186423711&w=2

This way we let the user choose using this workaround or not based on his
observations on this code behavior when trying to use the TPM.

Fixed a checkpatch issue present on the previous patch, thanks to Daniel Walker.

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Acked-by: Eric Paris <eparis@redhat.com>
Tested-by: Seiji Munetoh <seiji.munetoh@gmail.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tpm/tpm_tis.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -257,6 +257,10 @@ out:
 	return size;
 }
 
+static int itpm;
+module_param(itpm, bool, 0444);
+MODULE_PARM_DESC(itpm, "Force iTPM workarounds (found on some Lenovo laptops)");
+
 /*
  * If interrupts are used (signaled by an irq set in the vendor structure)
  * tpm.c can skip polling for the data to be available as the interrupt is
@@ -293,7 +297,7 @@ static int tpm_tis_send(struct tpm_chip
 		wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
 			      &chip->vendor.int_queue);
 		status = tpm_tis_status(chip);
-		if ((status & TPM_STS_DATA_EXPECT) == 0) {
+		if (!itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
 			rc = -EIO;
 			goto out_err;
 		}
@@ -467,6 +471,10 @@ static int tpm_tis_init(struct device *d
 		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
 		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
 
+	if (itpm)
+		dev_info(dev, "Intel iTPM workaround enabled\n");
+
+
 	/* Figure out the capabilities */
 	intfcaps =
 	    ioread32(chip->vendor.iobase +


