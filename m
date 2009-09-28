Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbZI1Dga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbZI1Dga (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 23:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZI1Dg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 23:36:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:10283 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbZI1Dg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 23:36:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,463,1249282800"; 
   d="scan'208";a="192305794"
Date: Mon, 28 Sep 2009 11:36:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nigel Cunningham <ncunningham@crca.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: No more bits in vm_area_struct's vm_flags.
Message-ID: <20090928033624.GA11191@localhost>
References: <4AB9A0D6.1090004@crca.org.au> <20090924100518.78df6b93.kamezawa.hiroyu@jp.fujitsu.com> <4ABC80B0.5010100@crca.org.au> <20090925174009.79778649.kamezawa.hiroyu@jp.fujitsu.com> <4AC0234F.2080808@crca.org.au> <20090928120450.c2d8a4e2.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928120450.c2d8a4e2.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 11:04:50AM +0800, KAMEZAWA Hiroyuki wrote:
> Hi,
> 
> On Mon, 28 Sep 2009 12:45:35 +1000
> Nigel Cunningham <ncunningham@crca.org.au> wrote:
> > KAMEZAWA Hiroyuki wrote:
> > > On Fri, 25 Sep 2009 18:34:56 +1000
> > > Nigel Cunningham <ncunningham@crca.org.au> wrote:
> > >> Hi.
> > >>
> > >> KAMEZAWA Hiroyuki wrote:
> > >>>> I have some code in TuxOnIce that needs a bit too (explicitly mark the
> > >>>> VMA as needing to be atomically copied, for GEM objects), and am not
> > >>>> sure what the canonical way to proceed is. Should a new unsigned long be
> > >>>> added? The difficulty I see with that is that my flag was used in
> > >>>> shmem_file_setup's flags parameter (drm_gem_object_alloc), so that
> > >>>> function would need an extra parameter too..
> > >>> Hmm, how about adding vma->vm_flags2 ?
> > >> The difficulty there is that some functions pass these flags as arguments.
> > >>
> > > Ah yes. But I wonder some special flags, which is rarey used, can be moved
> > > to vm_flags2...
> > > 
> > > For example,
> > > 
> > >  #define VM_SEQ_READ     0x00008000      /* App will access data sequentially */
> > >  #define VM_RAND_READ    0x00010000      /* App will not benefit from clustered reads */
> > > are all capsuled under
> > > mm.h
> > >  117 #define VM_READHINTMASK                 (VM_SEQ_READ | VM_RAND_READ)
> > >  118 #define VM_ClearReadHint(v)             (v)->vm_flags &= ~VM_READHINTMASK
> > >  119 #define VM_NormalReadHint(v)            (!((v)->vm_flags & VM_READHINTMASK))
> > >  120 #define VM_SequentialReadHint(v)        ((v)->vm_flags & VM_SEQ_READ)
> > >  121 #define VM_RandomReadHint(v)            ((v)->vm_flags & VM_RAND_READ)
> > > 
> > > Or
> > > 
> > > 105 #define VM_PFN_AT_MMAP  0x40000000      /* PFNMAP vma that is fully mapped at mmap time */
> > > is only used under special situation.
> > > 
> > > etc..
> > > 
> > > They'll be able to be moved to other(new) flag field, IIUC.
> > 
> CCing Fengguang.
> 
> Breif Summary of thread:
>  Now, vm->vm_flags has no more avialable bits. Then, I proposed Nigel
>  to move some flags from vm->vm_flags to other flags as vm->vm_????.
>  It seems readahead-hints are candidates for this......

Agreed and thanks for the summary.

> > I'm working on a patch to do this, and am looking at is_mergeable_vma,
> > which is invoked via can_vma_merge_after from vma_merge from
> > madvise_behaviour (which potentially modifies these hint flags). Should
> > those hints be considered in that function? (Do I need to pass the hints
> > in as well and check they're equal?)
> 
> I think it should be handled.

Agreed.

> But, yes it implies to add a new argument to several functions in mmap.c
> and maybe a patch will be ugly.
> 
> How about addding this check ?
> 
> is_mergeable_vma(...)
> ....
>   if (vma->vm_hints)
> 	return 0;
> 
> And not calling vma_merge() at madvice(ACCESS_PATTERN_HINT).
> 
> I wonder there are little chances when madice(ACCESS_PATTERN_HINT) is
> given against mapped-file-vma...

Me wonder too. The access hints should be rarely used.
A simple solution is reasonable for them.

But what if more flags going into vm_hints in future?

Thanks,
Fengguang

> > 
> > By the way, VM_ClearReadHint and VM_NormalReadHint are currently unused.
> >  madvise_behaviour manipulates the flags directly (in preparing
> > potential replacement values). Not sure if something should be done
> > about that.
> > 
> > By the way #2, in response to the later message in this thread, I'm
> > calling the new var vma->vm_hints, and have put it at the end of the
> > struct at the moment. Is that a good place?
> > 
> I think it seems nice. But please before entries under CONFIG.
> How about just after vm_private_data ?
> 
> Regards,
> -Kame
> 
