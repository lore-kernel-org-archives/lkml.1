Return-Path: <linux-kernel-owner+w=401wt.eu-S1763416AbYJMJrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763416AbYJMJrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761158AbYJMJhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:37:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48652 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757335AbYJMJhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:37:51 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 37/80] tty: Cris has a nice RS485 ioctl so we should steal it
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:37:48 +0100
Message-ID: <20081013093741.21645.21338.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

JP Tosoni observed:

"About a RS485 ioctl: could you consider the attached files which are
 already in the Linux kernel (in include/asm-cris).  They define a
 TIOCSERSETRS485 (ioctl.h), and the data structure (rs485.h)
 with allows to specify timings. Sounds just like what we want ?"

and he's right: sort of. Rework the structure to use flag bits and make the
time delay a fixed sized field so we don't get 32/64bit problems. Add the ioctls
to x86 so that people know what to add to their platform of choice.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 include/asm-x86/ioctls.h |    2 ++
 include/linux/serial.h   |   16 ++++++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)


diff --git a/include/asm-x86/ioctls.h b/include/asm-x86/ioctls.h
index 3366035..1a8ac45 100644
--- a/include/asm-x86/ioctls.h
+++ b/include/asm-x86/ioctls.h
@@ -51,6 +51,8 @@
 #define TCSETS2		_IOW('T', 0x2B, struct termios2)
 #define TCSETSW2	_IOW('T', 0x2C, struct termios2)
 #define TCSETSF2	_IOW('T', 0x2D, struct termios2)
+#define TIOCGRS485	0x542E
+#define TIOCSRS485	0x542F
 #define TIOCGPTN	_IOR('T', 0x30, unsigned int)
 				/* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
diff --git a/include/linux/serial.h b/include/linux/serial.h
index deb7143..1ea8d92 100644
--- a/include/linux/serial.h
+++ b/include/linux/serial.h
@@ -173,6 +173,22 @@ struct serial_icounter_struct {
 	int reserved[9];
 };
 
+/*
+ * Serial interface for controlling RS485 settings on chips with suitable
+ * support. Set with TIOCSRS485 and get with TIOCGRS485 if supported by your
+ * platform. The set function returns the new state, with any unsupported bits
+ * reverted appropriately.
+ */
+
+struct serial_rs485 {
+	__u32	flags;			/* RS485 feature flags */
+#define SER_RS485_ENABLED		(1 << 0)
+#define SER_RS485_RTS_ON_SEND		(1 << 1)
+#define SER_RS485_RTS_AFTER_SEND	(1 << 2)
+	__u32	delay_rts_before_send;	/* Milliseconds */
+	__u32	padding[6];		/* Memory is cheap, new structs
+					   are a royal PITA .. */
+};
 
 #ifdef __KERNEL__
 #include <linux/compiler.h>

