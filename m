Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934074Ab0BYVXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:23:37 -0500
Received: from mail.windriver.com ([147.11.1.11]:63834 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933981Ab0BYVXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:23:31 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 6/8] earlyprintk,vga,kdb: Fix \b and \r for earlyprintk=vga with kdb
Date: Thu, 25 Feb 2010 15:22:04 -0600
Message-Id: <1267132926-23685-7-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1267132926-23685-1-git-send-email-jason.wessel@windriver.com>
References: <1267132926-23685-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 25 Feb 2010 21:22:50.0507 (UTC) FILETIME=[AF258DB0:01CAB660]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow kdb to work properly with with earlyprintk=vga by interpreting
the backspace and carriage return output characters.  These
interpretation of these characters is used for simple line editing
provided in the kdb shell.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: x86@kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/early_printk.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index b9c830c..fa99bae 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -41,6 +41,14 @@ static void early_vga_write(struct console *con, const char *str, unsigned n)
 				writew(0x720, VGABASE + 2*(max_xpos*j + i));
 			current_ypos = max_ypos-1;
 		}
+#ifdef CONFIG_KGDB_KDB
+		if (c == '\b') {
+			if (current_xpos > 0)
+				current_xpos--;
+		} else if (c == '\r') {
+			current_xpos = 0;
+		} else
+#endif
 		if (c == '\n') {
 			current_xpos = 0;
 			current_ypos++;
-- 
1.6.4.rc1

