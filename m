Return-Path: <linux-kernel-owner+w=401wt.eu-S934422AbXLPPe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934422AbXLPPe5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 10:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759264AbXLPPet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 10:34:49 -0500
Received: from fmmailgate09.web.de ([217.72.192.184]:48086 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbXLPPes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 10:34:48 -0500
Date: Sun, 16 Dec 2007 16:34:47 +0100
Message-Id: <49015158@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: Matt.Domsch@dell.com, hpa@zytor.com
Subject: [PATCH] [RFC] be more verbose when probing EDD
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX180/FyRcegFkfKOdzkr2sukpLA/qZrtST10xZDLIP5ZVZBNI
 mne05vBqaGutaM3uNderkL7V+Ley3W0uDglOqA5LX1vjtZTjlw=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

i`m sysadmin for quite some time and while being that, i have come across the one or another system, which refused to boot a linux kernel. typical symptom i have seen is a blinking cursor in the upper left just after kernel/initrd were loaded.

i never spent much time on that and either choose another system for linux or choose "failsafe" option, if the installer of my favourite distro gave that option.

since a colleague of mine was hit by that problem some weeks ago and i also came across that again recently, i started to investigate deeper and found, that EDD Bios probe is the problem here.

i found more than a handful of references on the net where people report similar problems. many discussion threads contained that typical smattering babble and seldom somebody gave that essential hint "try edd=off" for which i`m sure it would have helped many times.

that`s why i started to spend some thoughts on this how to make this easier/better for the user.

so

- it seems there are buggy Bios implementations out there which have problems with EDD
- your favourite distro may have set CONFIG_EDD=y|m , so EDD probe is on by default quite often nowadays.
- setting "edd=off" when you get that hang on boot is _not_ obvious.
- adressing this issue may be a little bit late, since i have mostly seen that problem on older machines, but not on recently bought
- i have at least two different systems with different types of chipsets to demonstrate this

on one of those, i added some printf`s to edd.c and this routine seems to be problematic and never returns 

        /* Extended Get Device Parameters */

        ei->params.length = sizeof(ei->params);
        ax = 0x4800;
        dx = devno;
        asm("pushfl; int $0x13; popfl"
            : "+a" (ax), "+d" (dx), "=m" (ei->params)
            : "S" (&ei->params)
            : "ebx", "ecx", "edi");

i had a short conversation with matt domsch and hpa, who both think that additional printf`s would be an easy solution and not too bad to be added.

here is a quick and dirty initial patch from me:

--- linux-2.6.23/arch/x86/boot/main.c.orig      2007-12-09 11:40:24.315346712 +0100
+++ linux-2.6.23/arch/x86/boot/main.c   2007-12-09 16:11:43.644512504 +0100
@@ -152,7 +152,10 @@
 
        /* Query EDD information */
 #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
-       query_edd();
+        printf("Probing EDD (query Bios for boot-device information)\n");
+        printf("If boot hangs here, you may have a buggy Bios. Try edd=skipmbr or edd=off");
+        query_edd();
+        printf("\rOK                                                                       \n");
 #endif
        /* Do the last things and invoke protected mode */
        go_to_protected_mode();


ok, fore sure it`s better to do that stuff in query_edd() itself, but before making a better version, i`d like to discuss if such patch would get accepted at all and if it`s a valid approach to let the kernel print some line which get`s overwritten ("\rOK + lot`s of whitespaces") milliseconds later on successful function return.

regards
roland

______________________________________________________________________________
Jetzt neu! Im riesigen WEB.DE Club SmartDrive Dateien freigeben und mit 
Freunden teilen! http://www.freemail.web.de/club/smartdrive_ttc.htm/?mc=021134

