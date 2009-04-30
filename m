Return-Path: <linux-kernel-owner+w=401wt.eu-S1764058AbZD3Qpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764058AbZD3Qpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763221AbZD3Qox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:44:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50537 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757809AbZD3Qov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:44:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: x86@vger.kernel.org
Subject: [PATCH 1/2] x86: two small fixes in termios.h
Date: Thu, 30 Apr 2009 18:40:45 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de> <200904301839.08854.arnd@arndb.de>
In-Reply-To: <200904301839.08854.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904301840.45666.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19DB+Vghtb9p4iy1teAWLG0rPJOBdj24u+0UA6
 +QqBkyn7japhpKOmHKwtEMoa2Ab9XKkdkre3g+lWcGE9DzstyZ
 zQa/PiBbMaqzpcLVdtk8w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Remis Lima Baima <remis.developer@googlemail.com>

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
 arch/x86/include/asm/termios.h |   56 +++++++++++++++++++++++++++-------------
 1 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/termios.h b/arch/x86/include/asm/termios.h
index f729563..cbfc2d5 100644
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
-{
-	SET_LOW_TERMIOS_BITS(termios, termio, c_iflag);
-	SET_LOW_TERMIOS_BITS(termios, termio, c_oflag);
-	SET_LOW_TERMIOS_BITS(termios, termio, c_cflag);
-	SET_LOW_TERMIOS_BITS(termios, termio, c_lflag);
-	return copy_from_user(termios->c_cc, termio->c_cc, NCC);
+{
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

