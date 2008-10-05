Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbYJEQTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbYJEQTK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbYJEQNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:13:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49590 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757439AbYJEQNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:13:32 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 40/76] stallion: Use krefs
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:13:31 +0100
Message-ID: <20081005161210.1997.73195.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use tty_port_init and krefs in the stallion drivers to protect us from devices
going away underneath us. As with the other drives some rearranging is done to
pass the tty structure down properly on the user side.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/Kconfig     |    4 +-
 drivers/char/istallion.c |  107 +++++++++++++++++++++++++---------------------
 drivers/char/stallion.c  |  105 ++++++++++++++++++++++++++++-----------------
 3 files changed, 123 insertions(+), 93 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index caff851..700ff96 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -350,7 +350,7 @@ config STALDRV
 
 config STALLION
 	tristate "Stallion EasyIO or EC8/32 support"
-	depends on STALDRV && BROKEN_ON_SMP && (ISA || EISA || PCI)
+	depends on STALDRV && (ISA || EISA || PCI)
 	help
 	  If you have an EasyIO or EasyConnection 8/32 multiport Stallion
 	  card, then this is for you; say Y.  Make sure to read
@@ -361,7 +361,7 @@ config STALLION
 
 config ISTALLION
 	tristate "Stallion EC8/64, ONboard, Brumby support"
-	depends on STALDRV && BROKEN_ON_SMP && (ISA || EISA || PCI)
+	depends on STALDRV && (ISA || EISA || PCI)
 	help
 	  If you have an EasyConnection 8/64, ONboard, Brumby or Stallion
 	  serial multiport card, say Y here. Make sure to read
diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 843a2af..96ee112 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -623,24 +623,25 @@ static int	stli_memioctl(struct inode *ip, struct file *fp, unsigned int cmd, un
 static void	stli_brdpoll(struct stlibrd *brdp, cdkhdr_t __iomem *hdrp);
 static void	stli_poll(unsigned long arg);
 static int	stli_hostcmd(struct stlibrd *brdp, struct stliport *portp);
-static int	stli_initopen(struct stlibrd *brdp, struct stliport *portp);
+static int	stli_initopen(struct tty_struct *tty, struct stlibrd *brdp, struct stliport *portp);
 static int	stli_rawopen(struct stlibrd *brdp, struct stliport *portp, unsigned long arg, int wait);
 static int	stli_rawclose(struct stlibrd *brdp, struct stliport *portp, unsigned long arg, int wait);
-static int	stli_waitcarrier(struct stlibrd *brdp, struct stliport *portp, struct file *filp);
-static int	stli_setport(struct stliport *portp);
+static int	stli_waitcarrier(struct tty_struct *tty, struct stlibrd *brdp,
+				struct stliport *portp, struct file *filp);
+static int	stli_setport(struct tty_struct *tty);
 static int	stli_cmdwait(struct stlibrd *brdp, struct stliport *portp, unsigned long cmd, void *arg, int size, int copyback);
 static void	stli_sendcmd(struct stlibrd *brdp, struct stliport *portp, unsigned long cmd, void *arg, int size, int copyback);
 static void	__stli_sendcmd(struct stlibrd *brdp, struct stliport *portp, unsigned long cmd, void *arg, int size, int copyback);
 static void	stli_dodelaycmd(struct stliport *portp, cdkctrl_t __iomem *cp);
-static void	stli_mkasyport(struct stliport *portp, asyport_t *pp, struct ktermios *tiosp);
+static void	stli_mkasyport(struct tty_struct *tty, struct stliport *portp, asyport_t *pp, struct ktermios *tiosp);
 static void	stli_mkasysigs(asysigs_t *sp, int dtr, int rts);
 static long	stli_mktiocm(unsigned long sigvalue);
 static void	stli_read(struct stlibrd *brdp, struct stliport *portp);
 static int	stli_getserial(struct stliport *portp, struct serial_struct __user *sp);
-static int	stli_setserial(struct stliport *portp, struct serial_struct __user *sp);
+static int	stli_setserial(struct tty_struct *tty, struct serial_struct __user *sp);
 static int	stli_getbrdstats(combrd_t __user *bp);
-static int	stli_getportstats(struct stliport *portp, comstats_t __user *cp);
-static int	stli_portcmdstats(struct stliport *portp);
+static int	stli_getportstats(struct tty_struct *tty, struct stliport *portp, comstats_t __user *cp);
+static int	stli_portcmdstats(struct tty_struct *tty, struct stliport *portp);
 static int	stli_clrportstats(struct stliport *portp, comstats_t __user *cp);
 static int	stli_getportstruct(struct stliport __user *arg);
 static int	stli_getbrdstruct(struct stlibrd __user *arg);
@@ -731,12 +732,16 @@ static void stli_cleanup_ports(struct stlibrd *brdp)
 {
 	struct stliport *portp;
 	unsigned int j;
+	struct tty_struct *tty;
 
 	for (j = 0; j < STL_MAXPORTS; j++) {
 		portp = brdp->ports[j];
 		if (portp != NULL) {
-			if (portp->port.tty != NULL)
-				tty_hangup(portp->port.tty);
+			tty = tty_port_tty_get(&portp->port);
+			if (tty != NULL) {
+				tty_hangup(tty);
+				tty_kref_put(tty);
+			}
 			kfree(portp);
 		}
 	}
@@ -824,7 +829,7 @@ static int stli_open(struct tty_struct *tty, struct file *filp)
  *	requires several commands to the board we will need to wait for any
  *	other open that is already initializing the port.
  */
-	portp->port.tty = tty;
+	tty_port_tty_set(&portp->port, tty);
 	tty->driver_data = portp;
 	portp->port.count++;
 
@@ -835,7 +840,7 @@ static int stli_open(struct tty_struct *tty, struct file *filp)
 
 	if ((portp->port.flags & ASYNC_INITIALIZED) == 0) {
 		set_bit(ST_INITIALIZING, &portp->state);
-		if ((rc = stli_initopen(brdp, portp)) >= 0) {
+		if ((rc = stli_initopen(tty, brdp, portp)) >= 0) {
 			portp->port.flags |= ASYNC_INITIALIZED;
 			clear_bit(TTY_IO_ERROR, &tty->flags);
 		}
@@ -864,7 +869,7 @@ static int stli_open(struct tty_struct *tty, struct file *filp)
  *	then also we might have to wait for carrier.
  */
 	if (!(filp->f_flags & O_NONBLOCK)) {
-		if ((rc = stli_waitcarrier(brdp, portp, filp)) != 0)
+		if ((rc = stli_waitcarrier(tty, brdp, portp, filp)) != 0)
 			return rc;
 	}
 	portp->port.flags |= ASYNC_NORMAL_ACTIVE;
@@ -930,7 +935,7 @@ static void stli_close(struct tty_struct *tty, struct file *filp)
 	stli_flushbuffer(tty);
 
 	tty->closing = 0;
-	portp->port.tty = NULL;
+	tty_port_tty_set(&portp->port, NULL);
 
 	if (portp->openwaitcnt) {
 		if (portp->close_delay)
@@ -952,9 +957,9 @@ static void stli_close(struct tty_struct *tty, struct file *filp)
  *	this still all happens pretty quickly.
  */
 
-static int stli_initopen(struct stlibrd *brdp, struct stliport *portp)
+static int stli_initopen(struct tty_struct *tty,
+				struct stlibrd *brdp, struct stliport *portp)
 {
-	struct tty_struct *tty;
 	asynotify_t nt;
 	asyport_t aport;
 	int rc;
@@ -969,10 +974,7 @@ static int stli_initopen(struct stlibrd *brdp, struct stliport *portp)
 	    sizeof(asynotify_t), 0)) < 0)
 		return rc;
 
-	tty = portp->port.tty;
-	if (tty == NULL)
-		return -ENODEV;
-	stli_mkasyport(portp, &aport, tty->termios);
+	stli_mkasyport(tty, portp, &aport, tty->termios);
 	if ((rc = stli_cmdwait(brdp, portp, A_SETPORT, &aport,
 	    sizeof(asyport_t), 0)) < 0)
 		return rc;
@@ -1161,22 +1163,21 @@ static int stli_cmdwait(struct stlibrd *brdp, struct stliport *portp, unsigned l
  *	waiting for the command to complete - so must have user context.
  */
 
-static int stli_setport(struct stliport *portp)
+static int stli_setport(struct tty_struct *tty)
 {
+	struct stliport *portp = tty->driver_data;
 	struct stlibrd *brdp;
 	asyport_t aport;
 
 	if (portp == NULL)
 		return -ENODEV;
-	if (portp->port.tty == NULL)
-		return -ENODEV;
 	if (portp->brdnr >= stli_nrbrds)
 		return -ENODEV;
 	brdp = stli_brds[portp->brdnr];
 	if (brdp == NULL)
 		return -ENODEV;
 
-	stli_mkasyport(portp, &aport, portp->port.tty->termios);
+	stli_mkasyport(tty, portp, &aport, tty->termios);
 	return(stli_cmdwait(brdp, portp, A_SETPORT, &aport, sizeof(asyport_t), 0));
 }
 
@@ -1187,7 +1188,8 @@ static int stli_setport(struct stliport *portp)
  *	maybe because if we are clocal then we don't need to wait...
  */
 
-static int stli_waitcarrier(struct stlibrd *brdp, struct stliport *portp, struct file *filp)
+static int stli_waitcarrier(struct tty_struct *tty, struct stlibrd *brdp,
+				struct stliport *portp, struct file *filp)
 {
 	unsigned long flags;
 	int rc, doclocal;
@@ -1195,7 +1197,7 @@ static int stli_waitcarrier(struct stlibrd *brdp, struct stliport *portp, struct
 	rc = 0;
 	doclocal = 0;
 
-	if (portp->port.tty->termios->c_cflag & CLOCAL)
+	if (tty->termios->c_cflag & CLOCAL)
 		doclocal++;
 
 	spin_lock_irqsave(&stli_lock, flags);
@@ -1572,10 +1574,11 @@ static int stli_getserial(struct stliport *portp, struct serial_struct __user *s
  *	just quietly ignore any requests to change irq, etc.
  */
 
-static int stli_setserial(struct stliport *portp, struct serial_struct __user *sp)
+static int stli_setserial(struct tty_struct *tty, struct serial_struct __user *sp)
 {
 	struct serial_struct sio;
 	int rc;
+	struct stliport *portp = tty->driver_data;
 
 	if (copy_from_user(&sio, sp, sizeof(struct serial_struct)))
 		return -EFAULT;
@@ -1594,7 +1597,7 @@ static int stli_setserial(struct stliport *portp, struct serial_struct __user *s
 	portp->closing_wait = sio.closing_wait;
 	portp->custom_divisor = sio.custom_divisor;
 
-	if ((rc = stli_setport(portp)) < 0)
+	if ((rc = stli_setport(tty)) < 0)
 		return rc;
 	return 0;
 }
@@ -1685,17 +1688,17 @@ static int stli_ioctl(struct tty_struct *tty, struct file *file, unsigned int cm
 		rc = stli_getserial(portp, argp);
 		break;
 	case TIOCSSERIAL:
-		rc = stli_setserial(portp, argp);
+		rc = stli_setserial(tty, argp);
 		break;
 	case STL_GETPFLAG:
 		rc = put_user(portp->pflag, (unsigned __user *)argp);
 		break;
 	case STL_SETPFLAG:
 		if ((rc = get_user(portp->pflag, (unsigned __user *)argp)) == 0)
-			stli_setport(portp);
+			stli_setport(tty);
 		break;
 	case COM_GETPORTSTATS:
-		rc = stli_getportstats(portp, argp);
+		rc = stli_getportstats(tty, portp, argp);
 		break;
 	case COM_CLRPORTSTATS:
 		rc = stli_clrportstats(portp, argp);
@@ -1742,7 +1745,7 @@ static void stli_settermios(struct tty_struct *tty, struct ktermios *old)
 
 	tiosp = tty->termios;
 
-	stli_mkasyport(portp, &aport, tiosp);
+	stli_mkasyport(tty, portp, &aport, tiosp);
 	stli_cmdwait(brdp, portp, A_SETPORT, &aport, sizeof(asyport_t), 0);
 	stli_mkasysigs(&portp->asig, ((tiosp->c_cflag & CBAUD) ? 1 : 0), -1);
 	stli_cmdwait(brdp, portp, A_SETSIGNALS, &portp->asig,
@@ -1854,7 +1857,7 @@ static void stli_hangup(struct tty_struct *tty)
 	clear_bit(ST_TXBUSY, &portp->state);
 	clear_bit(ST_RXSTOP, &portp->state);
 	set_bit(TTY_IO_ERROR, &tty->flags);
-	portp->port.tty = NULL;
+	tty_port_tty_set(&portp->port, NULL);
 	portp->port.flags &= ~ASYNC_NORMAL_ACTIVE;
 	portp->port.count = 0;
 	spin_unlock_irqrestore(&stli_lock, flags);
@@ -1998,7 +2001,7 @@ static int stli_portinfo(struct stlibrd *brdp, struct stliport *portp, int portn
 	char *sp, *uart;
 	int rc, cnt;
 
-	rc = stli_portcmdstats(portp);
+	rc = stli_portcmdstats(NULL, portp);
 
 	uart = "UNKNOWN";
 	if (brdp->state & BST_STARTED) {
@@ -2188,7 +2191,7 @@ static void stli_read(struct stlibrd *brdp, struct stliport *portp)
 
 	if (test_bit(ST_RXSTOP, &portp->state))
 		return;
-	tty = portp->port.tty;
+	tty = tty_port_tty_get(&portp->port);
 	if (tty == NULL)
 		return;
 
@@ -2230,6 +2233,7 @@ static void stli_read(struct stlibrd *brdp, struct stliport *portp)
 		set_bit(ST_RXING, &portp->state);
 
 	tty_schedule_flip(tty);
+	tty_kref_put(tty);
 }
 
 /*****************************************************************************/
@@ -2362,7 +2366,7 @@ static int stli_hostcmd(struct stlibrd *brdp, struct stliport *portp)
 	if (ap->notify) {
 		nt = ap->changed;
 		ap->notify = 0;
-		tty = portp->port.tty;
+		tty = tty_port_tty_get(&portp->port);
 
 		if (nt.signal & SG_DCD) {
 			oldsigs = portp->sigs;
@@ -2399,6 +2403,7 @@ static int stli_hostcmd(struct stlibrd *brdp, struct stliport *portp)
 				tty_schedule_flip(tty);
 			}
 		}
+		tty_kref_put(tty);
 
 		if (nt.data & DT_RXBUSY) {
 			donerx++;
@@ -2535,14 +2540,15 @@ static void stli_poll(unsigned long arg)
  *	the slave.
  */
 
-static void stli_mkasyport(struct stliport *portp, asyport_t *pp, struct ktermios *tiosp)
+static void stli_mkasyport(struct tty_struct *tty, struct stliport *portp,
+				asyport_t *pp, struct ktermios *tiosp)
 {
 	memset(pp, 0, sizeof(asyport_t));
 
 /*
  *	Start of by setting the baud, char size, parity and stop bit info.
  */
-	pp->baudout = tty_get_baud_rate(portp->port.tty);
+	pp->baudout = tty_get_baud_rate(tty);
 	if ((tiosp->c_cflag & CBAUD) == B38400) {
 		if ((portp->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
 			pp->baudout = 57600;
@@ -2695,7 +2701,7 @@ static int stli_initports(struct stlibrd *brdp)
 			printk("STALLION: failed to allocate port structure\n");
 			continue;
 		}
-
+		tty_port_init(&portp->port);
 		portp->magic = STLI_PORTMAGIC;
 		portp->portnr = i;
 		portp->brdnr = brdp->brdnr;
@@ -4220,7 +4226,7 @@ static struct stliport *stli_getport(unsigned int brdnr, unsigned int panelnr,
  *	what port to get stats for (used through board control device).
  */
 
-static int stli_portcmdstats(struct stliport *portp)
+static int stli_portcmdstats(struct tty_struct *tty, struct stliport *portp)
 {
 	unsigned long	flags;
 	struct stlibrd	*brdp;
@@ -4249,15 +4255,15 @@ static int stli_portcmdstats(struct stliport *portp)
 	stli_comstats.flags = portp->port.flags;
 
 	spin_lock_irqsave(&brd_lock, flags);
-	if (portp->port.tty != NULL) {
-		if (portp->port.tty->driver_data == portp) {
-			stli_comstats.ttystate = portp->port.tty->flags;
+	if (tty != NULL) {
+		if (portp->port.tty == tty) {
+			stli_comstats.ttystate = tty->flags;
 			stli_comstats.rxbuffered = -1;
-			if (portp->port.tty->termios != NULL) {
-				stli_comstats.cflags = portp->port.tty->termios->c_cflag;
-				stli_comstats.iflags = portp->port.tty->termios->c_iflag;
-				stli_comstats.oflags = portp->port.tty->termios->c_oflag;
-				stli_comstats.lflags = portp->port.tty->termios->c_lflag;
+			if (tty->termios != NULL) {
+				stli_comstats.cflags = tty->termios->c_cflag;
+				stli_comstats.iflags = tty->termios->c_iflag;
+				stli_comstats.oflags = tty->termios->c_oflag;
+				stli_comstats.lflags = tty->termios->c_lflag;
 			}
 		}
 	}
@@ -4294,7 +4300,8 @@ static int stli_portcmdstats(struct stliport *portp)
  *	what port to get stats for (used through board control device).
  */
 
-static int stli_getportstats(struct stliport *portp, comstats_t __user *cp)
+static int stli_getportstats(struct tty_struct *tty, struct stliport *portp,
+							comstats_t __user *cp)
 {
 	struct stlibrd *brdp;
 	int rc;
@@ -4312,7 +4319,7 @@ static int stli_getportstats(struct stliport *portp, comstats_t __user *cp)
 	if (!brdp)
 		return -ENODEV;
 
-	if ((rc = stli_portcmdstats(portp)) < 0)
+	if ((rc = stli_portcmdstats(tty, portp)) < 0)
 		return rc;
 
 	return copy_to_user(cp, &stli_comstats, sizeof(comstats_t)) ?
@@ -4427,7 +4434,7 @@ static int stli_memioctl(struct inode *ip, struct file *fp, unsigned int cmd, un
 
 	switch (cmd) {
 	case COM_GETPORTSTATS:
-		rc = stli_getportstats(NULL, argp);
+		rc = stli_getportstats(NULL, NULL, argp);
 		done++;
 		break;
 	case COM_CLRPORTSTATS:
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 19db1eb..81b3234 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -405,9 +405,9 @@ static unsigned int	stl_baudrates[] = {
 
 static int	stl_memioctl(struct inode *ip, struct file *fp, unsigned int cmd, unsigned long arg);
 static int	stl_brdinit(struct stlbrd *brdp);
-static int	stl_getportstats(struct stlport *portp, comstats_t __user *cp);
+static int	stl_getportstats(struct tty_struct *tty, struct stlport *portp, comstats_t __user *cp);
 static int	stl_clrportstats(struct stlport *portp, comstats_t __user *cp);
-static int	stl_waitcarrier(struct stlport *portp, struct file *filp);
+static int	stl_waitcarrier(struct tty_struct *tty, struct stlport *portp, struct file *filp);
 
 /*
  *	CD1400 uart specific handling functions.
@@ -612,8 +612,9 @@ static struct class *stallion_class;
 static void stl_cd_change(struct stlport *portp)
 {
 	unsigned int oldsigs = portp->sigs;
+	struct tty_struct *tty = tty_port_tty_get(&portp->port);
 
-	if (!portp->port.tty)
+	if (!tty)
 		return;
 
 	portp->sigs = stl_getsignals(portp);
@@ -623,7 +624,8 @@ static void stl_cd_change(struct stlport *portp)
 
 	if ((oldsigs & TIOCM_CD) && ((portp->sigs & TIOCM_CD) == 0))
 		if (portp->port.flags & ASYNC_CHECK_CD)
-			tty_hangup(portp->port.tty);
+			tty_hangup(tty);
+	tty_kref_put(tty);
 }
 
 /*
@@ -734,7 +736,7 @@ static int stl_open(struct tty_struct *tty, struct file *filp)
  *	On the first open of the device setup the port hardware, and
  *	initialize the per port data structure.
  */
-	portp->port.tty = tty;
+	tty_port_tty_set(&portp->port, tty);
 	tty->driver_data = portp;
 	portp->port.count++;
 
@@ -774,7 +776,7 @@ static int stl_open(struct tty_struct *tty, struct file *filp)
  *	then also we might have to wait for carrier.
  */
 	if (!(filp->f_flags & O_NONBLOCK))
-		if ((rc = stl_waitcarrier(portp, filp)) != 0)
+		if ((rc = stl_waitcarrier(tty, portp, filp)) != 0)
 			return rc;
 
 	portp->port.flags |= ASYNC_NORMAL_ACTIVE;
@@ -789,7 +791,8 @@ static int stl_open(struct tty_struct *tty, struct file *filp)
  *	maybe because if we are clocal then we don't need to wait...
  */
 
-static int stl_waitcarrier(struct stlport *portp, struct file *filp)
+static int stl_waitcarrier(struct tty_struct *tty, struct stlport *portp,
+							struct file *filp)
 {
 	unsigned long	flags;
 	int		rc, doclocal;
@@ -801,7 +804,7 @@ static int stl_waitcarrier(struct stlport *portp, struct file *filp)
 
 	spin_lock_irqsave(&stallion_lock, flags);
 
-	if (portp->port.tty->termios->c_cflag & CLOCAL)
+	if (tty->termios->c_cflag & CLOCAL)
 		doclocal++;
 
 	portp->openwaitcnt++;
@@ -949,7 +952,7 @@ static void stl_close(struct tty_struct *tty, struct file *filp)
 	tty_ldisc_flush(tty);
 
 	tty->closing = 0;
-	portp->port.tty = NULL;
+	tty_port_tty_set(&portp->port, NULL);
 
 	if (portp->openwaitcnt) {
 		if (portp->close_delay)
@@ -1183,8 +1186,9 @@ static int stl_getserial(struct stlport *portp, struct serial_struct __user *sp)
  *	just quietly ignore any requests to change irq, etc.
  */
 
-static int stl_setserial(struct stlport *portp, struct serial_struct __user *sp)
+static int stl_setserial(struct tty_struct *tty, struct serial_struct __user *sp)
 {
+	struct stlport *	portp = tty->driver_data;
 	struct serial_struct	sio;
 
 	pr_debug("stl_setserial(portp=%p,sp=%p)\n", portp, sp);
@@ -1205,7 +1209,7 @@ static int stl_setserial(struct stlport *portp, struct serial_struct __user *sp)
 	portp->close_delay = sio.close_delay;
 	portp->closing_wait = sio.closing_wait;
 	portp->custom_divisor = sio.custom_divisor;
-	stl_setport(portp, portp->port.tty->termios);
+	stl_setport(portp, tty->termios);
 	return 0;
 }
 
@@ -1282,10 +1286,10 @@ static int stl_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd
 		rc = stl_getserial(portp, argp);
 		break;
 	case TIOCSSERIAL:
-		rc = stl_setserial(portp, argp);
+		rc = stl_setserial(tty, argp);
 		break;
 	case COM_GETPORTSTATS:
-		rc = stl_getportstats(portp, argp);
+		rc = stl_getportstats(tty, portp, argp);
 		break;
 	case COM_CLRPORTSTATS:
 		rc = stl_clrportstats(portp, argp);
@@ -1452,7 +1456,7 @@ static void stl_hangup(struct tty_struct *tty)
 		portp->tx.head = NULL;
 		portp->tx.tail = NULL;
 	}
-	portp->port.tty = NULL;
+	tty_port_tty_set(&portp->port, NULL);
 	portp->port.flags &= ~ASYNC_NORMAL_ACTIVE;
 	portp->port.count = 0;
 	wake_up_interruptible(&portp->port.open_wait);
@@ -1805,7 +1809,7 @@ static int __devinit stl_initports(struct stlbrd *brdp, struct stlpanel *panelp)
 				"(size=%Zd)\n", sizeof(struct stlport));
 			break;
 		}
-
+		tty_port_init(&portp->port);
 		portp->magic = STL_PORTMAGIC;
 		portp->portnr = i;
 		portp->brdnr = panelp->brdnr;
@@ -1832,6 +1836,7 @@ static void stl_cleanup_panels(struct stlbrd *brdp)
 	struct stlpanel *panelp;
 	struct stlport *portp;
 	unsigned int j, k;
+	struct tty_struct *tty;
 
 	for (j = 0; j < STL_MAXPANELS; j++) {
 		panelp = brdp->panels[j];
@@ -1841,8 +1846,11 @@ static void stl_cleanup_panels(struct stlbrd *brdp)
 			portp = panelp->ports[k];
 			if (portp == NULL)
 				continue;
-			if (portp->port.tty != NULL)
-				stl_hangup(portp->port.tty);
+			tty = tty_port_tty_get(&portp->port);
+			if (tty != NULL) {
+				stl_hangup(tty);
+				tty_kref_put(tty);
+			}
 			kfree(portp->tx.buf);
 			kfree(portp);
 		}
@@ -2498,7 +2506,7 @@ static struct stlport *stl_getport(int brdnr, int panelnr, int portnr)
  *	what port to get stats for (used through board control device).
  */
 
-static int stl_getportstats(struct stlport *portp, comstats_t __user *cp)
+static int stl_getportstats(struct tty_struct *tty, struct stlport *portp, comstats_t __user *cp)
 {
 	comstats_t	stl_comstats;
 	unsigned char	*head, *tail;
@@ -2525,18 +2533,17 @@ static int stl_getportstats(struct stlport *portp, comstats_t __user *cp)
 	portp->stats.rxbuffered = 0;
 
 	spin_lock_irqsave(&stallion_lock, flags);
-	if (portp->port.tty != NULL)
-		if (portp->port.tty->driver_data == portp) {
-			portp->stats.ttystate = portp->port.tty->flags;
-			/* No longer available as a statistic */
-			portp->stats.rxbuffered = 1; /*portp->port.tty->flip.count; */
-			if (portp->port.tty->termios != NULL) {
-				portp->stats.cflags = portp->port.tty->termios->c_cflag;
-				portp->stats.iflags = portp->port.tty->termios->c_iflag;
-				portp->stats.oflags = portp->port.tty->termios->c_oflag;
-				portp->stats.lflags = portp->port.tty->termios->c_lflag;
-			}
+	if (tty != NULL && portp->port.tty == tty) {
+		portp->stats.ttystate = tty->flags;
+		/* No longer available as a statistic */
+		portp->stats.rxbuffered = 1; /*tty->flip.count; */
+		if (tty->termios != NULL) {
+			portp->stats.cflags = tty->termios->c_cflag;
+			portp->stats.iflags = tty->termios->c_iflag;
+			portp->stats.oflags = tty->termios->c_oflag;
+			portp->stats.lflags = tty->termios->c_lflag;
 		}
+	}
 	spin_unlock_irqrestore(&stallion_lock, flags);
 
 	head = portp->tx.head;
@@ -2640,7 +2647,7 @@ static int stl_memioctl(struct inode *ip, struct file *fp, unsigned int cmd, uns
 
 	switch (cmd) {
 	case COM_GETPORTSTATS:
-		rc = stl_getportstats(NULL, argp);
+		rc = stl_getportstats(NULL, NULL, argp);
 		break;
 	case COM_CLRPORTSTATS:
 		rc = stl_clrportstats(NULL, argp);
@@ -3243,7 +3250,7 @@ static void stl_cd1400flowctrl(struct stlport *portp, int state)
 
 	if (portp == NULL)
 		return;
-	tty = portp->port.tty;
+	tty = tty_port_tty_get(&portp->port);
 	if (tty == NULL)
 		return;
 
@@ -3288,6 +3295,7 @@ static void stl_cd1400flowctrl(struct stlport *portp, int state)
 
 	BRDDISABLE(portp->brdnr);
 	spin_unlock_irqrestore(&brd_lock, flags);
+	tty_kref_put(tty);
 }
 
 /*****************************************************************************/
@@ -3305,7 +3313,7 @@ static void stl_cd1400sendflow(struct stlport *portp, int state)
 
 	if (portp == NULL)
 		return;
-	tty = portp->port.tty;
+	tty = tty_port_tty_get(&portp->port);
 	if (tty == NULL)
 		return;
 
@@ -3325,6 +3333,7 @@ static void stl_cd1400sendflow(struct stlport *portp, int state)
 	}
 	BRDDISABLE(portp->brdnr);
 	spin_unlock_irqrestore(&brd_lock, flags);
+	tty_kref_put(tty);
 }
 
 /*****************************************************************************/
@@ -3478,6 +3487,7 @@ static void stl_cd1400txisr(struct stlpanel *panelp, int ioaddr)
 	int		len, stlen;
 	char		*head, *tail;
 	unsigned char	ioack, srer;
+	struct tty_struct *tty;
 
 	pr_debug("stl_cd1400txisr(panelp=%p,ioaddr=%x)\n", panelp, ioaddr);
 
@@ -3504,8 +3514,11 @@ static void stl_cd1400txisr(struct stlpanel *panelp, int ioaddr)
 	if ((len == 0) || ((len < STL_TXBUFLOW) &&
 	    (test_bit(ASYI_TXLOW, &portp->istate) == 0))) {
 		set_bit(ASYI_TXLOW, &portp->istate);
-		if (portp->port.tty)
-			tty_wakeup(portp->port.tty);
+		tty = tty_port_tty_get(&portp->port);
+		if (tty) {
+			tty_wakeup(tty);
+			tty_kref_put(tty);
+		}
 	}
 
 	if (len == 0) {
@@ -3569,7 +3582,7 @@ static void stl_cd1400rxisr(struct stlpanel *panelp, int ioaddr)
 		return;
 	}
 	portp = panelp->ports[(ioack >> 3)];
-	tty = portp->port.tty;
+	tty = tty_port_tty_get(&portp->port);
 
 	if ((ioack & ACK_TYPMASK) == ACK_TYPRXGOOD) {
 		outb((RDCR + portp->uartaddr), ioaddr);
@@ -3633,10 +3646,12 @@ static void stl_cd1400rxisr(struct stlpanel *panelp, int ioaddr)
 		}
 	} else {
 		printk("STALLION: bad RX interrupt ack value=%x\n", ioack);
+		tty_kref_put(tty);
 		return;
 	}
 
 stl_rxalldone:
+	tty_kref_put(tty);
 	outb((EOSRR + portp->uartaddr), ioaddr);
 	outb(0, (ioaddr + EREG_DATA));
 }
@@ -4175,7 +4190,7 @@ static void stl_sc26198flowctrl(struct stlport *portp, int state)
 
 	if (portp == NULL)
 		return;
-	tty = portp->port.tty;
+	tty = tty_port_tty_get(&portp->port);
 	if (tty == NULL)
 		return;
 
@@ -4226,6 +4241,7 @@ static void stl_sc26198flowctrl(struct stlport *portp, int state)
 
 	BRDDISABLE(portp->brdnr);
 	spin_unlock_irqrestore(&brd_lock, flags);
+	tty_kref_put(tty);
 }
 
 /*****************************************************************************/
@@ -4244,7 +4260,7 @@ static void stl_sc26198sendflow(struct stlport *portp, int state)
 
 	if (portp == NULL)
 		return;
-	tty = portp->port.tty;
+	tty = tty_port_tty_get(&portp->port);
 	if (tty == NULL)
 		return;
 
@@ -4269,6 +4285,7 @@ static void stl_sc26198sendflow(struct stlport *portp, int state)
 	}
 	BRDDISABLE(portp->brdnr);
 	spin_unlock_irqrestore(&brd_lock, flags);
+	tty_kref_put(tty);
 }
 
 /*****************************************************************************/
@@ -4408,6 +4425,7 @@ static void stl_sc26198intr(struct stlpanel *panelp, unsigned int iobase)
 
 static void stl_sc26198txisr(struct stlport *portp)
 {
+	struct tty_struct *tty;
 	unsigned int	ioaddr;
 	unsigned char	mr0;
 	int		len, stlen;
@@ -4422,8 +4440,11 @@ static void stl_sc26198txisr(struct stlport *portp)
 	if ((len == 0) || ((len < STL_TXBUFLOW) &&
 	    (test_bit(ASYI_TXLOW, &portp->istate) == 0))) {
 		set_bit(ASYI_TXLOW, &portp->istate);
-		if (portp->port.tty)
-			tty_wakeup(portp->port.tty);
+		tty = tty_port_tty_get(&portp->port);
+		if (tty) {
+			tty_wakeup(tty);
+			tty_kref_put(tty);
+		}
 	}
 
 	if (len == 0) {
@@ -4476,7 +4497,7 @@ static void stl_sc26198rxisr(struct stlport *portp, unsigned int iack)
 
 	pr_debug("stl_sc26198rxisr(portp=%p,iack=%x)\n", portp, iack);
 
-	tty = portp->port.tty;
+	tty = tty_port_tty_get(&portp->port);
 	ioaddr = portp->ioaddr;
 	outb(GIBCR, (ioaddr + XP_ADDR));
 	len = inb(ioaddr + XP_DATA) + 1;
@@ -4515,6 +4536,7 @@ static void stl_sc26198rxisr(struct stlport *portp, unsigned int iack)
 			stl_sc26198txunflow(portp, tty);
 		}
 	}
+	tty_kref_put(tty);
 }
 
 /*****************************************************************************/
@@ -4528,7 +4550,7 @@ static void stl_sc26198rxbadch(struct stlport *portp, unsigned char status, char
 	struct tty_struct	*tty;
 	unsigned int		ioaddr;
 
-	tty = portp->port.tty;
+	tty = tty_port_tty_get(&portp->port);
 	ioaddr = portp->ioaddr;
 
 	if (status & SR_RXPARITY)
@@ -4566,6 +4588,7 @@ static void stl_sc26198rxbadch(struct stlport *portp, unsigned char status, char
 		if (status == 0)
 			portp->stats.rxtotal++;
 	}
+	tty_kref_put(tty);
 }
 
 /*****************************************************************************/

