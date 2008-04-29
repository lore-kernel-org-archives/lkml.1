Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbYD2RYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbYD2RYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758069AbYD2RUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:20:40 -0400
Received: from ns2.suse.de ([195.135.220.15]:43002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758036AbYD2RUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:20:38 -0400
Date: Tue, 29 Apr 2008 10:18:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>
Subject: [11/37] USB: OHCI: fix bug in controller resume
Message-ID: <20080429171821.GL14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-ohci-fix-bug-in-controller-resume.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit: 0d22f65515307c878ddd20b1305cce925ca9516c

This patch (as1063) fixes a bug in the way ohci-hcd resumes its
controllers.  It leaves the Master Interrupt Enable bit turned off.

If the root hub is resumed immediately this won't matter.  But if the
root hub is suspended (say because no devices are plugged in), it won't
ever wake up by itself.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: David Brownell <david-b@pacbell.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ohci-pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ohci-pci.c
+++ b/drivers/usb/host/ohci-pci.c
@@ -312,11 +312,13 @@ static int ohci_pci_suspend (struct usb_
 
 static int ohci_pci_resume (struct usb_hcd *hcd)
 {
+	struct ohci_hcd	*ohci = hcd_to_ohci(hcd);
+
 	set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
 
 	/* FIXME: we should try to detect loss of VBUS power here */
 	prepare_for_handover(hcd);
-
+	ohci_writel(ohci, OHCI_INTR_MIE, &ohci->regs->intrenable);
 	return 0;
 }
 

-- 
