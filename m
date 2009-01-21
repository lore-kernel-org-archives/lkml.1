Return-Path: <linux-kernel-owner+w=401wt.eu-S1760418AbZAUPQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760418AbZAUPQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbZAUPQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 10:16:02 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:52840 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722AbZAUPQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 10:16:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=is4qK0cItRXPH6uoRX52VqhYIR5uYHZvOBndDg/3VREHUOblwuqhp3g2ajuOjyGHTw
         Omqc5MPEqKcDdkowEwzIMQV7d7XQQAI5jjhVJaQeSmRy6S/NLq0E83oqAczsqui+oqOn
         ppKH9jR3H8ZkxBG4RwDEUjPfJ70+9p9WOJwDI=
Message-ID: <49773C2E.9090608@gmail.com>
Date: Wed, 21 Jan 2009 16:15:58 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>, lkml <linux-kernel@vger.kernel.org>
CC: uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH] x86, um: fix GETREG/PUTREG macros
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When these macros aren't called with regs, e.g. with foo
this will incorectly expand to foo->foo.gp[*]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
My other patch should probably as well have been sent to this list:
http://lkml.org/lkml/2009/1/21/203

diff --git a/arch/um/sys-x86_64/signal.c b/arch/um/sys-x86_64/signal.c
index 1a899a7..31d0e9c 100644
--- a/arch/um/sys-x86_64/signal.c
+++ b/arch/um/sys-x86_64/signal.c
@@ -49,8 +49,8 @@ static int copy_sc_from_user(struct pt_regs *regs,
 	struct user_i387_struct fp;
 	int err = 0;
 
-#define GETREG(regs, regno, sc, regname)				\
-	__get_user((regs)->regs.gp[(regno) / sizeof(unsigned long)],	\
+#define GETREG(_regs, regno, sc, regname)				\
+	__get_user((_regs)->regs.gp[(regno) / sizeof(unsigned long)],	\
 		   &(sc)->regname)
 
 	err |= GETREG(regs, R8, from, r8);
@@ -104,8 +104,8 @@ static int copy_sc_to_user(struct sigcontext __user *to,
 	err |= __put_user(0, &to->gs);
 	err |= __put_user(0, &to->fs);
 
-#define PUTREG(regs, regno, sc, regname)				\
-	__put_user((regs)->regs.gp[(regno) / sizeof(unsigned long)],	\
+#define PUTREG(_regs, regno, sc, regname)				\
+	__put_user((_regs)->regs.gp[(regno) / sizeof(unsigned long)],	\
 		   &(sc)->regname)
 
 	err |= PUTREG(regs, RDI, to, di);

