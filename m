Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbZCLPcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbZCLPcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZCLPcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:32:11 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:44178 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZCLPcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:32:10 -0400
Date: Thu, 12 Mar 2009 16:27:33 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       akpm@linux-foundation.org
Subject: Re: [PATCH] acquire mmap semaphore in pagemap_read.
Message-ID: <20090312162733.4e8fd197@skybase>
In-Reply-To: <1236871414.3213.50.camel@calx>
References: <20090312113308.6fe18a93@skybase>
	<20090312114533.GA2407@x200.localdomain>
	<20090312125410.25400d18@skybase>
	<1236871414.3213.50.camel@calx>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 10:23:34 -0500
Matt Mackall <mpm@selenic.com> wrote:

> On Thu, 2009-03-12 at 12:54 +0100, Martin Schwidefsky wrote:
> > On Thu, 12 Mar 2009 14:45:33 +0300
> > Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > 
> > > On Thu, Mar 12, 2009 at 11:33:08AM +0100, Martin Schwidefsky wrote:
> > > > --- linux-2.6/fs/proc/task_mmu.c
> > > > +++ linux-2.6-patched/fs/proc/task_mmu.c
> > > > @@ -716,7 +716,9 @@ static ssize_t pagemap_read(struct file 
> > > >  	 * user buffer is tracked in "pm", and the walk
> > > >  	 * will stop when we hit the end of the buffer.
> > > >  	 */
> > > > +	down_read(&mm->mmap_sem);
> > > >  	ret = walk_page_range(start_vaddr, end_vaddr, &pagemap_walk);
> > > > +	up_read(&mm->mmap_sem);
> > > 
> > > This will introduce "put_user under mmap_sem" which is deadlockable.
> > 
> > Hmm, interesting. In this case the pagemap interface is fundamentally broken.
> 
> Well it means we may have to reintroduce the very annoying double
> buffering from various earlier implementations. But let's leave this
> discussion until after we've figured out what to do about the walker
> code.

Which would be really ugly. I still have not grasped why this will
introduce a deadlock though. The worst the put_user can do is to cause
a page fault, no? I do not see where the fault handler acquires the
mmap_sem as writer. It takes the mmap_sem as reader and two readers
should be fine.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

