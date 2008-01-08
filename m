Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbYAHDoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbYAHDoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 22:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYAHDoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 22:44:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:48781 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbYAHDoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 22:44:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=gFJwa9yfh1dTCbOqghsVs2jbsp7sgo3q1AXb8G4i8A4L7IrMhBIDKQcF+vaBNNxYKqMfdyijgh9/cCUMHH03X+EBlsqRYuDKA6E/j6Ot1HIkV2eD71KidiU1GwixFwcTXLvM/8x74z8Op+XyngiZpU/gWcD4DPjj/6BQIGaqtCY=
Message-ID: <4782F180.7000104@gmail.com>
Date: Tue, 08 Jan 2008 06:44:00 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: ralf@linux-mips.org, linux-mips@linux-mips.org
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: [BUG][PATCH] fix broken software reset for Malta board
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>

I noticed that the commit f197465384bf7ef1af184c2ed1a4e268911a91e3
(MIPS Tech: Get rid of volatile in core code) broke the software
reset functionality for MIPS Malta boards in big-endian mode.

According to the MIPS Malta board user's manual, writing the magic
32-bit GORESET value into the SOFTRES register initiates board soft
reset. My experimentation has shown that the endianness of the GORESET
integer should thereby be the same as the endianness, which has been
set for the CPU itself. The writew() function used to write the magic
value in the code introduced by the commit mentioned above, however,
swaps bytes for big-endian kernels and transfers 16 bits instead of 32.

The patch below replaces the writew() function by the __raw_writel()
routine, which leaves the byte order intact and transfers the whole
MIPS machine word. Trivial code cleanup (replacing spaces by a tab
and cutting oversized lines to make checkpatch.pl happy) is also
included.

The patch was tested using a Malta evaluation board running in both
BE and LE modes. For both modes, software reset was fully functional
after the change.

P.S. I suspect that the same commit broke the "standby" functionality
for MIPS Atlas boards. However, I did not touch the Atlas code as I
don't have such board at my disposal and also because the linux-mips.org
Web site claims that Atlas support is scheduled for removal.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>

---
diff --git a/arch/mips/mips-boards/generic/reset.c b/arch/mips/mips-boards/generic/reset.c
index 7a1bb51..583d468 100644
--- a/arch/mips/mips-boards/generic/reset.c
+++ b/arch/mips/mips-boards/generic/reset.c
@@ -39,16 +39,18 @@ static void atlas_machine_power_off(void);
 
 static void mips_machine_restart(char *command)
 {
-	unsigned int __iomem *softres_reg = ioremap(SOFTRES_REG, sizeof(unsigned int));
+	unsigned int __iomem *softres_reg =
+		ioremap(SOFTRES_REG, sizeof(unsigned int));
 
-	writew(GORESET, softres_reg);
+	__raw_writel(GORESET, softres_reg);
 }
 
 static void mips_machine_halt(void)
 {
-        unsigned int __iomem *softres_reg = ioremap(SOFTRES_REG, sizeof(unsigned int));
+	unsigned int __iomem *softres_reg =
+		ioremap(SOFTRES_REG, sizeof(unsigned int));
 
-	writew(GORESET, softres_reg);
+	__raw_writel(GORESET, softres_reg);
 }
 
 #if defined(CONFIG_MIPS_ATLAS)
