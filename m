Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbYAOTN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbYAOTN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 14:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYAOTNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 14:13:20 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:11911 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYAOTNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 14:13:19 -0500
Date: Tue, 15 Jan 2008 11:10:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Anton Salikhmetov" <salikhmetov@gmail.com>
Cc: "Christoph Hellwig" <hch@infradead.org>, linux-mm@kvack.org,
       jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, miklos@szeredi.hu
Subject: Re: [PATCH 1/2] Massive code cleanup of sys_msync()
Message-Id: <20080115111018.1e27a229.randy.dunlap@oracle.com>
In-Reply-To: <4df4ef0c0801151102l4d72b6b5j702e21beb1ebe459@mail.gmail.com>
References: <12004129652397-git-send-email-salikhmetov@gmail.com>
	<12004129734126-git-send-email-salikhmetov@gmail.com>
	<20080115175705.GA21557@infradead.org>
	<4df4ef0c0801151102l4d72b6b5j702e21beb1ebe459@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008 22:02:54 +0300 Anton Salikhmetov wrote:

> 2008/1/15, Christoph Hellwig <hch@infradead.org>:
> > On Tue, Jan 15, 2008 at 07:02:44PM +0300, Anton Salikhmetov wrote:

> > > @@ -33,71 +34,65 @@ asmlinkage long sys_msync(unsigned long start, size_t len, int flags)
> > >       unsigned long end;
> > >       struct mm_struct *mm = current->mm;
> > >       struct vm_area_struct *vma;
> > > -     int unmapped_error = 0;
> > > -     int error = -EINVAL;
> > > +     int error = 0, unmapped_error = 0;
> > >
> > >       if (flags & ~(MS_ASYNC | MS_INVALIDATE | MS_SYNC))
> > > -             goto out;
> > > +             return -EINVAL;
> > >       if (start & ~PAGE_MASK)
> > > -             goto out;
> > > +             return -EINVAL;
> >
> > The goto out for a simple return style is used quite commonly in kernel
> > code to have a single return statement which makes code maintaince, e.g.
> > adding locks or allocations simpler.  Not sure that getting rid of it
> > makes a lot of sense.
> 
> Sorry, I can't agree. That's what is written in the CodingStyle document:
> 
> The goto statement comes in handy when a function exits from multiple
> locations and some common work such as cleanup has to be done.

CodingStyle does not try to cover Everything.  Nor do we want it to.

At any rate, there is a desire for functions to have a single point
of return, regardless of the amount of cleanup to be done, so I agree
with Christoph's comments.


> The second part of requirement does not hold true for the sys_msync() routine.
> 
> >
> > > +             file = vma->vm_file;
> > > +             if ((flags & MS_SYNC) && file && (vma->vm_flags & VM_SHARED)) {
> >
> > Given that file is assigned just above it would be more readable to test
> > it first.
> 
> The second part of my solution changes this code, anyway.
> 
> >
> > > +                     if (error)
> > > +                             return error;
> >
> > This should be an goto out, returns out of the middle of the function
> > make reading and maintaining the code not so nice.
> 
> Sorry, I don't think so. No "common cleanup" is needed here.


---
~Randy
