Return-Path: <linux-kernel-owner+w=401wt.eu-S1750891AbZHRVV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750891AbZHRVV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbZHRVV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:21:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:61810 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbZHRVV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:21:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] Revert netlink ABI change to gnet_stats_basic
Date: Tue, 18 Aug 2009 21:21:24 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: Michael Spang <mspang@csclub.uwaterloo.ca>,
       "David S. Miller" <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
References: <1250002683-28554-1-git-send-email-mspang@csclub.uwaterloo.ca> <118a63b80908160642j73568637n2f3fa97fc33d8e57@mail.gmail.com> <4A885FD1.4030105@gmail.com>
In-Reply-To: <4A885FD1.4030105@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908182121.24726.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/6Wc8XpnI117VMaQbJZqISLBPbLaLBcHCJLUQ
 bg9d51JGS9qDAi4OIAg50aWqFi8XCTWkR/ghR4I2hSLN3K2Trm
 /Zchb44c57IO+bzn8k+hg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 August 2009 19:36:49 Eric Dumazet wrote:
> In 5e140dfc1fe87eae27846f193086724806b33c7d "net: reorder struct Qdisc
> for better SMP performance" the definition of struct gnet_stats_basic
> changed incompatibly, as copies of this struct are shipped to
> userland via netlink.
> 
> Restoring old behavior is not welcome, for performance reason.
> 
> Fix is to use a private structure for kernel, and
> teach gnet_stats_copy_basic() to convert from kernel to user land,
> using legacy structure (struct gnet_stats_basic)

Are you sure that the packed structure is actually an advantage
for performance? On architectures that do not have unaligned stores
in hardware, the compiler will generate highly inefficient code
for accessing packed variables, in order to avoid alignment exceptions.

It would need some more measurements, but I'd guess that 

struct gnet_stats_basic_packed
{
       __u64   bytes __attribute__ ((packed, aligned(4)));
       __u32   packets;
};

would give significantly better code on those architectures than
your version, while still giving you the 12-byte size.

	Arnd <><
