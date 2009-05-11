Return-Path: <linux-kernel-owner+w=401wt.eu-S1761215AbZEKXT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761215AbZEKXT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbZEKXTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:19:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59550 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbZEKXTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:19:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: x86@kernel.org
Subject: [PATCH v2] x86: fix ktermios-termio conversion
Date: Mon, 11 May 2009 23:19:17 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>
References: <20090511222702.352192505@arndb.de> <20090511222702.352192505@arndb.de>> <200905112259.04714.arnd@arndb.de>
In-Reply-To: <200905112259.04714.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905112319.17999.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18ceBljhUq1H2j30RS3ITxMYePbSvUdq9ceFtj
 mUygN43twnlR5TV18q80dFu8QNrAceHr/MOJgixyop5G9TCgJf
 ngVh6E8MRh80FU+uAfrHg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The operation with the variable 'c_line' was missing in the function
'user_termio_to_kernel_termios'. Also the casting '*(unsigned short *)'
in the macro 'SET_LOW_TERMIOS_BITS' was a bit 'unhealthy'. So the macro
was removed and the function was changed to be like in other archs
(e.g. h8300, m68k, sparc) that have a more elegant solution.

In the function 'kernel_termios_to_user_termio' the return values of
the functions calls 'put_user' and 'copy_to_user' were not being
checked.

Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---

initial patch was wordwrapped, resend

 arch/x86/include/asm/termios.h |   54 +++++++++++++++++++++++++++------------
 1 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/termios.h b/arch/x86/include/asm/termios.h
index f729563..47420df 100644
--- a/arch/x86/include/asm/termios.h
+++ b/arch/x86/include/asm/termios.h
@@ -54,20 +54,37 @@ struct termio {
 /*
  * Translate a "termio" structure into a "termios". Ugh.
  */
-#define SET_LOW_TERMIOS_BITS(termios, termio, x) { \
-	unsigned short __tmp; \
-	get_user(__tmp,&(termio)->x); \
-	*(unsigned short *) &(termios)->x = __tmp; \
-}
-
 static inline int user_termio_to_kernel_termios(struct ktermios *termios,
 						struct termio __user *termio)
 {
-	SET_LOW_TERMIOS_BITS(termios, termio, c_iflag);
-	SET_LOW_TERMIOS_BITS(termios, termio, c_oflag);
-	SET_LOW_TERMIOS_BITS(termios, termio, c_cflag);
-	SET_LOW_TERMIOS_BITS(termios, termio, c_lflag);
-	return copy_from_user(termios->c_cc, termio->c_cc, NCC);
+	unsigned short tmp;
+
+	if (get_user(tmp, &termio->c_iflag) < 0)
+		goto fault;
+	termios->c_iflag = (0xffff0000 & termios->c_iflag) | tmp;
+
+	if (get_user(tmp, &termio->c_oflag) < 0)
+		goto fault;
+	termios->c_oflag = (0xffff0000 & termios->c_oflag) | tmp;
+
+	if (get_user(tmp, &termio->c_cflag) < 0)
+		goto fault;
+	termios->c_cflag = (0xffff0000 & termios->c_cflag) | tmp;
+
+	if (get_user(tmp, &termio->c_lflag) < 0)
+		goto fault;
+	termios->c_lflag = (0xffff0000 & termios->c_lflag) | tmp;
+
+	if (get_user(termios->c_line, &termio->c_line) < 0)
+		goto fault;
+
+	if (copy_from_user(termios->c_cc, termio->c_cc, NCC) != 0)
+		goto fault;
+
+	return 0;
+
+ fault:
+	return -EFAULT;
 }
 
 /*
@@ -76,12 +93,15 @@ static inline int user_termio_to_kernel_termios(struct ktermios *termios,
 static inline int kernel_termios_to_user_termio(struct termio __user *termio,
 					    struct ktermios *termios)
 {
-	put_user((termios)->c_iflag, &(termio)->c_iflag);
-	put_user((termios)->c_oflag, &(termio)->c_oflag);
-	put_user((termios)->c_cflag, &(termio)->c_cflag);
-	put_user((termios)->c_lflag, &(termio)->c_lflag);
-	put_user((termios)->c_line,  &(termio)->c_line);
-	return copy_to_user((termio)->c_cc, (termios)->c_cc, NCC);
+	if (put_user(termios->c_iflag, &termio->c_iflag) < 0 ||
+	    put_user(termios->c_oflag, &termio->c_oflag) < 0 ||
+	    put_user(termios->c_cflag, &termio->c_cflag) < 0 ||
+	    put_user(termios->c_lflag, &termio->c_lflag) < 0 ||
+	    put_user(termios->c_line,  &termio->c_line) < 0 ||
+	    copy_to_user(termio->c_cc, termios->c_cc, NCC) != 0)
+		return -EFAULT;
+
+	return 0;
 }
 
 static inline int user_termios_to_kernel_termios(struct ktermios *k,
-- 
1.6.0.4

