Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbXCSMMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbXCSMMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 08:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbXCSMMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 08:12:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:42926 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbXCSMM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 08:12:29 -0400
Date: Mon, 19 Mar 2007 14:13:10 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, general@lists.openfabrics.org,
       Roland Dreier <rolandd@cisco.com>, David Miller <davem@davemloft.net>
Subject: Re: dst_ifdown breaks infiniband?
Message-ID: <20070319121310.GE18497@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <20070318155532.GG7958@mellanox.co.il>
	<20070318191238.GA20518@ms2.inr.ac.ru>
	<20070318195355.GB11078@mellanox.co.il>
	<20070318201826.GB27004@ms2.inr.ac.ru>
	<20070319093632.GB8386@mellanox.co.il>
	<20070319120534.GA28187@ms2.inr.ac.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319120534.GA28187@ms2.inr.ac.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>:
> Subject: Re: dst_ifdown breaks infiniband?
> 
> Hello!
> 
> > If a device driver sets neigh_destructor in neigh_params, this could
> > get called after the device has been unregistered and the driver module
> > removed.
> 
> It is the same problem: if dst->neighbour holds neighbour, it should
> not hold device. parms->dev is not supposed to be used after
> neigh_parms_release(). F.e. set parms->dev to NULL to catch bad references.

Yes. I fixed that - simply checking that neighbour->dev is a
loopback device is sufficient to detect the fact that
the device is being unregistered.

> Do you search for a way to find real inifiniband device in
> ipoib_neigh_destructor()?

No, not anymore.

> I guess you will not be able.

I agree it's not possible.

> The problem is logical: if destructor needs device, neighbour entry
> _somehow_ have to hold reference to the device (via neigh->dev, neigh->parms,
> whatever). Hence, if we hold neighbour entry, unregister cannot be completed.
> Therefore, destructor cannot refer to device. Q.E.D. :-)
> 
> Seems, releasing dst->neighbour is inevitable.

infiniband sets parm->neigh_destructor, and I search for a way to prevent
this destructor from being called after the module has been unloaded.
Ideas?

-- 
MST
