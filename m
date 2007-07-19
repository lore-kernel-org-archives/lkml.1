Return-Path: <linux-kernel-owner+w=401wt.eu-S934034AbXGSMym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034AbXGSMym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbXGSMyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:54:33 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:48311 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbXGSMyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:54:32 -0400
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Thu, 19 Jul 2007 14:52:07 +0200
User-Agent: KMail/1.9.1
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       Auke Kok <auke-jan.h.kok@intel.com>
References: <20070716091236.GA10718@elte.hu> <20070719104756.GA13769@elte.hu> <20070719105816.GA15852@elte.hu>
In-Reply-To: <20070719105816.GA15852@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191452.09609.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 12:58, Ingo Molnar wrote:
> i.e. it's the classic 'eth0 got stuck somehow' tx/rx state machine 
> hickup symptoms, with no other bad symptoms such as lockups or crashes.

Duh, I found it.

The e1000 poll routine does this to leave polling mode.

	netif_rx_complete(poll_dev);
        e1000_irq_enable(adapter);
        return 0;

Which looks innocent enough, except that e1000_irq_enable has
this little irq_sem counter:

	if (likely(atomic_dec_and_test(&adapter->irq_sem))) {
                E1000_WRITE_REG(&adapter->hw, IMS, IMS_ENABLE_MASK);
                E1000_WRITE_FLUSH(&adapter->hw);
        }

So as poll_napi calls the poll() routine repeatedly, the irq_sem
counter is decremented by one each time. During the first call,
it re-enables the interrupt. During the next calls, irq_sem goes
negative.

Then an interrupt comes in, e1000_intr disables the interrupt,
increments irq_sem by one, and schedules the device for rx_action.
rx_action calls dev->poll(), which finishes cleaning rx/rx rings,
and when it finds there's no more work, it calls rx_complete and
irq_enable. Except irq_enable doesn't enable anything now, since
irq_sem is <= 0, and dec_and_test returns false.

The whole irq_sem accounting in the e1000 does not rhyme well with
netpoll's way of exercising dev->poll(). The reason my patch triggers
the problem reliably for you is that now, we always get at least
two invocations of dev->poll: once from poll_napi - where we do not
remove the device from the poll list any longer - and another one
from net_rx_action.

I don't have a fix ready yet - I hope I'll have something later
this afternoon.

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
