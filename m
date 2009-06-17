Return-Path: <linux-kernel-owner+w=401wt.eu-S933217AbZFQO2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217AbZFQO2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 10:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756469AbZFQO2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 10:28:30 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:3889 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbZFQO23 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 10:28:29 -0400
X-SpamScore: -28
X-BigFish: VPS-28(zz1432R98dR936eN1805Mzz1202hzzz32i17ch6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KLE073-02-OKD-01
Date: Wed, 17 Jun 2009 16:28:19 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in tty ldisc and friends
Message-ID: <20090617142819.GR5139@amd.com>
References: <20090616085028.GA13771@elte.hu> <20090616095706.36f01282@lxorguk.ukuu.org.uk> <20090616100015.GD6432@elte.hu> <20090616110419.14bc9485@lxorguk.ukuu.org.uk> <20090616101240.GB28204@elte.hu> <20090616102509.GA32717@elte.hu> <20090616102910.GA11011@elte.hu> <20090616103606.GA3497@elte.hu> <1245227523.13761.21661.camel@twins> <20090617141018.GA6846@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090617141018.GA6846@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 17 Jun 2009 14:28:20.0081 (UTC) FILETIME=[DCB4F610:01C9EF57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 04:10:18PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Tue, 2009-06-16 at 12:36 +0200, Ingo Molnar wrote:
> > 
> > > +++ b/lib/dma-debug.c
> > > @@ -62,6 +62,8 @@ struct dma_debug_entry {
> > >  #endif
> > >  };
> > >  
> > > +static struct lock_class_key hash_bucket_class;
> > > +
> > >  struct hash_bucket {
> > >  	struct list_head list;
> > >  	spinlock_t lock;
> > > @@ -716,7 +718,8 @@ void dma_debug_init(u32 num_entries)
> > >  
> > >  	for (i = 0; i < HASH_SIZE; ++i) {
> > >  		INIT_LIST_HEAD(&dma_entry_hash[i].list);
> > > -		dma_entry_hash[i].lock = SPIN_LOCK_UNLOCKED;
> > > +		spin_lock_init(&dma_entry_hash[i].lock);
> > > +		lockdep_set_lock_class(&dma_entry_hash[i].lock, &hash_bucket_class);
> > >  	}
> > >  
> > >  	if (dma_debug_fs_init() != 0) {
> > 
> > I don't see what you need that lockdep_set_class() for, the 
> > spin_lock_init() would already set a class specific to the 
> > callsite. And since all these buckets are initialized from the 
> > same place (ie, this loop), they'd all share the same class.
> >
> > Its just that the old style SPIN_LOCK_UNLOCKED doesn't set a class 
> > and then reverts to the static address of the lock object itself 
> > that these locks used to have different classes.
> > 
> > So in short, yes the above patch should fix it, but it could be 
> > done shorter..
> 
> Indeed ... Joerg: mind removing the set_class complication and just 
> switch it to spin_lock_init().

Ok, done.

> 
> > we really should do another round of SPIN_LOCK_UNLOCKED cleanups 
> > and finally remove that thing.
> 
> +1.

A first step might be updating the documentation under
Documentation/spinlocks.txt to teach people the new right way of
initializing spinlocks :-)

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

