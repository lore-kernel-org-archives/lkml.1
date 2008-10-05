Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbYJEQPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbYJEQPu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbYJEQJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:09:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48474 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756537AbYJEQJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:09:16 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 31/76] tty: Cris has a nice RS485 ioctl so we should steal it
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:09:16 +0100
Message-ID: <20081005160858.1997.45339.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index c0c338b..2cd4775 100644
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

