Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbXLaWBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbXLaWBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 17:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbXLaWBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 17:01:37 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:47932 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbXLaWBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 17:01:36 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett Packard
To: James Morris <jmorris@namei.org>
Subject: Re: 2.6.24-rc6-mm1 - git-lblnet.patch and networking horkage
Date: Mon, 31 Dec 2007 17:01:24 -0500
User-Agent: KMail/1.9.7
Cc: Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, netdev@vger.kernel.org
References: <3281504256.5618888@mail.hp.com> <200712311506.15230.paul.moore@hp.com> <Xine.LNX.4.64.0801010841060.25768@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0801010841060.25768@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712311701.24685.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 December 2007 4:46:09 pm James Morris wrote:
> On Mon, 31 Dec 2007, Paul Moore wrote:
> > I'm pretty certain this is an uninitialized value problem now and not a
> > use-after-free issue.  The invalid/garbage ->iif value seems to only
> > happen on packets that are generated locally and sent back into the stack
> > for local consumption, e.g. loopback.  These local packets also need to
> > have been cloned at some point, either on the output or input path.
>
> I think we need to find out exactly what's happening, first.

The more I've looked at the code this afternoon, I'm certain this is the case.  
I've also been running a patched kernel (using option #2 from below) and all 
of the skbs coming up the stack have valid ->iif values.  Granted, I haven't 
examined the code from the avahi daemon or the tcl test cases and traced the 
entire code path through the kernel but I _am_ certain that at some point in 
that code path the packet is cloned and due to a problem in skb_clone() 
the ->iif field is not copied correctly causing the problems we have all 
seen.

How much smoke needs to be coming from the gun? :)

> > The problem appears to be a skb_clone() function which does not clear the
> > skb structure properly and fails to copy the ->iif value from the
> > original skb to the cloned skb.  From what I can tell, there are two
> > possible solutions to this problem:
> >
> >  1. Clear all of the cloned skb fields in skb_clone() via memset()
>
> Sounds like it's not going to fly for performance reasons in any case.

That was my gut feeling.  I was also a little unsure where exactly the correct 
placement should be for the memset() call.

> >  2. Copy the ->iif field in __copy_skb_header()
>
> Seems valid.

Okay, I'll stick with this approach.  I'll post a patch backed against 
net-2.6.25 tomorrow as an RFC to see if anyone on netdev has any strong 
feelings.  If no one complains, I'll add it to the lblnet git tree.

-- 
paul moore
linux security @ hp
