Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbZIXLtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbZIXLtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZIXLtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:49:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:48508 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbZIXLtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:49:21 -0400
Date: Thu, 24 Sep 2009 11:48:52 GMT
From: tip-bot for Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, jason.wessel@windriver.com,
       lenb@kernel.org, akpm@linux-foundation.org, gregkh@suse.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lenb@kernel.org, akpm@linux-foundation.org, jason.wessel@windriver.com,
       torvalds@linux-foundation.org, gregkh@suse.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <4ABAAB89.1080407@windriver.com>
References: <4ABAAB89.1080407@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: early_printk: Protect against using the same device twice
Message-ID: <tip-429a6e5e2c1fbe5d805aad123efbdb5f0c14769f@git.kernel.org>
Git-Commit-ID: 429a6e5e2c1fbe5d805aad123efbdb5f0c14769f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 24 Sep 2009 11:48:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  429a6e5e2c1fbe5d805aad123efbdb5f0c14769f
Gitweb:     http://git.kernel.org/tip/429a6e5e2c1fbe5d805aad123efbdb5f0c14769f
Author:     Jason Wessel <jason.wessel@windriver.com>
AuthorDate: Wed, 23 Sep 2009 18:13:13 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Sep 2009 13:01:13 +0200

x86: early_printk: Protect against using the same device twice

If you use the kernel argument:

  earlyprintk=serial,ttyS0,115200

This will cause a recursive hang printing the same line
again and again:

 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
bootconsole [earlyser0] enabled
Linux version 2.6.31-07863-gb64ada6 (mingo@sirius) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #16789 SMP Wed Sep 23 21:09:43 CEST 2009
Linux version 2.6.31-07863-gb64ada6 (mingo@sirius) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #16789 SMP Wed Sep 23 21:09:43 CEST 2009
Linux version 2.6.31-07863-gb64ada6 (mingo@sirius) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #16789 SMP Wed Sep 23 21:09:43 CEST 2009
Linux version 2.6.31-07863-gb64ada6 (mingo@sirius) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #16789 SMP Wed Sep 23 21:09:43 CEST 2009
Linux version 2.6.31-07863-gb64ada6 (mingo@sirius) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #16789 SMP Wed Sep 23 21:09:43 CEST 2009

Instead warn the end user that they specified the device
a second time, and ignore that second console.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <4ABAAB89.1080407@windriver.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/early_printk.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 2acfd3f..41fd965 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -178,6 +178,11 @@ asmlinkage void early_printk(const char *fmt, ...)
 
 static inline void early_console_register(struct console *con, int keep_early)
 {
+	if (early_console->index != -1) {
+		printk(KERN_CRIT "ERROR: earlyprintk= %s already used\n",
+		       con->name);
+		return;
+	}
 	early_console = con;
 	if (keep_early)
 		early_console->flags &= ~CON_BOOT;
