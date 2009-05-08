Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbZEHId6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbZEHId6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 04:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZEHIdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 04:33:47 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43804 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbZEHIdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 04:33:45 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] Char: epca, fix ASYNC flags
Date: Fri,  8 May 2009 10:32:44 +0200
Message-Id: <1241771564-31133-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <8763gcsa5e.fsf@tac.ki.iif.hu>
References: <8763gcsa5e.fsf@tac.ki.iif.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ASYNC_* flags are not bits, but rather constants, use ilog2 to obtain
bit positions and stay atomic.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/char/epca.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index 8797b77..01948e4 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -1518,7 +1518,7 @@ static void doevent(int crd)
 		if (event & MODEMCHG_IND) {
 			/* A modem signal change has been indicated */
 			ch->imodem = mstat;
-			if (test_bit(ASYNC_CHECK_CD, &ch->port.flags)) {
+			if (test_bit(ilog2(ASYNC_CHECK_CD), &ch->port.flags)) {
 				/* We are now receiving dcd */
 				if (mstat & ch->dcd)
 					wake_up_interruptible(&ch->port.open_wait);
@@ -1765,9 +1765,9 @@ static void epcaparam(struct tty_struct *tty, struct channel *ch)
 		 * that the driver will wait on carrier detect.
 		 */
 		if (ts->c_cflag & CLOCAL)
-			clear_bit(ASYNC_CHECK_CD, &ch->port.flags);
+			clear_bit(ilog2(ASYNC_CHECK_CD), &ch->port.flags);
 		else
-			set_bit(ASYNC_CHECK_CD, &ch->port.flags);
+			set_bit(ilog2(ASYNC_CHECK_CD), &ch->port.flags);
 		mval = ch->m_dtr | ch->m_rts;
 	} /* End CBAUD not detected */
 	iflag = termios2digi_i(ch, ts->c_iflag);
@@ -2244,7 +2244,8 @@ static void do_softint(struct work_struct *work)
 			if (test_and_clear_bit(EPCA_EVENT_HANGUP, &ch->event)) {
 				tty_hangup(tty);
 				wake_up_interruptible(&ch->port.open_wait);
-				clear_bit(ASYNC_NORMAL_ACTIVE, &ch->port.flags);
+				clear_bit(ilog2(ASYNC_NORMAL_ACTIVE),
+						&ch->port.flags);
 			}
 		}
 		tty_kref_put(tty);
-- 
1.6.2.4

