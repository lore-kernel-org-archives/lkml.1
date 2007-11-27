Return-Path: <linux-kernel-owner+w=401wt.eu-S1752940AbXK0FYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbXK0FYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 00:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbXK0FY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 00:24:26 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50785 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282AbXK0FYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 00:24:25 -0500
Message-Id: <1196141064.31920.1223402735@webmail.messagingengine.com>
X-Sasl-Enc: xxkOXA00liiTSniL6zjGFCXnCv2aLIZ3niZEO7i17qog 1196141064
From: "Bron Gondwana" <brong@fastmail.fm>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Christian Kujau" <lists@nerdbynature.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rob Mueller" <robm@fastmail.fm>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <alpine.LFD.0.9999.0711142020220.2786@woody.linux-foundation.org>
   <20071115052538.GA21522@brong.net>
   <alpine.LFD.0.9999.0711142130090.2786@woody.linux-foundation.org>
   <alpine.LFD.0.9999.0711142148380.2786@woody.linux-foundation.org>
   <20071115115049.GA8297@brong.net>
   <alpine.LFD.0.9999.0711150818320.2786@woody.linux-foundation.org>
   <1195155601.22457.25.camel@lappy> <1195159457.22457.35.camel@lappy>
   <alpine.LFD.0.9999.0711151252340.4260@woody.linux-foundation.org>
   <alpine.LFD.0.9999.0711151300250.4260@woody.linux-foundation.org>
   <20071122034204.GA14079@brong.net>
   <20071126205428.c264ccff.akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] mm: add dirty_highmem option
In-Reply-To: <20071126205428.c264ccff.akpm@linux-foundation.org>
Date: Tue, 27 Nov 2007 16:24:24 +1100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 20:54:28 -0800, "Andrew Morton" <akpm@linux-foundation.org> said:
> On Thu, 22 Nov 2007 14:42:04 +1100 Bron Gondwana <brong@fastmail.fm>
> wrote:
> 
> >  /*
> > + * free highmem will not be subtracted from the total free memory
> > + * for calculating free ratios if vm_dirty_highmem is true
> > + */
> > +int vm_dirty_highmem;
> 
> One would expect that setting dirty_highmem to true would cause highmem
> to
> be accounted in dirty-memory calculations.  However with this change
> reality is in fact the inverse of that.
> 
> So how about this?

Actually, I'm confused now.  Maybe I chose a bad name to begin with.
Does it mean "I am allowed to dirty high memory" or "my high memory
will be dirty if this is on"?

Hmm... I'm even having trouble articulating what's odd about it.

I guess my internal model was: "if this flag is set then you are
allowed to make high memory dirty without needing to flush it
immediately", which is why I made it that way around.


No - you're wrong.  My patch _did_ include high memory in the dirty
memory calculations when dirty_highmem was true.

>  	x = global_page_state(NR_FREE_PAGES)
>  		+ global_page_state(NR_INACTIVE)
>  		+ global_page_state(NR_ACTIVE);

This is the total memory, _including_ high memory.

>           x -= highmem_dirtyable_memory(x);

This removes the high memory from the total count.


I think I got it right.  If dirty_highmem is set to true, then
don't subtract highmem from the total memory count before
calculating the percentages.  That's what I meant, and that's
what the toggle did.  Removed the subtraction.

Bron.


>  Documentation/filesystems/proc.txt |    4 ++--
>  mm/page-writeback.c                |    8 ++++----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff -puN
> Documentation/filesystems/proc.txt~mm-add-dirty_highmem-option-fix
> Documentation/filesystems/proc.txt
> --- a/Documentation/filesystems/proc.txt~mm-add-dirty_highmem-option-fix
> +++ a/Documentation/filesystems/proc.txt
> @@ -1265,8 +1265,8 @@ Contains, as a boolean, a switch to allo
>  part of the "available" memory against which the dirty ratios will be
>  applied.
>  
> -Setting this to 1 can be useful on 32 bit machines where you want to
> make
> -random changes within an MMAPed file that is larger than your available
> +Setting this to 0 (false) can be useful on 32 bit machines where you
> wish to
> +make random changes within an MMAPed file that is larger than your
> available
>  lowmem, however it is potentially dangerous and has serious
>  bounce-buffer
>  issues.
>  
> diff -puN mm/page-writeback.c~mm-add-dirty_highmem-option-fix
> mm/page-writeback.c
> --- a/mm/page-writeback.c~mm-add-dirty_highmem-option-fix
> +++ a/mm/page-writeback.c
> @@ -69,10 +69,10 @@ static inline long sync_writeback_pages(
>  int dirty_background_ratio = 5;
>  
>  /*
> - * free highmem will not be subtracted from the total free memory
> - * for calculating free ratios if vm_dirty_highmem is true
> + * free highmem will be subtracted from the total free memory for
> calculating
> + * free ratios if vm_dirty_highmem is true
>   */
> -int vm_dirty_highmem;
> +int vm_dirty_highmem = 1;
>  
>  /*
>   * The generator of dirty data starts writeback at this percentage
> @@ -293,7 +293,7 @@ static unsigned long determine_dirtyable
>  	x = global_page_state(NR_FREE_PAGES)
>  		+ global_page_state(NR_INACTIVE)
>  		+ global_page_state(NR_ACTIVE);
> -	if (!vm_dirty_highmem)
> +	if (vm_dirty_highmem)
>  		x -= highmem_dirtyable_memory(x);
>  	return x + 1;	/* Ensure that we never return 0 */
>  }
> _
> 
> 
> 
> 
> (I dropped the already-merged part of your patch)
> 
> (I fixed a build error in kernel/sysctl.c: "one" was defined twice when
> suitable config options were set).
> 
> (It's an unpleasing patch, btw.  But it's an unpleasant problem and at
> least
> this way people can tell us "hey, I did <this> and it started to work")
-- 
  Bron Gondwana
  brong@fastmail.fm

