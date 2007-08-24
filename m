Return-Path: <linux-kernel-owner+w=401wt.eu-S1765706AbXHXN7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765706AbXHXN7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 09:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbXHXN7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 09:59:20 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:49958 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390AbXHXN7T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 09:59:19 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: netdev <netdev@vger.kernel.org>
Subject: RFC: issues concerning the next NAPI interface
Date: Fri, 24 Aug 2007 15:59:16 +0200
User-Agent: KMail/1.8.2
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708241559.17055.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when I tried to get the eHEA driver working with the new interface,
the following issues came up.

1) The current implementation of netif_rx_schedule, netif_rx_complete
   and the net_rx_action have the following problem: netif_rx_schedule
   sets the NAPI_STATE_SCHED flag and adds the NAPI instance to the poll_list.
   netif_rx_action checks NAPI_STATE_SCHED, if set it will add the device
   to the poll_list again (as well). netif_rx_complete clears the NAPI_STATE_SCHED.
   If an interrupt handler calls netif_rx_schedule on CPU 2
   after netif_rx_complete has been called on CPU 1 (and the poll function 
   has not returned yet), the NAPI instance will be added twice to the 
   poll_list (by netif_rx_schedule and net_rx_action). Problems occur when 
   netif_rx_complete is called twice for the device (BUG() called)

2) If an ethernet chip supports multiple receive queues, the queues are 
   currently all processed on the CPU where the interrupt comes in. This
   is because netif_rx_schedule will always add the rx queue to the CPU's
   napi poll_list. The result under heavy presure is that all queues will
   gather on the weakest CPU (with highest CPU load) after some time as they
   will stay there as long as the entire queue is emptied. On SMP systems 
   this behaviour is not desired. It should also work well without interrupt
   pinning.
   It would be nice if it is possible to schedule queues to other CPU's, or
   at least to use interrupts to put the queue to another cpu (not nice for 
   as you never know which one you will hit). 
   I'm not sure how bad the tradeoff would be.

3) On modern systems the incoming packets are processed very fast. Especially
   on SMP systems when we use multiple queues we process only a few packets
   per napi poll cycle. So NAPI does not work very well here and the interrupt 
   rate is still high. What we need would be some sort of timer polling mode 
   which will schedule a device after a certain amount of time for high load 
   situations. With high precision timers this could work well. Current
   usual timers are too slow. A finer granularity would be needed to keep the
   latency down (and queue length moderate).

What do you think?

Thanks,
Jan-Bernd
