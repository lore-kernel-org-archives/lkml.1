Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbZLDQZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbZLDQZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932180AbZLDQZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:25:57 -0500
Received: from mail-px0-f188.google.com ([209.85.216.188]:63384 "EHLO
	mail-px0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbZLDQZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:25:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=aQzGWQ4ovhjGTargYmCdCplBo5GVlRjJ2sJcDqrkffrgimD1JgjDWG52CbI5vup++A
         3E93ioMCBytsfIJvbNyVXDW2NTLYj05IC4jbPmnD0sZ39rkKIVhDutLFPVEWfjiDMZIQ
         cYMUiEOBFM09htqECiL0j86xDO0/4GPze9zh4=
MIME-Version: 1.0
Date: Fri, 4 Dec 2009 22:26:02 +0600
Message-ID: <b9df5fa10912040826s52e82f2cpd53604835be50c27@mail.gmail.com>
Subject: [PATCH] x86: Call __va() to get trampoline_base.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 x86, tboot: Call __va() to get trampoline_base.

 Do not pass trampoline_base as parameter of virt_to_phys.
Because trampoline_base is in .cpuinit.data section, but its
called from non-cpuinit function. So use __va(TRAMPOLINE_BASE)
instead of trampoline_base, which helps to fix section mismatch.

We were warned by the following warning:

  LD      arch/x86/kernel/built-in.o
WARNING: arch/x86/kernel/built-in.o(.text+0x13c5f): Section mismatch
in reference from the function tboot_setup_sleep() to the variable
.cpuinit.data:trampoline_base
The function tboot_setup_sleep() references
the variable __cpuinitdata trampoline_base.
This is often because tboot_setup_sleep lacks a __cpuinitdata
annotation or the annotation of trampoline_base is wrong.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

--- linus/arch/x86/kernel/tboot.c	2009-12-04 17:22:57.000000000 +0600
+++ rakib/arch/x86/kernel/tboot.c	2009-12-04 17:19:09.000000000 +0600
@@ -191,7 +191,7 @@ static int tboot_setup_sleep(void)

 #ifdef CONFIG_X86_TRAMPOLINE
 	/* AP trampoline code */
-	add_mac_region(virt_to_phys(trampoline_base), TRAMPOLINE_SIZE);
+	add_mac_region(virt_to_phys(__va(TRAMPOLINE_BASE)), TRAMPOLINE_SIZE);
 #endif

 	/* kernel code + data + bss */
