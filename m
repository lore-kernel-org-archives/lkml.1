Return-Path: <linux-kernel-owner+w=401wt.eu-S933424AbYDBUpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424AbYDBUpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932724AbYDBUk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:40:26 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:45124 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932719AbYDBUkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:40:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pgzqR6kHSrG1QwBELY3WTYuaHNeKftBC2/1LSm9o+As84WkUIB8KohADP0qt4OmkORUE5s44mnmZJdjB55XWfipqXyOB79z20ja9atw1unRXryLn87B0wrkQqAc7SGX9AowtSkRn6b/YuLMjZj+QlUz/Ipm/Aaj4TRS2CVwJC8Y=  ;
X-YMail-OSG: 7EcvT2wVM1kHZlm_O9_cooK9RtO1MdKWpWt59Em2S34v512CZKH7tJZJJSi9mvEXOfSY5XsVOj6_cFiPxdnmOvbXY3aDQ1__TH4Bv8625GXabLiW9mjbFzYk7yXe
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg KH <greg@kroah.com>
Subject: [PATCH 2.6.25-rc8] usb: another ehci_iaa_watchdog fix
Date: Wed, 2 Apr 2008 13:40:20 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, Mark Lord <lkml@rtr.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804021340.21348.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch, suggested by Alan Stern, fixes the hung USB issues
on my notebook from suspend/resume cycles.

It does so by eliminating some confusion about the internal state
machine associated with unlinking from the EHCI async schedule ring,
which caused a recent regression:

  http://bugzilla.kernel.org/show_bug.cgi?id=10345

Signed-off-by: Mark Lord <mlord@pobox.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Merge before 2.6.25-final please...

--- rc8/drivers/usb/host/ehci-hub.c	2008-03-11 11:18:40.000000000 -0400
+++ linux/drivers/usb/host/ehci-hub.c	2008-04-02 13:28:50.000000000 -0400
@@ -135,8 +135,6 @@
 		hcd->state = HC_STATE_QUIESCING;
 	}
 	ehci->command = ehci_readl(ehci, &ehci->regs->command);
-	if (ehci->reclaim)
-		end_unlink_async(ehci);
 	ehci_work(ehci);
 
 	/* Unlike other USB host controller types, EHCI doesn't have
@@ -180,6 +178,9 @@
 	ehci_halt (ehci);
 	hcd->state = HC_STATE_SUSPENDED;
 
+	if (ehci->reclaim)
+		end_unlink_async(ehci);
+
 	/* allow remote wakeup */
 	mask = INTR_MASK;
 	if (!device_may_wakeup(&hcd->self.root_hub->dev))

