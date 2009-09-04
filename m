Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbZIDB2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbZIDB2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 21:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbZIDB2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 21:28:38 -0400
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:44667 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756074AbZIDB2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 21:28:37 -0400
Date: Thu, 3 Sep 2009 19:28:18 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       srajiv@linux.vnet.ibm.com, Debora Velarde <debora@linux.vnet.ibm.com>,
       Marcel Selhorst <m.selhorst@sirrix.com>,
       James Morris <jmorris@namei.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] TPM: Fixup pcrs sysfs file
Message-ID: <20090904012818.GU4973@obsidianresearch.com>
References: <20090902031613.GA11464@obsidianresearch.com> <20090903165219.2f79cdc1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903165219.2f79cdc1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 04:52:19PM -0700, Andrew Morton wrote:

> > diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> > index a6b52d6..8ba0187 100644
> > +++ b/drivers/char/tpm/tpm.c
> > @@ -696,8 +696,8 @@ int __tpm_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
> >  
> >  	cmd.header.in = pcrread_header;
> >  	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
> > -	BUILD_BUG_ON(cmd.header.in.length > READ_PCR_RESULT_SIZE);
> > -	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
> > +	BUILD_BUG_ON(sizeof(cmd) < READ_PCR_RESULT_SIZE);
> > +	rc = transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
> >  			  "attempting to read a pcr value");
> >  
> >  	if (rc == 0)
> 
> That sounds like a fairly serious bug, and this looks like a 2.6.31
> patch.

To be fair, I'm not sure the pcrs sysfile provides anything terribly
usefull.. None of the sysfs files in this driver seem to follow the
standard one-value-one-file convention either. But, if it is going to
be included it may as well work properly...

> Jan's build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch (in
> -mm) simply removes the bogus BUILD_BUG_ON(). I think we might as well
> do that within the context of your patch.

> So I end up with the below, which I propose for 2.6.31:

OK. That is fair. The tpm_cmd_params union contains a tpm_pcrread_out
which should 'by design' ensure there is enough space.

Jan's removal of the 2nd BUILD_BUG_ON is also good.

But I notice tpm_pcr_extend also has a mis-use of the transmit_cmd
idiom. This one functions ok because the in/out RPC message size
happen to be the same. But lets fix it too?

Thanks,
Jason

>From 25da64a0927088c766745763728c6bcd973d0f4e Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Date: Tue, 1 Sep 2009 21:08:55 -0600
Subject: [PATCH] TPM: Fixup pcrs sysfs file

I'm testing the tpm_tis low level driver with a winbond WPCT200:
$ cat caps
Manufacturer: 0x57454300
TCG version: 1.2
Firmware version: 2.16

and noted that tpm_pcr_read for the pcrs sysfile file does not function.
tpm_tis_recv returned with an error because the expected reply size was
set to 14 (the request size) and the chip returned 30 bytes.

The TCG spec says the reply size for READ_PCR is supposed to be 30 bytes.

The length input to transmit_cmd is the size of the reply, not of the
request.

With this change my chip reports all 23 pcrs.

Also fix tpm_pcr_extend to match the idiom of the rest of the code to
prevent future confusion.

Finally, the BUILD_BUG_ON() is just wrong - it's testing a value which
isn't a compile-time constant. Simply remove that assertion, the
buffer is large enough by design.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index a6b52d6..5d5b324 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -696,8 +696,7 @@ int __tpm_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
 
 	cmd.header.in = pcrread_header;
 	cmd.params.pcrread_in.pcr_idx = cpu_to_be32(pcr_idx);
-	BUILD_BUG_ON(cmd.header.in.length > READ_PCR_RESULT_SIZE);
-	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
+	rc = transmit_cmd(chip, &cmd, READ_PCR_RESULT_SIZE,
 			  "attempting to read a pcr value");
 
 	if (rc == 0)
@@ -742,7 +741,7 @@ EXPORT_SYMBOL_GPL(tpm_pcr_read);
  * the module usage count.
  */
 #define TPM_ORD_PCR_EXTEND cpu_to_be32(20)
-#define EXTEND_PCR_SIZE 34
+#define EXTEND_PCR_RESULT_SIZE 34
 static struct tpm_input_header pcrextend_header = {
 	.tag = TPM_TAG_RQU_COMMAND,
 	.length = cpu_to_be32(34),
@@ -760,10 +759,9 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 		return -ENODEV;
 
 	cmd.header.in = pcrextend_header;
-	BUILD_BUG_ON(be32_to_cpu(cmd.header.in.length) > EXTEND_PCR_SIZE);
 	cmd.params.pcrextend_in.pcr_idx = cpu_to_be32(pcr_idx);
 	memcpy(cmd.params.pcrextend_in.hash, hash, TPM_DIGEST_SIZE);
-	rc = transmit_cmd(chip, &cmd, cmd.header.in.length,
+	rc = transmit_cmd(chip, &cmd, EXTEND_PCR_RESULT_SIZE,
 			  "attempting extend a PCR value");
 
 	module_put(chip->dev->driver->owner);
-- 
1.5.4.2

