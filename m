Return-Path: <linux-kernel-owner+w=401wt.eu-S1762974AbXEKSJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762974AbXEKSJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 14:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758377AbXEKSJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 14:09:19 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754924AbXEKSJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 14:09:18 -0400
Date: Fri, 11 May 2007 11:08:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 2/2] mm: change mmap_sem over to the scalable rw_mutex
Message-Id: <20070511110824.a617c679.akpm@linux-foundation.org>
In-Reply-To: <1178903537.2781.13.camel@lappy>
References: <20070511131541.992688403@chello.nl>
	<20070511132321.984615201@chello.nl>
	<20070511091744.236e8409.akpm@linux-foundation.org>
	<1178903537.2781.13.camel@lappy>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 19:12:16 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> (now with reply-all)
> 
> On Fri, 2007-05-11 at 09:17 -0700, Andrew Morton wrote:
> > On Fri, 11 May 2007 15:15:43 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > -	down_write(&current->mm->mmap_sem);
> > > +	rw_mutex_write_lock(&current->mm->mmap_lock);
> > 
> > y'know, this is such an important lock and people have had such problems
> > with it and so many different schemes and ideas have popped up that I'm
> > kinda thinking that we should wrap it:
> > 
> > 	write_lock_mm(struct mm_struct *mm);
> > 	write_unlock_mm(struct mm_struct *mm);
> > 	read_lock_mm(struct mm_struct *mm);
> > 	read_unlock_mm(struct mm_struct *mm);
> > 
> > so that further experimentations become easier?
> 
> Sure, can do; it'd require a few more functions than these, but its not
> too many. However, what is the best way to go about such massive rename
> actions? Just push them through quickly, and make everybody cope?

Well, if we _do_ decide to do this (is anyone howling?) then we can do

static inline void write_lock_mm(struct mm_struct *mm)
{
	down_write(&mm->mmap_sem);
}

and then let the conversions trickle into the tree in an orderly fashion.

Once we think all the conversions have landed, we rename mmap_sem to
_mmap_sem to avoid any backpedalling.

