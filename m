Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbZGDUH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbZGDUH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 16:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZGDUHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 16:07:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:33611 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbZGDUHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 16:07:18 -0400
Date: Sat, 4 Jul 2009 20:07:01 GMT
From: tip-bot for Akinobu Mita <akinobu.mita@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akinobu.mita@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akinobu.mita@gmail.com
In-Reply-To: <20090701021307.GA3127@localhost.localdomain>
References: <20090701021307.GA3127@localhost.localdomain>
Subject: [tip:x86/urgent] x86: fix usage of bios intcall()
Message-ID: <tip-febe04de3be4bf66f9339d8847db2806d99fd164@git.kernel.org>
Git-Commit-ID: febe04de3be4bf66f9339d8847db2806d99fd164
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 04 Jul 2009 20:07:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  febe04de3be4bf66f9339d8847db2806d99fd164
Gitweb:     http://git.kernel.org/tip/febe04de3be4bf66f9339d8847db2806d99fd164
Author:     Akinobu Mita <akinobu.mita@gmail.com>
AuthorDate: Wed, 1 Jul 2009 11:13:07 +0900
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 4 Jul 2009 12:56:32 -0700

x86: fix usage of bios intcall()

Some intcall() misuses the input biosregs as output in
cf06de7b9cdd3efee7a59dced1977b3c21d43732

This fixes the problem vga=ask boot option doesn't show enough modes.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
LKML-Reference: <20090701021307.GA3127@localhost.localdomain>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/boot/video-bios.c |    3 +--
 arch/x86/boot/video-vesa.c |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/video-bios.c b/arch/x86/boot/video-bios.c
index d660be4..49e0c18 100644
--- a/arch/x86/boot/video-bios.c
+++ b/arch/x86/boot/video-bios.c
@@ -37,14 +37,13 @@ static int set_bios_mode(u8 mode)
 	ireg.al = mode;		/* AH=0x00 Set Video Mode */
 	intcall(0x10, &ireg, NULL);
 
-
 	ireg.ah = 0x0f;		/* Get Current Video Mode */
 	intcall(0x10, &ireg, &oreg);
 
 	do_restore = 1;		/* Assume video contents were lost */
 
 	/* Not all BIOSes are clean with the top bit */
-	new_mode = ireg.al & 0x7f;
+	new_mode = oreg.al & 0x7f;
 
 	if (new_mode == mode)
 		return 0;	/* Mode change OK */
diff --git a/arch/x86/boot/video-vesa.c b/arch/x86/boot/video-vesa.c
index c700147..275dd17 100644
--- a/arch/x86/boot/video-vesa.c
+++ b/arch/x86/boot/video-vesa.c
@@ -45,7 +45,7 @@ static int vesa_probe(void)
 	ireg.di = (size_t)&vginfo;
 	intcall(0x10, &ireg, &oreg);
 
-	if (ireg.ax != 0x004f ||
+	if (oreg.ax != 0x004f ||
 	    vginfo.signature != VESA_MAGIC ||
 	    vginfo.version < 0x0102)
 		return 0;	/* Not present */
@@ -70,7 +70,7 @@ static int vesa_probe(void)
 		ireg.di = (size_t)&vminfo;
 		intcall(0x10, &ireg, &oreg);
 
-		if (ireg.ax != 0x004f)
+		if (oreg.ax != 0x004f)
 			continue;
 
 		if ((vminfo.mode_attr & 0x15) == 0x05) {
