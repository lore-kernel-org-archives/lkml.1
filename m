Return-Path: <linux-kernel-owner+w=401wt.eu-S1763987AbXHHKMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763987AbXHHKMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760525AbXHHKLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:11:54 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:60048 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760296AbXHHKLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:11:53 -0400
Date: Wed, 8 Aug 2007 12:11:47 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
To: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: "??" <wux@landicorp.com>, Linux Kernel list <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] mmc: at91_mci: add multiwrite cap
Message-ID: <20070808121147.1433d055@poseidon.drzeus.cx>
In-Reply-To: <46B9926B.3090707@rfo.atmel.com>
References: <46B9926B.3090707@rfo.atmel.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-21754-1186567909-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-21754-1186567909-0001-2
Content-Type: multipart/mixed; boundary="MP_ee=1AVMpIpUqdn15H1mL+t9"

--MP_ee=1AVMpIpUqdn15H1mL+t9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wed, 08 Aug 2007 11:52:43 +0200
Nicolas Ferre <nicolas.ferre@rfo.atmel.com> wrote:

> From: Wu Xuan <wux@landicorp.com>
>=20
> Add multiwrite support capability.
>=20
> Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
> ---

Just like that? :)

If I could just bother you with testing the included patch first. Just
load the module and insert a card. WARNING! It will eat your data, so
do it on a test card. And remember to remove it once you're done.

Rgds
Pierre

--MP_ee=1AVMpIpUqdn15H1mL+t9
Content-Type: text/x-patch; name=mmc-test.patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=mmc-test.patch

commit e966ae990cd2ef3be48ece8cde0f97f04a0d6024
Author: Pierre Ossman <drzeus@drzeus.cx>
Date:   Tue Aug 7 14:27:17 2007 +0200

    mmc: mmc host test driver
   =20
    A dummy driver that performs a series of requests that are often mis-
    handled by host drivers.
   =20
    Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>

diff --git a/drivers/mmc/card/Kconfig b/drivers/mmc/card/Kconfig
index aa8a4e4..28db50d 100644
--- a/drivers/mmc/card/Kconfig
+++ b/drivers/mmc/card/Kconfig
@@ -32,6 +32,12 @@ config MMC_BLOCK_BOUNCE
=20
 	  If unsure, say Y here.
=20
+config MMC_TEST
+	tristate "MMC host test driver"
+	default n
+	help
+	  Dummy driver that tests that a host performs as it should.
+
 config SDIO_UART
 	tristate "SDIO UART/GPS class support"
 	depends on MMC
diff --git a/drivers/mmc/card/Makefile b/drivers/mmc/card/Makefile
index fc5a784..944447d 100644
--- a/drivers/mmc/card/Makefile
+++ b/drivers/mmc/card/Makefile
@@ -9,5 +9,6 @@ endif
 obj-$(CONFIG_MMC_BLOCK)		+=3D mmc_block.o
 mmc_block-objs			:=3D block.o queue.o
=20
+obj-$(CONFIG_MMC_TEST)		+=3D mmc_test.o
 obj-$(CONFIG_SDIO_UART)		+=3D sdio_uart.o
=20
diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
new file mode 100644
index 0000000..06c9ef2
--- /dev/null
+++ b/drivers/mmc/card/mmc_test.c
@@ -0,0 +1,520 @@
+/*
+ *  linux/drivers/mmc/card/mmc_test.c
+ *
+ *  Copyright 2007 Pierre Ossman
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ */
+
+#include <linux/mmc/core.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/host.h>
+#include <linux/mmc/mmc.h>
+
+#include <linux/scatterlist.h>
+
+static int set_blksize(struct mmc_card *card, unsigned size)
+{
+	struct mmc_command cmd;
+	int ret;
+
+	cmd.opcode =3D MMC_SET_BLOCKLEN;
+	cmd.arg =3D size;
+	cmd.flags =3D MMC_RSP_R1 | MMC_CMD_AC;
+	ret =3D mmc_wait_for_cmd(card->host, &cmd, 5);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int do_transfer(struct mmc_card *card, struct mmc_request *mrq,
+		int write, unsigned blocks, unsigned blksz)
+{
+	int ret, i;
+	u8 *buffer;
+
+	struct scatterlist sg;
+
+	buffer =3D kzalloc((blocks + 1) * blksz, GFP_KERNEL);
+	if (!buffer) {
+		ret =3D -ENOMEM;
+		goto out;
+	}
+
+	if (!write)
+		memset(buffer, 0xDF, blocks * blksz);
+
+	memset(mrq->data, 0, sizeof(struct mmc_data));
+
+	mrq->data->blksz =3D blksz;
+	mrq->data->blocks =3D blocks;
+	mrq->data->flags =3D write ? MMC_DATA_WRITE : MMC_DATA_READ;
+	mrq->data->sg =3D &sg;
+	mrq->data->sg_len =3D 1;
+
+	sg_init_one(&sg, buffer, blocks * blksz);
+
+	mmc_set_data_timeout(mrq->data, card, write);
+
+	mmc_wait_for_req(card->host, mrq);
+
+	if (!write) {
+		for (i =3D 0;i < blocks * blksz;i++) {
+			if (buffer[i] =3D=3D 0xDF) {
+				ret =3D -EIO;
+				break;
+			}
+		}
+
+		for (i =3D 0;i < blksz;i++) {
+			if (buffer[blocks * blksz + i] !=3D 0x00) {
+				ret =3D -EIO;
+				break;
+			}
+		}
+	}
+
+	ret =3D 0;
+
+out:
+	kfree(buffer);
+	return ret;
+}
+
+static int do_valid_transfer(struct mmc_card *card, struct mmc_request *mr=
q,
+		int write, unsigned blocks, unsigned blksz)
+{
+	int ret;
+
+	ret =3D set_blksize(card, blksz);
+	if (ret)
+		return ret;
+
+	memset(mrq->cmd, 0, sizeof(struct mmc_command));
+
+	if (blocks > 1)
+		mrq->cmd->opcode =3D write ? MMC_WRITE_MULTIPLE_BLOCK : MMC_READ_MULTIPL=
E_BLOCK;
+	else
+		mrq->cmd->opcode =3D write ? MMC_WRITE_BLOCK : MMC_READ_SINGLE_BLOCK;
+
+	mrq->cmd->arg =3D 0;
+	mrq->cmd->flags =3D MMC_RSP_R1 | MMC_CMD_ADTC;
+
+	memset(mrq->stop, 0, sizeof(struct mmc_command));
+
+	if (blocks > 1) {
+		mrq->stop->opcode =3D MMC_STOP_TRANSMISSION;
+		mrq->stop->arg =3D 0;
+		mrq->stop->flags =3D MMC_RSP_R1B | MMC_CMD_AC;
+	} else {
+		mrq->stop->opcode =3D MMC_SEND_STATUS;
+		mrq->stop->arg =3D card->rca << 16;
+		mrq->stop->flags =3D MMC_RSP_R1 | MMC_CMD_AC;
+	}
+
+	return do_transfer(card, mrq, write, blocks, blksz);
+}
+
+static int do_invalid_transfer(struct mmc_card *card, struct mmc_request *=
mrq,
+		int write, unsigned blocks, unsigned blksz)
+{
+	memset(mrq->cmd, 0, sizeof(struct mmc_command));
+
+	mrq->cmd->opcode =3D MMC_SEND_STATUS;
+	mrq->cmd->arg =3D card->rca << 16;
+	mrq->cmd->flags =3D MMC_RSP_R1 | MMC_CMD_ADTC;
+
+	memset(mrq->stop, 0, sizeof(struct mmc_command));
+
+	mrq->stop->opcode =3D MMC_SEND_STATUS;
+	mrq->stop->arg =3D card->rca << 16;
+	mrq->stop->flags =3D MMC_RSP_R1 | MMC_CMD_AC;
+
+	return do_transfer(card, mrq, write, blocks, blksz);
+}
+
+static int test_pow2_reads(struct mmc_card *card)
+{
+	int ret, i;
+
+	struct mmc_request mrq;
+	struct mmc_command cmd;
+	struct mmc_command stop;
+	struct mmc_data data;
+
+	printk(KERN_INFO "%s: Testing reading power of two block sizes...\n",
+		mmc_hostname(card->host));
+
+	for (i =3D 1;i <=3D 512;i <<=3D 1) {
+		memset(&mrq, 0, sizeof(struct mmc_request));
+
+		mrq.cmd =3D &cmd;
+		mrq.data =3D &data;
+		mrq.stop =3D &stop;
+
+		ret =3D do_valid_transfer(card, &mrq, 0, 1, i);
+		if (ret)
+			goto out;
+
+		ret =3D 0;
+
+		if (!ret && cmd.error)
+			ret =3D cmd.error;
+		if (!ret && data.error)
+			ret =3D data.error;
+		if (!ret && stop.error)
+			ret =3D stop.error;
+		if (!ret && data.bytes_xfered !=3D i)
+			ret =3D -EIO;
+
+		if (ret)
+			break;
+	}
+
+out:
+	printk(KERN_INFO "%s: Result: %s\n", mmc_hostname(card->host),
+		ret ? "FAIL" : "OK");
+
+	return ret;
+}
+
+static int test_pow2_writes(struct mmc_card *card)
+{
+	int ret, i;
+
+	struct mmc_request mrq;
+	struct mmc_command cmd;
+	struct mmc_command stop;
+	struct mmc_data data;
+
+	printk(KERN_INFO "%s: Testing writing power of two block sizes...\n",
+		mmc_hostname(card->host));
+
+	for (i =3D 1;i <=3D 512;i <<=3D 1) {
+		memset(&mrq, 0, sizeof(struct mmc_request));
+
+		mrq.cmd =3D &cmd;
+		mrq.data =3D &data;
+		mrq.stop =3D &stop;
+
+		ret =3D do_valid_transfer(card, &mrq, 1, 1, i);
+		if (ret)
+			goto out;
+
+		ret =3D 0;
+
+		if (!ret && cmd.error)
+			ret =3D cmd.error;
+		if (!ret && data.error)
+			ret =3D data.error;
+		if (!ret && stop.error)
+			ret =3D stop.error;
+		if (!ret && data.bytes_xfered !=3D i)
+			ret =3D -EIO;
+
+		if (ret)
+			break;
+	}
+
+out:
+	printk(KERN_INFO "%s: Result: %s\n", mmc_hostname(card->host),
+		ret ? "FAIL" : "OK");
+
+	return ret;
+}
+
+static int test_weird_reads(struct mmc_card *card)
+{
+	int ret, i;
+
+	struct mmc_request mrq;
+	struct mmc_command cmd;
+	struct mmc_command stop;
+	struct mmc_data data;
+
+	printk(KERN_INFO "%s: Testing reading unusual block sizes...\n",
+		mmc_hostname(card->host));
+
+	for (i =3D 3;i <=3D 512;i +=3D 7) {
+		memset(&mrq, 0, sizeof(struct mmc_request));
+
+		mrq.cmd =3D &cmd;
+		mrq.data =3D &data;
+		mrq.stop =3D &stop;
+
+		ret =3D do_valid_transfer(card, &mrq, 0, 1, i);
+		if (ret)
+			goto out;
+
+		ret =3D 0;
+
+		if (!ret && cmd.error)
+			ret =3D cmd.error;
+		if (!ret && data.error)
+			ret =3D data.error;
+		if (!ret && stop.error)
+			ret =3D stop.error;
+		if (!ret && data.bytes_xfered !=3D i)
+			ret =3D -EIO;
+
+		if (ret)
+			break;
+	}
+
+out:
+	printk(KERN_INFO "%s: Result: %s\n", mmc_hostname(card->host),
+		ret ? "FAIL" : "OK");
+
+	return ret;
+}
+
+static int test_weird_writes(struct mmc_card *card)
+{
+	int ret, i;
+
+	struct mmc_request mrq;
+	struct mmc_command cmd;
+	struct mmc_command stop;
+	struct mmc_data data;
+
+	printk(KERN_INFO "%s: Testing writing unusual block sizes...\n",
+		mmc_hostname(card->host));
+
+	for (i =3D 3;i <=3D 512;i +=3D 7) {
+		memset(&mrq, 0, sizeof(struct mmc_request));
+
+		mrq.cmd =3D &cmd;
+		mrq.data =3D &data;
+		mrq.stop =3D &stop;
+
+		ret =3D do_valid_transfer(card, &mrq, 1, 1, i);
+		if (ret)
+			goto out;
+
+		ret =3D 0;
+
+		if (!ret && cmd.error)
+			ret =3D cmd.error;
+		if (!ret && data.error)
+			ret =3D data.error;
+		if (!ret && stop.error)
+			ret =3D stop.error;
+		if (!ret && data.bytes_xfered !=3D i)
+			ret =3D -EIO;
+
+		if (ret)
+			break;
+	}
+
+out:
+	printk(KERN_INFO "%s: Result: %s\n", mmc_hostname(card->host),
+		ret ? "FAIL" : "OK");
+
+	return ret;
+}
+
+static int test_bytes_xfer_single(struct mmc_card *card)
+{
+	int ret;
+
+	struct mmc_request mrq;
+	struct mmc_command cmd;
+	struct mmc_command stop;
+	struct mmc_data data;
+
+	printk(KERN_INFO "%s: Testing correct bytes_xfered for a single block...\=
n",
+		mmc_hostname(card->host));
+
+	if (!(card->host->caps & MMC_CAP_MULTIWRITE)) {
+		printk(KERN_INFO "%s: Result: UNSUPPORTED\n",
+			mmc_hostname(card->host));
+		return -EINVAL;
+	}
+
+	memset(&mrq, 0, sizeof(struct mmc_request));
+
+	mrq.cmd =3D &cmd;
+	mrq.data =3D &data;
+	mrq.stop =3D &stop;
+
+	ret =3D do_invalid_transfer(card, &mrq, 1, 1, 512);
+	if (ret)
+		goto out;
+
+	ret =3D 0;
+
+	if (!ret && cmd.error)
+		ret =3D cmd.error;
+	if (!ret && data.error !=3D -ETIMEDOUT)
+		ret =3D data.error;
+	if (!ret && stop.error)
+		ret =3D stop.error;
+	if (!ret && data.bytes_xfered !=3D 0)
+		ret =3D -EINVAL;
+
+out:
+	printk(KERN_INFO "%s: Result: %s\n", mmc_hostname(card->host),
+		ret ? "FAIL" : "OK");
+
+	return ret;
+}
+
+static int test_bytes_xfer_multi(struct mmc_card *card)
+{
+	int ret;
+
+	struct mmc_request mrq;
+	struct mmc_command cmd;
+	struct mmc_command stop;
+	struct mmc_data data;
+
+	printk(KERN_INFO "%s: Testing correct bytes_xfered for multiple blocks...=
\n",
+		mmc_hostname(card->host));
+
+	if (!(card->host->caps & MMC_CAP_MULTIWRITE) ||
+			(card->host->max_blk_count < 2) ||
+			(card->host->max_req_size < 1024) ||
+			(card->host->max_seg_size < 1024)) {
+		printk(KERN_INFO "%s: Result: UNSUPPORTED\n",
+			mmc_hostname(card->host));
+		return -EINVAL;
+	}
+
+	memset(&mrq, 0, sizeof(struct mmc_request));
+
+	mrq.cmd =3D &cmd;
+	mrq.data =3D &data;
+	mrq.stop =3D &stop;
+
+	ret =3D do_invalid_transfer(card, &mrq, 1, 2, 512);
+	if (ret)
+		goto out;
+
+	ret =3D 0;
+
+	if (!ret && cmd.error)
+		ret =3D cmd.error;
+	if (!ret && data.error !=3D -ETIMEDOUT)
+		ret =3D data.error;
+	if (!ret && stop.error)
+		ret =3D stop.error;
+	if (!ret && data.bytes_xfered !=3D 0)
+		ret =3D -EINVAL;
+
+out:
+	printk(KERN_INFO "%s: Result: %s\n", mmc_hostname(card->host),
+		ret ? "FAIL" : "OK");
+
+	return ret;
+}
+
+static int test_busy_wait(struct mmc_card *card)
+{
+	int ret;
+
+	struct mmc_request mrq;
+	struct mmc_command cmd;
+	struct mmc_command stop;
+	struct mmc_data data;
+
+	printk(KERN_INFO "%s: Testing that host waits for busy...\n",
+		mmc_hostname(card->host));
+
+	memset(&mrq, 0, sizeof(struct mmc_request));
+
+	mrq.cmd =3D &cmd;
+	mrq.data =3D &data;
+	mrq.stop =3D &stop;
+
+	ret =3D do_valid_transfer(card, &mrq, 1, 10, 512);
+	if (ret)
+		goto out;
+
+	ret =3D 0;
+
+	if (!ret && cmd.error)
+		ret =3D cmd.error;
+	if (!ret && data.error)
+		ret =3D data.error;
+	if (!ret && stop.error)
+		ret =3D stop.error;
+	if (!ret && data.bytes_xfered !=3D 10 * 512)
+		ret =3D -EIO;
+
+	if (ret)
+		goto out;
+
+	memset(&cmd, 0, sizeof(struct mmc_command));
+
+	cmd.opcode =3D MMC_SEND_STATUS;
+	cmd.arg =3D card->rca << 16;
+	cmd.flags =3D MMC_RSP_R1 | MMC_CMD_ADTC;
+
+	ret =3D mmc_wait_for_cmd(card->host, &cmd, 0);
+	if (ret)
+		goto out;
+
+	if (!(cmd.resp[0] & R1_READY_FOR_DATA))
+		ret =3D -EIO;
+
+out:
+	printk(KERN_INFO "%s: Result: %s\n", mmc_hostname(card->host),
+		ret ? "FAIL" : "OK (uncertain, test multiple cards)");
+
+	return ret;
+}
+
+static int mmc_test_probe(struct mmc_card *card)
+{
+	mmc_claim_host(card->host);
+
+	test_pow2_writes(card);
+	test_pow2_reads(card);
+
+	test_weird_writes(card);
+	test_weird_reads(card);
+
+	test_bytes_xfer_single(card);
+	test_bytes_xfer_multi(card);
+
+	test_busy_wait(card);
+
+	mmc_release_host(card->host);
+
+	return -ENODEV;
+}
+
+static void mmc_test_remove(struct mmc_card *card)
+{
+}
+
+static struct mmc_driver mmc_driver =3D {
+	.drv		=3D {
+		.name	=3D "mmc_test",
+	},
+	.probe		=3D mmc_test_probe,
+	.remove		=3D mmc_test_remove,
+};
+
+static int __init mmc_test_init(void)
+{
+	return mmc_register_driver(&mmc_driver);
+}
+
+static void __exit mmc_test_exit(void)
+{
+	mmc_unregister_driver(&mmc_driver);
+}
+
+module_init(mmc_test_init);
+module_exit(mmc_test_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Multimedia Card (MMC) host test driver");
+MODULE_AUTHOR("Pierre Ossman");
+
+

--MP_ee=1AVMpIpUqdn15H1mL+t9--

--=_hera.drzeus.cx-21754-1186567909-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGuZbj7b8eESbyJLgRAlceAJ4wSD2ufSX2LlwqpZLsJdRQRmqpTQCg3xTZ
TIedou8nYymBb3HbuOQFNi8=
=zlpo
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-21754-1186567909-0001-2--
