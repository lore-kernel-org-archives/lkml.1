Return-Path: <linux-kernel-owner+w=401wt.eu-S1762326AbXEUNxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762326AbXEUNxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 09:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755938AbXEUNx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 09:53:26 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:45825 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107AbXEUNxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 09:53:25 -0400
Subject: Re: RSS controller v2 Test results (lmbench )
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: balbir@linux.vnet.ibm.com
Cc: Rik van Riel <riel@redhat.com>, Pavel Emelianov <xemul@sw.ru>,
       Paul Menage <menage@google.com>, Kirill Korotaev <dev@sw.ru>,
       devel@openvz.org, Linux Containers <containers@lists.osdl.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>
In-Reply-To: <464D267A.50107@linux.vnet.ibm.com>
References: <464C95D4.7070806@linux.vnet.ibm.com>
	 <464D1599.1000506@redhat.com>  <464D267A.50107@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 21 May 2007 09:53:34 -0400
Message-Id: <1179755615.5113.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-18 at 09:37 +0530, Balbir Singh wrote:
> Rik van Riel wrote:
> > Balbir Singh wrote:
> > 
> >> A meaningful container size does not hamper performance. I am in the
> >> process
> >> of getting more results (with varying container sizes). Please let me
> >> know
> >> what you think of the results? Would you like to see different
> >> benchmarks/
> >> tests/configuration results?
> > 
> > AIM7 results might be interesting, especially when run to crossover.
> > 
> 
> I'll try and get hold of AIM7, I have some AIM9 results (please
> see the attachment, since the results overflow 80 columns, I've
> attached them).
> 
> > OTOH, AIM7 can make the current VM explode spectacularly :)
> > 
> > I saw it swap out 1.4GB of memory in one run, on my 2GB memory test
> > system.  That's right, it swapped out almost 75% of memory.
> > 
> 
> This would make a good test case for the RSS and the unmapped page
> cache controller. Thanks for bringing it to my attention.
> 
> > Presumably all the AIM7 processes got stuck in the pageout code
> > simultaneously and all decided they needed to swap some pages out.
> > However, the shell got stuck too so I could not get sysrq output
> > on time.
> > 
> 
> oops! I wonder if AIM7 creates too many processes and exhausts all
> memory. I've seen a case where during an upgrade of my tetex on my
> laptop, the setup process failed and continued to fork processes
> filling up 4GB of swap.

Jumping in late, I just want to note that in our investigations, when
AIM7 gets into this situation [non-responsive system], it's because all
cpus are in reclaim, spinning on an anon_vma spin lock.  AIM7 forks [10s
of] thousands of children from a single parent, resultings in thousands
of vmas on the anon_vma list.  shrink_inactive_list() must walk this
list twice [page_referenced() and try_to_unmap()] under spin_lock for
each anon page.  

[Aside:  Just last week, I encountered a similar situation on the
i_mmap_lock for page cache pages running a 1200 user Oracle/OLTP run on
a largish ia64 system.  Left the system spitting out "soft lockup"
messages/stack dumps overnight.  Still spitting the next day, so I
decided to reboot.]

I have a patch that turns the anon_vma lock into a reader/writer lock
that alleviates the problem somewhat, but with 10s of thousands of vmas
on the lists, system still can't swap enough memory fast enough to
recover.

We've run some AIM7 tests with Rik's "split lru list" patch, both with
and without the anon_vma reader/writer lock patch.  We'll be posting
results later this week.  Quick summary:  with Rik's patch, AIM
performance tanks earlier, as the system starts swapping earlier.
However, system remains responsive to shell input.  More into to follow.

> 
> > I am trying out a little VM patch to fix that now, carefully watching
> > vmstat output.  Should be fun...
> > 
> 
> VM debugging is always fun!

For some definition thereof...

Lee


