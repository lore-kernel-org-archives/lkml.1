Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbZGRL3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbZGRL3D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 07:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbZGRL3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 07:29:01 -0400
Received: from bu3sch.de ([62.75.166.246]:35972 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbZGRL3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 07:29:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ben Gardner <bgardner@wabtec.com>
Subject: [PATCH] cs5535_gpio: Fix root triggerable integer underflow
Date: Sat, 18 Jul 2009 13:28:36 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907181328.36292.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a possible root triggerable (I hope the device is only
readable by root?) integer underflow.
Well, it's not really an underflow, but as loff_t is a signed type, the
range check at the start of the function is incomplete. It needs to check for <0, too.
Otherwise the loop below will poke into random memory and I/O space.
This could be used to crash the machine, at least.

This patch is only compiletested, because I do not have the hardware.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

I'm not sure if this bug is exploitable. I _guess_ the device is only readable by root
on a standard setup.

---
 drivers/char/cs5535_gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/drivers/char/cs5535_gpio.c
+++ linux-2.6/drivers/char/cs5535_gpio.c
@@ -124,21 +124,21 @@ static ssize_t cs5535_gpio_write(struct 
 static ssize_t cs5535_gpio_read(struct file *file, char __user *buf,
 				size_t len, loff_t *ppos)
 {
 	u32	m = iminor(file->f_path.dentry->d_inode);
 	u32	base = gpio_base + cs5535_lowhigh_base(m);
 	int	rd_bit = 1 << (m & 0x0f);
 	int	i;
 	char	ch;
 	ssize_t	count = 0;
 
-	if (*ppos >= ARRAY_SIZE(rm))
+	if (*ppos < 0 || *ppos >= ARRAY_SIZE(rm))
 		return 0;
 
 	for (i = *ppos; (i < (*ppos + len)) && (i < ARRAY_SIZE(rm)); i++) {
 		ch = (inl(base + rm[i].rd_offset) & rd_bit) ?
 		     rm[i].on : rm[i].off;
 
 		if (put_user(ch, buf+count))
 			return -EFAULT;
 
 		count++;

-- 
Greetings, Michael.
