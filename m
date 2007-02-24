Return-Path: <linux-kernel-owner+w=401wt.eu-S932714AbXBXPrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714AbXBXPrD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 10:47:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932838AbXBXPrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 10:47:03 -0500
Received: from amsfep19-int.chello.nl ([213.46.243.16]:59291 "EHLO
	amsfep11-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932714AbXBXPrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 10:47:01 -0500
Subject: Re: [PATCH 18/29] netfilter: notify about NF_QUEUE vs emergency
	skbs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Patrick McHardy <kaber@trash.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
In-Reply-To: <45E05954.8050204@trash.net>
References: <20070221144304.512721000@taijtu.programming.kicks-ass.net>
	 <20070221144843.299254000@taijtu.programming.kicks-ass.net>
	 <45E05954.8050204@trash.net>
Content-Type: text/plain
Date: Sat, 24 Feb 2007 16:46:50 +0100
Message-Id: <1172332010.28579.6.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-24 at 16:27 +0100, Patrick McHardy wrote:
> Peter Zijlstra wrote:
> > Emergency skbs should never touch user-space, however NF_QUEUE is fully user
> > configurable. Notify the user of his mistake and try to continue.
> >
> > --- linux-2.6-git.orig/net/netfilter/core.c	2007-02-14 12:09:07.000000000 +0100
> > +++ linux-2.6-git/net/netfilter/core.c	2007-02-14 12:09:18.000000000 +0100
> > @@ -187,6 +187,11 @@ next_hook:
> >  		kfree_skb(*pskb);
> >  		ret = -EPERM;
> >  	} else if ((verdict & NF_VERDICT_MASK)  == NF_QUEUE) {
> > +		if (unlikely((*pskb)->emergency)) {
> > +			printk(KERN_ERR "nf_hook: NF_QUEUE encountered for "
> > +					"emergency skb - skipping rule.\n");
> > +			goto next_hook;
> > +		}
> 
> If I'm not mistaken any skb on the receive side might get
> allocated from the reserve. I don't see how the user could
> avoid this except by not using queueing at all.

Well, the rules could be setup so that the storage path will never hit
the queue.

> I also didn't see a patch dropping packets allocated from
> the reserve that are forwarded or processed directly without
> getting queued to a socket, so this would allow them to
> bypass userspace queueing and still go through.
> 
> I think the user should just exclude packets necessary for
> swapping from queueing manually, based on IP addresses,
> port numbers or something like that.

Indeed, this patch will just warn the user that he did something very
wrong and should avoid this situation.

Perhaps skipping is not the proper action, but dropping them will most
certainly freeze the box. Either way seems unlucky. Might as well stick
BUG() in there :-(.

Any ideas on how to resolve this are most welcome, detecting the
situation on either rule insert or swapon and failing the respective
action would be most ideal, but I have no idea if that is feasible.

