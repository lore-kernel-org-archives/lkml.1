Return-Path: <linux-kernel-owner+w=401wt.eu-S1762339AbYECLvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762339AbYECLvt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 07:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbYECLvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 07:51:42 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:59452 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbYECLvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 07:51:41 -0400
Message-ID: <481C51BE.5010606@aknet.ru>
Date: Sat, 03 May 2008 15:51:26 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Takashi Iwai <tiwai@suse.de>, Linux kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Vojtech Pavlik <vojtech@suse.cz>,
       Michael Opdenacker <michael-lists@free-electrons.com>
Subject: [patch][resend] pcspkr: fix dependancies
X-Enigmail-Version: 0.95.2
Content-Type: multipart/mixed;
 boundary="------------090001000505050702090808"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090001000505050702090808
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello.

linux-2.6.25 has the strange dependancies
for pc-speaker, which prevents snd-pcsp
from working.
Namely, the platform device (created in
arch/x86/kernel/pcspeaker.c) depends on
the platform driver (CONFIG_INPUT_PCSPKR).
I wonder if it is a good practice to make
the platform device to depend on the driver,
I guess it is not.

The attached patch reverses that.
It adds the config option for the pcspkr
platform device and makes the platform
drivers to depend on that.
This allows snd-pcsp to work at least in
some configurations.

Ingo, would it be possible to get that
applied?

---
fix pcspkr dependancies: make the pcspkr platform
drivers to depend on a platform device, and
not the other way around.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Vojtech Pavlik <vojtech@suse.cz>
CC: Michael Opdenacker <michael-lists@free-electrons.com>
CC: Takashi Iwai <tiwai@suse.de>

--------------090001000505050702090808
Content-Type: text/x-patch;
 name="pcsp_dep2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pcsp_dep2.diff"

--- a/init/Kconfig	2008-04-26 13:40:20.000000000 +0400
+++ b/init/Kconfig	2008-04-26 18:20:40.000000000 +0400
@@ -624,6 +624,14 @@
 	help
 	  Enable support for generating core dumps. Disabling saves about 4k.
 
+config PCSPKR_PLATFORM
+	bool "Enable PC-Speaker support" if EMBEDDED
+	depends on ALPHA || X86 || MIPS || PPC_PREP || PPC_CHRP || PPC_PSERIES
+	default y
+	help
+          This option allows to disable the internal PC-Speaker
+          support, saving some memory.
+
 config COMPAT_BRK
 	bool "Disable heap randomization"
 	default y
--- a/arch/x86/kernel/Makefile	2008-04-26 13:40:06.000000000 +0400
+++ b/arch/x86/kernel/Makefile	2008-04-26 18:22:49.000000000 +0400
@@ -83,7 +83,7 @@
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
 
-ifdef CONFIG_INPUT_PCSPKR
+ifdef CONFIG_PCSPKR_PLATFORM
 obj-y				+= pcspeaker.o
 endif
 
--- a/drivers/input/misc/Kconfig	2008-04-22 20:50:41.000000000 +0400
+++ b/drivers/input/misc/Kconfig	2008-04-26 18:23:32.000000000 +0400
@@ -14,7 +14,7 @@
 
 config INPUT_PCSPKR
 	tristate "PC Speaker support"
-	depends on ALPHA || X86 || MIPS || PPC_PREP || PPC_CHRP || PPC_PSERIES
+	depends on PCSPKR_PLATFORM
 	help
 	  Say Y here if you want the standard PC Speaker to be used for
 	  bells and whistles.

--------------090001000505050702090808--
