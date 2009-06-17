Return-Path: <linux-kernel-owner+w=401wt.eu-S1764637AbZFQOKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764637AbZFQOKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760055AbZFQOKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:10:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42205 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757677AbZFQOKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:10:33 -0400
Date: Wed, 17 Jun 2009 16:10:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Joerg Roedel <joerg.roedel@amd.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in tty ldisc and friends
Message-ID: <20090617141018.GA6846@elte.hu>
References: <20090616093741.0d5b36bc@lxorguk.ukuu.org.uk> <20090616085028.GA13771@elte.hu> <20090616095706.36f01282@lxorguk.ukuu.org.uk> <20090616100015.GD6432@elte.hu> <20090616110419.14bc9485@lxorguk.ukuu.org.uk> <20090616101240.GB28204@elte.hu> <20090616102509.GA32717@elte.hu> <20090616102910.GA11011@elte.hu> <20090616103606.GA3497@elte.hu> <1245227523.13761.21661.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245227523.13761.21661.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2009-06-16 at 12:36 +0200, Ingo Molnar wrote:
> 
> > +++ b/lib/dma-debug.c
> > @@ -62,6 +62,8 @@ struct dma_debug_entry {
> >  #endif
> >  };
> >  
> > +static struct lock_class_key hash_bucket_class;
> > +
> >  struct hash_bucket {
> >  	struct list_head list;
> >  	spinlock_t lock;
> > @@ -716,7 +718,8 @@ void dma_debug_init(u32 num_entries)
> >  
> >  	for (i = 0; i < HASH_SIZE; ++i) {
> >  		INIT_LIST_HEAD(&dma_entry_hash[i].list);
> > -		dma_entry_hash[i].lock = SPIN_LOCK_UNLOCKED;
> > +		spin_lock_init(&dma_entry_hash[i].lock);
> > +		lockdep_set_lock_class(&dma_entry_hash[i].lock, &hash_bucket_class);
> >  	}
> >  
> >  	if (dma_debug_fs_init() != 0) {
> 
> I don't see what you need that lockdep_set_class() for, the 
> spin_lock_init() would already set a class specific to the 
> callsite. And since all these buckets are initialized from the 
> same place (ie, this loop), they'd all share the same class.
>
> Its just that the old style SPIN_LOCK_UNLOCKED doesn't set a class 
> and then reverts to the static address of the lock object itself 
> that these locks used to have different classes.
> 
> So in short, yes the above patch should fix it, but it could be 
> done shorter..

Indeed ... Joerg: mind removing the set_class complication and just 
switch it to spin_lock_init().

> we really should do another round of SPIN_LOCK_UNLOCKED cleanups 
> and finally remove that thing.

+1.

	Ingo
