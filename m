Return-Path: <linux-kernel-owner+w=401wt.eu-S933579AbZIPWrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579AbZIPWrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760276AbZIPWqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:46:55 -0400
Received: from kroah.org ([198.145.64.141]:48919 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760316AbZIPWjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:39:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:14 2009
Message-Id: <20090916223714.807142378@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [patch 11/45] TPM: Fixup boot probe timeout for tpm_tis driver
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=tpm-fixup-boot-probe-timeout-for-tpm_tis-driver.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

commit ec57935837a78f9661125b08a5d08b697568e040 upstream.

When probing the device in tpm_tis_init the call request_locality
uses timeout_a, which wasn't being initalized until after
request_locality. This results in request_locality falsely timing
out if the chip is still starting. Move the initialization to before
request_locality.

This probably only matters for embedded cases (ie mine), a BIOS likely
gets the TPM into a state where this code path isn't necessary.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tpm/tpm_tis.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -450,6 +450,12 @@ static int tpm_tis_init(struct device *d
 		goto out_err;
 	}
 
+	/* Default timeouts */
+	chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+	chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
+	chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+	chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+
 	if (request_locality(chip, 0) != 0) {
 		rc = -ENODEV;
 		goto out_err;
@@ -457,12 +463,6 @@ static int tpm_tis_init(struct device *d
 
 	vendor = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
 
-	/* Default timeouts */
-	chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
-	chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
-	chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
-	chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
-
 	dev_info(dev,
 		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
 		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));


