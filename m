Return-Path: <linux-kernel-owner+w=401wt.eu-S932545AbZKBXbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbZKBXbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 18:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757257AbZKBXbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 18:31:25 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:52624 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216AbZKBXbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 18:31:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=N0ba9M2fNUuQcoOYwEXAyJipp9nNRuPq3dw6Nin7m+VklVlFEDsVHZZ+yCCi/2ECTZ
         cJnKnKOKcYIJbqH8q85EQi2IcOP6bRUKVsMt5mzecyobCLYEfdZif3SxpyEd0Zp7icW2
         jMFPB2jrbhsyyBLELwzmnAUKmhCMct9q9RgEU=
Date: Tue, 3 Nov 2009 08:28:29 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>
Subject: Re: OOM killer, page fault
Message-Id: <20091103082829.db0b1e33.minchan.kim@barrios-desktop>
In-Reply-To: <Pine.LNX.4.64.0911021556020.12937@sister.anvils>
References: <20091030063216.GA30712@gamma.logic.tuwien.ac.at>
	<20091102005218.8352.A69D9226@jp.fujitsu.com>
	<20091102135640.93de7c2a.minchan.kim@barrios-desktop>
	<20091102140216.02567ff8.kamezawa.hiroyu@jp.fujitsu.com>
	<20091102150110.74f8a601.minchan.kim@barrios-desktop>
	<Pine.LNX.4.64.0911021556020.12937@sister.anvils>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Hugh. 

On Mon, 2 Nov 2009 16:26:56 +0000 (GMT)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> On Mon, 2 Nov 2009, Minchan Kim wrote:
> > On Mon, 2 Nov 2009 14:02:16 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > 
> > > Maybe some code returns VM_FAULT_OOM by mistake and pagefault_oom_killer()
> > > is called. digging mm/memory.c is necessary...
> > > 
> > > I wonder why...now is this code
> > > ===
> > > static int do_nonlinear_fault(struct mm_struct *mm, struct vm_area_struct *vma,
> > >                 unsigned long address, pte_t *page_table, pmd_t *pmd,
> > >                 unsigned int flags, pte_t orig_pte)
> > > {
> > >         pgoff_t pgoff;
> > > 
> > >         flags |= FAULT_FLAG_NONLINEAR;
> > > 
> > > 	if (!pte_unmap_same(mm, pmd, page_table, orig_pte))
> > >                 return 0;
> > > 
> > >         if (unlikely(!(vma->vm_flags & VM_NONLINEAR))) {
> > >                 /*
> > >                  * Page table corrupted: show pte and kill process.
> > >                  */
> > >                 print_bad_pte(vma, address, orig_pte, NULL);
> > >                 return VM_FAULT_OOM;
> > >         }
> > > 
> > >         pgoff = pte_to_pgoff(orig_pte);
> > >         return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
> > > }
> > > ==
> > > Then, OOM...is this really OOM ?
> > 
> > It seems that the goal is to kill process by OOM trick as comment said.
> > 
> > I found It results from Hugh's commit 65500d234e74fc4e8f18e1a429bc24e51e75de4a.
> > I think it's not a real OOM. 
> > 
> > BTW, If it is culpit in this case, print_bad_pte should have remained any log. :)
> 
> Yes, the chances are that this is not related to Norbert's problem.
> But thank you for reminding me of that not-very-nice hack of mine.
> 
> It was kind-of valid at the time that I wrote it (2.6.15), when
> VM_FAULT_OOM did kill the faulting process.  But since then the fault
> path has rightly been changed (in x86 at least, I didn't check the rest)
> to let the OOM killer decide who to kill: so now there's a danger that
> a pagetable corruption there will instead kill some unrelated process.
> 
> Being lazy, I'm inclined simply to change that to VM_FAULT_SIGBUS now:
> which doesn't actually guarantee that the process will be killed, but
> should be better than just repeatedly re-faulting on the entry.  (I
> don't much want to SIGKILL current since mm might not be current's.)
> 
> That aberrant use of VM_FAULT_OOM has recently been copied into
> do_swap_page() (the first instance; the second instance is right -
> hmm, well, the second instance is normally right, but I guess it
> also covers pagetable corruption cases which we can't distinguish
> there; oh well) and should be corrected there too.
> 
> Does VM_FAULT_SIGBUS sound good enough to you?

I am Okay. 
First of all, we have to prevent innocent process killing.
Second, although it returns SIGBUS, we can distinguish it from normal SIGBUS
by bad pte log.
Third, we don't want to add new VM_FAULT_XXX as possible as. :)


> 
> Hugh


-- 
Kind regards,
Minchan Kim
