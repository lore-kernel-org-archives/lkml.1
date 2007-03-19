Return-Path: <linux-kernel-owner+w=401wt.eu-S965458AbXCSFax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965458AbXCSFax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 01:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965452AbXCSFax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 01:30:53 -0400
Received: from zoot.lnxi.com ([63.145.151.20]:56363 "EHLO zoot.lnxi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965182AbXCSFaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 01:30:52 -0400
To: David Miller <davem@davemloft.net>
Cc: mst@dev.mellanox.co.il, ebiederman@lnxi.com, kuznet@ms2.inr.ac.ru,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: dst_ifdown breaks infiniband?
References: <m3tzwi8a20.fsf@maxwell.lnxi.com>
	<20070318223653.GO11078@mellanox.co.il>
	<20070318224234.GP11078@mellanox.co.il>
	<20070318.171337.112622504.davem@davemloft.net>
From: ebiederman@lnxi.com (Eric W. Biederman)
Date: Sun, 18 Mar 2007 23:30:39 -0600
In-Reply-To: <20070318.171337.112622504.davem@davemloft.net> (David Miller's
 message of "Sun, 18 Mar 2007 17:13:37 -0700 (PDT)")
Message-ID: <m3aby94x6o.fsf@maxwell.lnxi.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
> Date: Mon, 19 Mar 2007 00:42:34 +0200

>> > Hmm. Then the code moving dst->dev to point to the loopback
>> > device will have to be fixed too. I'll post a patch a bit later.
>> 
>> Does this look sane (untested)?
>> 
>> Signed-off-by: Michael S. Tsirkin <mst@dev.mellanox.co.il>
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

Sure.  In the network namespace case I think the careful ordering of the
shutdown handles that case.   Even with per network namespace lo
unregistered it still existed until the network namespace actually
exited.  And it only happened on exit.  

So while there may be a tiny race there it hasn't been an issue yet
in practice.

I wasn't proposing that we fix it this way.  I was simply saying that
there was the possibility for the case to exist.  The existence of
a per network namespace loopback device is fairly fundamental to the
network namespace concept.  Heck I think Herbert has been looking at
it for vserver which almost totally socket isolation.

Eric
