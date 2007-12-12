Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbXLLRa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbXLLRa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 12:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbXLLRas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 12:30:48 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1908 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750913AbXLLRar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 12:30:47 -0500
Message-ID: <47601A73.5010804@myri.com>
Date: Wed, 12 Dec 2007 12:29:23 -0500
From: Andrew Gallatin <gallatin@myri.com>
User-Agent: Thunderbird 1.5.0.7 (Macintosh/20060909)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: joonwpark81@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [RFC] net: napi fix
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I apologize for loosing threading, I'm replying from the archives]

 > The problem is that the driver is doing a NAPI completion and
 > re-enabling chip interrupts with work_done == weight, and that is
 > illegal.

The only time at least myri10ge will do this is due to
the !netif_running(netdev) check.   Eg, from myri10ge's poll:

	work_done = myri10ge_clean_rx_done(mgp, budget);

	if (work_done < budget || !netif_running(netdev)) {
		netif_rx_complete(netdev, napi);
		put_be32(htonl(3), mgp->irq_claim);
	}

Is the netif_running() check even required? Is this just
a bad way to solve a race with running NAPI at down() time
that would be better solved by putting a napi_synchronize()
in the driver's down() routine?

I'd rather fix this right than add another check to a
questionable code path.

Thanks,

Drew
