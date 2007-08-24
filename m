Return-Path: <linux-kernel-owner+w=401wt.eu-S1762202AbXHXViH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762202AbXHXViH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbXHXVhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:37:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59072
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756499AbXHXVhw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:37:52 -0400
Date: Fri, 24 Aug 2007 14:37:51 -0700 (PDT)
Message-Id: <20070824.143751.112614506.davem@davemloft.net>
To: ossthema@de.ibm.com
Cc: netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: RFC: issues concerning the next NAPI interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <200708241559.17055.ossthema@de.ibm.com>
References: <200708241559.17055.ossthema@de.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Bernd Themann <ossthema@de.ibm.com>
Date: Fri, 24 Aug 2007 15:59:16 +0200

> 1) The current implementation of netif_rx_schedule, netif_rx_complete
>    and the net_rx_action have the following problem: netif_rx_schedule
>    sets the NAPI_STATE_SCHED flag and adds the NAPI instance to the poll_list.
>    netif_rx_action checks NAPI_STATE_SCHED, if set it will add the device
>    to the poll_list again (as well). netif_rx_complete clears the NAPI_STATE_SCHED.
>    If an interrupt handler calls netif_rx_schedule on CPU 2
>    after netif_rx_complete has been called on CPU 1 (and the poll function 
>    has not returned yet), the NAPI instance will be added twice to the 
>    poll_list (by netif_rx_schedule and net_rx_action). Problems occur when 
>    netif_rx_complete is called twice for the device (BUG() called)

Indeed, this is the "who should manage the list" problem.
Probably the answer is that whoever transitions the NAPI_STATE_SCHED
bit from cleared to set should do the list addition.

Patches welcome :-)

> 3) On modern systems the incoming packets are processed very fast. Especially
>    on SMP systems when we use multiple queues we process only a few packets
>    per napi poll cycle. So NAPI does not work very well here and the interrupt 
>    rate is still high. What we need would be some sort of timer polling mode 
>    which will schedule a device after a certain amount of time for high load 
>    situations. With high precision timers this could work well. Current
>    usual timers are too slow. A finer granularity would be needed to keep the
>    latency down (and queue length moderate).

This is why minimal levels of HW interrupt mitigation should be enabled
in your chip.  If it does not support this, you will indeed need to look
into using high resolution timers or other schemes to alleviate this.

I do not think it deserves a generic core networking helper facility,
the chips that can't mitigate interrupts are few and obscure.
