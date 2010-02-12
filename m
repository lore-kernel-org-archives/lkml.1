Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab0BLJCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 04:02:21 -0500
Received: from ozlabs.org ([203.10.76.45]:56228 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab0BLJCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 04:02:19 -0500
From: Michael Neuling <mikey@neuling.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Helge Deller <deller@gmx.de>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Anton Blanchard <anton@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Create initial stack independent of PAGE_SIZE
In-reply-to: <20100212161305.73B2.A69D9226@jp.fujitsu.com>
References: <20100209132529.bfc455b7.akpm@linux-foundation.org> <31586.1265953455@neuling.org> <20100212161305.73B2.A69D9226@jp.fujitsu.com>
Comments: In-reply-to KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
   message dated "Fri, 12 Feb 2010 16:20:40 +0900."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Fri, 12 Feb 2010 20:02:16 +1100
Message-ID: <2593.1265965336@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20100212161305.73B2.A69D9226@jp.fujitsu.com> you wrote:
> > Currently we create the initial stack based on the PAGE_SIZE.  This is
> > unnecessary.  
> 
> I don't think this is enough explanation. In past mail, you described
> why page size dependency is harmful. I hope you add it into the patch
> description.

I don't think it's harmful, it's just irrelevant.  Stack size is
independent of page size.  

> IOW, we don't need to change the unnecessary-but-non-harmful behavior.
> 
> > 
> > This creates this initial stack independent of the PAGE_SIZE.
> > 
> > It also bumps up the number of 4k pages allocated from 20 to 32, to
> > align with 64K page systems.
> 
> Why do we need page-aligning? Do you mean this code doesn't works on
> 128K (or more larger) page systems?

If the "random" setting is not a common multiple of the 4k and 64k
pages, they will end up getting aligned differently, hence causing what
we are trying to avoid in the first place with this patch.

I should probably add this as a comment in the code comment?

Mikey

> 
> 
> > 
> > Signed-off-by: Michael Neuling <mikey@neuling.org>
> > ---
> > This is the second half of my original patch. This can be targeted for
> > 2.6.34 as it's just a cleanup.
> > 
> > Tested on PPC64 with 4k and 64k pages.
> > 
> >  fs/exec.c |    4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > Index: linux-2.6-ozlabs/fs/exec.c
> > ===================================================================
> > --- linux-2.6-ozlabs.orig/fs/exec.c
> > +++ linux-2.6-ozlabs/fs/exec.c
> > @@ -554,8 +554,6 @@ static int shift_arg_pages(struct vm_are
> >  	return 0;
> >  }
> >  
> > -#define EXTRA_STACK_VM_PAGES	20	/* random */
> > -
> >  /*
> >   * Finalizes the stack vm_area_struct. The flags and permissions are updat
ed,
> >   * the stack is optionally relocated, and some extra space is added.
> > @@ -630,7 +628,7 @@ int setup_arg_pages(struct linux_binprm 
> >  			goto out_unlock;
> >  	}
> >  
> > -	stack_expand = EXTRA_STACK_VM_PAGES * PAGE_SIZE;
> > +	stack_expand = 131072UL; /* randomly 32*4k (or 2*64k) pages */
> >  	stack_size = vma->vm_end - vma->vm_start;
> >  	/*
> >  	 * Align this down to a page boundary as expand_stack
> 
> 
> 
