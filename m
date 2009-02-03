Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbZBCQmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbZBCQmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbZBCQmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:42:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752436AbZBCQme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:42:34 -0500
Date: Tue, 3 Feb 2009 08:40:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Hugh Dickins <hugh@veritas.com>, Greg KH <gregkh@suse.de>,
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
In-Reply-To: <1233677610.15321.129.camel@lts-notebook>
Message-ID: <alpine.LFD.2.00.0902030822450.3247@localhost.localdomain>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>  <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>  <1233259410.2315.75.camel@lts-notebook>  <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain> 
 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>  <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com>  <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain>  <20090130055639.GA30950@suse.de>  <alpine.LFD.2.00.0901300811260.3150@localhost.localdomain>
  <Pine.LNX.4.64.0901301724010.1563@blonde.anvils>  <alpine.LFD.2.00.0901300946360.3150@localhost.localdomain>  <1233345190.908.36.camel@lts-notebook>  <alpine.LFD.2.00.0901301159500.3150@localhost.localdomain>  <Pine.LNX.4.64.0901302048360.18677@blonde.anvils>
  <1233351412.908.69.camel@lts-notebook>  <alpine.LFD.2.00.0901301426390.3150@localhost.localdomain>  <Pine.LNX.4.64.0901311216250.6763@blonde.anvils> <1233677610.15321.129.camel@lts-notebook>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Lee Schermerhorn wrote:
> 
> This reminded me of something I'd seen recently looking
> at /proc/<pid>/[numa]_maps for <a large commercial database> on
> Linux/x86_64: 
> 
> 2adadf2b9000-2adadf2c0000 rwxp 00000000 00:0e 4072                       /dev/zero
> 
> For portability between Linux and various Unix-like systems that don't
> support MAP_ANON*, perhaps?

Odd. 

At first I thought that it is just that Linux will turn a MAP_SHARED | 
MAP_ANON into that /dev/zero thing, so you won't be able to tell by lookup 
at /proc/maps. So it would be very possible that the application did not 
actually open /dev/zero at all, and used MAP_ANON instead (see the whole 
shmem_zero_setup() and shmem_file_setup() thing).

But those mappings have that 'p' for private there, so it's not 
MAP_SHARED. And yes, that means that your large commercial database really 
did open /dev/zero and mapped it privately. They must be living in the 
past.

> Anyway, from the addresses and permissions, these all look potentially
> mergeable.  The offset is preventing merging, right?  I guess that's one
> of the downsides of mapping /dev/zero rather than using MAP_ANONYMOUS?

Yeah. The MAP_ANON code has a total hack:

                case MAP_PRIVATE:
                        /*
                         * Set pgoff according to addr for anon_vma.
                         */
                        pgoff = addr >> PAGE_SHIFT;
                        break;

where the whole point is to allow sharing: since pgoff doesn't matter, we 
can make it be something that will merge _if_ you don't play games (of 
course, if you then start usign mremap to move things around, that all 
breaks, and you lose the merging ;)

That said, if it's just a hundred segments, nobody really cares. It's 
going to make vma lookup fractionally slower, but not so anybody would 
likely ever notice even in benchmarks. And if it's just this one db, it's 
certainly not going to use any noticeable amount of memory either.

Merging is important, but it's important to avoid the _really_ common 
cases, and to make /proc/maps more readable etc. It's not like it matters 
for the occasional crazy setup.

But you could still try to teach the DB people to use MAP_ANON.

			Linus
