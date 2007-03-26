Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbXCZPpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbXCZPpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 11:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbXCZPpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 11:45:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:26990 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbXCZPpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 11:45:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,330,1170662400"; 
   d="scan'208"; a="64089130:sNHT209220651"
X-Identity-Key: id2
Message-ID: <4607E943.6000804@intel.com>
Date: Mon, 26 Mar 2007 08:39:47 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: -rc5: e1000 resume weirdness
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070326101153.GA4593@elte.hu>
In-Reply-To: <20070326101153.GA4593@elte.hu>
X-OriginalArrivalTime: 26 Mar 2007 15:45:16.0370 (UTC) FILETIME=[BFFA4320:01C76FBD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> hm, on a T60, after suspend/resume, i get an e1000 timeout:
> 
> e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> e1000: eth0: e1000_clean_tx_irq: Detected Tx Unit Hang
>   Tx Queue             <0>
>   TDH                  <ec>
>   TDT                  <ec>
>   next_to_use          <ec>
>   next_to_clean        <82>
> buffer_info[next_to_clean]
>   time_stamp           <fffcc3db>
>   next_to_watch        <82>
>   jiffies              <fffd5da0>
>   next_to_watch.status <1>
> 
> it works fine after that reset. The e1000 driver didnt do this before 
> after resume the network was always available immediately. So this 
> appears to be a relatively new regression (post-rc3 or so). high-res 
> timers was disabled.
> 
> 	Ingo

THT == TDH -> this is a 'bogus' tx hang indicating that one or more parts
in the TX patch is not properly enabled.

Most likely, I suspect that we haven't enabled something because the ordering
of irq free/alloc was messed up and nobody cared before, but with all the
pci_save_state fixes going in we hit a bump.

The reset kicks it all back up in order so it's something silly like this for
sure.

The attached patch fixes that and sitting in my queue for a few days. Can you
see if that works?

Auke


---
e1000: Free interrupts symmetrically with resume

From: Auke Kok <auke-jan.h.kok@intel.com>

Free interrupts symmetrically with resume allocation to prevent
pci save/restore state from possibly failing or warning.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
---

 drivers/net/e1000/e1000_main.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index 55ef148..93d41f0 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -5190,6 +5190,7 @@ e1000_suspend(struct pci_dev *pdev, pm_message_t state)
 	if (netif_running(netdev)) {
 		WARN_ON(test_bit(__E1000_RESETTING, &adapter->flags));
 		e1000_down(adapter);
+		e1000_free_irq(adapter);
 	}
 
 #ifdef CONFIG_PM
@@ -5257,9 +5258,6 @@ e1000_suspend(struct pci_dev *pdev, pm_message_t state)
 	if (adapter->hw.phy.type == e1000_phy_igp_3)
 		e1000_igp3_phy_powerdown_workaround_ich8lan(&adapter->hw);
 
-	if (netif_running(netdev))
-		e1000_free_irq(adapter);
-
 	/* Release control of h/w to f/w.  If f/w is AMT enabled, this
 	 * would have already happened in close and is redundant. */
 	e1000_release_hw_control(adapter);
