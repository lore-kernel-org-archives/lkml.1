Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbYGUJyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbYGUJyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 05:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbYGUJy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 05:54:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51653 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbYGUJy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 05:54:27 -0400
Message-ID: <48845B8B.300@cn.fujitsu.com>
Date: Mon, 21 Jul 2008 17:48:59 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Alan Cox <alan@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [build error] istallion build failure
References: <48845504.20102@cn.fujitsu.com>
In-Reply-To: <48845504.20102@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wang Chen said the following on 2008-7-21 17:21:
> Alan, commit "istallion: use tty_port"(b02f5ad6a3ff5a1ee2a7b8ec6eee338de553b060)
> is guilty.
> 
> drivers/char/istallion.c: In function ‘stli_open’:
> drivers/char/istallion.c:829: error: ‘struct stliport’ has no member named ‘refcount’
> drivers/char/istallion.c: In function ‘stli_close’:
> drivers/char/istallion.c:891: error: ‘struct stliport’ has no member named ‘refcount’
> drivers/char/istallion.c:892: error: ‘struct stliport’ has no member named ‘refcount’
> drivers/char/istallion.c:893: error: ‘struct stliport’ has no member named ‘refcount’
> drivers/char/istallion.c:928: error: ‘struct tty_ldisc’ has no member named ‘flush_buffer’
> drivers/char/istallion.c:929: error: ‘struct tty_ldisc’ has no member named ‘flush_buffer’
> drivers/char/istallion.c: In function ‘stli_waitcarrier’:
> drivers/char/istallion.c:1205: error: ‘struct stliport’ has no member named ‘refcount’
> drivers/char/istallion.c:1234: error: ‘struct stliport’ has no member named ‘refcount’
> drivers/char/istallion.c: In function ‘stli_ioctl’:
> drivers/char/istallion.c:1663: warning: unused variable ‘ival’
> drivers/char/istallion.c: In function ‘stli_hangup’:
> drivers/char/istallion.c:1860: error: ‘struct stliport’ has no member named ‘refcount’
> drivers/char/istallion.c: In function ‘stli_portcmdstats’:
> drivers/char/istallion.c:4249: error: ‘struct tty_port’ has no member named ‘flag’
> drivers/char/istallion.c: At top level:
> drivers/char/istallion.c:4500: warning: initialization from incompatible pointer type
> make[2]: *** [drivers/char/istallion.o] Error 1
> make[1]: *** [drivers/char] Error 2
> make: *** [drivers] Error 2
> 

Fix the compile error which was caused by commit "istallion: use tty_port" and "tty: Ldisc revamp".
Also make the warning silent.

Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
---
diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 6ef1c56..7930fba 100644
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
@@ -826,7 +826,7 @@ static int stli_open(struct tty_struct *tty, struct file *filp)
  */
 	portp->port.tty = tty;
 	tty->driver_data = portp;
-	portp->refcount++;
+	portp->port.count++;
 
 	wait_event_interruptible(portp->raw_wait,
 			!test_bit(ST_INITIALIZING, &portp->state));
@@ -888,9 +888,9 @@ static void stli_close(struct tty_struct *tty, struct file *filp)
 		spin_unlock_irqrestore(&stli_lock, flags);
 		return;
 	}
-	if ((tty->count == 1) && (portp->refcount != 1))
-		portp->refcount = 1;
-	if (portp->refcount-- > 1) {
+	if ((tty->count == 1) && (portp->port.count != 1))
+		portp->port.count = 1;
+	if (portp->port.count-- > 1) {
 		spin_unlock_irqrestore(&stli_lock, flags);
 		return;
 	}
@@ -925,8 +925,8 @@ static void stli_close(struct tty_struct *tty, struct file *filp)
 	clear_bit(ST_TXBUSY, &portp->state);
 	clear_bit(ST_RXSTOP, &portp->state);
 	set_bit(TTY_IO_ERROR, &tty->flags);
-	if (tty->ldisc.flush_buffer)
-		(tty->ldisc.flush_buffer)(tty);
+	if (tty->ldisc.ops->flush_buffer)
+		(tty->ldisc.ops->flush_buffer)(tty);
 	set_bit(ST_DOFLUSHRX, &portp->state);
 	stli_flushbuffer(tty);
 
@@ -1202,7 +1202,7 @@ static int stli_waitcarrier(struct stlibrd *brdp, struct stliport *portp, struct
 	spin_lock_irqsave(&stli_lock, flags);
 	portp->openwaitcnt++;
 	if (! tty_hung_up_p(filp))
-		portp->refcount--;
+		portp->port.count--;
 	spin_unlock_irqrestore(&stli_lock, flags);
 
 	for (;;) {
@@ -1231,7 +1231,7 @@ static int stli_waitcarrier(struct stlibrd *brdp, struct stliport *portp, struct
 
 	spin_lock_irqsave(&stli_lock, flags);
 	if (! tty_hung_up_p(filp))
-		portp->refcount++;
+		portp->port.count++;
 	portp->openwaitcnt--;
 	spin_unlock_irqrestore(&stli_lock, flags);
 
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
@@ -1660,7 +1661,6 @@ static int stli_ioctl(struct tty_struct *tty, struct file *file, unsigned int cm
 {
 	struct stliport *portp;
 	struct stlibrd *brdp;
-	unsigned int ival;
 	int rc;
 	void __user *argp = (void __user *)arg;
 
@@ -1857,7 +1857,7 @@ static void stli_hangup(struct tty_struct *tty)
 	set_bit(TTY_IO_ERROR, &tty->flags);
 	portp->port.tty = NULL;
 	portp->port.flags &= ~ASYNC_NORMAL_ACTIVE;
-	portp->refcount = 0;
+	portp->port.count = 0;
 	spin_unlock_irqrestore(&stli_lock, flags);
 
 	wake_up_interruptible(&portp->port.open_wait);
@@ -4246,7 +4246,7 @@ static int stli_portcmdstats(struct stliport *portp)
 	stli_comstats.panel = portp->panelnr;
 	stli_comstats.port = portp->portnr;
 	stli_comstats.state = portp->state;
-	stli_comstats.flags = portp->port.flag;
+	stli_comstats.flags = portp->port.flags;
 
 	spin_lock_irqsave(&brd_lock, flags);
 	if (portp->port.tty != NULL) {


