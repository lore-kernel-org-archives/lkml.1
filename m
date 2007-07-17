Return-Path: <linux-kernel-owner+w=401wt.eu-S1758915AbXGQITV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915AbXGQITV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 04:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbXGQITA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 04:19:00 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:29282 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbXGQIS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 04:18:59 -0400
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Tue, 17 Jul 2007 10:16:25 +0200
User-Agent: KMail/1.9.1
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
References: <20070716091236.GA10718@elte.hu> <20070716.042640.18306462.davem@davemloft.net> <alpine.LFD.0.999.0707161425361.20061@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707161425361.20061@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707171016.27358.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 July 2007 23:40, Linus Torvalds wrote:
>  - The change seems to always set the LIST_FROZEN bit when calling 
>    ->poll(), and at least on e1000, the NAPI poll() routine ends up doing 
>    that netif_rx_complete(), so we're *guaranteed* to always take the 
>    early exit and not do anything.

That is only in the poll_napi case, where netpoll tries to push pending
frames. The default caller for dev->poll() is net_rx_action.

We only ever get into this particular code branch in poll_napi when
the RX_SCHED bit is already set, ie someone put the device on the NAPI
poll_list and raised the softirq. poll_napi is just doing manually what
net_rx_action would do anyway once the softirq is serviced.

>  - The early return from netif_rx_complete() ends up meaning that an 
>    edge-triggered interrupt isn't handled properly, and will this never 
>    happen again, since it never goes away.

Sorry, I may be sitting on my brain this morning, but I don't understand
how skipping netif_rx_complete would affect ACKing of interrupts.

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
