Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbZLIRo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbZLIRo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbZLIRo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:44:26 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:54425 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbZLIRoZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:44:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EAz8ILVeDKHm8f1TaF6VFVYXJTDRlTpyDw6tEGmotvnzz94/nqwGP4wTCat+UXo5JK
         xUjBgFdp1gIjFGl1+p4M2ANyKGl3kOvsWvAHcNDV3DLlsnZTGi3P0nyG/j9nY6eh91Bm
         MRVXfgu/+2KyHBBpEGEc3gdCrQxU++wDDD2MQ=
MIME-Version: 1.0
Date: Wed, 9 Dec 2009 18:44:31 +0100
Message-ID: <c62985530912090944p24dfe910mf9fff4c021ac7691@mail.gmail.com>
Subject: [PATCH] nvram: Fix missing smp_lock.h in nvram
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/6, Thomas Gleixner <tglx@linutronix.de>:
> Linus,
>
> Please pull the latest bkl-drivers-for-linus git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> bkl-drivers-for-linus
>
> Thanks,
>
> 	tglx
>
> ------------------>
> Frederic Weisbecker (3):
>       mem_class: Drop the bkl from memory_open()
>       nvram: Drop the bkl from nvram_llseek()


This breaks the upstream tree. It looks like a patch from Ingo
that removed the bkl in nvram_open() is missing.

Please consider the following patch:

>From 4ce046f911b1cb62b4e952fd599e0d8c3dcd8703 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 9 Dec 2009 18:31:53 +0100
Subject: [PATCH] nvram: Fix missing smp_lock.h in nvram

The bkl has been removed from nvram_llseek() and smp_lock.h was
removed because another patch in the same tree zapped the remaining
usage of bkl in the same file. But this patch must have been excluded
later, then we still need the smp_lock.h headers for the bkl use
in nvram_open().

This fixes the following build error:

drivers/char/nvram.c: In function ‘nvram_open’:
drivers/char/nvram.c:332: erreur: implicit declaration of function ‘lock_kernel’
drivers/char/nvram.c:339: erreur: implicit declaration of function
‘unlock_kernel’
make[2]: *** [drivers/char/nvram.o] Erreur 1
make[1]: *** [drivers/char] Erreur 2
make: *** [drivers] Erreur 2

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 drivers/char/nvram.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 2100a8f..4008e2c 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -110,6 +110,7 @@
 #include <linux/spinlock.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
+#include <linux/smp_lock.h>

 #include <asm/system.h>

-- 
1.6.2.3
