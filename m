Return-Path: <linux-kernel-owner+w=401wt.eu-S933816AbXCSFS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816AbXCSFS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 01:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965047AbXCSFS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 01:18:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:39017 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933827AbXCSFSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 01:18:55 -0400
Date: Mon, 19 Mar 2007 07:19:34 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: David Miller <davem@davemloft.net>
Cc: mst@dev.mellanox.co.il, ebiederman@lnxi.com, kuznet@ms2.inr.ac.ru,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: dst_ifdown breaks infiniband?
Message-ID: <20070319051934.GS11078@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <m3tzwi8a20.fsf@maxwell.lnxi.com>
	<20070318223653.GO11078@mellanox.co.il>
	<20070318224234.GP11078@mellanox.co.il>
	<20070318.171337.112622504.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318.171337.112622504.davem@davemloft.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting David Miller <davem@davemloft.net>:
> Subject: Re: [ofa-general] Re: dst_ifdown breaks infiniband?
> 
> From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
> Date: Mon, 19 Mar 2007 00:42:34 +0200
> 
> > > Quoting Michael S. Tsirkin <mst@dev.mellanox.co.il>:
> > > Subject: Re: [ofa-general] Re: dst_ifdown breaks infiniband?
> > > 
> > > > Quoting Eric W. Biederman <ebiederman@lnxi.com>:
> > > > Subject: Re: [ofa-general] Re: dst_ifdown breaks infiniband?
> > > > 
> > > > "Michael S. Tsirkin" <mst@dev.mellanox.co.il> writes:
> > > > 
> > > > >> > Why is neighbour->dev changed here?
> > > > >> 
> > > > >> It holds reference to device and prevents its destruction.
> > > > >> If dst is held somewhere, we cannot destroy the device and deadlock
> > > > >> while unregister.
> > > > >
> > > > > BTW, can this ever happen for the loopback device itself?
> > > > > Is it ever unregistered?
> > > > 
> > > > Well I don't think the loopback device is currently but as soon
> > > > as we get network namespace support we will have multiple loopback
> > > > devices and they will get unregistered when we remove the network
> > > > namespace.
> > > 
> > > Hmm. Then the code moving dst->dev to point to the loopback
> > > device will have to be fixed too. I'll post a patch a bit later.
> > 
> > Does this look sane (untested)?
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@dev.mellanox.co.il>
> 
> You can't point it at NULL, we don't point it at loopback
> just for fun.
> 
> There can be asynchronous paths elsewhere in the networking still
> referencing the neigh or dst and they will (correctly) feel free to
> derefence whatever device is hanging there.  So transitioning
> to NULL is invalid.
> 
> You guys will need to come up with a better solution for this silly
> situation with network namespaces.  Loopback is always available to
> point dead routes and neighbour entries at, and this assumption is
> massively rooted in the networking.

Yes, I see this now.

I guess it's best to focus on the original problem with dst_ifdown breaking
infiniband for now.

For that, we have to audit all the places where dst->neighbour is dereferenced for
RCU safety, and this is already a massive task.

-- 
MST
