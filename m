Return-Path: <linux-kernel-owner+w=401wt.eu-S1752726AbYJaO60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbYJaO60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 10:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYJaO6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 10:58:17 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:61611 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751250AbYJaO6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 10:58:17 -0400
Date: Fri, 31 Oct 2008 15:58:16 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: console_sem locking annotations?
Message-ID: <Pine.LNX.4.64.0810311555240.23424@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-344480228-1225465096=:23424"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-344480228-1225465096=:23424
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

	Hi,

I'm trying to add sparse locking annotations for console_sem.
However, I don't know how to handle try_acquire_console_sem().

Without handling it, I get e.g.:

| drivers/video/ps3fb.c:533:24: warning: context problem in 'ps3fb_release': 'release_console_sem' expected different context
| drivers/video/ps3fb.c:533:24:    context 'console_sem': wanted >= 1, got 0

I tried handling it using __cond_lock() --- as is used for e.g. spin_trylock()
--- but it didn't work. Besides, with spin_trylock(), I also get:

| drivers/char/vt.c:2524:2: warning: context problem in 'vt_console_print': '_spin_unlock' expected different context
| drivers/char/vt.c:2524:2:    context 'lock': wanted >= 1, got 0

so it looks like it won't work anyway?

Anyone with a clue? Thanks!

---
 include/linux/console.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -115,9 +115,9 @@ extern int update_console_cmdline(char *
 extern void register_console(struct console *);
 extern int unregister_console(struct console *);
 extern struct console *console_drivers;
-extern void acquire_console_sem(void);
-extern int try_acquire_console_sem(void);
-extern void release_console_sem(void);
+extern void acquire_console_sem(void) __acquires(console_sem);
+extern int try_acquire_console_sem(void);	// ??? FIXME
+extern void release_console_sem(void) __releases(console_sem);
 extern void console_conditional_schedule(void);
 extern void console_unblank(void);
 extern struct tty_driver *console_device(int *);

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-344480228-1225465096=:23424--
