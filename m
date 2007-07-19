Return-Path: <linux-kernel-owner+w=401wt.eu-S938451AbXGSPnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938451AbXGSPnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757982AbXGSPnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:43:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:20884 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757655AbXGSPm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:42:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,557,1175497200"; 
   d="scan'208";a="270329299"
Message-ID: <469F867C.7020707@intel.com>
Date: Thu, 19 Jul 2007 08:42:52 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Olaf Kirch <olaf.kirch@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>, Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       Auke Kok <auke-jan.h.kok@intel.com>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
References: <20070716091236.GA10718@elte.hu> <20070719104756.GA13769@elte.hu> <20070719105816.GA15852@elte.hu> <200707191452.09609.olaf.kirch@oracle.com>
In-Reply-To: <200707191452.09609.olaf.kirch@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jul 2007 15:42:54.0097 (UTC) FILETIME=[78AE6010:01C7CA1B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Kirch wrote:
> On Thursday 19 July 2007 12:58, Ingo Molnar wrote:
>> i.e. it's the classic 'eth0 got stuck somehow' tx/rx state machine 
>> hickup symptoms, with no other bad symptoms such as lockups or crashes.
> 
> Duh, I found it.
> 
> The e1000 poll routine does this to leave polling mode.
> 
> 	netif_rx_complete(poll_dev);
>         e1000_irq_enable(adapter);
>         return 0;
> 
> Which looks innocent enough, except that e1000_irq_enable has
> this little irq_sem counter:
> 
> 	if (likely(atomic_dec_and_test(&adapter->irq_sem))) {
>                 E1000_WRITE_REG(&adapter->hw, IMS, IMS_ENABLE_MASK);
>                 E1000_WRITE_FLUSH(&adapter->hw);
>         }
> 
> So as poll_napi calls the poll() routine repeatedly, the irq_sem
> counter is decremented by one each time. During the first call,
> it re-enables the interrupt. During the next calls, irq_sem goes
> negative.
> 
> Then an interrupt comes in, e1000_intr disables the interrupt,
> increments irq_sem by one, and schedules the device for rx_action.
> rx_action calls dev->poll(), which finishes cleaning rx/rx rings,
> and when it finds there's no more work, it calls rx_complete and
> irq_enable. Except irq_enable doesn't enable anything now, since
> irq_sem is <= 0, and dec_and_test returns false.
> 
> The whole irq_sem accounting in the e1000 does not rhyme well with
> netpoll's way of exercising dev->poll().

it's been accused of worse things ;)

> The reason my patch triggers
> the problem reliably for you is that now, we always get at least
> two invocations of dev->poll: once from poll_napi - where we do not
> remove the device from the poll list any longer - and another one
> from net_rx_action.
> 
> I don't have a fix ready yet - I hope I'll have something later
> this afternoon.

interesting, you seem to found the cause allright. I can't confirm the problem 
but I know that netpoll and NAPI has historically been an issue. I look forward 
to your suggestions...

Cheers,

Auke
