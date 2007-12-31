Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbXLaUHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbXLaUHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 15:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbXLaUHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 15:07:03 -0500
Received: from mailhub.hp.com ([192.151.27.10]:57670 "EHLO mailhub.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbXLaUHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 15:07:00 -0500
From: Paul Moore <paul.moore@hp.com>
To: James Morris <jmorris@namei.org>
Subject: Re: 2.6.24-rc6-mm1 - git-lblnet.patch and networking horkage
Date: Mon, 31 Dec 2007 15:06:13 -0500
User-Agent: KMail/1.9.7
Cc: Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, netdev@vger.kernel.org
References: <3281504256.5618888@mail.hp.com> <Xine.LNX.4.64.0712270848260.19279@us.intercode.com.au> <200712311213.32515.paul.moore@hp.com>
In-Reply-To: <200712311213.32515.paul.moore@hp.com>
Organization: Hewlett Packard
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712311506.15230.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 December 2007 12:13:32 pm Paul Moore wrote:
> On Wednesday 26 December 2007 4:52:03 pm James Morris wrote:
> > On Thu, 26 Dec 2007, Paul Moore wrote:
> > > As James said I'm away right now and computer access is limited.
> > > However, I'm stuck in the airport right now and spent some time looking
> > > at the code ... Based on what has been found so far I wonder if the
> > > problem isn't a race but a problem of skb->iif never being initialized
> > > correctly?  To my untrained eye it looks like __netdev_alloc_skb()
> > > should be setting skb->iif (like it does for skb->dev) but it currently
> > > doesn't.
> >
> > ->iif will be zeroed during skb allocation, then set during
> > netif_receive_skb().
>
> I was able to reproduce this bug this morning by running avahi as James did
> and did a little more digging.  I don't have a fix yet, but thought I would
> pass along what I've found in case this triggers a moment of clarity to
> someone out there ...
>
> The skb->iif value appears to be messed up as early as netif_receive_skb(),
> in my case it is set to 196611 (trust me, I don't have that many interfaces
> in my test machine) which causes the ->iif initialization code in
> netif_receive_skb() to be skipped because ->iif is greater than zero.  This
> particular packet is locally generated and locally consumed.
>
> Hopefully I'll have a fix later this afternoon but if someone has a bright
> idea I'd love to hear it ...

[NOTE: I added netdev to this thread to gather some input.  @netdev folks, the 
problem is that the skb->iif field contains garbage in some cases which is 
causing problems for some new SELinux network code.  The exact problem 
probably isn't too important for this discussion, what is important is that 
the skb->iif field contains a non-zero garbage value some of the time on 
incoming packets.]

I'm pretty certain this is an uninitialized value problem now and not a 
use-after-free issue.  The invalid/garbage ->iif value seems to only happen 
on packets that are generated locally and sent back into the stack for local 
consumption, e.g. loopback.  These local packets also need to have been 
cloned at some point, either on the output or input path.

The problem appears to be a skb_clone() function which does not clear the skb 
structure properly and fails to copy the ->iif value from the original skb to 
the cloned skb.  From what I can tell, there are two possible solutions to 
this problem:

 1. Clear all of the cloned skb fields in skb_clone() via memset()
 2. Copy the ->iif field in __copy_skb_header()

I don't have a good enough understanding of all the details involving skb 
memory management to know if option #1 is a Good Idea or not, but option #2 
seems much simpler and solves the problem of garbage in the ->iif field.  My 
preference is to go with option #2 but before I submit a patch does anyone 
think this is the wrong solution?

-- 
paul moore
linux security @ hp
