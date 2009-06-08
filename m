Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbZFHINr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbZFHINr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 04:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZFHINc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 04:13:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:43808 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbZFHINa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 04:13:30 -0400
Date: Mon, 8 Jun 2009 08:12:52 GMT
From: tip-bot for Dave Young <hidave.darkstar@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hidave.darkstar@gmail.com, hpa@zytor.com,
       mingo@redhat.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, hidave.darkstar@gmail.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <a8e1da0906080040k7852f770v1e2aa2ebb0f52369@mail.gmail.com>
References: <a8e1da0906080040k7852f770v1e2aa2ebb0f52369@mail.gmail.com>
Subject: [tip:core/printk] printk: Add halt_delay=<msecs> parameter for printk delay in halt phase
Message-ID: <tip-f43a6b1611aff688e21f323b64b98b57f8b7f721@git.kernel.org>
Git-Commit-ID: f43a6b1611aff688e21f323b64b98b57f8b7f721
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 08 Jun 2009 08:12:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f43a6b1611aff688e21f323b64b98b57f8b7f721
Gitweb:     http://git.kernel.org/tip/f43a6b1611aff688e21f323b64b98b57f8b7f721
Author:     Dave Young <hidave.darkstar@gmail.com>
AuthorDate: Mon, 8 Jun 2009 15:40:07 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 8 Jun 2009 10:10:34 +0200

printk: Add halt_delay=<msecs> parameter for printk delay in halt phase

Add a halt_delay module parameter in printk.c used to read the
printk messages in halt/poweroff/restart phase, delay each
printk messages by halt_delay milliseconds.

It is useful for debugging if there's no other way to dump kernel
messages at that time. (if a system has no serial port - and if
netconsole has already gone down at that stage where the messages
are printed.)

The halt_delay max value is 65535, default value is 0. To add
a halt-day of 10 seconds, change it by:

    echo 10000 > /sys/module/printk/parameters/halt_delay

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <a8e1da0906080040k7852f770v1e2aa2ebb0f52369@mail.gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/kernel-parameters.txt |    5 +++++
 kernel/printk.c                     |   17 +++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6172e43..0630428 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1847,6 +1847,11 @@ and is between 256 and 4096 characters. It is defined in the file
 	printk.time=	Show timing data prefixed to each printk message line
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 
+	printk.halt_delay=
+			Milliseconds to delay each printk during
+			halt/poweroff/restart phase.
+			Format: <ushort>
+
 	processor.max_cstate=	[HW,ACPI]
 			Limit processor to maximum C-state
 			max_cstate=9 overrides any DMI blacklist limit.
diff --git a/kernel/printk.c b/kernel/printk.c
index 5052b54..2114231 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -250,6 +250,22 @@ static inline void boot_delay_msec(void)
 }
 #endif
 
+/* msecs delay after each halt/poweroff/restart phase printk,
+ unsigned short is enough for delay in milliseconds */
+static unsigned short halt_delay;
+
+static inline void halt_delay_msec(void)
+{
+	if (unlikely(halt_delay == 0 || !(system_state == SYSTEM_HALT
+				|| system_state == SYSTEM_POWER_OFF
+				|| system_state == SYSTEM_RESTART)))
+		return;
+
+	mdelay(halt_delay);
+}
+
+module_param(halt_delay, ushort, S_IRUGO | S_IWUSR);
+
 /*
  * Commands to do_syslog:
  *
@@ -649,6 +665,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	char *p;
 
 	boot_delay_msec();
+	halt_delay_msec();
 
 	preempt_disable();
 	/* This stops the holder of console_sem just where we want him */
