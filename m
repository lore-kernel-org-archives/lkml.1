Return-Path: <linux-kernel-owner+w=401wt.eu-S965866AbXCSPM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965866AbXCSPM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965860AbXCSPM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:12:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:42110 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965862AbXCSPMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:12:54 -0400
Date: Mon, 19 Mar 2007 17:13:36 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, general@lists.openfabrics.org,
       Roland Dreier <rolandd@cisco.com>, David Miller <davem@davemloft.net>
Subject: Re: dst_ifdown breaks infiniband?
Message-ID: <20070319151336.GA24225@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <20070318155532.GG7958@mellanox.co.il>
	<20070318191238.GA20518@ms2.inr.ac.ru>
	<20070318195355.GB11078@mellanox.co.il>
	<20070318201826.GB27004@ms2.inr.ac.ru>
	<20070319093632.GB8386@mellanox.co.il>
	<20070319120534.GA28187@ms2.inr.ac.ru>
	<20070319121248.GD18497@mellanox.co.il>
	<20070319125919.GA4239@ms2.inr.ac.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319125919.GA4239@ms2.inr.ac.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>:
> Subject: Re: dst_ifdown breaks infiniband?
> 
> Hello!
> 
> > infiniband sets parm->neigh_destructor, and I search for a way to prevent
> > this destructor from being called after the module has been unloaded.
> > Ideas?
> 
> It must be called in any case to update/release internal ipoib structures.

I don't think there's a problem.
All we do in destructor is release the ipoib_neigh resource.
And on device unregister we release all resources anyway.

> The idea is to move call of parm->neigh_destructor from neighbour destructor
> to the moment when it is unhashed, right after n->dead is set.
>
> infiniband is the only user (atm clip uses it too, but that use is obviously
> dummy), so that nobody will be harmed.

This might work. Could you post a patch to better show what you mean to do?

> But ipoib will have to check for validity of skb->dst->neighbour before
> attempt to reinitialize private data on dead (n->dead != 0) neighbour.

We set a flag before unregister_netdev and test it in start_xmit so
that's covered I think.

-- 
MST
