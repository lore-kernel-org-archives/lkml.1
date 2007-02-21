Return-Path: <linux-kernel-owner+w=401wt.eu-S1422824AbXBUTYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422824AbXBUTYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422828AbXBUTYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:24:45 -0500
Received: from smtp.osdl.org ([65.172.181.24]:39143 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422824AbXBUTYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:24:44 -0500
Date: Wed, 21 Feb 2007 11:24:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
cc: tglx@linutronix.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: Linux 2.6.21-rc1
In-Reply-To: <45DC6C2C.7040509@intel.com>
Message-ID: <Pine.LNX.4.64.0702211123020.4043@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
 <1172064762.25076.56.camel@localhost.localdomain> <45DC6C2C.7040509@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 Feb 2007, Kok, Auke wrote:
> 
> I think we need to drop this now. The report that says that this *fixes*
> something might have been on regular interrupts only. I currently suspect that
> it breaks all MSI interrupts, which would make sense if I look a the code.
> Very bad indeed.
> 
> I'll try to come up with something else or send a patch that reverts it.

I'm going to be off-line for a couple of days, so I just reverted it.

		Linus

---
commit b5bf28cde894b3bb3bd25c13a7647020562f9ea0
Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
Date:   Wed Feb 21 11:21:44 2007 -0800

    Revert "e1000: fix shared interrupt warning message"
    
    This reverts commit d2ed16356ff4fb9de23fbc5e5d582ce580390106.
    
    As Thomas Gleixner reports:
      "e1000 is not working anymore. ifup fails permanentely.
        ADDRCONF(NETDEV_UP): eth0: link is not ready
       nothing else"
    
    The broken commit was identified with "git bisect".
    
    Auke Kok says:
      "I think we need to drop this now.  The report that says that this
       *fixes* something might have been on regular interrupts only.  I
       currently suspect that it breaks all MSI interrupts, which would make
       sense if I look a the code.  Very bad indeed."
    
    Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
    Acked-by: Auke Kok <auke-jan.h.kok@intel.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Jeff Garzik <jeff@garzik.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index a710237..98215fd 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -1417,6 +1417,10 @@ e1000_open(struct net_device *netdev)
 	if ((err = e1000_setup_all_rx_resources(adapter)))
 		goto err_setup_rx;
 
+	err = e1000_request_irq(adapter);
+	if (err)
+		goto err_req_irq;
+
 	e1000_power_up_phy(adapter);
 
 	if ((err = e1000_up(adapter)))
@@ -1427,10 +1431,6 @@ e1000_open(struct net_device *netdev)
 		e1000_update_mng_vlan(adapter);
 	}
 
-	err = e1000_request_irq(adapter);
-	if (err)
-		goto err_req_irq;
-
 	/* If AMT is enabled, let the firmware know that the network
 	 * interface is now open */
 	if (adapter->hw.mac_type == e1000_82573 &&
@@ -1439,10 +1439,10 @@ e1000_open(struct net_device *netdev)
 
 	return E1000_SUCCESS;
 
-err_req_irq:
-	e1000_down(adapter);
 err_up:
 	e1000_power_down_phy(adapter);
+	e1000_free_irq(adapter);
+err_req_irq:
 	e1000_free_all_rx_resources(adapter);
 err_setup_rx:
 	e1000_free_all_tx_resources(adapter);
