Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYKPFiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYKPFiv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 00:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYKPFik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 00:38:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61539 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbYKPFik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 00:38:40 -0500
Message-ID: <491FB107.6050703@cn.fujitsu.com>
Date: Sun, 16 Nov 2008 13:35:03 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Arjan van de Ven <arjan@infradead.org>, Paul Menage <menage@google.com>,
       kamezawa.hiroyu@jp.fujitsu.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "David S. Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
       Jes Sorensen <jes@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
References: <491FA28B.2070003@cn.fujitsu.com>	<20081115205229.765f7ee3@infradead.org> <20081115210334.3870cdf6.akpm@linux-foundation.org>
In-Reply-To: <20081115210334.3870cdf6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 15 Nov 2008 20:52:29 -0800 Arjan van de Ven <arjan@infradead.org> wrote:
> 
>> On Sun, 16 Nov 2008 12:33:15 +0800
>> Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>>
>>> some subsystem needs vmalloc() when required memory is large.
>>> but current kernel has not APIs for this requirement.
>>> this patch introduces simple_malloc() and simple_free().
>> Hi
>>
>> I kinda really don't like this approach. vmalloc() (and especially,
>> vfree()) is a really expensive operation, and vmalloc()'d memory is
>> also slower (due to tlb pressure).
> 
> And it can fragment, which effectively means a dead box.
> 
>> Realistically, people should try hard
>> to use small datastructure instead....
> 
> Yup, it makes it easier for people to do something which we strongly
> discourage.  The risk got worse with all these 64-bit machines with
> vast amounts of virtual address space.  It makes it easier for people
> to develop and "test" code which isn't reliable on smaller machines.
> 
>

vmalloc() is not good for performance and increasing fragment.
but vmalloc() is need for some subsystems' alternative malloc,
like cgroup's tasks file and other subsystems(about 20 subsystems).

these subsystems use kmalloc() in the most condition, but may need
vmalloc() in some rare condition. so they use alternative malloc.

So, since these subsystems' maintainer have good reasons for using vmalloc(),
they can use simple_malloc() too. simple_malloc() is not for common using.
(I should document when we use simple_malloc() in the code)

simple_free() is useful. there are several subsystems which use a flags
for selecting kfree() or vfree(), and some subsystems recount the size hardy
before kfree() or vfree().

Thanks, Lai.

