Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbZDNVmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbZDNVmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbZDNVmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:42:05 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:44058 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbZDNVmD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:42:03 -0400
Message-ID: <49E502B5.7070700@cosmosbay.com>
Date: Tue, 14 Apr 2009 23:40:05 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Jeff Chua <jeff.chua.linux@gmail.com>, Patrick McHardy <kaber@trash.net>,
       paulmck@linux.vnet.ibm.com, David Miller <davem@davemloft.net>,
       paulus@samba.org, mingo@elte.hu, torvalds@linux-foundation.org,
       laijs@cn.fujitsu.com, jengelh@medozas.de, r000n@r000n.net,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU (v3)
References: <20090411174801.GG6822@linux.vnet.ibm.com>	<18913.53699.544083.320542@cargo.ozlabs.ibm.com>	<20090412173108.GO6822@linux.vnet.ibm.com>	<20090412.181330.23529546.davem@davemloft.net>	<20090413040413.GQ6822@linux.vnet.ibm.com>	<20090413095309.631cf395@nehalam>	<49E48136.5060700@trash.net>	<49E49C65.8060808@cosmosbay.com>	<20090414074554.7fa73e2f@nehalam>	<49E4B0A5.70404@cosmosbay.com>	<b6a2187b0904140951r3c6a41fdnc26b149202bdfa84@mail.gmail.com>	<20090414111716.28585806@nehalam>	<49E4E3E8.5090201@cosmosbay.com> <20090414141351.0f63ac98@nehalam>
In-Reply-To: <20090414141351.0f63ac98@nehalam>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 14 Apr 2009 23:40:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger a écrit :
> This is an alternative version of ip/ip6/arp tables locking using
> per-cpu locks.  This avoids the overhead of synchronize_net() during
> update but still removes the expensive rwlock in earlier versions.
> 
> The idea for this came from an earlier version done by Eric Dumazet.
> Locking is done per-cpu, the fast path locks on the current cpu
> and updates counters.  The slow case involves acquiring the locks on
> all cpu's.
> 
> The mutex that was added for 2.6.30 in xt_table is unnecessary since
> there already is a mutex for xt[af].mutex that is held.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> ---
>  include/linux/netfilter/x_tables.h |    5 -
>  net/ipv4/netfilter/arp_tables.c    |  112 +++++++++------------------------
>  net/ipv4/netfilter/ip_tables.c     |  123 +++++++++++--------------------------
>  net/ipv6/netfilter/ip6_tables.c    |  119 +++++++++++------------------------
>  net/netfilter/x_tables.c           |   28 --------
>  5 files changed, 110 insertions(+), 277 deletions(-)
> 

Tested successfuly on my dev machine, thanks Stephen.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>


"strace -tt -T iptables -L" on this 8 cpu machine show quite fast operations now
(sub 1/HZ) 

23:37:26.629489 getsockopt(3, SOL_IP, 0x40 /* IP_??? */, "filter\0\300\\\236@\365\271\231\"\300`\225T\367\1\0\0\0\0vm\300`\225T\367\
16"..., [84]) = 0 <0.000008>
23:37:26.629579 brk(0)                  = 0x8054000 <0.000006>
23:37:26.629613 brk(0x8075000)          = 0x8075000 <0.000007>
23:37:26.629660 getsockopt(3, SOL_IP, 0x41 /* IP_??? */, "filter\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0L"..., [10608])
= 0 <0.000031>
23:37:26.629772 fstat64(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0 <0.000007>

same fast operation for an "iptables -A INPUT" operation


23:37:02.180313 close(4)                = 0 <0.000006>
23:37:02.180382 setsockopt(3, SOL_IP, 0x40 /* IP_??? */, "filter\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\16"..., 10664)
= 0 <0.000114>
23:37:02.180552 setsockopt(3, SOL_IP, 0x41 /* IP_??? */, "filter\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\20"..., 292) =
0 <0.000015>
23:37:02.180635 close(3)                = 0 <0.000010>

