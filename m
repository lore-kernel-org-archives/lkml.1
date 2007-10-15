Return-Path: <linux-kernel-owner+w=401wt.eu-S1760678AbXJOJqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760678AbXJOJqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 05:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbXJOJqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 05:46:38 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:30171 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754643AbXJOJqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 05:46:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PK5VT20zB8mpzQk1dP7cU2cmUpxCyjh1ydXDKL1ssj8aib32xSwpw7Z7m0Jt0IadfGiEqHfyY8izA2mGuYmNN6HcElfXQvId5r7nC8No2+IFbfYRTZhg8bCaswvMh/cB1hVYe3pFitnskVGpjvVePz8W65/mVu2VD/JIXjkeI30=  ;
X-YMail-OSG: .7mTVa8VM1nVpOGq1.M01dPWbFVDVeEb4J4vo7i4dkbKKLuHKRIdX3IvvbW3cZftiCBE0EpqCQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: Interaction between Xen and XFS: stray RW mappings
Date: Tue, 16 Oct 2007 00:56:46 +1000
User-Agent: KMail/1.9.5
Cc: David Chinner <dgc@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       xfs@oss.sgi.com, Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       Morten =?iso-8859-1?q?B=C3=B8geskov?= 
	<xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com> <p731wbw4t3h.fsf@bingen.suse.de>
In-Reply-To: <p731wbw4t3h.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710160056.47458.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007 19:36, Andi Kleen wrote:
> David Chinner <dgc@sgi.com> writes:
> > And yes, we delay unmapping pages until we have a batch of them
> > to unmap. vmap and vunmap do not scale, so this is batching helps
> > alleviate some of the worst of the problems.
>
> You're keeping vmaps around for already freed pages?

> That will be a big problem for proper PAT support, which needs
> to track all mappings to memory. It's not just a problem for Xen.
>
> In fact I suspect it is already broken with DRM or AGP for example which
> can use UC and WC mappings -- if you keep the mapping around and
> DRM or AGP turns the page in another mapping uncacheable you're
> creating an illegal cache attribute alias. These are known to occasionally
> create cache corruptions on several x86s; giving ___VERY___ hard to debug
> bugs once a blue moon.

Is this true even if you don't write through those old mappings?
Is DRM or AGP then not also broken with lazy highmem flushing, or
how do they solve that?


> Probably it'll require some generic VM batching mechanism where
> Xen or PAT code can hook into the list or force unmap the mappings
> as needed.

Definitely.


> Definitely needs to be fixed if true. You're lucky that Xen caught it
> in time.

I've been thinking that a simple debug mode could be a good idea.
Have a new field in the struct page to count the number of possible
unflushed mappings to the page so that things like PAT could go
BUG_ON appropriate conditions. Would that be helpful?
