Return-Path: <linux-kernel-owner+w=401wt.eu-S1750756AbXCFUM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750756AbXCFUM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbXCFUM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:12:27 -0500
Received: from coyote.holtmann.net ([217.160.111.169]:35109 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbXCFUM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:12:26 -0500
Subject: [PATCH] Fix buffer overflow in Omnikey CardMan 4040 driver
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harald Welte <laforge@gnumonks.org>, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-ipwZ34ZPXY2dEliSm+CM"
Date: Tue, 06 Mar 2007 22:12:00 +0100
Message-Id: <1173215520.15106.9.camel@aeonflux.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ipwZ34ZPXY2dEliSm+CM
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Linus,

the attached patch fixes a buffer overflow in the Omnikey CardMan 4040
driver that could lead to a potential arbitrary code execution with
kernel privileges.

Regards

Marcel


--=-ipwZ34ZPXY2dEliSm+CM
Content-Disposition: attachment; filename=patch-cardman-4040
Content-Type: text/plain; name=patch-cardman-4040; charset=UTF-8
Content-Transfer-Encoding: 7bit

[PATCH] Fix buffer overflow in Omnikey CardMan 4040 driver (CVE-2007-0005)

Based on a patch from Don Howard <dhoward@redhat.com>

When calling write() with a buffer larger than 512 bytes, the
driver's write buffer overflows, allowing to overwrite the EIP and
execute arbitrary code with kernel privileges.

In read(), there exists a similar problem, but coming from the device.
A malicous or buggy device sending more than 512 bytes can overflow
of the driver's read buffer, with the same effects as above.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Harald Welte <laforge@gnumonks.org>

---
commit 5be3f29dbb70cf7b3eaa5e1be6dfa553c98ea1ad
tree 158eb27c16e372650d7bc8c6536b46f052932148
parent c3442e296517aee733d62fc3fe03211598902c7d
author Marcel Holtmann <marcel@holtmann.org> Tue, 06 Mar 2007 22:02:23 +0100
committer Marcel Holtmann <marcel@holtmann.org> Tue, 06 Mar 2007 22:02:23 +0100

 drivers/char/pcmcia/cm4040_cs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/pcmcia/cm4040_cs.c b/drivers/char/pcmcia/cm4040_cs.c
index 0e82968..f2e4ec4 100644
--- a/drivers/char/pcmcia/cm4040_cs.c
+++ b/drivers/char/pcmcia/cm4040_cs.c
@@ -273,6 +273,7 @@ static ssize_t cm4040_read(struct file *filp, char __user *buf,
 	DEBUGP(6, dev, "BytesToRead=%lu\n", bytes_to_read);
 
 	min_bytes_to_read = min(count, bytes_to_read + 5);
+	min_bytes_to_read = min_t(size_t, min_bytes_to_read, READ_WRITE_BUFFER_SIZE);
 
 	DEBUGP(6, dev, "Min=%lu\n", min_bytes_to_read);
 
@@ -340,7 +341,7 @@ static ssize_t cm4040_write(struct file *filp, const char __user *buf,
 		return 0;
 	}
 
-	if (count < 5) {
+	if ((count < 5) || (count > READ_WRITE_BUFFER_SIZE)) {
 		DEBUGP(2, dev, "<- cm4040_write buffersize=%Zd < 5\n", count);
 		return -EIO;
 	}

--=-ipwZ34ZPXY2dEliSm+CM--

