Return-Path: <linux-kernel-owner+w=401wt.eu-S932321AbZIOG5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbZIOG5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 02:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757991AbZIOG5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 02:57:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42572 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756898AbZIOG5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 02:57:38 -0400
Date: Tue, 15 Sep 2009 08:57:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Paris <eparis@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       James Morris <jmorris@namei.org>, Thomas Liu <tliu@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [origin tree SLAB corruption] BUG kmalloc-64: Poison
	overwritten, INFO: Allocated in bdi_alloc_work+0x2b/0x100 age=175
	cpu=1 pid=3514
Message-ID: <20090915065707.GA3435@elte.hu>
References: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com> <alpine.LRH.2.00.0909071215530.3222@tundra.namei.org> <20090912072450.GA6767@elte.hu> <1252808939.13780.30.camel@dhcp231-106.rdu.redhat.com> <20090914071631.GA24801@elte.hu> <alpine.LFD.2.01.0909140725470.3654@localhost.localdomain> <20090914162902.GF6773@linux.vnet.ibm.com> <20090914171037.GG14984@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914171037.GG14984@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Mon, Sep 14 2009, Paul E. McKenney wrote:
> > On Mon, Sep 14, 2009 at 07:40:27AM -0700, Linus Torvalds wrote:
> > > 
> > > 
> > > On Mon, 14 Sep 2009, Ingo Molnar wrote:
> > > > 
> > > > BUG kmalloc-64: Poison overwritten
> > > > -----------------------------------------------------------------------------
> > > > 
> > > > INFO: 0xf498f6a0-0xf498f6a7. First byte 0x90 instead of 0x6b
> > > > INFO: Allocated in bdi_alloc_work+0x2b/0x100 age=175 cpu=1 pid=3514
> > > > INFO: Freed in bdi_work_free+0x45/0x60 age=9 cpu=1 pid=3509
> > > > INFO: Slab 0xc3257d84 objects=36 used=11 fp=0xf498f690 flags=0x400000c3
> > > > INFO: Object 0xf498f690 @offset=1680 fp=0xf498fe00
> > > > 
> > > > Bytes b4 0xf498f680:  ab 0d 00 00 9c 27 ff ff 5a 5a 5a 5a 5a 5a 5a 5a ?....'??ZZZZZZZZ
> > > >   Object 0xf498f690:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > > >   Object 0xf498f6a0:  90 f3 98 f4 60 3c 11 c1 6b 6b 6b 6b 6b 6b 6b 6b .?.?`<.?kkkkkkkk
> > > 
> > > That's 8 bytes of 0xf498f398 and 0xc1113c60. Doesn't look like much, but 
> > > they're both valid kernel pointers, and the 0xf498f398 one is actually 
> > > into the same page as the corruption, so it's a pointer to the same slab 
> > > type (or at least same size). Which is a good hint in itself: we're 
> > > looking at a list or something.
> > > 
> > > And it's at offset 16 in the structure. 
> > > 
> > > That's almost certainly a "struct bdi_work", and the use-aftr-free thing 
> > > is the "struct rcu_head rcu_head" part of it. That first thing (pointer to 
> > > the same page) is 'next', and the second thing is a pointer to kernel text 
> > > (and I can pretty much guarantee that 0xc1113c60 is 'bdi_work_free').
> > > 
> > > So this is either a fs/fs-writeback.c bug, or it's a problem with RCU. 
> > > Both of them are new or hugely changed since 2.6.31.
> > 
> > If this run had used CONFIG_TREE_PREEMPT_RCU rather than the 
> > CONFIG_TREE_RCU that it actually had used, I would suggest applying 
> > the patchset I submitted yesterday (Sept 13).
> > 
> > 	http://thread.gmane.org/gmane.linux.kernel/888803
> 
> Ingo, did it? [...]

The config i attached to the bugreport has:

 #
 # RCU Subsystem
 #
 CONFIG_TREE_RCU=y
 # CONFIG_TREE_PREEMPT_RCU is not set
 CONFIG_RCU_TRACE=y
 CONFIG_RCU_FANOUT=64
 CONFIG_RCU_FANOUT_EXACT=y
 CONFIG_TREE_RCU_TRACE=y

So TREE_PREEMPT_RCU & the synchronize_rcu() bug Paul fixed is out.

> [...] I'll dive into this tonight, Linus' analysis and just a general 
> feel does point in the direction of the bdi work.

Hard to tell whether it's BDI, RCU or something else - sadly this is the 
only incident i've managed to log so far. (We'd be all much happier if 
boxes crashed left and right! ;)

-tip's been carrying the RCU changes for a long(er) time which would 
reduce the chance of this being RCU related. [ It's still possible 
though: if it's a bug with a probability of hitting this box on these 
workloads with a chance of 1:20,000 or worse. ]

Plus it triggered shortly after i updated -tip to latest -git which had 
the BDI bits - which would indicate the BDI stuff - or just about 
anything else in -git for that matter - or something older in -tip. 
Every day without having hit this crash once more broadens the range of 
plausible possibilities.

In any case, i'll refrain from trying to fit a line on a single point of 
measurement ;-)

	Ingo
