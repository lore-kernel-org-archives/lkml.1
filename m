Return-Path: <linux-kernel-owner+w=401wt.eu-S1762607AbXLMHAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762607AbXLMHAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761445AbXLMG4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:56:03 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55080 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758911AbXLMGz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:55:58 -0500
Date: Wed, 12 Dec 2007 22:51:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-usb@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Brownell <dbrownell@users.sourceforge.net>,
       Dave Miller <davem@davemloft.net>, Dely Sy <dely.l.sy@intel.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 11/60] USB: fix up EHCI startup synchronization
Message-ID: <20071213065132.GL6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-fix-up-ehci-startup-synchronization.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David Brownell <david-b@pacbell.net>

patch 1cb52658b4f5b10a9e91f8e1c21ca2bcc1b9a3ca in mainline.

A recent patch added software synchronization during EHCI startup,
so ports aren't switched away from the companion controllers after
resets have started.  This patch adds a short delay letting hardware
finish that port switching before any new resets begin ... so both
ends of that hardware race window are closed.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Dave Miller <davem@davemloft.net>
Cc: Dely Sy <dely.l.sy@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-hcd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -575,12 +575,15 @@ static int ehci_run (struct usb_hcd *hcd
 	 * from the companions to the EHCI controller.  If any of the
 	 * companions are in the middle of a port reset at the time, it
 	 * could cause trouble.  Write-locking ehci_cf_port_reset_rwsem
-	 * guarantees that no resets are in progress.
+	 * guarantees that no resets are in progress.  After we set CF,
+	 * a short delay lets the hardware catch up; new resets shouldn't
+	 * be started before the port switching actions could complete.
 	 */
 	down_write(&ehci_cf_port_reset_rwsem);
 	hcd->state = HC_STATE_RUNNING;
 	ehci_writel(ehci, FLAG_CF, &ehci->regs->configured_flag);
 	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
+	msleep(5);
 	up_write(&ehci_cf_port_reset_rwsem);
 
 	temp = HC_VERSION(ehci_readl(ehci, &ehci->caps->hc_capbase));

-- 
