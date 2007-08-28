Return-Path: <linux-kernel-owner+w=401wt.eu-S1762106AbXH1UWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762106AbXH1UWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760825AbXH1UWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:22:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33051
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753978AbXH1UVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:21:55 -0400
Date: Tue, 28 Aug 2007 13:21:52 -0700 (PDT)
Message-Id: <20070828.132152.38706038.davem@davemloft.net>
To: ossthema@de.ibm.com
Cc: jchapman@katalix.com, shemminger@linux-foundation.org, akepner@sgi.com,
       netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: RFC: issues concerning the next NAPI interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <200708281319.03903.ossthema@de.ibm.com>
References: <200708271147.01890.ossthema@de.ibm.com>
	<20070827.133721.59473971.davem@davemloft.net>
	<200708281319.03903.ossthema@de.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Bernd Themann <ossthema@de.ibm.com>
Date: Tue, 28 Aug 2007 13:19:03 +0200

> I will try the following scheme (once we get hrtimers): Each device
> (queue) has a hrtimer.  Schedule the timer in the poll function
> instead of reactivating IRQs when a high load situation has been
> detected and all packets have been emptied from the receive queue.
> The timer function could then just call netif_rx_schedule to
> register the rx_queue for NAPI again.

Interrupt mitigation only works if it helps you avoid interrupts.
This scheme potentially makes more of them happen.

The hrtimer is just another interrupt, a cpu locally triggered one,
but it has much of the same costs nonetheless.

So if you set this timer, it triggers, and no packets arrive, you are
taking more interrupts and doing more work than if you had disabled
NAPI.

In fact, for certain packet rates, your scheme would result in
twice as many interrupts than the current scheme.

This is one of several reasons why hardware is the only truly proper
place for this kind of logic.  Only the hardware can see the packet
arrive, and do the interrupt deferral without any cpu intervention
whatsoever.
