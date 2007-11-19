Return-Path: <linux-kernel-owner+w=401wt.eu-S1752496AbXKSSlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbXKSSlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbXKSSlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:41:32 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:35328 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751021AbXKSSlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:41:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=t4nDCsYOFDWNUSu8MVRseCkzFO4HP3+5lAfEo4NBU5WYt2oURUxY5ObFbcPnOpd/MFDNzvS4iJC9Q+9CmBM4to14ofJF0aU421647czCrxzbbh3zr1a4DBCu32jEaaGciz2o2j905KjhawM3Y8aXjf5ic0JH7gmdVBqkV2hLII0=  ;
X-YMail-OSG: YJ48laYVM1mkBpR.LM1jBuWsvJZW97xFt7ArpbKbXLJqlXCe6lLIKij2btC3gyV7vNRV_GrouQ--
Date: Mon, 19 Nov 2007 10:41:28 -0800
From: David Brownell <david-b@pacbell.net>
To: stable@kernel.org, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [patch 19/26] USB: mutual exclusion for EHCI init and port resets
Cc: zwane@arm.linux.org.uk, tytso@mit.edu, torvalds@linux-foundation.org,
       stern@rowland.harvard.edu, reviews@ml.cw.f00f.org, rdunlap@xenotime.net,
       mkrufky@linuxtv.org, jmforbes@linuxtx.org, dely.l.sy@intel.com,
       davem@davemloft.net, davej@redhat.com, chuckw@quantumlinux.com,
       cebbert@redhat.com, cavokz@gmail.com, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org
References: <20071119181438.617190424@mini.kroah.org>
 <20071119181920.GT15425@kroah.com>
In-Reply-To: <20071119181920.GT15425@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071119184128.E43D423C403@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Still needs the following update, IMO ... 

======	CUT HERE
A recent patch added software synchronization during EHCI startup,
so ports aren't switched away from the companion controllers after
resets have started.  This patch adds a short delay letting hardware
get a chance to finish that port switching before any new resets begin.

That is, both sides of that hardware race window need to be closed.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/usb/host/ehci-hcd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- g26.orig/drivers/usb/host/ehci-hcd.c	2007-11-13 16:07:12.000000000 -0800
+++ g26/drivers/usb/host/ehci-hcd.c	2007-11-13 16:13:01.000000000 -0800
@@ -594,12 +594,15 @@ static int ehci_run (struct usb_hcd *hcd
 	 * from the companions to the EHCI controller.  If any of the
 	 * companions are in the middle of a port reset at the time, it
 	 * could cause trouble.  Write-locking ehci_cf_port_reset_rwsem
-	 * guarantees that no resets are in progress.
+	 * guarantees that no resets are in progress.  After we set CF,
+	 * a short delay lets the hardware catch up; new resets shouldn't
+	 * start before the port switching actions complete.
 	 */
 	down_write(&ehci_cf_port_reset_rwsem);
 	hcd->state = HC_STATE_RUNNING;
 	ehci_writel(ehci, FLAG_CF, &ehci->regs->configured_flag);
 	ehci_readl(ehci, &ehci->regs->command);	/* unblock posted writes */
+	msleep(5);
 	up_write(&ehci_cf_port_reset_rwsem);
 
 	temp = HC_VERSION(ehci_readl(ehci, &ehci->caps->hc_capbase));
