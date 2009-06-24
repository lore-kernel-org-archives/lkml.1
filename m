Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbZFXJdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbZFXJdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757813AbZFXJdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:33:41 -0400
Received: from www84.your-server.de ([213.133.104.84]:52257 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863AbZFXJdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:33:39 -0400
Subject: Re: [merged]
 proctxt-update-kernel-filesystem-proctxt-documentation.patch removed from
 -mm tree
From: Stefani Seibold <stefani@seibold.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <m1my7ykrs7.fsf@fess.ebiederm.org>
References: <200906182243.n5IMhwuV003008@imap1.linux-foundation.org>
	 <1245824444.22613.3.camel@wall-e>
	 <20090623233247.7ed661b7.akpm@linux-foundation.org>
	 <1245825903.23818.4.camel@wall-e>
	 <20090624001302.18de9e21.akpm@linux-foundation.org>
	 <m1my7ykrs7.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 11:33:25 +0200
Message-Id: <1245836005.32678.36.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 24.06.2009, 00:35 -0700 schrieb Eric W. Biederman:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Wed, 24 Jun 2009 08:45:03 +0200 Stefani Seibold <stefani@seibold.net> wrote:
> >
> >> Am Dienstag, den 23.06.2009, 23:32 -0700 schrieb Andrew Morton:
> >> > On Wed, 24 Jun 2009 08:20:44 +0200 Stefani Seibold <stefani@seibold.net> wrote:
> >> > 
> >> > > what is with the associated
> >> > > procfs-provide-stack-information-for-threads-v08.patch
> >> > > patch?
> >> > > 
> >> > > There was no real objections against this patch, so why not merge it for
> >> > > 2.6.31?
> >> > 
> >> > Alexey pointed out that it doesn't actually work.
> >> 
> >> That is not true... it works. With my patch the kernel does exactly know
> >> where the thread stack is and therefor it is easy to determinate the
> >> associated map.
> 
> Usually yes, but not in all cases.

Which cases? The only way i know is to set the stack pointer to an
arbitrary place in user space.... And this is not a common use case.  

> 
> 
> > On Tue, 16 Jun 2009 02:33:33 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:
> >
> >> On Mon, Jun 15, 2009 at 03:02:05PM -0700, akpm@linux-foundation.org wrote:
> >> >      procfs-provide-stack-information-for-threads-v08.patch
> >> > --- a/fs/proc/array.c~procfs-provide-stack-information-for-threads-v08
> >> 
> >> > +++ a/fs/proc/array.c
> >> > @@ -321,6 +321,54 @@ static inline void task_context_switch_c
> >> >  			p->nivcsw);
> >> >  }
> >> >  
> >> > +static inline unsigned long get_stack_usage_in_bytes(struct vm_area_struct *vma,
> >> > +					struct task_struct *p)
> >> > +{
> >> > +	unsigned long	i;
> >> > +	struct page	*page;
> >> > +	unsigned long	stkpage;
> >> > +
> >> > +	stkpage = KSTK_ESP(p) & PAGE_MASK;
> >> > +
> >> > +#ifdef CONFIG_STACK_GROWSUP
> >> > +	for (i = vma->vm_end; i-PAGE_SIZE > stkpage; i -= PAGE_SIZE) {
> >> > +
> >> > +		page = follow_page(vma, i-PAGE_SIZE, 0);
> >> 
> >> How can this work?
> >>

I replied a message for a solution to this problem but i get no answer.

>  
> >> If stack page got swapped out, you'll get smaller than actual result.
> >
> > Alexey's point is that follow_page() will return NULL if it hits a
> > swapped-out stack page and the loop will exit, leading to an incorrect
> > (ie: short) return value from get_stack_usage_in_bytes().
> >
> > Is this claim wrong?
> 

No.

I digged in the kernel source and the only solution i found is to use
the walk_page_range() like show_smap() in proc/fs/task_mmu.c.

Maybe there is an easier way, but i dont know.

So i would implement a similar function like smaps_pte_range() in
proc/fs/task_mmu.c to detected the high water usage.

> 
> Add to that the code is unnecessarily complicated.
> 

I don't like statements like that, without a explaination.

> The patch mixes several different changes together.  It deserves being
> broken up into at least two patches.
> 

Everybody tells me a different way to do a patch. Which one is the right
way. Ingo's, Andrew's or your way?  

And it is a question of time if you a hacker girl which is not a full
time linux kernel developer.

> I am concerned about the performance.  Glibc opens /proc/self/maps in
> practically every application so doing something like following page
> tables requires testing and verifying the performance.
> 

I understand your concern, that is the reason why i display the stack
high water usage mark only in /proc/<pid>/status. This is normally a
human interface.

/proc/<pid>/maps or smaps will only show where the thread stack is
resided and the max. of the stack size, which is only a simple
subtraction.

The reason to display the max. size is, because the stack start isn't
equal to the map start address. 

> Eric

Stefani

Write a patch: 16 hours
To get a patch into the kernel: 16 days
Overhead: 800 percent


