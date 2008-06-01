Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbYFAHyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbYFAHyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 03:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYFAHyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 03:54:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323AbYFAHyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 03:54:05 -0400
Date: Sun, 1 Jun 2008 00:53:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k libc5 regression
Message-Id: <20080601005338.3affe880.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz>
References: <Pine.LNX.4.64.0805262226280.11902@anakin>
	<Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 00:19:32 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:

> On Mon, 26 May 2008, Geert Uytterhoeven wrote:
> 
> > Recently I noticed a regression when running an old libc5 binary
> > (amiga-lilo) on m68k. It fails with the error message:
> 
> Hmm, libc5 is known to make broken assumptions about brk location, that's 
> why we introduced CONFIG_COMPAT_BRK, do you have that option turned on?
> 
> > So I bisected it to:
> > commit 4cc6028d4040f95cdb590a87db478b42b8be0508
> > Author: Jiri Kosina <jkosina@suse.cz>
> > Date:   Wed Feb 6 22:39:44 2008 +0100
> >     brk: check the lower bound properly
> 
> Indeed, this should take CONFIG_COMPAT_BRK into account. Does the patch 
> below fix it? (assuming that you have CONFIG_COMPAT_BRK=y):
> 
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> 
> brk: check lower bound properly
> 
> The check in sys_brk() on minimum value the brk might have must take 
> CONFIG_COMPAT_BRK setting into account. When this option is turned on 
> (i.e. we support ancient legacy binaries, e.g. libc5-linked stuff), the 
> lower bound on brk value is mm->end_code, otherwise the brk start is 
> allowed to be arbitrarily shifted.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index fac6633..834118b 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -245,10 +245,16 @@ asmlinkage unsigned long sys_brk(unsigned long brk)
>  	unsigned long rlim, retval;
>  	unsigned long newbrk, oldbrk;
>  	struct mm_struct *mm = current->mm;
> +	unsigned long min_brk;
>  
>  	down_write(&mm->mmap_sem);
>  
> -	if (brk < mm->start_brk)
> +#ifdef CONFIG_COMPAT_BRK
> +	min_brk = mm->end_code;
> +#else
> +	min_brk = mm->start_brk;
> +#endif
> +	if (brk < min_brk)
>  		goto out;
>  

OK, we have a problem here.

Somebody has gone and checked this patch into their tree and it now
appears in linux-next.

I do not know how to work out how this patch got into linux-next.

It's not in any of the trees which I pull so I guess that person has
been shuffling URLs without telling me.

One of the reasons this is bad is that, frankly, I trust almost nobody
to remember to backport fixes into 2.6.25.x.  I'm not even at all
confident that our mystery new part-time memory management maintainer
will remember to merge this into 2.6.26.  The fact that this person
failed to add a Cc:stable@kernel.org to the changelog doesn't inspire
confidence.

I shall merge this fix into my tree (y'know - the one where memory
management patches are hosted) and I'll get it into 2.6.26 and shall
offer it to the -stable team.  This will cause me to get collisions
with the duplicated patch in linux-next but fortunately it is small. 
This time.

And to whoever did this: please don't.
