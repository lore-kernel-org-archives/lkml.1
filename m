Return-Path: <linux-kernel-owner+w=401wt.eu-S1751423AbZL1DQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbZL1DQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 22:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbZL1DQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 22:16:34 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59499 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbZL1DQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 22:16:33 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Dec 2009 12:13:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org
Subject: Re: [RFC PATCH] asynchronous page fault.
Message-Id: <20091228121318.780fd104.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091228025839.GF3601@balbir.in.ibm.com>
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
	<1261912796.15854.25.camel@laptop>
	<20091228005746.GE3601@balbir.in.ibm.com>
	<20091228100514.ec6f9949.kamezawa.hiroyu@jp.fujitsu.com>
	<20091228025839.GF3601@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009 08:28:39 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-12-28 10:05:14]:

> >   - rb-tree's rb_left and rb_right don't points to memory other than
> >     rb-tree. (or NULL)  And vmas are not freed/reused while rcu_read_lock().
> >     Then, we don't dive into unknown memory.
> >   - Then, we can skip rcu_assign_pointer().
> >
> 
> We can, but the data being on read-side is going to be out-of-date
> more than without the use of rcu_assign_pointer(). Do we need variants
> like to rcu_rb_next() to avoid overheads for everyone?
> 
I myself can't know how often out-of-date data can be seen (because I use x86).

But, I feel that we don't see broken tree so often. Because...
  - Single-threaded apps never see broken tree.
  - Even if rb-tree modification frequently happens, tree rotation is not
    very often and sub-trees tend to be stable as a chunk.

Hmm, adding barrier like this ?

static inline void
__vma_unlink(struct mm_struct *mm, struct vm_area_struct *vma,
                struct vm_area_struct *prev)
{
        prev->vm_next = vma->vm_next;
        rb_erase(&vma->vm_rb, &mm->mm_rb);
        if (mm->mmap_cache == vma)
                mm->mmap_cache = prev;
	smp_wb(); <==============================================(new)
}



Regards,
-Kame

