Return-Path: <linux-kernel-owner+w=401wt.eu-S937479AbXGSJp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937479AbXGSJp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758833AbXGSJpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:45:47 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24708 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbXGSJpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:45:46 -0400
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Thu, 19 Jul 2007 11:44:22 +0200
User-Agent: KMail/1.9.1
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
References: <20070716091236.GA10718@elte.hu> <20070718164341.GA6327@elte.hu> <20070719090930.GA27765@elte.hu>
In-Reply-To: <20070719090930.GA27765@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191144.24434.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 11:09, Ingo Molnar wrote:
> the e1000 in this laptop is historically pretty robust. The only problem 
> i ever had with it were some rx/tx hw-engine latency problems [pings 
> from the outside took up to 1 second to propagate] that were quickly 
> fixed by the e1000 driver guys. Maybe that's related. (although it never 
> caused total inavailability of networking - it was only latency 
> problems)

I've been poring over this code for 3 days now, and I'm facing a blank
wall, mind-wise :-)

 -	it is pretty clear that net_rx_action is invoked every once
	in a while only. netdev watchdog timeouts are a pretty
	unmistakable sign for that.

 -	You say that netconsole output continues to trickle after
	the network gets wedged. This could be caused by the
	e1000 watchdog, which triggers a NIC interrupt "to ensure
	rx ring is cleaned". I assume that this triggers the
	regular e1000_intr, which succeeds in putting the NIC on
	the poll_list, and net_rx_action call dev->poll once.

	If this assumption is true, this means that
	 -	once an interrupt gets through, NAPI is working
		as designed
	 -	no other interrupts are arriving (Rx, Tx-completion)

So, can you verify whether there are any interrupts arriving on the
NIC after the network got wedged? You could also try
ethtool -s eth0 msglevel 65535 - would be interesting to see what
dmesg contains. If there's little to no debug output from the
driver, let it run for 10 seconds or so, in order to catch the
e1000 watchdog timer a few times.

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
