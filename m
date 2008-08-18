Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbYHRPnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbYHRPnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 11:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYHRPnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 11:43:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55791 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751713AbYHRPnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 11:43:24 -0400
Date: Mon, 18 Aug 2008 16:25:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Tosoni" <jp.tosoni@acksys.fr>
Cc: "'Laurent Pinchart'" <laurentp@cse-semaphore.com>,
       "'Aristeu Rozanski'" <arozansk@redhat.com>,
       <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] 8250: add support for DTR/DSR hardware flow control
Message-ID: <20080818162526.1975dace@lxorguk.ukuu.org.uk>
In-Reply-To: <000f01c8f88c$ad29d950$2e01a8c0@acksys.local>
References: <200808071032.16709.laurentp@cse-semaphore.com>
	<000f01c8f88c$ad29d950$2e01a8c0@acksys.local>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2008 14:54:05 +0200
"Tosoni" <jp.tosoni@acksys.fr> wrote:

> About a RS485 ioctl: could you consider the attached files which are already
> in the Linux kernel (in include/asm-cris).
> They define a TIOCSERSETRS485 (ioctl.h), and the data structure (rs485.h)
> with allows to specify timings. Sounds just like what we want ?

I had a deeper look at this for RS485 and the answer is "sort of". I've
reworked the structure to keep it the same size irrespective of 32/64bit
systems, and to make stuff flags that can be, plus add some extra u32
words in case we need to (.. when we need to ;)) add stuff later.

Comments, thoughts - will this do what people in the RS485 world need ?

Alan
--------------

tty: Cris has a nice RS485 ioctl so we should steal it

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
