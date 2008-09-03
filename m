Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbYICRjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbYICRjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbYICRiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:38:19 -0400
Received: from mail.suse.de ([195.135.220.2]:51640 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937AbYICRiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:38:18 -0400
Date: Wed, 3 Sep 2008 10:25:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Will Newton <will.newton@gmail.com>,
       Alex Williamson <alex.williamson@hp.com>,
       David Brownell <david-b@pacbell.net>
Subject: [patch 18/42] 8250: improve workaround for UARTs that dont
	re-assert THRE correctly
Message-ID: <20080903172554.GS7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="8250-improve-workaround-for-uarts-that-don-t-re-assert-thre-correctly.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Will Newton <will.newton@gmail.com>

commit 363f66fe06c75270b669c88e321e6b354ba0201e upstream

Recent changes to tighten the check for UARTs that don't correctly
re-assert THRE (01c194d9278efc15d4785ff205643e9c0bdcef53: "serial 8250:
tighten test for using backup timer") caused problems when such a UART was
opened for the second time - the bug could only successfully be detected
at first initialization.  For users of this version of this particular
UART IP it is fatal.

This patch stores the information about the bug in the bugs field of the
port structure when the port is first started up so subsequent opens can
check this bit even if the test for the bug fails.

David Brownell: "My own exposure to this is that the UART on DaVinci
hardware, which TI allegedly derived from its original 16550 logic, has
periodically gone from working to unusable with the mainline 8250.c ...
and back and forth a bunch.  Currently it's "unusable", a regression from
some previous versions.  With this patch from Will, it's usable."

Signed-off-by: Will Newton <will.newton@gmail.com>
Acked-by: Alex Williamson <alex.williamson@hp.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/8250.c |   16 ++++++++++++----
 drivers/serial/8250.h |    1 +
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1895,15 +1895,23 @@ static int serial8250_startup(struct uar
 		 * kick the UART on a regular basis.
 		 */
 		if (!(iir1 & UART_IIR_NO_INT) && (iir & UART_IIR_NO_INT)) {
+			up->bugs |= UART_BUG_THRE;
 			pr_debug("ttyS%d - using backup timer\n", port->line);
-			up->timer.function = serial8250_backup_timeout;
-			up->timer.data = (unsigned long)up;
-			mod_timer(&up->timer, jiffies +
-				poll_timeout(up->port.timeout) + HZ / 5);
 		}
 	}
 
 	/*
+	 * The above check will only give an accurate result the first time
+	 * the port is opened so this value needs to be preserved.
+	 */
+	if (up->bugs & UART_BUG_THRE) {
+		up->timer.function = serial8250_backup_timeout;
+		up->timer.data = (unsigned long)up;
+		mod_timer(&up->timer, jiffies +
+			  poll_timeout(up->port.timeout) + HZ / 5);
+	}
+
+	/*
 	 * If the "interrupt" for this port doesn't correspond with any
 	 * hardware interrupt, we use a timer-based system.  The original
 	 * driver used to do this with IRQ0.
--- a/drivers/serial/8250.h
+++ b/drivers/serial/8250.h
@@ -49,6 +49,7 @@ struct serial8250_config {
 #define UART_BUG_QUOT	(1 << 0)	/* UART has buggy quot LSB */
 #define UART_BUG_TXEN	(1 << 1)	/* UART has buggy TX IIR status */
 #define UART_BUG_NOMSR	(1 << 2)	/* UART has buggy MSR status bits (Au1x00) */
+#define UART_BUG_THRE	(1 << 3)	/* UART has buggy THRE reassertion */
 
 #define PROBE_RSA	(1 << 0)
 #define PROBE_ANY	(~0)

-- 
