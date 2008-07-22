Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbYGVXWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbYGVXWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbYGVXSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:18:16 -0400
Received: from ns2.suse.de ([195.135.220.15]:57564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119AbYGVXSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:18:15 -0400
Date: Tue, 22 Jul 2008 16:14:58 -0700
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
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Brownell <dbrownell@users.sourceforge.net>,
       Leonid <leonidv11@gmail.com>
Subject: [patch 12/47] USB: ohci - record data toggle after unlink
Message-ID: <20080722231458.GM8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-ohci-record-data-toggle-after-unlink.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David Brownell <dbrownell@users.sourceforge.net>

commit 29c8f6a727a683b5988877dd80dbdefd49e64a51 upstream

This patch fixes a problem with OHCI where canceling bulk or
interrupt URBs may lose track of the right data toggle.  This
seems to be a longstanding bug, possibly dating back to the
Linux 2.4 kernel, which stayed hidden because

 (a) about half the time the data toggle bit was correct;
 (b) canceling such URBs is unusual; and
 (c) the few drivers which cancel these URBs either
      [1] do it only as part of shutting down, or
      [2] have fault recovery logic, which recovers.

For those transfer types, the toggle is normally written back
into the ED when each TD is retired.  But canceling bypasses
the mechanism used to retire TDs ... so on average, half the
time the toggle bit will be invalid after cancelation.

The fix is simple:  the toggle state of any canceled TDs are
propagated back to the ED in the finish_unlinks function.

(Issue found by leonidv11@gmail.com ...)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Leonid <leonidv11@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ohci-q.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/usb/host/ohci-q.c
+++ b/drivers/usb/host/ohci-q.c
@@ -952,6 +952,7 @@ rescan_this:
 			struct urb	*urb;
 			urb_priv_t	*urb_priv;
 			__hc32		savebits;
+			u32		tdINFO;
 
 			td = list_entry (entry, struct td, td_list);
 			urb = td->urb;
@@ -966,6 +967,17 @@ rescan_this:
 			savebits = *prev & ~cpu_to_hc32 (ohci, TD_MASK);
 			*prev = td->hwNextTD | savebits;
 
+			/* If this was unlinked, the TD may not have been
+			 * retired ... so manually save the data toggle.
+			 * The controller ignores the value we save for
+			 * control and ISO endpoints.
+			 */
+			tdINFO = hc32_to_cpup(ohci, &td->hwINFO);
+			if ((tdINFO & TD_T) == TD_T_DATA0)
+				ed->hwHeadP &= ~cpu_to_hc32(ohci, ED_C);
+			else if ((tdINFO & TD_T) == TD_T_DATA1)
+				ed->hwHeadP |= cpu_to_hc32(ohci, ED_C);
+
 			/* HC may have partly processed this TD */
 			td_done (ohci, urb, td);
 			urb_priv->td_cnt++;

-- 
