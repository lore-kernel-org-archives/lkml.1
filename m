Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYIRJCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYIRJCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 05:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYIRJCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 05:02:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59016 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbYIRJCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 05:02:04 -0400
Message-ID: <48D21875.7030605@cn.fujitsu.com>
Date: Thu, 18 Sep 2008 16:59:33 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, manfred@colorfullife.com
Subject: Re: [RFC PATCH] rcu: introduce kfree_rcu()
References: <48D1D694.9010802@cn.fujitsu.com> <20080918064406.GC6397@linux.vnet.ibm.com>
In-Reply-To: <20080918064406.GC6397@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How to usage kfree_rcu:

struct my_struct {
	int data;
	struct rcu_head rcu;
};

----------------original code:--------------------------
void my_struct_release_rcu(struct rcu_head *rcu)
{
	struct my_struct *p;

	item = container_of(rcu, struct my_struct, rcu);
	kfree(p);
}

void some_fuction()
{
	struct my_struct *p;
	.....;
	call_rcu(&p->rcu, my_struct_release_rcu);
	.....;
}
---end---

-----------------after use kfree_rcu:--------------------

/* my_struct_release_rcu() was removed */

void some_fuction()
{
	struct my_struct *p;
	.....;
	kfree_rcu(p, &p->rcu);
	.....;
}
---end---

1) unloadable modules:
   A) use my_struct_release_rcu():
      when we unload this modules, we need call rcu_barrier() to wait
      all my_struct_release_rcu() had called.
   B) use kfree_rcu():
      if all trivial callback are removed and kfree_rcu() are used instead,
      we do not need to wait anything. just quick finish unloading.

2) duplicate code:
   A) use my_struct_release_rcu():
      All trivial callback are very like my_struct_release_rcu(),
      all are duplicate code.
   B) use kfree_rcu():
      all trivial callback are removed, not duplicate code like
      my_struct_release_rcu().

3) cache:
   A) use my_struct_release_rcu():
      my_struct_release_rcu() is called rarely, when my_struct_release_rcu()
      is being called, cache missing will occur.
   B) use kfree_rcu():
      my_struct_release_rcu() is removed, not such cache missing.

4) future:
   A) use my_struct_release_rcu():
      when new user use rcu, the most callback is trivial callback
      like my_struct_release_rcu(). this is the common of using rcu.
      so the problems of above are more and more heavy.
   B) use kfree_rcu():
      fix these problems for ever.


Paul E. McKenney wrote:
> On Thu, Sep 18, 2008 at 12:18:28PM +0800, Lai Jiangshan wrote:
>> sometimes a rcu callback is just calling kfree() to free a struct's memory
>> (we say this callback is a trivial callback.).
>> this patch introduce kfree_rcu() to do these things directly, easily.
> 
> Interesting!  Please see questions and comments below.
> 
>> There are 4 reasons that we need kfree_rcu():
>>
>> 1) unloadable modules:
>>    a module(rcu callback is defined in this module) using rcu must
>>    call rcu_barrier() when unload. rcu_barrier() will increase
>>    the system's overhead(the more cpus the worse) and
>>    rcu_barrier() is very time-consuming. if all rcu callback defined
>>    in this module are trivial callback, we can just call kfree_rcu()
>>    instead, save a rcu_barrier() when unload.
> 
> You lost me on this one.  Suppose that the following sequence of
> events occurred:
> 
> a.	The module invokes call_rcu() or kfree_rcu().  The callback
> 	is queued on CPU 0.
> 
> b.	Perhaps a grace period completes, and the callback is therefore
> 	moved to CPU 0's donelist.  But CPU 0 is busy, so doesn't get
> 	around to invoking the callback.  (For example, ksoftirqd.)
> 
> c.	The module is unloaded, and uses kfree_rcu() instead of
> 	rcu_barrier().  The callback is queued on CPU 1.

uses kfree_rcu() instead of trivial callback, not rcu_barrier()

> 
> d.	A grace period completes, and CPU 1 is relatively idle, so
> 	invokes its callback quickly.  The module is therefore unloaded.
> 
> e.	CPU 0 finally gets around to executing its callback, but the
> 	module has been unloaded, so there is nothingness where the
> 	callback function used to be.  We get an oops.
> 

we done need wait anything if not callback is defined in this module.

> What prevents this sequence of events from happening?
> 

