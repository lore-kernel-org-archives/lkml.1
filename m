Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbYDBQcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbYDBQcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbYDBQc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:32:28 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57870 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491AbYDBQc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:32:28 -0400
Date: Wed, 2 Apr 2008 19:32:26 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
In-Reply-To: <19f34abd0804020915k210277bbmb6b9aa28f282bb42@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804021924280.6839@sbz-30.cs.Helsinki.FI>
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com> 
 <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk> 
 <Pine.LNX.4.64.0804021020280.25738@sbz-30.cs.Helsinki.FI> 
 <20080402072456.GI12774@kernel.dk> <20080402072846.GA16454@elte.hu> 
 <20080402105539.GA5610@linux.vnet.ibm.com>  <84144f020804020401j4e5863dcofd16662baa54574@mail.gmail.com>
  <20080402160809.GA4123@linux.vnet.ibm.com>
 <19f34abd0804020915k210277bbmb6b9aa28f282bb42@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

On Wed, Apr 2, 2008 at 6:08 PM, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > Would the following be an appropriate fix?  It seems to me to be in
> > the same spirit as the existing check for s->ctor.
 
On Wed, 2 Apr 2008, Vegard Nossum wrote:
> In my opinion, no.
> 
> It would fix the false positives, but would in fact also hide cases
> such as this one with cfq, e.g. the real cases of mis-use.

Yes, but we might as well put Paul's patch in now and remove that later 
when we have a proper fix, no?

On Wed, 2 Apr 2008, Vegard Nossum wrote:
> Peter Zijlstra suggested this:
> > It would have to register an call_rcu callback itself in order to mark
> > it freed - and handle the race with the object being handed out again.
> 
> I will try to look into this -- for now, I need to understand RCU
> first (I've seen your LWN articles -- great work! :-))

Well, maybe we can add two new states: RCU_FREED and RCU_VALIDATED? The 
object is flagged with the first one as soon as an object is handed over 
to kmem_cache_free() and the latter needs to hook to the validation phase 
of RCU (how is that done btw?). Then kmemcheck could even give a better 
error message: "RCU-freed object used without validation."

And with delayed free for kmemcheck we discussed before, we'd hold on to 
the objects long enough to actually see these error conditions.

			Pekka
