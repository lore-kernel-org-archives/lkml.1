Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbXJYQbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbXJYQbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbXJYQbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:31:15 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:26105 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750710AbXJYQbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:31:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3caOG64C9xvwfXo3hCznbn62ti7q0YP7eliz+WIfHtNsjQWkUjsqP2Rigl2cKykRNiSwofSvUthy9GJp8o5U6JXWWfcYc/7T13YpR5eV5XlXbMaQQ5Hsy0/4t3q1Oy/MuhSPhunRQh6WICVjWYL6xsxlGKf5QqM5ejELXW+eZfk=  ;
X-YMail-OSG: pZY.5sYVM1mR1XzUr7DDDORTsGjiFuIOl.5rXHErMAl1DZPaaZkUgKnELrVeQwkXAQPfnGiI0Q--
From: David Brownell <david-b@pacbell.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 2.6.24-rc1] resource_len() utility function
Date: Thu, 25 Oct 2007 09:31:11 -0700
User-Agent: KMail/1.9.6
Cc: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
References: <200710241820.52376.david-b@pacbell.net> <200710242138.23252.david-b@pacbell.net> <20071025132939.3fd010f9@the-village.bc.nu>
In-Reply-To: <20071025132939.3fd010f9@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710250931.11636.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007, Alan Cox wrote:
> > So you'd suggest having search utilities (as with platform_bus)
> > returning resource indices not resources?
> 
> That seems a bad idea to me

I'm assuming you mean they should continue to work like they
do today:  return the resource.  Your pseudocode below shows
an iomap utility taking a resource.


> > Thing is, BARs are usually well defined, but when folk glue
> > resources together they use whatever order is convenient on
> > that particular platform.  And different platforms can have
> > different numbers and types of resources, etc.
> 
> Far better I think that pci_ functions that take BAR values end up as
> wrappers of the form
> 
> 	pci_iomap(pdev, bar)
> 		return dev_iomap_resource(&pdev->resource[bar]);

Sure, for PCI ... where the meaning of BARs is a fixed part of the
hardware spec, and it's not uncommon to skip a few.

But as I noted, that notion doesn't apply cleanly outside PCI;
indexes aren't necessarily portable between systems.  So any
such interface should discourage their use.


One issue with a dev_iomap() is that only memory resources
really need mapping ... but *all* of them need claiming.
(Modulo the detail that the iomap morphs i/o addresses too.)

The $SUBJECT function is a (minor) simplification for both
the mapping and claiming steps.

I think I'd rather see a dev_resource_claim() which combines
the request_{,mem_}region() semantics with mapping ... that
way drivers could save code, not just unify the two types
of register addressing.

- Dave


