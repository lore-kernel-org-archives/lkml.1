Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbZAZXxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbZAZXxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZAZXxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:53:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751875AbZAZXxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:53:41 -0500
Date: Mon, 26 Jan 2009 15:52:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ying Han <yinghan@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       mikew@google.com, rientjes@google.com, rohitseth@google.com,
       hugh@veritas.com, a.p.zijlstra@chello.nl, hpa@zytor.com,
       edwintorok@gmail.com, lee.schermerhorn@hp.com, npiggin@suse.de
Subject: Re: [RFC v2][PATCH]page_fault retry with NOPAGE_RETRY
Message-Id: <20090126155246.2d7df309.akpm@linux-foundation.org>
In-Reply-To: <604427e00901261508n7967ea74m3deacd3213c86065@mail.gmail.com>
References: <604427e00812051140s67b2a89dm35806c3ee3b6ed7a@mail.gmail.com>
	<20090126113728.58212a30.akpm@linux-foundation.org>
	<604427e00901261508n7967ea74m3deacd3213c86065@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 15:08:48 -0800
Ying Han <yinghan@google.com> wrote:

> On Mon, Jan 26, 2009 at 11:37 AM, Andrew Morton
> <akpm@linux-foundation.org>wrote:
> 
> > On Fri, 5 Dec 2008 11:40:19 -0800
> > Ying Han <yinghan@google.com> wrote:
> >
> > > --- a/arch/x86/mm/fault.c
> > > +++ b/arch/x86/mm/fault.c
> > > @@ -591,6 +591,7 @@ void __kprobes do_page_fault(struct pt_regs *regs,
> > unsigne
> > >  #ifdef CONFIG_X86_64
> > >       unsigned long flags;
> > >  #endif
> > > +     unsigned int retry_flag = FAULT_FLAG_RETRY;
> > >
> > >       tsk = current;
> > >       mm = tsk->mm;
> > > @@ -689,6 +690,7 @@ again:
> > >               down_read(&mm->mmap_sem);
> > >       }
> > >
> > > +retry:
> > >       vma = find_vma(mm, address);
> > >       if (!vma)
> > >               goto bad_area;
> > > @@ -715,6 +717,7 @@ again:
> > >  good_area:
> > >       si_code = SEGV_ACCERR;
> > >       write = 0;
> > > +     write |= retry_flag;
> > >       switch (error_code & (PF_PROT|PF_WRITE)) {
> > >       default:        /* 3: write, present */
> > >               /* fall through */
> > > @@ -743,6 +746,15 @@ good_area:
> > >                       goto do_sigbus;
> > >               BUG();
> > >       }
> > > +
> > > +     if (fault & VM_FAULT_RETRY) {
> > > +             if (write & FAULT_FLAG_RETRY) {
> > > +                     retry_flag &= ~FAULT_FLAG_RETRY;
> > > +                     goto retry;
> > > +             }
> > > +             BUG();
> > > +     }
> > > +
> > >       if (fault & VM_FAULT_MAJOR)
> > >               tsk->maj_flt++;
> > >       else
> >
> > This code is mixing flags from the FAULT_FLAG_foor domain into local
> > variable `write'.  But that's inappropriate because `write' is a
> > boolean, and in one of Ingo's trees, `write' gets bits other than bit 0
> > set, and it all generally ends up a mess.
> >
> > Can we not do that?  I assume that a previous version of this patch
> > kept those things separated?
> >
> > Something like this, I think?
> >
> > diff -puN arch/x86/mm/fault.c~page_fault-retry-with-nopage_retry-fix
> > arch/x86/mm/fault.c
> > --- a/arch/x86/mm/fault.c~page_fault-retry-with-nopage_retry-fix
> > +++ a/arch/x86/mm/fault.c
> > @@ -799,7 +799,7 @@ void __kprobes do_page_fault(struct pt_r
> >        struct vm_area_struct *vma;
> >        int write;
> >        int fault;
> > -       unsigned int retry_flag = FAULT_FLAG_RETRY;
> > +       int retry_flag = 1;
> >
> >        tsk = current;
> >        mm = tsk->mm;
> > @@ -951,6 +951,7 @@ good_area:
> >        }
> >
> >        write |= retry_flag;
> > +
> >        /*
> >         * If for any reason at all we couldn't handle the fault,
> >         * make sure we exit gracefully rather than endlessly redo
> > @@ -969,8 +970,8 @@ good_area:
> >         * be removed or changed after the retry.
> >         */
> >         if (fault & VM_FAULT_RETRY) {
> > -               if (write & FAULT_FLAG_RETRY) {
> > -                       retry_flag &= ~FAULT_FLAG_RETRY;
> > +               if (retry_flag) {
> > +                       retry_flag = 0;
> >                        goto retry;
> >                }
> >                BUG();
> 
> with this change, 'write' still gets bits other than bit 0
> set in the case of 'write, not present' and the Ingo's problem remains, am i
> missing something here?

umm, yes.  This?

--- a/arch/x86/mm/fault.c~page_fault-retry-with-nopage_retry-fix-fix
+++ a/arch/x86/mm/fault.c
@@ -950,8 +950,6 @@ good_area:
 		return;
 	}
 
-	write |= retry_flag;
-
 	/*
 	 * If for any reason at all we couldn't handle the fault,
 	 * make sure we exit gracefully rather than endlessly redo
_


(I should just give up here - doing too many things at once)

> >
> >
> >
> > Question: why is this code passing `write==true' into handle_mm_fault()
> > in the retry case?
> > Here i am using unused bit of "write" to carry FAULT_FLAG_RETRY flag down
> > to the handle_mm_fault(). Meanwhile, "write" still have its read/write bit
> > set as it is before. It is true that 'write == true' in the retry patch, but
> > i did the correct interpretation in
> 
> 
> 
> > static int do_linear_fault() {
> >
>          int write = write_access & ~FAULT_FLAG_RETRY;
>          unsigned int flags = (write ? FAULT_FLAG_WRITE : 0);
> 
>          flags |= (write_access & FAULT_FLAG_RETRY);
>          pte_unmap(page_table);
>          return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
> }


OK, this is horridly confusing.  Is `write_access' a boolean, as its
name implies, or is it a bunch of flags?

If we're going to turn it into a bunch of flags then it should be
renamed!  And callsites such as do_page_fault() should rename their
local variable `write' to something which accurately conveys the new
usage.  And various code comments in mm/memory.c (which don't appear to
exist) should be updated.

I think that a good way to present this is as a preparatory patch:
"convert the fourth argument to handle_mm_fault() from a boolean to a
flags word".  That would be a simple do-nothing patch which affects all
architectures and which ideally would break the build at any
unconverted code sites.  (Change the argument order?)

What do you think?
