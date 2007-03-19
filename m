Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbXCSMFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbXCSMFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 08:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbXCSMFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 08:05:41 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:59087 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753812AbXCSMFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 08:05:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=WYFQxkHQXa2WhWYYZ3giaEj9L5tC5YP/djkE7U1o/1EQojbbCWLhLNX6EA2RKrIQ/PKeoIW1CQKV7Cw4OdoOG1b+1TNau0L/QC1cYnfr13RyJunVXOWv7b//IC4tZH9+SKtPfooDNDNOw4djkALg6i/QlE3T/D/ke69WGpC4cU4=;
Date: Mon, 19 Mar 2007 15:05:34 +0300
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, general@lists.openfabrics.org,
       Roland Dreier <rolandd@cisco.com>, David Miller <davem@davemloft.net>
Subject: Re: dst_ifdown breaks infiniband?
Message-ID: <20070319120534.GA28187@ms2.inr.ac.ru>
References: <20070318155532.GG7958@mellanox.co.il> <20070318191238.GA20518@ms2.inr.ac.ru> <20070318195355.GB11078@mellanox.co.il> <20070318201826.GB27004@ms2.inr.ac.ru> <20070319093632.GB8386@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319093632.GB8386@mellanox.co.il>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> If a device driver sets neigh_destructor in neigh_params, this could
> get called after the device has been unregistered and the driver module
> removed.

It is the same problem: if dst->neighbour holds neighbour, it should
not hold device. parms->dev is not supposed to be used after
neigh_parms_release(). F.e. set parms->dev to NULL to catch bad references.


Do you search for a way to find real inifiniband device in
ipoib_neigh_destructor()? I guess you will not be able.
The problem is logical: if destructor needs device, neighbour entry
_somehow_ have to hold reference to the device (via neigh->dev, neigh->parms,
whatever). Hence, if we hold neighbour entry, unregister cannot be completed.
Therefore, destructor cannot refer to device. Q.E.D. :-)

Seems, releasing dst->neighbour is inevitable.

Alexey
