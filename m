Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbYGKM7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbYGKM7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 08:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYGKM7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 08:59:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbYGKM7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 08:59:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix the (i)Stallion driver's putchar() and break_ctl() ops
To: alan@redhat.com, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 11 Jul 2008 13:59:00 +0100
Message-ID: <20080711125900.22945.3639.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the Stallion driver's putchar() and break_ctl() ops and iStallion's
putchar() to return values.

Is it actually possible for putchar() or break_ctl() to be called with tty ==
NULL or can the check be discarded?

Should stl_write() be returning 0 if tty->driver_data is NULL or tx.buf is
NULL?  Is this even possible?

I've made Stallion's functions return -EINVAL as stli_breakctl() if the checks
fail.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/char/istallion.c |    5 +++--
 drivers/char/stallion.c  |   16 +++++++++-------
 2 files changed, 12 insertions(+), 9 deletions(-)


diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 89d56c0..d90803e 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -598,7 +598,7 @@ static int	stli_parsebrd(struct stlconf *confp, char **argp);
 static int	stli_open(struct tty_struct *tty, struct file *filp);
 static void	stli_close(struct tty_struct *tty, struct file *filp);
 static int	stli_write(struct tty_struct *tty, const unsigned char *buf, int count);
-static void	stli_putchar(struct tty_struct *tty, unsigned char ch);
+static int	stli_putchar(struct tty_struct *tty, unsigned char ch);
 static void	stli_flushchars(struct tty_struct *tty);
 static int	stli_writeroom(struct tty_struct *tty);
 static int	stli_charsinbuffer(struct tty_struct *tty);
@@ -1333,7 +1333,7 @@ static int stli_write(struct tty_struct *tty, const unsigned char *buf, int coun
  *	first them do the new ports.
  */
 
-static void stli_putchar(struct tty_struct *tty, unsigned char ch)
+static int stli_putchar(struct tty_struct *tty, unsigned char ch)
 {
 	if (tty != stli_txcooktty) {
 		if (stli_txcooktty != NULL)
@@ -1342,6 +1342,7 @@ static void stli_putchar(struct tty_struct *tty, unsigned char ch)
 	}
 
 	stli_txcookbuf[stli_txcooksize++] = ch;
+	return 0;
 }
 
 /*****************************************************************************/
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 2eeb9b2..19db1eb 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -1025,7 +1025,7 @@ static int stl_write(struct tty_struct *tty, const unsigned char *buf, int count
 
 /*****************************************************************************/
 
-static void stl_putchar(struct tty_struct *tty, unsigned char ch)
+static int stl_putchar(struct tty_struct *tty, unsigned char ch)
 {
 	struct stlport	*portp;
 	unsigned int	len;
@@ -1034,12 +1034,12 @@ static void stl_putchar(struct tty_struct *tty, unsigned char ch)
 	pr_debug("stl_putchar(tty=%p,ch=%x)\n", tty, ch);
 
 	if (tty == NULL)
-		return;
+		return -EINVAL;
 	portp = tty->driver_data;
 	if (portp == NULL)
-		return;
+		return -EINVAL;
 	if (portp->tx.buf == NULL)
-		return;
+		return -EINVAL;
 
 	head = portp->tx.head;
 	tail = portp->tx.tail;
@@ -1053,6 +1053,7 @@ static void stl_putchar(struct tty_struct *tty, unsigned char ch)
 			head = portp->tx.buf;
 	}	
 	portp->tx.head = head;
+	return 0;
 }
 
 /*****************************************************************************/
@@ -1459,19 +1460,20 @@ static void stl_hangup(struct tty_struct *tty)
 
 /*****************************************************************************/
 
-static void stl_breakctl(struct tty_struct *tty, int state)
+static int stl_breakctl(struct tty_struct *tty, int state)
 {
 	struct stlport	*portp;
 
 	pr_debug("stl_breakctl(tty=%p,state=%d)\n", tty, state);
 
 	if (tty == NULL)
-		return;
+		return -EINVAL;
 	portp = tty->driver_data;
 	if (portp == NULL)
-		return;
+		return -EINVAL;
 
 	stl_sendbreak(portp, ((state == -1) ? 1 : 2));
+	return 0;
 }
 
 /*****************************************************************************/

