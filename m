Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbYIWVKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbYIWVKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbYIWVKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:10:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:49594 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbYIWVKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:10:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references:x-gmailtapped-by;
	b=nDm0Cx0GxKiyQLnSvuB6QScnbP37Zs/RsF9o9x4Mp+kvqZ2HtZOC3EXUb0cLovm3o
	uTGmIe2CSRD7hghH2XCrw==
Message-ID: <65634d660809231410v47fb9d84s63fa76f358756729@mail.gmail.com>
Date: Tue, 23 Sep 2008 14:10:21 -0700
From: "Tom Herbert" <therbert@google.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: [PATCH 0/2]: Remote softirq invocation infrastructure.
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com,
       steffen.klassert@secunet.com
In-Reply-To: <48D92174.5010902@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080919.234824.223177211.davem@davemloft.net>
	 <48D80C9C.2070108@nortel.com>
	 <20080922.151233.229805934.davem@davemloft.net>
	 <48D92174.5010902@nortel.com>
X-GMailtapped-By: 172.25.146.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> That patch basically just picks an arbitrary cpu for each flow.  This would
> spread the load out across cpus, but it doesn't allow any input from
> userspace.
>

We've been running softRSS for a while
(http://marc.info/?l=linux-netdev&m=120475045519940&w=2) which I
believe has very similar functionality to this patch.  From this work
we found some nice ways to improve scaling that might be applicable:

- When routing packets to CPU based on hash, sending to another CPU
sharing L2 or L3 cache is best performance.
- We added a simple functionality to route packets to the CPU on which
the application last did a read for the socket.  This seems to be a
win for cache locality.
- We added a lookup table that maps the Toeplitz hash to the receiving
CPU where the application is running.  This is for those devices that
provide the Toeplitz hash in the receive descriptor.  This is a win
since the CPU receiving the interrupt doesn't need to take any cache
misses on the packet itself.
- In our (preliminary) 10G testing we found that routing packets in
software with the the above trick actually allows higher PPS and
better CPU utilization than using hardware RSS.  Also, using both the
software routing and hardware RSS yields the best results.

Tom

> We have a current application where there are 16 cores and 16 threads. They
> would really like to be able to pin one thread to each core and tell the
> kernel what packets they're interested in so that the kernel can process
> those packets on that core to gain the maximum caching benefit as well as
> reduce reordering issues.  In our case the hardware supports filtering for
> multiqueues, so we could pass this information down to the hardware to avoid
> software filtering.
>
> Either way, it requires some way for userspace to indicate interest in a
> particular flow.  Has anyone given any thought to what an API like this
> would look like?
>
> I suppose we could automatically look at bound network sockets owned by
> tasks that are affined to single cpus.  This would simplify userspace but
> would reduce flexibility for things like packet sockets with socket filters
> applied.
>
> Chris
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
