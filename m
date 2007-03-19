Return-Path: <linux-kernel-owner+w=401wt.eu-S933853AbXCSNEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853AbXCSNEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 09:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933861AbXCSNEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 09:04:30 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:60456 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933853AbXCSNE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 09:04:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=dGZcTCc7LSWdYHdrRgNexhypWTp/lU1f5BB6RSb+aKLQysOBIDOEpc8xqLah7R2hfshrHduApwo7fN9Shl8M9gKJwlqAqH3BAHQr549z4nsQ7gP3tMSvOXdXtSwJ+OumFGCHeU9Ob5CxjSNoyMQuPaS+/tXJ4F6CyTleOatCUNk=;
Date: Mon, 19 Mar 2007 15:59:19 +0300
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, general@lists.openfabrics.org,
       Roland Dreier <rolandd@cisco.com>, David Miller <davem@davemloft.net>
Subject: Re: dst_ifdown breaks infiniband?
Message-ID: <20070319125919.GA4239@ms2.inr.ac.ru>
References: <20070318155532.GG7958@mellanox.co.il> <20070318191238.GA20518@ms2.inr.ac.ru> <20070318195355.GB11078@mellanox.co.il> <20070318201826.GB27004@ms2.inr.ac.ru> <20070319093632.GB8386@mellanox.co.il> <20070319120534.GA28187@ms2.inr.ac.ru> <20070319121248.GD18497@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319121248.GD18497@mellanox.co.il>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> infiniband sets parm->neigh_destructor, and I search for a way to prevent
> this destructor from being called after the module has been unloaded.
> Ideas?

It must be called in any case to update/release internal ipoib structures.

The idea is to move call of parm->neigh_destructor from neighbour destructor
to the moment when it is unhashed, right after n->dead is set.

infiniband is the only user (atm clip uses it too, but that use is obviously
dummy), so that nobody will be harmed.

But ipoib will have to check for validity of skb->dst->neighbour before
attempt to reinitialize private data on dead (n->dead != 0) neighbour.

Alexey
