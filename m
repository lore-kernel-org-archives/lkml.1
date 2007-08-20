Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbXHTBFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbXHTBFx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 21:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbXHTBFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 21:05:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41504
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753659AbXHTBFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 21:05:41 -0400
Date: Sun, 19 Aug 2007 18:05:40 -0700 (PDT)
Message-Id: <20070819.180540.74750322.davem@davemloft.net>
To: felix@chelsio.com
Cc: sean.hefty@intel.com, netdev@vger.kernel.org, rdreier@cisco.com,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate
 PS_TCPportsfrom the host TCP port space.
From: David Miller <davem@davemloft.net>
In-Reply-To: <8A71B368A89016469F72CD08050AD334018E20BE@maui.asicdesigners.com>
References: <8A71B368A89016469F72CD08050AD334018E20BC@maui.asicdesigners.com>
	<20070819.174017.77241227.davem@davemloft.net>
	<8A71B368A89016469F72CD08050AD334018E20BE@maui.asicdesigners.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Felix Marti" <felix@chelsio.com>
Date: Sun, 19 Aug 2007 17:47:59 -0700

> [Felix Marti]

Please stop using this to start your replies, thank you.

> David and Herbert, so you agree that the user<>kernel
> space memory copy overhead is a significant overhead and we want to
> enable zero-copy in both the receive and transmit path? - Yes, copy
> avoidance is mainly an API issue and unfortunately the so widely used
> (synchronous) sockets API doesn't make copy avoidance easy, which is one
> area where protocol offload can help. Yes, some apps can resort to
> sendfile() but there are many apps which seem to have trouble switching
> to that API... and what about the receive path?

On the send side none of this is an issue.  You either are sending
static content, in which using sendfile() is trivial, or you're
generating data dynamically in which case the data copy is in the
noise or too small to do zerocopy on and if not you can use a shared
mmap to generate your data into, and then sendfile out from that file,
to avoid the copy that way.

splice() helps a lot too.

Splice has the capability to do away with the receive side too, and
there are a few receivefile() implementations that could get cleaned
up and merged in.

Also, the I/O bus is still the more limiting factor and main memory
bandwidth in all of this, it is the smallest data pipe for
communications out to and from the network.  So the protocol header
avoidance gains of TSO and LRO are still a very worthwhile savings.

But even if RDMA increases performance 100 fold, it still doesn't
avoid the issue that it doesn't fit in with the rest of the networking
stack and feature set.

Any monkey can change the rules around ("ok I can make it go fast as
long as you don't need firewalling, packet scheduling, classification,
and you only need to talk to specific systems that speak this same
special protocol") to make things go faster.  On the other hand well
designed solutions can give performance gains within the constraints
of the full system design and without sactificing functionality.
