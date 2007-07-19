Return-Path: <linux-kernel-owner+w=401wt.eu-S965670AbXGSTSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965670AbXGSTSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 15:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932771AbXGSTSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 15:18:04 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:17934 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763762AbXGSTSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 15:18:02 -0400
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Thu, 19 Jul 2007 21:13:25 +0200
User-Agent: KMail/1.9.1
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
References: <20070716091236.GA10718@elte.hu> <469F867C.7020707@intel.com> <20070719160713.GA3807@elte.hu>
In-Reply-To: <20070719160713.GA3807@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707192113.26878.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 18:07, Ingo Molnar wrote:
> because i dont seem to be able to trigger Olaf's WARN_ON(), can you see 
> anything in the ethtool output that i sent in the previous mail(s)?

If the WARN_ON doesn't trigger, I cannot see how my patch would affect
your system.

 -	IF we enter the if() branch in poll_napi, then the following
	must hold:
	 -	an interrupt from the e1000 arrived
	 -	e1000_intr disables interrupts, increments irq_sem
		(which is now 1) and schedules rx_action

 -	Now, inside poll_napi, the following happens:
	 -	poll_napi is called, finds the device is marked for
		polling, invokes dev->poll
	 -	dev->poll calls netif_rx_complete (which does *not*
		remove the device from the poll list), and re-enables
		interrupts. irq_sem is now 0.

 -	Finally, the rx_action softirq is run, which calls dev->poll
	again, which ends up invoking netif_rx_complete once more,
	and tries to re-enable interrupts. The latter doesn't do
	anything except decrementing irq_sem once more, which now
	goes negative.

	Which would trigger the WARN_ON.

Now, as you say the WARN_ON is never triggered, it follows that
we never end up in the if() branch of poll_napi. But that is
where the only substantial modification of my patch is.

Here's a somewhat drastic modification that should not change any
timing, but just verifies whether my patch is to blame at all. Can
you give it a try?

Thanks,
Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
---
Test patch
---
 include/linux/netdevice.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: build-2.6/include/linux/netdevice.h
===================================================================
--- build-2.6.orig/include/linux/netdevice.h
+++ build-2.6/include/linux/netdevice.h
@@ -1027,7 +1027,7 @@ static inline void netif_rx_complete(str
 	 * But at least it doesn't penalize the non-netpoll
 	 * code path. */
 	if (test_bit(__LINK_STATE_POLL_LIST_FROZEN, &dev->state))
-		return;
+		BUG();
 #endif
 
 	local_irq_save(flags);
