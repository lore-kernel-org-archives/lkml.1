Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab0BDSTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 13:19:18 -0500
Received: from ixro-out-rtc.ixiacom.com ([92.87.192.98]:4400 "EHLO
	ixro-ex1.ixiacom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756536Ab0BDSTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:19:14 -0500
From: Octavian Purdila <opurdila@ixiacom.com>
Organization: Ixia
To: David Miller <davem@davemloft.net>
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed port numbers
Date: Thu, 4 Feb 2010 20:15:51 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-trunk-686; KDE/4.3.2; i686; ; )
Cc: amwang@redhat.com, linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
       nhorman@tuxdriver.com, linux-sctp@vger.kernel.org
References: <201002031312.48531.opurdila@ixiacom.com> <201002041444.01897.opurdila@ixiacom.com> <20100204.094110.64247447.davem@davemloft.net>
In-Reply-To: <20100204.094110.64247447.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002042015.51092.opurdila@ixiacom.com>
X-OriginalArrivalTime: 04 Feb 2010 18:19:13.0411 (UTC) FILETIME=[8DC55D30:01CAA5C6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 February 2010 19:41:10 you wrote:

> From: Octavian Purdila <opurdila@ixiacom.com>
> Date: Thu, 4 Feb 2010 14:44:01 +0200
> 
> > My concern is that we can have multiple applications that require a
> > fixed port and if those ports are significantly apart we will
> > decrease the port range available for connect. And that will hurt
> > the rate of which new connections can be opened.
> 
> I'm already uneasy about adding the simple check every time
> we loop around in the bind port allocator.
> 
> Adding an LSM hook to this spot?  I absolutely refuse to allow
> that, it will completely kill bind performance.
> 

I think Tetsuo was proposing the LSM hook, so I'll leave him the daunting task 
of convincing you of the benefit of that :) - I have no opinion on this due to 
massive lack of knowledge.

I was just proposing to use a discrete set of ports instead of a range. The 
check in the current patch:

int inet_is_reserved_local_port(int port)
{
       int min, max;

       inet_get_local_reserved_ports(&min, &max);
       if (min && max)
               return (port >= min && port <= max);
       return 0;
}

would become:

int inet_is_reserved_local_port(int port)
{
	if (test_bit(port, reserved_ports))
		return 1;
	return 0;
}

In theory it might be slower because of the reserved_ports bitmap will have a 
larger memory footprint than just a min/max, especially with random port 
allocation. But is this an issue in practice?
