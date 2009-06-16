Return-Path: <linux-kernel-owner+w=401wt.eu-S934182AbZFPFgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934182AbZFPFgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933317AbZFPFgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:36:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:60105 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760852AbZFPFgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:36:08 -0400
Date: Tue, 16 Jun 2009 07:36:09 +0200
From: Nick Piggin <npiggin@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
Message-ID: <20090616053609.GB2924@wotan.suse.de>
References: <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com> <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop> <1245059859.23207.16.camel@penberg-laptop> <20090615102737.GA20461@wotan.suse.de> <1245062727.12400.23.camel@pasglop> <20090615112355.GB6012@wotan.suse.de> <Pine.LNX.4.64.0906151329310.24256@sister.anvils> <20090616045704.GC28596@wotan.suse.de> <1245130087.12400.82.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245130087.12400.82.camel@pasglop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 03:28:07PM +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2009-06-16 at 06:57 +0200, Nick Piggin wrote:
> > 
> > Yes but that's heavily qualified. As I said, we already require
> > a lot of knowledge of context passed in to it. I have no interest
> > in adding code to make *early boot* code not have to care about
> > that, especially because everybody else certainly has to know
> > whether they are calling the allocator with interrupts disabled
> > or a lock held etc.
> 
> You seem to totally ignore the argument I made to answer this specific
> point in one of my previous emails. Right, they are to some extent
> subjective, but I believe they have some standing. The main one is
> probably that it's a lot less obvious to a lot of code where in the boot
> process it's going to be called, or even if it's going to be called at
> boot, later, both. This is especially true nowadays with all the talks
> about shuffling more of the boot process around.

I didn't ignore that argument, I just don't agree. It only does
not "know" the context it is called from if it does not get that
information passed to it from its caller who does know.

 
> > To be clear about this: the allocator is fully servicable and
> > no different to normal system running at this point. The
> > difference for example is that code runs with interrupts off
> > but incorrectly uses GFP_KERNEL for allocations. This is a
> > blatent bug in any other kernel code, I don't know why boot
> > code is OK to be horrible and wrong and work around it with
> > the equally horrible system_state (and this gfp mask which is
> > just system_state under another name).
> 
> Because it would be extremely impractical to have to explicitely pass
> the gfp_flags around for anything that can be called at boot time. This
> is as simple as that. A -lot- more impractical than requiring atomic
> call sites to know what they are doing.

We'll see.

 
> > I just don't want to use this slab fix in question to be a
> > license to throw away and forget all about any context information
> > in the early boot code because someone asserts "it will make the
> > code better".  I'm fine with the slab change for now, but let's
> > try to retain context information as well.
> 
> But in many case it's meaningless. Again, what do you define as "boot"
> is a very obscure thing here.

It's not obscure. I'm vague because it doesn't matter *all that much*.

 
> > If somebody comes up with a patch to remove thousands of lines
> > of boot code by ignoring context, then I might concede the
> > point and we could remove the context annotations.
> 
> No, we don't want to -add- thousands of lines of code :-) And we can

I don't understand. Where would you be adding thousands of lines
of code?


> indeed remove a bunch of the old slab_is_available() tests too indeed.
> And no, they should not -all- be converted to NOWAIT. See vmalloc() as a
> good example, I have a few more like that.

There aren't too many significant code simplifications AFAIKS.
