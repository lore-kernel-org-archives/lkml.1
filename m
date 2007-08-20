Return-Path: <linux-kernel-owner+w=401wt.eu-S1762384AbXHTV3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762384AbXHTV3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbXHTV25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:28:57 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:1861 "EHLO myri.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761480AbXHTV2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:28:55 -0400
X-Greylist: delayed 2928 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Aug 2007 17:28:54 EDT
Message-ID: <46C9FAB4.5020609@myri.com>
Date: Mon, 20 Aug 2007 16:33:56 -0400
From: Patrick Geoffray <patrick@myri.com>
Organization: Myricom, Inc.
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Felix Marti <felix@chelsio.com>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, David Miller <davem@davemloft.net>,
       sean.hefty@intel.com, netdev@vger.kernel.org, rdreier@cisco.com,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCPportsfrom
 the host TCP port space.
References: <20070819.174017.77241227.davem@davemloft.net> <8A71B368A89016469F72CD08050AD334018E20BE@maui.asicdesigners.com> <20070820094317.GA14817@2ka.mipt.ru> <8A71B368A89016469F72CD08050AD334018E2115@maui.asicdesigners.com>
In-Reply-To: <8A71B368A89016469F72CD08050AD334018E2115@maui.asicdesigners.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Felix Marti wrote:
> Yes, the app will take the cache hits when accessing the data. However,
> the fact remains that if there is a copy in the receive path, you
> require and additional 3x memory BW (which is very significant at these
> high rates and most likely the bottleneck for most current systems)...
> and somebody always has to take the cache miss be it the copy_to_user or
> the app.

The cache miss is going to cost you half the memory bandwidth of a full 
copy. If the data is already in cache, then the copy is cheaper.

However, removing the copy removes the kernel from the picture on the 
receive side, so you lose demultiplexing, asynchronism, security, 
accounting, flow-control, swapping, etc. If it's ok with you to not use 
the kernel stack, then why expect to fit in the existing infrastructure 
anyway ?

> Yes, RDMA support is there... but we could make it better and easier to

What do you need from the kernel for RDMA support beyond HW drivers ? A 
fast way to pin and translate user memory (ie registration). That is 
pretty much the sandbox that David referred to.

Eventually, it would be useful to be able to track the VM space to 
implement a registration cache instead of using ugly hacks in user-space 
to hijack malloc, but this is completely independent from the net stack.

> use. We have a problem today with port sharing and there was a proposal

The port spaces are either totally separate and there is no issue, or 
completely identical and you should then run your connection manager in 
user-space or fix your middlewares.

> and not for technical reasons. I believe this email threads shows in
> detail how RDMA (a network technology) is treated as bastard child by
> the network folks, well at least by one of them.

I don't think it's fair. This thread actually show how pushy some RDMA 
folks are about not acknowledging that the current infrastructure is 
here for a reason, and about mistaking zero-copy and RDMA.

This is a similar argument than the TOE discussion, and it was 
definitively a good decision to not mess up the Linux stack with TOEs.

Patrick
