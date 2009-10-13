Return-Path: <linux-kernel-owner+w=401wt.eu-S1757801AbZJMA4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbZJMA4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 20:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZJMA4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 20:56:47 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53424 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbZJMA4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 20:56:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 13 Oct 2009 09:53:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] munmap() don't check sysctl_max_mapcount
Message-Id: <20091013095342.197c767b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0910121512070.2943@sister.anvils>
References: <20091002180533.5F77.A69D9226@jp.fujitsu.com>
	<Pine.LNX.4.64.0910091007010.17240@sister.anvils>
	<20091012184654.E4D0.A69D9226@jp.fujitsu.com>
	<Pine.LNX.4.64.0910121512070.2943@sister.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 16:04:08 +0100 (BST)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> On Mon, 12 Oct 2009, KOSAKI Motohiro wrote:
> > And, I doubt I haven't catch your mention. May I ask some question?
> > Honestly I don't think max_map_count is important knob. it is strange
> > mutant of limit of virtual address space in the process.
> > At very long time ago (probably the stone age), linux doesn't have
> > vma rb_tree handling, then many vma directly cause find_vma slow down.
> > However current linux have good scalability. it can handle many vma issue.
> 
> I think there are probably several different reasons for the limit,
> some perhaps buried in prehistory, yes, and others forgotten.
> 
> One reason is well-known to your colleague, KAMEZAWA-san:
> the ELF core dump format only supports a ushort number of sections.
> 
yes.

> One reason will be to limit the amount of kernel memory which can
> be pinned by a user program - why limit their ability to to lock down
> user pages, if we let them run wild with kernel data structures?
> The more important on 32-bit machines with more than 1GB of memory, as
> the lowmem restriction comes to bite.  But I probably should not have
> mentioned that, I fear you'll now go on a hunt for other places where
> we impose no such limit, and embarrass me greatly with the result ;)
> 
> And one reason will be the long vma->vm_next searches: less of an
> issue nowadays, yes, and preemptible if you have CONFIG_PREEMPT=y;
> but still might be something of a problem.
> 
> > So, Why do you think max_mapcount sould be strictly keeped?
> 
> I don't believe it's the most serious limit we have, and I'm no
> expert on its origins; but I do believe that if we profess to have
> some limit, then we have to enforce it.  If we're going to allow
> anybody to get around the limit, better just throw the limit away.
> 
> > 
> > Honestly, I doubt nobody suffer from removing sysctl_max_mapcount.
> 
> I expect Kame to disagree with you on that.
> 
> > 
> > And yes, stack unmapping have exceptional charactatics. the guard zone
> > gurantee it never raise map_count. 
> > So, I think the attached patch (0001-Don-t...) is the same as you talked about, right?
> 
> Yes, I've not tested but that looks right to me (I did have to think a
> bit to realize that the case where the munmap spans more than one vma
> is fine with the check you've added).  In the version below I've just
> changed your code comment.
> 
> > I can accept it. I haven't test it on ia64. however, at least it works
> > well on x86.
> > 
> > BUT, I still think kernel souldn't refuse any resource deallocation.
> > otherwise, people discourage proper resource deallocation and encourage
> > brutal intentional memory leak programming style. What do you think?
> 
> I think you're a little too trusting.  It's common enough that in order
> to free one resource, we need just a little of another resource; and
> it is frustrating when that other resource is tightly limited.  But if
> somebody owes you 10000 yen, and asks to borrow just another 1000 yen
> to make some arrangement to pay you back, then the next day asks to
> borrow just another 1000 yen to enhance that arrangement, then....
> 
> That's what I'm asking to guard against here.   But if you're so
> strongly against having that limit, please just get your customers
> to raise it to INT_MAX: that should be enough to keep away from
> its practical limitations, shouldn't it?
> 
> 
I discussed with Kosaki. Ah, hmm, reporing our status.

 - Even if we think the program which exceeds max_map_count and go abort()
   as buggy program, we don't think abort() (in library) is very good.
   So, we want to avoid this. 

 - We hear one of our collegue (debugger team) is now preparing ELF-extention
   patches for kernel and gdb. We hear solaris has ELF-extention for handling more
   than 65535 program headers and recent AMD64 ABI draft includes it.
   We now think this extention should go first. We discuss him with our schedule.

 - Considering "too much consume memory" attack, we need some limits.
   Then, we wonder adding
          - system-wide max_map_count (enough large)
          or
          - determine per process max_map_count based on host's memory size.

   BTW, looking sysctl, there is threads-max.

       [kamezawa@bluextal ~]$ cat /proc/sys/kernel/threads-max
       409600

   This number is system-wide and automatically determined at boot.
   But, in fact, there is max_map_count and per process threads-max is determined
   by it. We think this not very neat.
   
 We'll consider more. Probably, we'll start from ELF extention.


Thanks,
-Kame


   






