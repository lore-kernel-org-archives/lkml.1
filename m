Return-Path: <linux-kernel-owner+w=401wt.eu-S1764073AbZFPVas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764073AbZFPVas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763021AbZFPVaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:30:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:15744 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762393AbZFPVaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:30:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DL1QryvSp7mMh/qnkElknRc6SFLBHy1e5slOlMuV64z3PsvUuY89ZsPfxtwie2EaBw
         FKKPXIoJMpnsp2gJCyhbt/cXYLQuffLabgrkEznULRHFdpV2G8xvSneXm85Us6lENHX1
         QOJWrFebelJBAqqXnzHfVP5lrhy7CgheKkmYg=
Date: Wed, 17 Jun 2009 01:30:04 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Stefani Seibold <stefani@seibold.net>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: + procfs-provide-stack-information-for-threads-v08.patch added
	to -mm tree
Message-ID: <20090616213004.GA6687@x200.localdomain>
References: <200906152202.n5FM25VD021536@imap1.linux-foundation.org> <20090615223333.GA8734@x200.localdomain> <1245133026.17989.2.camel@wall-e> <m1ski03r4f.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ski03r4f.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 12:39:28PM -0700, Eric W. Biederman wrote:
> Stefani Seibold <stefani@seibold.net> writes:
> 
> > Am Dienstag, den 16.06.2009, 02:33 +0400 schrieb Alexey Dobriyan:
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
> >> If stack page got swapped out, you'll get smaller than actual result.
> >> 
> >
> > If you tell me how to do it in the right way, i can fix it!
> 
> You are attempting to answer two questions here.
> 1) Where do the thread stacks reside.

Kernel doesn't know. Application stack is somewhere below/above
some SP register.

> 2) What is the maximum stack space that has been used.
> 
> Just listing the thread stacks seems like a small O(1) change.
> 
> Computing how much stack space has been used looks trickier.
> Perhaps you could map them with MAP_GROWSDOWN?  Of course that
> has the problem that you don't stop growing your stack until
> it bumps into something else.  Not ideal for a thread stack.
