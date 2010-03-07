Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab0CGCd0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 21:33:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52711 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab0CGCdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 21:33:24 -0500
Message-ID: <4B931068.70900@cn.fujitsu.com>
Date: Sun, 07 Mar 2010 10:33:12 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 4/4] cpuset,mm: use rwlock to protect task->mempolicy
 and 	mems_allowed
References: <4B8E3F77.6070201@cn.fujitsu.com> <6599ad831003050403v2e988723k1b6bf38d48707ab1@mail.gmail.com>
In-Reply-To: <6599ad831003050403v2e988723k1b6bf38d48707ab1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2010-3-5 20:03, Paul Menage wrote:
> On Wed, Mar 3, 2010 at 2:52 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>> if MAX_NUMNODES > BITS_PER_LONG, loading/storing task->mems_allowed or mems_allowed in
>> task->mempolicy are not atomic operations, and the kernel page allocator gets an empty
>> mems_allowed when updating task->mems_allowed or mems_allowed in task->mempolicy. So we
>> use a rwlock to protect them to fix this probelm.
> 
> Rather than adding locks, if the intention is just to avoid the
> allocator seeing an empty nodemask couldn't we instead do the
> equivalent of:
> 
> current->mems_allowed |= new_mask;
> current->mems_allowed = new_mask;
> 
> i.e. effectively set all new bits in the nodemask first, and then
> clear all old bits that are no longer in the new mask. The only
> downside of this is that a page allocation that races with the update
> could potentially allocate from any node in the union of the old and
> new nodemasks - but that's the case anyway for an allocation that
> races with an update, so I don't see that it's any worse.

Before applying this patch, cpuset updates task->mems_allowed just like
what you said. But the allocator is still likely to see an empty nodemask.
This problem have been pointed out by Nick Piggin.

The problem is following:
The size of nodemask_t is greater than the size of long integer, so loading
and storing of nodemask_t are not atomic operations. If task->mems_allowed
don't intersect with new_mask, such as the first word of the mask is empty
and only the first word of new_mask is not empty. When the allocator
loads a word of the mask before

	current->mems_allowed |= new_mask;

and then loads another word of the mask after

	current->mems_allowed = new_mask;

the allocator gets an empty nodemask.

I make a new patch to fix this problem now.
Considering the change of task->mems_allowed is not frequent, so in the new
patch, I use variables as a tag to indicate whether task->mems_allowed need
be update or not. And before setting the tag, cpuset caches the new mask of
every task at somewhere. 

When the allocator want to access task->mems_allowed, it must check updated-tag
first. If the tag is set, the allocator enters the slow path and updates
task->mems_allowed.

Thanks!
Miao

