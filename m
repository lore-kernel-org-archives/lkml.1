Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbZIERBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbZIERBA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 13:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZIERA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 13:00:59 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:44577 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbZIERA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 13:00:58 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's testsuite
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	<19099.52899.620345.326521@pilspetsen.it.uu.se>
	<19100.31254.666066.755541@pilspetsen.it.uu.se>
	<200909012042.59856.rjw@sisk.pl>
	<alpine.LFD.2.00.0909021429360.3590@eeepc.linux-foundation.org>
	<19105.5352.28380.230615@pilspetsen.it.uu.se>
	<alpine.LFD.2.00.0909040729490.5232@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040739060.17375@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040753370.17375@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040804450.23850@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040910140.4537@eeepc.linux-foundation.org>
Date: Sun, 06 Sep 2009 02:00:52 +0900
In-Reply-To: <alpine.LFD.2.00.0909040910140.4537@eeepc.linux-foundation.org>
	(Linus Torvalds's message of "Fri, 4 Sep 2009 09:11:58 -1000 (HST)")
Message-ID: <87pra55nsr.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, 4 Sep 2009, Linus Torvalds wrote:
>> 
>> So I'm starting to suspect that the real bug is that we do that 
>> 'pty_space()' in pty_write() call at all. The _callers_ should already 
>> have done the write_room() check, and if somebody doesn't do it, then the 
>> tty buffering will eventually do a hard limit at the 65kB allocation mark.
>
> Ok, so the thought was right, but the patch was obviously not even 
> compiled, because the compiler points out that 'c' was not initialized.
>
> I'm sure you already figured the obvious meaning out, but here's a fixed 
> version.

This is not meaning to object to your patch though, I think we would be
good to fix pty_space(), not leaving as wrong. With fix it, I guess we
don't get strange behavior in the near of buffer limit.

Also, it seems the non-n_tty path doesn't use tty_write_room() check,
and instead it just try to write and check written bytes which returned
by tty->ops->write().

So, it will use the 64kb limit at least few paths, and I'm not sure
though, non-n_tty path (e.g. ppp) doesn't use tty_write_room() check
always. It may not be consistent if we removed pty_space() in pty_write().

So, it may not be issue though, I made this patch to fix
pty_space(). What do you think?

Well, anyway, I've tested your patch and this patch fixed the
gcc-testsuite on my machine.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>



Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

diff -puN drivers/char/pty.c~tty-debug drivers/char/pty.c
--- linux-2.6/drivers/char/pty.c~tty-debug	2009-09-05 20:10:35.000000000 +0900
+++ linux-2.6-hirofumi/drivers/char/pty.c	2009-09-06 01:50:44.000000000 +0900
@@ -91,7 +91,7 @@ static void pty_unthrottle(struct tty_st
 
 static int pty_space(struct tty_struct *to)
 {
-	int n = 8192 - to->buf.memory_used;
+	int n = 8192 - tty_buffer_used(to);
 	if (n < 0)
 		return 0;
 	return n;
diff -puN drivers/char/tty_buffer.c~tty-debug drivers/char/tty_buffer.c
--- linux-2.6/drivers/char/tty_buffer.c~tty-debug	2009-09-05 21:02:48.000000000 +0900
+++ linux-2.6-hirofumi/drivers/char/tty_buffer.c	2009-09-05 21:08:47.000000000 +0900
@@ -231,6 +231,30 @@ int tty_buffer_request_room(struct tty_s
 EXPORT_SYMBOL_GPL(tty_buffer_request_room);
 
 /**
+ *	tty_buffer_used		-	return used tty buffer size
+ *	@tty: tty structure
+ *
+ *	Return used tty buffer size.
+ */
+size_t tty_buffer_used(struct tty_struct *tty)
+{
+	size_t size;
+	int left;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tty->buf.lock, flags);
+	if (tty->buf.tail)
+		left = tty->buf.tail->size - tty->buf.tail->used;
+	else
+		left = 0;
+	size = tty->buf.memory_used - left;
+	spin_unlock_irqrestore(&tty->buf.lock, flags);
+
+	return size;
+}
+EXPORT_SYMBOL_GPL(tty_buffer_used);
+
+/**
  *	tty_insert_flip_string	-	Add characters to the tty buffer
  *	@tty: tty structure
  *	@chars: characters
diff -puN include/linux/tty_flip.h~tty-debug include/linux/tty_flip.h
--- linux-2.6/include/linux/tty_flip.h~tty-debug	2009-09-05 21:06:25.000000000 +0900
+++ linux-2.6-hirofumi/include/linux/tty_flip.h	2009-09-05 21:06:39.000000000 +0900
@@ -2,6 +2,7 @@
 #define _LINUX_TTY_FLIP_H
 
 extern int tty_buffer_request_room(struct tty_struct *tty, size_t size);
+extern size_t tty_buffer_used(struct tty_struct *tty);
 extern int tty_insert_flip_string(struct tty_struct *tty, const unsigned char *chars, size_t size);
 extern int tty_insert_flip_string_flags(struct tty_struct *tty, const unsigned char *chars, const char *flags, size_t size);
 extern int tty_prepare_flip_string(struct tty_struct *tty, unsigned char **chars, size_t size);
_
