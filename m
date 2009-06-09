Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbZFIPiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbZFIPiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 11:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbZFIPir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 11:38:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbZFIPir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 11:38:47 -0400
Date: Tue, 9 Jun 2009 17:38:47 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native kernels
Message-ID: <20090609153847.GB9211@wotan.suse.de>
References: <4A0B62F7.5030802@goop.org> <200906032208.28061.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain> <200906041554.37102.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain> <20090609093918.GC16940@wotan.suse.de> <alpine.LFD.2.01.0906090749380.6847@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906090749380.6847@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 07:54:00AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 9 Jun 2009, Nick Piggin wrote:
> > > 
> > > And don't get me wrong - I don't like HIGHMEM. I detest the damn thing. I 
> > > hated having to merge it, and I still hate it. It's a stupid, ugly, and 
> > > very invasive config option. It's just that it's there to support a 
> > > stupid, ugly and very annoying fundamental hardware problem.
> > 
> > I was looking forward to be able to get rid of it... unfortunately
> > other 32-bit architectures are starting to use it again :(
> 
> .. and 32-bit x86 is still not dead, and there are still people who use it 
> with more than 1G of RAM (ie it's not like it's just purely a "small 
> embedded cell-phones with Atom" kind of thing that Intel seems to be 
> pushing for eventually).
> 
> > I guess it is not incredibly intrusive for generic mm code. A bit
> > of kmap sprinkled around which is actually quite a useful delimiter
> > of where pagecache is addressed via its kernel mapping.
> > 
> > Do you hate more the x86 code? Maybe that can be removed?
> 
> No, we can't remove the x86 code, and quite frankly, I don't even mind 
> that. The part I mind is actually the sprinkling of kmap all over. Do a 
> "git grep kmap fs", and you'll see that there are four times as many 
> kmap's in filesystem code than there are in mm/.

Yeah, I guess I just don't see it as such a bad thing. As I said,
it's nice to have something to grep for and not have pointers into
pagecache stored around the place (although filesystems do that
with buffercache).

If code has to jump through particular nasty hoops to use atomic
kmaps, that's not such a good thing...


> I was benchmarking btrfs on my little EeePC. There, kmap overhead was 25% 
> of file access time. Part of it is that people have been taught to use 
> "kmap_atomic()", which is usable under spinlocks and people have been told 
> that it's "fast". It's not fast. The whole TLB thing is slow as hell. 
> 
> Oh well. It's sad. But we can't get rid of it.

If it's such a problem, it could be made a lot faster without too
much problem. You could just introduce a FIFO of ptes behind it 
and flush them all in one go. 4K worth of ptes per CPU might
hopefully bring your overhead down to < 1%.


