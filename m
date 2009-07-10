Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbZGJMqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbZGJMqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 08:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbZGJMpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 08:45:51 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:56983 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292AbZGJMpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 08:45:49 -0400
Date: Fri, 10 Jul 2009 21:45:47 +0900 (JST)
Message-Id: <20090710.214547.34380852.mitake@dcl.info.waseda.ac.jp>
To: andi@firstfloor.org
Cc: a.p.zijlstra@chello.nl, fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired
 how many spinlocks to schedstat
From: mitake@dcl.info.waseda.ac.jp
In-Reply-To: <20090706115451.GA29715@one.firstfloor.org>
References: <20090706.142058.56800444.mitake@dcl.info.waseda.ac.jp>
	<1246870279.8143.4.camel@twins>
	<20090706115451.GA29715@one.firstfloor.org>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
Date: Mon, 6 Jul 2009 13:54:51 +0200

Thank you for your replying, Peter and Andi.

> > Maybe re-use the LOCK_CONTENDED macros for this, but I'm not sure we
> > want to go there and put code like this on the lock hot-paths for !debug
> > kernels.
> 
> My concern was similar.
> 
> I suspect it would be in theory ok for the slow spinning path, but I am 
> somewhat concerned about the additional cache miss for checking
> the global flag even in this case. This could hurt when
> the kernel is running fully cache hold, in that the cache miss
> might be far more expensive that  short spin.

Yes, there will be overhead. This is certain.
But there's the radical way to ignore this,
adding subcategory to Kconfig for measuring spinlocks and #ifdef to spinlock.c.
So people who wants to avoid this overhead can disable measurement of spinlocks completely.

And there's another way to avoid the overhead of measurement.
Making _spin_lock variable of function pointer.
When you don't want to measure spinlocks,
assign _spin_lock_raw() which is equals to current _spin_lock().
When you want to measure spinlocks,
assign _spin_lock_perf() which locks and measures.
This way will banish the cache miss problem you said.
I think this may be useful for avoiding problem of recursion.

> 
> Needs immediate value patching or just use a jumper kprobe when it's
> really needed? I think I would prefer the later variant.

What does "immediate value patching" mean?
I've never heard about this, so Googled but cannot find anything maybe you said.
Could you teach me about this?

But there's also spinlock recursion problem.. > kprobe
