Return-Path: <linux-kernel-owner+w=401wt.eu-S1762919AbZFNTUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762919AbZFNTUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 15:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757770AbZFNTUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 15:20:38 -0400
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:34602 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbZFNTUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 15:20:37 -0400
Subject: Re: [tpmdd-devel] TPM drivers support and Linux Integrity Module
 for 2.6.30
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: dds =?UTF-8?Q?=28=E2=98=95=29?= <dds@google.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com
In-Reply-To: <b8394ab90906140015h793aaf51rb9b105910e61fa1@mail.gmail.com>
References: <20cbb9450906112259m176153c9ucfa7a4d14642949f@mail.gmail.com>
	 <1244817141.3401.7.camel@dyn9002018117.watson.ibm.com>
	 <4A3474BD.4000804@linux.vnet.ibm.com>
	 <b8394ab90906140015h793aaf51rb9b105910e61fa1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Jun 2009 16:20:38 -0300
Message-Id: <1245007238.10712.5.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sun, 2009-06-14 at 16:15 +0900, dds (☕) wrote:
> Hello, I'd been meaning to write about this.
> 
> 
> On Sun, Jun 14, 2009 at 12:55 PM, Rajiv Andrade
> <srajiv@linux.vnet.ibm.com> wrote:
>         Hi Mimi, thanks for copying us.
>         
>         Shaz,
>         
>         If this is the same chip we find in the GM45 boards, iTPM, the
>         upstream
>         driver won't work properly with it.
>         Mainly because this iTPM returns the wrong status code when
>         the driver
>         didn't finish sending all bytes required for a specific
>         command.
>         As suggested by Seiji Munetoh in the tpmdd-devel sf mailing
>         list, you
>         can modify line 263 of tpm_tis.c as below:
>         
>         -               if ((status & TPM_STS_DATA_EXPECT) == 0) {
>         +               if ((status & TPM_STS_VALID) == 0) {
>         
> 
> This isn't unreasonable. In the block that should be executing there,
> it's proper to check both, since VALID is an override for DATA_EXPECT.
> See first patch.
>  
> 
Actually, according to the TIS spec, VALID bit just ensures that the
DATA_EXPECT bit value is correct, and isn't an override for that bit (if
I got your point right).Basically you can only trust on DATA_EXPECT bit
value if VALID bit is 1. What happens with the iTPM is that it says the
DATA_EXPECT is valid but doesn't set its value to 1 when it should. What
Seiji suggested was a bypass, since wait_for_stat() right above only
returns (successfully) when the VALID bit to be set to 1. 'status &
TPM_STS_VALID == 0' will always be false there. On the other hand we can
check if it's an iTPM, and in case it's true, bypass that if statement.
This is in the patch below.

Unfortunately I don't have such TPM in hands to get its manufacturer_id
and finish the fix, can you help us here?

Copying Seiji for his awareness and since he has a board with such TPM.
> 

>         
>         Then, after compiling it, since it also seems to not support
>         PNP, load
>         it with force option on:
>         
>         modprobe tpm_tis force=1
> 
> The problem here is acpi pnp but the fix is really simple. The current
> pnpacpi/core.c routine that looks for isapnp devices enumerated in
> acpi enforces that the acpi hid be a valid isapnp id (the formats are
> slightly different). But that's broken: it shoudl be enforcing that
> either the acpi hid or any acpi cids be valid isapnp ids. It's a
> one-line change to do this, see patch 2. 
> 
>  

That's great, thanks
>         
>         If modprobe fails the first time, try the second and then it
>         will work.
> 
> This is fixed by changing the order in the code of setting default
> timeouts and requesting locality. See patch 3.

Great too
>         
Thanks,
Rajiv


>From 9516dd1867326ee52ebbad9eb8be15f4ed35f98e Mon Sep 17 00:00:00 2001
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Date: Sun, 14 Jun 2009 15:37:07 -0300
Subject: [PATCH] TPM: iTPM doesn't set DATA_EXPECT bit

Since this chip doesn't set it, this bit check is bypassed in case
manufacturer_id indicates that's chip we are handling with. In order
to grab manufacturer_id value, tpm_getcap() was exported from tpm.c
code.

ITPM value isn't set since I don't have the chip available to get its
manufacturer_id value..

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm.c     |   18 +-----------------
 drivers/char/tpm/tpm.h     |   20 +++++++++++++++++++-
 drivers/char/tpm/tpm_tis.c |   12 ++++++++++--
 3 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index ccdd828..067d6a2 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -430,23 +430,6 @@ out:
 #define TPM_ERROR_SIZE 10
 #define TPM_RET_CODE_IDX 6
 
-enum tpm_capabilities {
-	TPM_CAP_FLAG = cpu_to_be32(4),
-	TPM_CAP_PROP = cpu_to_be32(5),
-	CAP_VERSION_1_1 = cpu_to_be32(0x06),
-	CAP_VERSION_1_2 = cpu_to_be32(0x1A)
-};
-
-enum tpm_sub_capabilities {
-	TPM_CAP_PROP_PCR = cpu_to_be32(0x101),
-	TPM_CAP_PROP_MANUFACTURER = cpu_to_be32(0x103),
-	TPM_CAP_FLAG_PERM = cpu_to_be32(0x108),
-	TPM_CAP_FLAG_VOL = cpu_to_be32(0x109),
-	TPM_CAP_PROP_OWNER = cpu_to_be32(0x111),
-	TPM_CAP_PROP_TIS_TIMEOUT = cpu_to_be32(0x115),
-	TPM_CAP_PROP_TIS_DURATION = cpu_to_be32(0x120),
-
-};
 
 static ssize_t transmit_cmd(struct tpm_chip *chip, struct tpm_cmd_t *cmd,
 			    int len, const char *desc)
@@ -501,6 +484,7 @@ ssize_t tpm_getcap(struct device *dev, __be32 subcap_id, cap_t *cap,
 		*cap = tpm_cmd.params.getcap_out.cap;
 	return rc;
 }
+EXPORT_SYMBOL_GPL(tpm_getcap);
 
 void tpm_gen_interrupt(struct tpm_chip *chip)
 {
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 8e00b4d..9f609e0 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -38,6 +38,23 @@ enum tpm_addr {
 	TPM_ADDR = 0x4E,
 };
 
+enum tpm_capabilities {
+	TPM_CAP_FLAG = cpu_to_be32(4),
+	TPM_CAP_PROP = cpu_to_be32(5),
+	CAP_VERSION_1_1 = cpu_to_be32(0x06),
+	CAP_VERSION_1_2 = cpu_to_be32(0x1A)
+};
+
+enum tpm_sub_capabilities {
+	TPM_CAP_PROP_PCR = cpu_to_be32(0x101),
+	TPM_CAP_PROP_MANUFACTURER = cpu_to_be32(0x103),
+	TPM_CAP_FLAG_PERM = cpu_to_be32(0x108),
+	TPM_CAP_FLAG_VOL = cpu_to_be32(0x109),
+	TPM_CAP_PROP_OWNER = cpu_to_be32(0x111),
+	TPM_CAP_PROP_TIS_TIMEOUT = cpu_to_be32(0x115),
+	TPM_CAP_PROP_TIS_DURATION = cpu_to_be32(0x120),
+
+};
 extern ssize_t tpm_show_pubek(struct device *, struct device_attribute *attr,
 				char *);
 extern ssize_t tpm_show_pcrs(struct device *, struct device_attribute *attr,
@@ -109,6 +126,7 @@ struct tpm_chip {
 
 	struct list_head list;
 	void (*release) (struct device *);
+	int manufacturer_id;
 };
 
 #define to_tpm_chip(n) container_of(n, struct tpm_chip, vendor)
@@ -264,7 +282,7 @@ struct tpm_cmd_t {
 	tpm_cmd_params	params;
 }__attribute__((packed));
 
-ssize_t	tpm_getcap(struct device *, __be32, cap_t *, const char *);
+extern ssize_t tpm_getcap(struct device *, __be32, cap_t *, const char *);
 
 extern void tpm_get_timeouts(struct tpm_chip *);
 extern void tpm_gen_interrupt(struct tpm_chip *);
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index aec1931..6c45f8f 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -27,6 +27,7 @@
 #include "tpm.h"
 
 #define TPM_HEADER_SIZE 10
+#define ITPM_ID 0
 
 enum tis_access {
 	TPM_ACCESS_VALID = 0x80,
@@ -293,7 +294,9 @@ static int tpm_tis_send(struct tpm_chip *chip, u8 *buf, size_t len)
 		wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c,
 			      &chip->vendor.int_queue);
 		status = tpm_tis_status(chip);
-		if ((status & TPM_STS_DATA_EXPECT) == 0) {
+		/* iTPM never sets the DATA_EXPECT bit */
+		if (((status & TPM_STS_DATA_EXPECT) == 0) &&
+		     (chip->manufacturer_id != ITPM_ID)) {
 			rc = -EIO;
 			goto out_err;
 		}
@@ -440,6 +443,7 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	u32 vendor, intfcaps, intmask;
 	int rc, i;
 	struct tpm_chip *chip;
+	cap_t cap;
 
 	if (!(chip = tpm_register_hardware(dev, &tpm_tis)))
 		return -ENODEV;
@@ -581,7 +585,11 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 
 	tpm_get_timeouts(chip);
 	tpm_continue_selftest(chip);
-
+	rc = tpm_getcap(chip->dev, TPM_CAP_PROP_MANUFACTURER, &cap,
+			"attempting to determine if it's an Intel iTPM");
+	
+	chip->manufacturer_id = (rc ? 0 : be32_to_cpu(cap.manufacturer_id));
+	
 	return 0;
 out_err:
 	if (chip->vendor.iobase)
-- 
1.6.1.2

