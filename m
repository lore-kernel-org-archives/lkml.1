Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbZKBQ1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbZKBQ1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbZKBQ1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:27:00 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:25879 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755364AbZKBQ07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:26:59 -0500
X-Trace: 279405545/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.19.148/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.19.148
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkcFAF+X7kpPRROU/2dsb2JhbACBUNsghDwE
X-IronPort-AV: E=Sophos;i="4.44,668,1249254000"; 
   d="scan'208";a="279405545"
Date: Mon, 2 Nov 2009 16:26:56 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Minchan Kim <minchan.kim@gmail.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>
Subject: Re: OOM killer, page fault
In-Reply-To: <20091102150110.74f8a601.minchan.kim@barrios-desktop>
Message-ID: <Pine.LNX.4.64.0911021556020.12937@sister.anvils>
References: <20091030063216.GA30712@gamma.logic.tuwien.ac.at>
 <20091102005218.8352.A69D9226@jp.fujitsu.com> <20091102135640.93de7c2a.minchan.kim@barrios-desktop>
 <20091102140216.02567ff8.kamezawa.hiroyu@jp.fujitsu.com>
 <20091102150110.74f8a601.minchan.kim@barrios-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Nov 2009, Minchan Kim wrote:
> On Mon, 2 Nov 2009 14:02:16 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > Maybe some code returns VM_FAULT_OOM by mistake and pagefault_oom_killer()
> > is called. digging mm/memory.c is necessary...
> > 
> > I wonder why...now is this code
> > ===
> > static int do_nonlinear_fault(struct mm_struct *mm, struct vm_area_struct *vma,
> >                 unsigned long address, pte_t *page_table, pmd_t *pmd,
> >                 unsigned int flags, pte_t orig_pte)
> > {
> >         pgoff_t pgoff;
> > 
> >         flags |= FAULT_FLAG_NONLINEAR;
> > 
> > 	if (!pte_unmap_same(mm, pmd, page_table, orig_pte))
> >                 return 0;
> > 
> >         if (unlikely(!(vma->vm_flags & VM_NONLINEAR))) {
> >                 /*
> >                  * Page table corrupted: show pte and kill process.
> >                  */
> >                 print_bad_pte(vma, address, orig_pte, NULL);
> >                 return VM_FAULT_OOM;
> >         }
> > 
> >         pgoff = pte_to_pgoff(orig_pte);
> >         return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
> > }
> > ==
> > Then, OOM...is this really OOM ?
> 
> It seems that the goal is to kill process by OOM trick as comment said.
> 
> I found It results from Hugh's commit 65500d234e74fc4e8f18e1a429bc24e51e75de4a.
> I think it's not a real OOM. 
> 
> BTW, If it is culpit in this case, print_bad_pte should have remained any log. :)

Yes, the chances are that this is not related to Norbert's problem.
But thank you for reminding me of that not-very-nice hack of mine.

It was kind-of valid at the time that I wrote it (2.6.15), when
VM_FAULT_OOM did kill the faulting process.  But since then the fault
path has rightly been changed (in x86 at least, I didn't check the rest)
to let the OOM killer decide who to kill: so now there's a danger that
a pagetable corruption there will instead kill some unrelated process.

Being lazy, I'm inclined simply to change that to VM_FAULT_SIGBUS now:
which doesn't actually guarantee that the process will be killed, but
should be better than just repeatedly re-faulting on the entry.  (I
don't much want to SIGKILL current since mm might not be current's.)

That aberrant use of VM_FAULT_OOM has recently been copied into
do_swap_page() (the first instance; the second instance is right -
hmm, well, the second instance is normally right, but I guess it
also covers pagetable corruption cases which we can't distinguish
there; oh well) and should be corrected there too.

Does VM_FAULT_SIGBUS sound good enough to you?

Hugh
