Return-Path: <linux-kernel-owner+w=401wt.eu-S1764709AbZCaX0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764709AbZCaX0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762529AbZCaXUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:20:38 -0400
Received: from sous-sol.org ([216.99.217.87]:33165 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762285AbZCaXUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:20:34 -0400
Message-Id: <20090331231409.035556389@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:10:53 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 08/45] USB: EHCI: add software retry for transaction errors
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=usb-ehci-add-software-retry-for-transaction-errors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Alan Stern <stern@rowland.harvard.edu>

upstream commit: a2c2706e1043c17139c2dafd171c4a5cf008ef7e

This patch (as1204) adds a software retry mechanism to ehci-hcd.  It
gets invoked when the driver encounters transaction errors on an
asynchronous endpoint.  On many systems, hardware deficiencies cause
such errors to occur if one device is unplugged while the host is
communicating with another device.  With the patch, the failed
transactions are retried and generally succeed the second or third
time through.

This is based on code originally written by Koichiro Saito.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested by: Koichiro Saito <Saito.Koichiro@adniss.jp>
CC: David Brownell <david-b@pacbell.net>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/host/ehci-q.c |   32 ++++++++++++++++++++++++++++++++
 drivers/usb/host/ehci.h   |    3 +++
 2 files changed, 35 insertions(+)

--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -333,12 +333,40 @@ qh_completions (struct ehci_hcd *ehci, s
 		token = hc32_to_cpu(ehci, qtd->hw_token);
 
 		/* always clean up qtds the hc de-activated */
+ retry_xacterr:
 		if ((token & QTD_STS_ACTIVE) == 0) {
 
 			/* on STALL, error, and short reads this urb must
 			 * complete and all its qtds must be recycled.
 			 */
 			if ((token & QTD_STS_HALT) != 0) {
+
+				/* retry transaction errors until we
+				 * reach the software xacterr limit
+				 */
+				if ((token & QTD_STS_XACT) &&
+						QTD_CERR(token) == 0 &&
+						--qh->xacterrs > 0 &&
+						!urb->unlinked) {
+					ehci_dbg(ehci,
+	"detected XactErr len %d/%d retry %d\n",
+	qtd->length - QTD_LENGTH(token), qtd->length,
+	QH_XACTERR_MAX - qh->xacterrs);
+
+					/* reset the token in the qtd and the
+					 * qh overlay (which still contains
+					 * the qtd) so that we pick up from
+					 * where we left off
+					 */
+					token &= ~QTD_STS_HALT;
+					token |= QTD_STS_ACTIVE |
+							(EHCI_TUNE_CERR << 10);
+					qtd->hw_token = cpu_to_hc32(ehci,
+							token);
+					wmb();
+					qh->hw_token = cpu_to_hc32(ehci, token);
+					goto retry_xacterr;
+				}
 				stopped = 1;
 
 			/* magic dummy for some short reads; qh won't advance.
@@ -421,6 +449,9 @@ halt:
 		/* remove qtd; it's recycled after possible urb completion */
 		list_del (&qtd->qtd_list);
 		last = qtd;
+
+		/* reinit the xacterr counter for the next qtd */
+		qh->xacterrs = QH_XACTERR_MAX;
 	}
 
 	/* last urb's completion might still need calling */
@@ -862,6 +893,7 @@ static void qh_link_async (struct ehci_h
 	head->qh_next.qh = qh;
 	head->hw_next = dma;
 
+	qh->xacterrs = QH_XACTERR_MAX;
 	qh->qh_state = QH_STATE_LINKED;
 	/* qtd completions reported later by interrupt */
 }
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -376,6 +376,9 @@ struct ehci_qh {
 #define	QH_STATE_UNLINK_WAIT	4		/* LINKED and on reclaim q */
 #define	QH_STATE_COMPLETING	5		/* don't touch token.HALT */
 
+	u8			xacterrs;	/* XactErr retry counter */
+#define	QH_XACTERR_MAX		32		/* XactErr retry limit */
+
 	/* periodic schedule info */
 	u8			usecs;		/* intr bandwidth */
 	u8			gap_uf;		/* uframes split/csplit gap */

