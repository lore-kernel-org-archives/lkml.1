Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbXJaIE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbXJaIE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 04:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbXJaIEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 04:04:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52089
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753716AbXJaID7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 04:03:59 -0400
Date: Wed, 31 Oct 2007 01:03:58 -0700 (PDT)
Message-Id: <20071031.010358.198439278.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
CC: linux-kernel@vger.kernel.org
Subject: termios bug fix proposal
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Right now there is at least one case in the tree (IRNET PPP)
where either the build is failing or garbage is being moved
to/from userspace for TCGETS and TCSETSF calls.

This is happening silently on x86 and friends because there is zero
type checking in these termios translator macros.

I include two changes below.  The irnet_ppp.c change, which is build
tested on sparc64 (where it was failing) and I think this should be
popped over to -stable too.  And also an example termios.h header
change for x86 that I would like see integrated in some shape or form,
and extended to all architectures that do things like this.

In this way such silent incorrect data won't slip through the cracks
any more.

This problem has existed for some time Alan, so I would appreciate
it very much if you would help me move things forward on this.

Thanks!

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/asm-x86/termios.h b/include/asm-x86/termios.h
index d501748..9fe4dc7 100644
--- a/include/asm-x86/termios.h
+++ b/include/asm-x86/termios.h
@@ -41,6 +41,8 @@ struct termio {
 
 #ifdef __KERNEL__
 
+#include <asm/uaccess.h>
+
 /*	intr=^C		quit=^\		erase=del	kill=^U
 	eof=^D		vtime=\0	vmin=\1		sxtc=\0
 	start=^Q	stop=^S		susp=^Z		eol=\0
@@ -58,39 +60,53 @@ struct termio {
 	*(unsigned short *) &(termios)->x = __tmp; \
 }
 
-#define user_termio_to_kernel_termios(termios, termio) \
-({ \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_iflag); \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_oflag); \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_cflag); \
-	SET_LOW_TERMIOS_BITS(termios, termio, c_lflag); \
-	copy_from_user((termios)->c_cc, (termio)->c_cc, NCC); \
-})
+static inline int user_termio_to_kernel_termios(struct termios *termios,
+						struct termio __user *termio)
+{
+	SET_LOW_TERMIOS_BITS(termios, termio, c_iflag);
+	SET_LOW_TERMIOS_BITS(termios, termio, c_oflag);
+	SET_LOW_TERMIOS_BITS(termios, termio, c_cflag);
+	SET_LOW_TERMIOS_BITS(termios, termio, c_lflag);
+	return copy_from_user(termios->c_cc, termio->c_cc, NCC);
+}
 
 /*
  * Translate a "termios" structure into a "termio". Ugh.
  */
-#define kernel_termios_to_user_termio(termio, termios) \
-({ \
-	put_user((termios)->c_iflag, &(termio)->c_iflag); \
-	put_user((termios)->c_oflag, &(termio)->c_oflag); \
-	put_user((termios)->c_cflag, &(termio)->c_cflag); \
-	put_user((termios)->c_lflag, &(termio)->c_lflag); \
-	put_user((termios)->c_line,  &(termio)->c_line); \
-	copy_to_user((termio)->c_cc, (termios)->c_cc, NCC); \
-})
-
-#define user_termios_to_kernel_termios(k, u) \
-	copy_from_user(k, u, sizeof(struct termios2))
-
-#define kernel_termios_to_user_termios(u, k) \
-	copy_to_user(u, k, sizeof(struct termios2))
-
-#define user_termios_to_kernel_termios_1(k, u) \
-	copy_from_user(k, u, sizeof(struct termios))
-
-#define kernel_termios_to_user_termios_1(u, k) \
-	copy_to_user(u, k, sizeof(struct termios))
+static inline kernel_termios_to_user_termio(struct termio __user *termio,
+					    struct termios *termios)
+{
+	put_user((termios)->c_iflag, &(termio)->c_iflag);
+	put_user((termios)->c_oflag, &(termio)->c_oflag);
+	put_user((termios)->c_cflag, &(termio)->c_cflag);
+	put_user((termios)->c_lflag, &(termio)->c_lflag);
+	put_user((termios)->c_line,  &(termio)->c_line);
+	return copy_to_user((termio)->c_cc, (termios)->c_cc, NCC);
+}
+
+static inline int user_termios_to_kernel_termios(struct termios2 *k,
+						 struct termios2 __user *u)
+{
+	return copy_from_user(k, u, sizeof(struct termios2));
+}
+
+static inline int kernel_termios_to_user_termios(struct termios2 __user *u,
+						 struct termios2 *k)
+{
+	return copy_to_user(u, k, sizeof(struct termios2));
+}
+
+static inline int user_termios_to_kernel_termios_1(struct termios *k,
+						   struct termios __user *u)
+{
+	return copy_from_user(k, u, sizeof(struct termios));
+}
+
+static inline int kernel_termios_to_user_termios_1(struct termios __user *u,
+						   struct termios *k)
+{
+	return copy_to_user(u, k, sizeof(struct termios));
+}
 
 #endif	/* __KERNEL__ */
 
diff --git a/net/irda/irnet/irnet_ppp.c b/net/irda/irnet/irnet_ppp.c
index 2f9f8dc..e0eab59 100644
--- a/net/irda/irnet/irnet_ppp.c
+++ b/net/irda/irnet/irnet_ppp.c
@@ -731,15 +731,25 @@ dev_irnet_ioctl(struct inode *	inode,
       /* Get termios */
     case TCGETS:
       DEBUG(FS_INFO, "Get termios.\n");
+#ifndef TCGETS2
       if(kernel_termios_to_user_termios((struct termios __user *)argp, &ap->termios))
 	break;
+#else
+      if(kernel_termios_to_user_termios_1((struct termios __user *)argp, &ap->termios))
+	break;
+#endif
       err = 0;
       break;
       /* Set termios */
     case TCSETSF:
       DEBUG(FS_INFO, "Set termios.\n");
+#ifndef TCGETS2
       if(user_termios_to_kernel_termios(&ap->termios, (struct termios __user *)argp))
 	break;
+#else
+      if(user_termios_to_kernel_termios_1(&ap->termios, (struct termios __user *)argp))
+	break;
+#endif
       err = 0;
       break;
 
