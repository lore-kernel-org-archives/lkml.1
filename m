Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbZFXHNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbZFXHNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 03:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZFXHNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 03:13:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750931AbZFXHNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 03:13:35 -0400
Date: Wed, 24 Jun 2009 00:13:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [merged]
 proctxt-update-kernel-filesystem-proctxt-documentation.patch removed from
 -mm tree
Message-Id: <20090624001302.18de9e21.akpm@linux-foundation.org>
In-Reply-To: <1245825903.23818.4.camel@wall-e>
References: <200906182243.n5IMhwuV003008@imap1.linux-foundation.org>
	<1245824444.22613.3.camel@wall-e>
	<20090623233247.7ed661b7.akpm@linux-foundation.org>
	<1245825903.23818.4.camel@wall-e>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 08:45:03 +0200 Stefani Seibold <stefani@seibold.net> wrote:

> Am Dienstag, den 23.06.2009, 23:32 -0700 schrieb Andrew Morton:
> > On Wed, 24 Jun 2009 08:20:44 +0200 Stefani Seibold <stefani@seibold.net> wrote:
> > 
> > > what is with the associated
> > > procfs-provide-stack-information-for-threads-v08.patch
> > > patch?
> > > 
> > > There was no real objections against this patch, so why not merge it for
> > > 2.6.31?
> > 
> > Alexey pointed out that it doesn't actually work.
> 
> That is not true... it works. With my patch the kernel does exactly know
> where the thread stack is and therefor it is easy to determinate the
> associated map.
> 

On Tue, 16 Jun 2009 02:33:33 +0400 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Mon, Jun 15, 2009 at 03:02:05PM -0700, akpm@linux-foundation.org wrote:
> >      procfs-provide-stack-information-for-threads-v08.patch
> > --- a/fs/proc/array.c~procfs-provide-stack-information-for-threads-v08
> 
> > +++ a/fs/proc/array.c
> > @@ -321,6 +321,54 @@ static inline void task_context_switch_c
> >  			p->nivcsw);
> >  }
> >  
> > +static inline unsigned long get_stack_usage_in_bytes(struct vm_area_struct *vma,
> > +					struct task_struct *p)
> > +{
> > +	unsigned long	i;
> > +	struct page	*page;
> > +	unsigned long	stkpage;
> > +
> > +	stkpage = KSTK_ESP(p) & PAGE_MASK;
> > +
> > +#ifdef CONFIG_STACK_GROWSUP
> > +	for (i = vma->vm_end; i-PAGE_SIZE > stkpage; i -= PAGE_SIZE) {
> > +
> > +		page = follow_page(vma, i-PAGE_SIZE, 0);
> 
> How can this work?
> 
> If stack page got swapped out, you'll get smaller than actual result.

Alexey's point is that follow_page() will return NULL if it hits a
swapped-out stack page and the loop will exit, leading to an incorrect
(ie: short) return value from get_stack_usage_in_bytes().

Is this claim wrong?
