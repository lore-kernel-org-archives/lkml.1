Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbZJLKcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbZJLKcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbZJLKcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:32:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43182
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754685AbZJLKcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:32:50 -0400
Date: Mon, 12 Oct 2009 03:32:46 -0700 (PDT)
Message-Id: <20091012.033246.56701176.davem@davemloft.net>
To: tilman@imap.cc
Cc: johannes@sipsolutions.net, hidave.darkstar@gmail.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-wireless@vger.kernel.org, linux-ppp@vger.kernel.org,
       netdev@vger.kernel.org, paulus@samba.org
Subject: Re: NOHZ: local_softirq_pending 08
From: David Miller <davem@davemloft.net>
In-Reply-To: <4AD2E8C8.4060205@imap.cc>
References: <4AD1BF06.3050103@phoenixsoftware.de>
	<1255261251.4095.143.camel@johannes.local>
	<4AD2E8C8.4060205@imap.cc>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Mon, 12 Oct 2009 10:28:56 +0200

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> [CCing PPP people]
> 
> Am 11.10.2009 13:40 schrieb Johannes Berg:
>> On Sun, 2009-10-11 at 13:18 +0200, Tilman Schmidt wrote:
>> 
>>> Can you explain a bit more what that message is about?
>>> I am encountering it in a completely different context
>>> (PPP over ISDN) [...]
>> 
>> Basically, calling netif_rx() with softirqs enabled.
> 
> AFAICS that would have to be the netif_rx() call in
> ppp_receive_nonmp_frame() [drivers/net/ppp_generic.c#L1791],
> called (via others) from the tasklet work function
> ppp_sync_process() [drivers/net/ppp_synctty.c#L545].
> Should that be changed to the
> "if (in_interrupt()) netif_rx(skb) else netif_rx_ni(skb)"
> stanza from the linux.kernel.wireless.general thread then?

The PPP receive paths in ppp_generic.c do a local_bh_disable()/
local_bh_enable() around packet receiving (via ppp_recv_lock()/
ppp_recv_unlock() in ppp_do_recv).

So at least that part is perfectly fine.

ppp_input(), as called from ppp_sync_process(), also disables BH's
around ppp_do_recv() calls (via read_lock_bh()/read_unlock_bh()).

So that's fine too.

Do you have a bug report or are you just scanning around looking
for trouble? :-)
