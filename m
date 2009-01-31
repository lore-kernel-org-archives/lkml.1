Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbZAaMgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbZAaMgt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 07:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbZAaMgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 07:36:41 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:55350 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbZAaMgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 07:36:40 -0500
Date: Sat, 31 Jan 2009 12:35:35 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mikos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
 file segments
In-Reply-To: <alpine.LFD.2.00.0901301426390.3150@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0901311216250.6763@blonde.anvils>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com> 
 <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain> 
 <1233259410.2315.75.camel@lts-notebook>  <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>
  <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain> 
 <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com> 
 <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain> 
 <20090130055639.GA30950@suse.de>  <alpine.LFD.2.00.0901300811260.3150@localhost.localdomain>
  <Pine.LNX.4.64.0901301724010.1563@blonde.anvils> 
 <alpine.LFD.2.00.0901300946360.3150@localhost.localdomain> 
 <1233345190.908.36.camel@lts-notebook>  <alpine.LFD.2.00.0901301159500.3150@localhost.localdomain>
  <Pine.LNX.4.64.0901302048360.18677@blonde.anvils> <1233351412.908.69.camel@lts-notebook>
 <alpine.LFD.2.00.0901301426390.3150@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009, Linus Torvalds wrote:
> On Fri, 30 Jan 2009, Lee Schermerhorn wrote:
> > 
> > I just verified that adding VM_ACCOUNT to VM_MERGEABLE does allow the
> > merge to happen with the test program.  And the system didn't come
> > crashing down around me.  But, I wouldn't trust that simple test as the
> > last word.  A short run of a stress load I use held up/still running,
> > but I can't tell whether it's merging as expected there.   
> 
> Just ignoring VM_ACCOUNT for merging is not the right thing to do. It 
> probably works in practice for just about everything, but at least in 
> theory it does mean that mmap() can stop honoring MAP_NORESERVE.
> 
> Admittedly the circumstances where that happens are unlikely, and nobody 
> probably even really uses MAP_NORESERVE in the first place, so I doubt you 
> can ever see it as a real issue, but it's still technically wrong to merge 
> vma's that can differ in VM_ACCOUNT.
> 
> Now, the particular test you have, VM_ACCOUNT differs only during that 
> temporary window, and the vma's really do end up with the same VM_ACCOUNT 
> state in the end, so merging them is correct, but if you were to privately 
> map the same file (or private anonymous map) with the same permissions 
> next to each other so that they -could- merge, but use MAP_NORESERVE on 
> one and not on the other, then they shouldn't merge.
> 
> So VM_ACCOUNT does matter - just barely - for merging, and we just happen 
> to currently hit it too much due to a very odd internal reason.

It matters more than just barely - if you care about non-overcommit,
or if you care about non-wrapping Committed_AS in your /proc/meminfo.

Ignoring VM_ACCOUNT when merging is very much the wrong thing to do,
because it lets an unaccounted area be treated thereafter as accounted,
or vice versa - even forgetting the MAP_NORESERVE special case.

I have by now recalled why I chose to play those VM_ACCOUNT games:
	/* We set VM_ACCOUNT in a shared mapping's vm_flags, to inform
	 * shmem_zero_setup (perhaps called through /dev/zero's ->mmap)
	 * that memory reservation must be checked; but that reservation
	 * belongs to shared memory object, not to vma: so now clear it.
We need a way to communicate not-MAP_NORESERVE to shmem.c, and we don't
just need it in the explicit shmem_zero_setup() case, we also need it
for the (probably rare nowadays) case when mmap() is working on file
/dev/zero (drivers/char/mem.c mmap_zero()), rather than using MAP_ANON.

Still haven't decided what's best to do about it (plenty of diversions):
perhaps we just say my error was to overload VM_ACCOUNT, and define a
new flag for the purpose, which can go into VM_MERGEABLE_FLAGS; but
I'd prefer a neater solution if it crosses my mind.

Hugh
