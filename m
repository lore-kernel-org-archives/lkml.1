Return-Path: <linux-kernel-owner+w=401wt.eu-S1761334AbZJITVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334AbZJITVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 15:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761317AbZJITVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 15:21:10 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:35271 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761269AbZJITVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 15:21:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EXlzdyARWog5Q15GmQMhq5+O0qb8I3Ic08FN1OwxrULUNP1P/JI/f8w648/0V2/p3Z
         K5/A68Up9R0NuLLjbgZZIDu7mcXWWM5T1lhHRnuSOUPRCmGflISETiIw8ukep6iDTW3n
         10CSkYl3iqg7XIH6a5nWMmVjF6ScCckZe9Yvc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Jonathan Corbet <corbet@lwn.net>,
       Alessio Igor Bogani <abogani@texware.it>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <gregkh@suse.de>
Subject: [PATCH] nvram: Drop the bkl from nvram_llseek()
Date: Fri,  9 Oct 2009 21:20:30 +0200
Message-Id: <1255116030-6929-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is nothing to protect inside nvram_llseek(), the file
offset doesn't need to be protected and nvram_len is only
initialized from an __init path.

It's safe to remove the big kernel lock there.

(Is this file still used? I can't even build it,
looks like it is built under CONFIG_GENERIC_NVRAM but this
option is referenced nowhere except in powerpc defconfigs)

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Kacur <jkacur@redhat.com>
Cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alessio Igor Bogani <abogani@texware.it>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <gregkh@suse.de>
---
 drivers/char/generic_nvram.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/char/generic_nvram.c b/drivers/char/generic_nvram.c
index ef31738..c49200e 100644
--- a/drivers/char/generic_nvram.c
+++ b/drivers/char/generic_nvram.c
@@ -32,7 +32,6 @@ static ssize_t nvram_len;
 
 static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
 {
-	lock_kernel();
 	switch (origin) {
 	case 1:
 		offset += file->f_pos;
@@ -41,12 +40,11 @@ static loff_t nvram_llseek(struct file *file, loff_t offset, int origin)
 		offset += nvram_len;
 		break;
 	}
-	if (offset < 0) {
-		unlock_kernel();
+	if (offset < 0)
 		return -EINVAL;
-	}
+
 	file->f_pos = offset;
-	unlock_kernel();
+
 	return file->f_pos;
 }
 
-- 
1.6.2.3

