Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab0CKFbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 00:31:08 -0500
Received: from cantor.suse.de ([195.135.220.2]:48544 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab0CKFbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 00:31:06 -0500
Date: Thu, 11 Mar 2010 16:30:59 +1100
From: Nick Piggin <npiggin@suse.de>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 4/4] cpuset,mm: use rwlock to protect task->mempolicy
 and 	mems_allowed
Message-ID: <20100311053059.GG5812@laptop>
References: <4B8E3F77.6070201@cn.fujitsu.com>
 <6599ad831003050403v2e988723k1b6bf38d48707ab1@mail.gmail.com>
 <4B931068.70900@cn.fujitsu.com>
 <6599ad831003091142t38c9ffc9rea7d351742ecbd98@mail.gmail.com>
 <4B9879E1.6000606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9879E1.6000606@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 01:04:33PM +0800, Miao Xie wrote:
> on 2010-3-10 3:42, Paul Menage wrote:
> > On Sat, Mar 6, 2010 at 6:33 PM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> >>
> >> Before applying this patch, cpuset updates task->mems_allowed just like
> >> what you said. But the allocator is still likely to see an empty nodemask.
> >> This problem have been pointed out by Nick Piggin.
> >>
> >> The problem is following:
> >> The size of nodemask_t is greater than the size of long integer, so loading
> >> and storing of nodemask_t are not atomic operations. If task->mems_allowed
> >> don't intersect with new_mask, such as the first word of the mask is empty
> >> and only the first word of new_mask is not empty. When the allocator
> >> loads a word of the mask before
> >>
> >>        current->mems_allowed |= new_mask;
> >>
> >> and then loads another word of the mask after
> >>
> >>        current->mems_allowed = new_mask;
> >>
> >> the allocator gets an empty nodemask.
> > 
> > Couldn't that be solved by having the reader read the nodemask twice
> > and compare them? In the normal case there's no race, so the second
> > read is straight from L1 cache and is very cheap. In the unlikely case
> > of a race, the reader would keep trying until it got two consistent
> > values in a row.
> 
> I think this method can't fix the problem because we can guarantee the second
> read is after the update of mask completes.

Any problem with using a seqlock?

The other thing you could do is store a pointer to the nodemask, and
allocate a new nodemask when changing it, issue a smp_wmb(), and then
store the new pointer. Read side only needs a smp_read_barrier_depends()

