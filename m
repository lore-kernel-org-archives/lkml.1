Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbZFHHkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbZFHHkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 03:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZFHHkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 03:40:18 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:55515 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbZFHHkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 03:40:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LtF2xaNd1mtQhIHb9N8VlcqWQTZZ+xDsGWFQi9EAyV1T1u920wbPM3Ih695i6CEosc
         8xBBk8c+RKwk6NX7tLN/WB2FV8olwXfMBKQg6iF9AkhEIofv9pev6lTwf6G81fTE06A7
         6L2ka6fMOF6rsNtIvPrPz003Qz1o5U1maTDyU=
MIME-Version: 1.0
Date: Mon, 8 Jun 2009 15:40:07 +0800
Message-ID: <a8e1da0906080040k7852f770v1e2aa2ebb0f52369@mail.gmail.com>
Subject: [PATCH v3] printk: add halt_delay parameter for printk delay in halt 
	phase
From: Dave Young <hidave.darkstar@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a halt_delay module parameter in printk.c used to read the printk
messages in halt/poweroff/restart phase, delay each printk messages
by halt_delay milliseconds. It is useful for debugging if there's no
other way to dump kernel messages that time.

The halt_delay max value is 65535, default value is 0, change it by:

echo xxx > /sys/module/printk/parameters/halt_delay

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
Documentation/kernel-parameters.txt |    5 +++++
kernel/printk.c                     |   17 +++++++++++++++++
2 files changed, 22 insertions(+)

--- linux-2.6.orig/kernel/printk.c	2009-06-08 13:55:35.000000000 +0800
+++ linux-2.6/kernel/printk.c	2009-06-08 13:56:23.000000000 +0800
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
@@ -649,6 +665,7 @@ asmlinkage int vprintk(const char *fmt,
 	char *p;

 	boot_delay_msec();
+	halt_delay_msec();

 	preempt_disable();
 	/* This stops the holder of console_sem just where we want him */
--- linux-2.6.orig/Documentation/kernel-parameters.txt	2009-05-28
08:40:42.000000000 +0800
+++ linux-2.6/Documentation/kernel-parameters.txt	2009-06-08
14:06:47.000000000 +0800
@@ -1897,6 +1897,11 @@ and is between 256 and 4096 characters.
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
