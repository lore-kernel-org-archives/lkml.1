Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbZDGI21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbZDGI21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbZDGI1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:27:53 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:23816 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbZDGI1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:27:49 -0400
X-SourceIP: 213.93.53.227
Subject: RE: [patch 03/20] x86, ptrace, bts: defer branch trace stopping
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E92768007@irsmsx504.ger.corp.intel.com>
References: <20090403144332.799740000@intel.com>
	 <20090403144550.712401000@intel.com> <1238770852.798.146.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77E9271853A@irsmsx504.ger.corp.intel.com>
	 <1238843551.4549.1041.camel@laptop>
	 <928CFBE8E7CB0040959E56B4EA41A77E92768007@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Apr 2009 10:29:21 +0200
Message-Id: <1239092961.798.5686.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 09:12 +0100, Metzger, Markus T wrote:
> >-----Original Message-----
> >From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
> >Sent: Saturday, April 04, 2009 1:13 PM
> >To: Metzger, Markus T
> >Cc: mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com; markus.t.metzger@gmail.com; roland@redhat.com;
> >eranian@googlemail.com; oleg@redhat.com; Villacis, Juan; ak@linux.jf.intel..com; linux-
> >kernel@vger.kernel.org; Andrew Morton
> >Subject: RE: [patch 03/20] x86, ptrace, bts: defer branch trace stopping
> >
> >On Sat, 2009-04-04 at 08:17 +0100, Metzger, Markus T wrote:
> >> >-----Original Message-----
> >> >From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
> >> >Sent: Friday, April 03, 2009 5:01 PM
> >> >To: Metzger, Markus T
> >>
> >>
> >> >Also, I can't say I like the name, what about something like:
> >> >
> >> >void account_locked_buffer(struct mm_struct *mm, long pages)
> >> >{
> >> >	down_write(&mm->mmap_sem);
> >> >
> >> >	mm->total_vm += pages;
> >> >	mm->locked_vm += pages;
> >> >
> >> >	up_write(&mm->mmap_sem);
> >> >}
> >> >
> >> >but looking more closely at that alloc_locked_buffer() stuff, I really
> >> >hate it, who in his right mind does a multi-page kmalloc() -- that's
> >> >crazy.
> >>
> >> I need a non-pageable chunk of memory to give to the cpu to store branch
> >> trace data in. Kmalloc() is easy to use and gives me what I need.
> >>
> >> How would I do this correctly?
> >
> >Well, how large should this buffer be and must it be physically
> >contiguous?
> 
> The size is set by the user. It is limited by (locked memory) RLIMIT.
> 
> The buffer need not be physically contiguous, but it must not be paged out
> and should be marked accessed and dirty.
> (see §18.7.8.2 in vol. 3b, Software Developer's Manual).

The Intel one I presume?

Ok, if you must mark the pages accessed and dirty you should get whole
pages, otherwise you cannot make that promise on the ptes, right?

> >Apparently its large enough to account in pages, that would suggest you
> >should use the page allocator to get memory.
> 
> Wouldn't kmalloc forward the request to the page allocator for large memory?

It may, but doesn't need to.

> >Furthermore, if it needs to be physically contiguous and its more than
> >say 8 pages worth, you're basically up shit creek.
> 
> If not enough memory is available, I would expect users to request smaller
> buffers until the request can be satisfied.

Sounds like a very bad interface, esp since you don't need physically
contiguous memory.

So what you need to do is allocate pages, order-0, grab a reference,
then vmap them into a linear piece, poke at the ptes to set the young
and dirty bits and provide that to your hardware.



