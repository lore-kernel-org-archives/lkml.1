Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbZIBD42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbZIBD42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 23:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbZIBD41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 23:56:27 -0400
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:50881 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752750AbZIBD41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 23:56:27 -0400
X-Greylist: delayed 2412 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Sep 2009 23:56:27 EDT
Date: Tue, 1 Sep 2009 21:16:13 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, srajiv@linux.vnet.ibm.com
Subject: [PATCH] TPM: Fixup pcrs sysfs file
Message-ID: <20090902031613.GA11464@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm testing the tpm_tis low level driver with a winbond WPCT200:
$ cat caps
Manufacturer: 0x57454300
TCG version: 1.2
Firmware version: 2.16

and noted that tpm_pcr_read for the pcrs sysfile file does not function.
tpm_tis_recv returned with an error because the expected reply size was
set to 14 (the request size) and the chip returned 30 bytes.

The TCG spec says the reply size is supposed to be 30 bytes.

First, the BUILD_BUG_ON was surely never correct, testing a run time
value in big endian with that macro is just wrong. I belive the intended
test was to ensure that the cmd buffer has enough space to store the
reply.

Second, the length input to transmit_cmd is the size of the reply, not
of the request. It should be 30 for READ_PCR.

With this change my chip reports all 23 pcrs.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index a6b52d6..8ba0187 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -696,8 +696,8 @@ int __tpm_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 
 	cmd.header.in = pcrread_header;
 	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
-	BUILD_BUG_ON(cmd.header.in.length > READ_PCR_RESULT_SIZE);
-	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
+	BUILD_BUG_ON(sizeof(cmd) < READ_PCR_RESULT_SIZE);
+	rc = transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
 			  "attempting to read a pcr value");
 
 	if (rc == 0)
-- 
1.5.4.2

