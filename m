Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbZLVRsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbZLVRsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 12:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZLVRsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 12:48:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37898 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbZLVRsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 12:48:52 -0500
Subject: Re: workqueue thing
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net
In-Reply-To: <alpine.LFD.2.00.0912220917270.31313@localhost.localdomain>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
	 <1261143924.20899.169.camel@laptop> <20091218135033.GB8678@basil.fritz.box>
	  <4B2B9949.1000608@linux.intel.com> <20091221091754.GG4489@kernel.dk>
	  <4B2F57E6.7020504@linux.intel.com> <4B2F768C.1040704@kernel.org>
	  <4B2F7DD2.2080902@linux.intel.com> <4B2F83F6.2040705@kernel.org>
	  <4B2F9212.3000407@linux.intel.com> <4B300C01.8080904@kernel.org>
	 <1261480220.4937.24.camel@laptop>
	 <alpine.LFD.2.00.0912220917270.31313@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 18:47:22 +0100
Message-ID: <1261504042.4937.59.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-22 at 09:20 -0800, Linus Torvalds wrote:
> 
> So stop arguing about irrelevancies. Nobody uses workqueues for RT or for 
> CPU-intensive crap. It's not what they were designed for, or used for.

RT crap maybe, but cpu intensive bits are used for sure, see the
crypto/crypto_wq.c drivers/md/dm*.c.

I've seen those consume significant amounts of cpu, now I'm not going to
argue that workqueues are not the best way to consume lots of cpu, but
the fact is they _are_ used for that.

And since tejun's thing doesn't have wakeup parallelism covered these
uses can turn into significant loads.

> If you _want_ to use them for that, that is _your_ problem. Not Tejuns.

I don't want to use workqueues at all.

> People use workqueues for other things _today_, and they have annoying 
> problems as they stand. It would be nice to get rid of the deadlock 
> issue, for example - right now the tty driver literally does crazy things, 
> and drops locks that it shouldn't drop due to the fact that it needs to 
> wait for queued work - even if the queued work it is actually waiting for 
> isn't the one that takes the lock!

Which in turn would imply we cannot carry fwd the current lockdep
annotations, right?

Which means we'll be stuck in a situation where A flushes B and B
flushes A will go undetected until we actually hit it.

Where exactly does the tty thing live in the code?

