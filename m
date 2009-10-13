Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbZJMCuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbZJMCuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 22:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbZJMCuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 22:50:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58894 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbZJMCuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 22:50:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH] munmap() don't check sysctl_max_mapcount
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0910121512070.2943@sister.anvils>
References: <20091012184654.E4D0.A69D9226@jp.fujitsu.com> <Pine.LNX.4.64.0910121512070.2943@sister.anvils>
Message-Id: <20091013102137.C755.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 13 Oct 2009 11:50:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > > If you change your patch so that do_munmap() cannot increase the final
> > > number vmas beyond sysctl_max_map_count, that would seem reasonable.
> > > But would that satisfy your testcase?  And does the testcase really
> > > matter in practice?  It doesn't seem to have upset anyone before.
> > 
> > Very thank you for payed attention to my patch. Yes, this is real issue.
> > my customer suffer from it.
> 
> That's a good reason for a fix; though nothing you say explains why
> they're operating right at the sysctl_max_map_count limit (which is
> likely to give them further surprises), and cannot raise that limit.

Probably, my last mail was not clear a bit. I talked about two thing
at the same time. sorry for ambiguous message.

 (1) custmer faced bug
 (2) my future view

In point (1), the limit itself is not problem at all. the customer
can change it. but nobody accept resource deallocation makes SIGABORT
internally. I think both kernel and glibc have fault.

removing sysctl_max_map_count is only my future view.


> > May I explain why you haven't seen this issue? this issue is architecture
> > independent problem. however register stack architecture (e.g. ia64, sparc)
> > dramatically increase the possibility of the heppen this issue.
> 
> Thanks for going to all this trouble; but I never doubted it could
> happen, nor that some would be more likely to suffer than others.
> 
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

Ah! yes.
I had forgot it. thanks pointing this.

Yes, I agree we can't remove max_mapcount yet.

Side node: My co-worker working on implement enhanced ELF header to gdb,
it's derived from solaris. I expect we can remove the above ushort limitation
in this year.

> One reason will be to limit the amount of kernel memory which can
> be pinned by a user program - why limit their ability to to lock down
> user pages, if we let them run wild with kernel data structures?
> The more important on 32-bit machines with more than 1GB of memory, as
> the lowmem restriction comes to bite.  But I probably should not have
> mentioned that, I fear you'll now go on a hunt for other places where
> we impose no such limit, and embarrass me greatly with the result ;)

hmhm, 32bit, I see.

Side note: 64K max_mapcount restrict number of thread to 32K. there seems
too small in modern 64bit. after solving ELF ushort issue, the default value
on 64bit might be considerable. I think.


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

OK, I agree.

> > Honestly, I doubt nobody suffer from removing sysctl_max_mapcount.
> 
> I expect Kame to disagree with you on that.

I have to say your expection is bingo! ;)


> > And yes, stack unmapping have exceptional charactatics. the guard zone
> > gurantee it never raise map_count. 
> > So, I think the attached patch (0001-Don-t...) is the same as you talked about, right?
> 
> Yes, I've not tested but that looks right to me (I did have to think a
> bit to realize that the case where the munmap spans more than one vma
> is fine with the check you've added).  In the version below I've just
> changed your code comment.

Thank you! 


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

The customer don't need to remove this limit. That's merely my personal
opinion.
Currently, various library and application don't check munmap() return value.  
I have pessimistic expection to change them. In practice, we have two way to
get rid of suffer of munlock return value.
  (1) removing the possibility of error return (i.g. remove sysctl_max_mapcount)
  (2) limitation bump up until usual application never touch its limit.

I thought we can (1). but I've changed my opinion by this mail. probably
(2) is better. but it is long term issue. we can't do it until solving ELF
issue....

Thanks again. you clarified various viewpoint.



