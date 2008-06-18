Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYFRVl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYFRVl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 17:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYFRVlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 17:41:47 -0400
Received: from relay2.globalproof.net ([194.146.153.25]:55472 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYFRVlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 17:41:46 -0400
From: Denys Fedoryshchenko <denys@visp.net.lb>
Organization: Virtual ISP S.A.L.
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [E1000-devel] [TCP]: TCP_DEFER_ACCEPT causes leak sockets
Date: Thu, 19 Jun 2008 00:41:52 +0300
User-Agent: KMail/1.9.5
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, David Miller <davem@davemloft.net>,
       vgusev@openvz.org, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
       mcmanus@ducksong.com, ilpo.jarvinen@helsinki.fi, kuznet@ms2.inr.ac.ru,
       xemul@openvz.org, Linus Torvalds <torvalds@linux-foundation.org>
References: <20080617083220.GA11393@elte.hu> <20080618200805.GA18756@elte.hu> <20080618213230.GA17821@elte.hu>
In-Reply-To: <20080618213230.GA17821@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806190041.52532.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * Ingo Molnar <mingo@elte.hu> wrote:
> with e1000e i get:
> 
>  64 bytes from europe (10.0.1.15): icmp_seq=1 ttl=64 time=0.212 ms
>  64 bytes from europe (10.0.1.15): icmp_seq=2 ttl=64 time=0.372 ms
>  64 bytes from europe (10.0.1.15): icmp_seq=3 ttl=64 time=0.815 ms
>  64 bytes from europe (10.0.1.15): icmp_seq=4 ttl=64 time=0.961 ms
>  64 bytes from europe (10.0.1.15): icmp_seq=5 ttl=64 time=0.201 ms
>  64 bytes from europe (10.0.1.15): icmp_seq=6 ttl=64 time=0.788 ms
> 
> TCP latencies are fine too - ssh feels snappy again.
> 
> it still does not have nearly as good latencies as say forcedeth though:
> 
>  64 bytes from mercury (10.0.1.13): icmp_seq=1 ttl=64 time=0.076 ms
>  64 bytes from mercury (10.0.1.13): icmp_seq=2 ttl=64 time=0.085 ms
>  64 bytes from mercury (10.0.1.13): icmp_seq=3 ttl=64 time=0.045 ms
>  64 bytes from mercury (10.0.1.13): icmp_seq=4 ttl=64 time=0.053 ms
> 
> that's 10 times better packet latencies.
> 
> and even an ancient Realtek RTL-8139 over 10 megabit Ethernet (!) has 
> better latencies than the e1000e over 1000 megabit:
> 
>  64 bytes from pluto (10.0.1.10): icmp_seq=2 ttl=64 time=0.309 ms
>  64 bytes from pluto (10.0.1.10): icmp_seq=3 ttl=64 time=0.333 ms
>  64 bytes from pluto (10.0.1.10): icmp_seq=4 ttl=64 time=0.329 ms
>  64 bytes from pluto (10.0.1.10): icmp_seq=5 ttl=64 time=0.311 ms
>  64 bytes from pluto (10.0.1.10): icmp_seq=6 ttl=64 time=0.302 ms
> 
> is it done intentionally perhaps? I dont think it makes much sense to 
> delay rx/tx processing on a completely idle box for such a long time.
Idle box, ICH8 chipset, e1000e, latest git.

MegaRouterCore-KARAM ~ # ping 192.168.20.26
PING 192.168.20.26 (192.168.20.26) 56(84) bytes of data.
64 bytes from 192.168.20.26: icmp_seq=1 ttl=64 time=0.109 ms
64 bytes from 192.168.20.26: icmp_seq=2 ttl=64 time=0.134 ms
64 bytes from 192.168.20.26: icmp_seq=3 ttl=64 time=0.120 ms
64 bytes from 192.168.20.26: icmp_seq=4 ttl=64 time=0.117 ms
64 bytes from 192.168.20.26: icmp_seq=5 ttl=64 time=0.117 ms
64 bytes from 192.168.20.26: icmp_seq=6 ttl=64 time=0.113 ms

Disabling interrupt moderation
MegaRouterCore-KARAM ~ # ethtool -C eth0 rx-usecs 0
MegaRouterCore-KARAM ~ # ping 192.168.20.26
PING 192.168.20.26 (192.168.20.26) 56(84) bytes of data.
64 bytes from 192.168.20.26: icmp_seq=1 ttl=64 time=0.072 ms
64 bytes from 192.168.20.26: icmp_seq=2 ttl=64 time=0.091 ms
64 bytes from 192.168.20.26: icmp_seq=3 ttl=64 time=0.066 ms
64 bytes from 192.168.20.26: icmp_seq=4 ttl=64 time=0.065 ms
64 bytes from 192.168.20.26: icmp_seq=5 ttl=64 time=0.077 ms
64 bytes from 192.168.20.26: icmp_seq=6 ttl=64 time=0.073 ms

Maybe try the same?
ethtool -C eth0 rx-usecs 0

-- 
------
Technical Manager
Virtual ISP S.A.L.
Lebanon
