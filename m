Return-Path: <linux-kernel-owner+w=401wt.eu-S1759767AbXLTXN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759767AbXLTXN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 18:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbXLTXNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 18:13:45 -0500
Received: from ozlabs.org ([203.10.76.45]:33679 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbXLTXNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 18:13:44 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/5] sg_ring for scsi
Date: Fri, 21 Dec 2007 10:13:38 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com, dougg@torque.net
References: <200712201645.19035.rusty@rustcorp.com.au> <200712201853.48643.rusty@rustcorp.com.au> <20071219.235807.173273479.davem@davemloft.net>
In-Reply-To: <20071219.235807.173273479.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712211013.38511.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 December 2007 18:58:07 David Miller wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> Date: Thu, 20 Dec 2007 18:53:48 +1100
>
> > Manipulating the magic chains is horrible; it looks simple to the
> > places which simply want to iterate through it, but it's awful for
> > code which wants to create them.
>
> I'm not saying complexity is inherent in this stuff, but
> assuming that it is the complexity should live as far away
> from the minions (the iterators in this case).  Therefore,
> the creators is the right spot for the hard stuff.

In this case, the main benefit of the sg chaining was that the conversion of 
most scsi drivers was easy (basically sg++ -> sg = sg_next(sg)).  The 
conversion to sg_ring is more complex, but the end result is not 
significantly more complex.

However, the cost to code which manipulates sg chains was significant: I tried 
using them in virtio and it was too ugly to live (so that doesn't support sg 
chaining).  If this was the best we could do, that'd be fine.

But, as demonstrated, there are real benefits of having an explicit header:

1) It removes the chain-end/explicit count ambiguity (see 
http://lkml.org/lkml/2007/10/25/209 & thread)
2) It allows others to manipulate sg chains, which couldn't be done before
   (eg. the ATA code which wants to append a padding element).
3) I can now hand you an sg ring for you to fill: sg chains can't do that.

In short, sg_ring is generally useful primitive.  sg chains are a clever hack 
for scsi_lib to create, and everyone else to read.

Hope that clarifies,
Rusty.
