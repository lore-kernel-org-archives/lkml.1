Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab0CKLDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 06:03:25 -0500
Received: from cantor.suse.de ([195.135.220.2]:55747 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098Ab0CKLDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 06:03:23 -0500
Date: Thu, 11 Mar 2010 22:03:17 +1100
From: Nick Piggin <npiggin@suse.de>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH V2 4/4] cpuset,mm: update task's mems_allowed lazily
Message-ID: <20100311110317.GL5812@laptop>
References: <4B94CD2D.8070401@cn.fujitsu.com>
 <alpine.DEB.2.00.1003081330370.18502@chino.kir.corp.google.com>
 <4B95F802.9020308@cn.fujitsu.com>
 <20100311081548.GJ5812@laptop>
 <4B98C6DE.3060602@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B98C6DE.3060602@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 06:33:02PM +0800, Miao Xie wrote:
> on 2010-3-11 16:15, Nick Piggin wrote:
> > On Tue, Mar 09, 2010 at 03:25:54PM +0800, Miao Xie wrote:
> >> on 2010-3-9 5:46, David Rientjes wrote:
> >> [snip]
> >>>> Considering the change of task->mems_allowed is not frequent, so in this patch,
> >>>> I use two variables as a tag to indicate whether task->mems_allowed need be
> >>>> update or not. And before setting the tag, cpuset caches the new mask of every
> >>>> task at its task_struct.
> >>>>
> >>>
> >>> So what exactly is the benefit of 58568d2 from last June that caused this 
> >>> issue to begin with?  It seems like this entire patchset is a revert of 
> >>> that commit.  So why shouldn't we just revert that one commit and then add 
> >>> the locking and updating necessary for configs where
> >>> MAX_NUMNODES > BITS_PER_LONG on top?
> >>
> >> I worried about the consistency of task->mempolicy with task->mems_allowed for
> >> configs where MAX_NUMNODES <= BITS_PER_LONG. 
> >>
> >> The problem that I worried is fowllowing:
> >> When the kernel allocator allocates pages for tasks, it will access task->mempolicy
> >> first and get the allowed node, then check whether that node is allowed by
> >> task->mems_allowed.
> >>
> >> But, Without this patch, ->mempolicy and ->mems_allowed is not updated at the same
> >> time. the kernel allocator may access the inconsistent information of ->mempolicy
> >> and ->mems_allowed, sush as the allocator gets the allowed node from old mempolicy,
> >> but checks whether that node is allowed by new mems_allowed which does't intersect
> >> old mempolicy.
> >>
> >> So I made this patchset.
> > 
> > I like your focus on keeping the hotpath light, but it is getting a bit
> > crazy. I wonder if it wouldn't be better just to teach those places that
> > matter to retry on finding an inconsistent nodemask? The only failure
> > case to worry about is getting an empty nodemask, isn't it?
> > 
> 
> Ok, I try to make a new patch by using seqlock.

Well... I do think seqlocks would be a bit simpler because they don't
require this checking and synchronizing of this patch.

But you are right: on non-x86 architectures seqlocks would probably be
more costly than your patch in the fastpaths. Unless you can avoid
using the seqlock in fastpaths and just have callers handle the rare
case of an empty nodemask.

cpuset_node_allowed_*wall doesn't need anything because it is just
interested in one bit in the mask.

cpuset_mem_spread_node doesn't matter because it will loop around and
try again if it doesn't find any nodes online.

cpuset_mems_allowed seems totally broken anyway

etc.

This approach might take a little more work, but I think it might be the
best way.

