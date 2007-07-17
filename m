Return-Path: <linux-kernel-owner+w=401wt.eu-S934261AbXGQOU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934261AbXGQOU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761481AbXGQOJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:09:35 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36842 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617AbXGQOJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:09:33 -0400
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Tue, 17 Jul 2007 16:07:07 +0200
User-Agent: KMail/1.9.1
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
References: <20070716091236.GA10718@elte.hu> <200707171028.36451.olaf.kirch@oracle.com> <20070717085748.GA32114@elte.hu>
In-Reply-To: <20070717085748.GA32114@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707171607.08644.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2007 10:57, Ingo Molnar wrote:
> i've got a new observation: changing CONFIG_HZ from 250 to 1000 makes 
> the problem go away. So it's somehow also related to jiffies.

There are several "Tx Hang detected" messages in the log, which looks
a lot as if net_rx_action never runs, or at least never calls
dev->poll on the e1000 nic.

Can you check whether/how often it bails out of net_rx_action taking
the softnet_break path?

My suspicion right now is that dev->quota goes way negative when
pushing out netconsole output. Normally, we bump the quota in
__net_rx_schedule. But the whole point of the patch is that
netpoll has no business removing the device from the poll_list,
so it stays there, and we don't end up calling __net_rx_schedule
as often as we would otherwise.

Can you try what happens if you change netif_rx_complete to
something like this:

	if (test_bit(__LINK_STATE_POLL_LIST_FROZEN, &dev->state)) {
		dev->quota = dev->weight;
		return;
	}

This is just a hack to make sure that we don't go to insanely
negative quotas while sending packets through netpoll.

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
