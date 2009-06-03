Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbZFCDJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbZFCDJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 23:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZFCDJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 23:09:26 -0400
Received: from mail-pz0-f109.google.com ([209.85.222.109]:50430 "EHLO
	mail-pz0-f109.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbZFCDJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 23:09:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nLZvH4qQkd9XSf1jlmIX5w9a1tZrHSEomRiR+Tq4QwLSVLvygrgls0sqhFn5nRUOt3
         T1jyn0h7iM4iv1wVADfzUB3GMEFJfCJeaP0OTn84DYGaZLmhq4OA+Fgj2S2wBJW9lMV9
         BmEwhc5Cz+TEPZHgEUh6jc1Ynn6pdMjfQL4w4=
MIME-Version: 1.0
Date: Wed, 3 Jun 2009 11:09:27 +0800
Message-ID: <a8e1da0906022009q4a6cf385t83c202e79f962b12@mail.gmail.com>
Subject: [PATCH v2] printk: add halt_delay parameter for printk delay in halt 
	phase
From: Dave Young <hidave.darkstar@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
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
kernel/printk.c |   16 ++++++++++++++++
1 file changed, 16 insertions(+)

--- linux-2.6.orig/kernel/printk.c	2009-06-03 10:16:55.000000000 +0800
+++ linux-2.6/kernel/printk.c	2009-06-03 10:32:43.000000000 +0800
@@ -250,6 +250,22 @@ static inline void boot_delay_msec(void)
 }
 #endif

+/* msecs delay after each halt/poweroff/restart phase printk,
+unsigned short is enough for delay in milliseconds */
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
