Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbZCXLSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbZCXLSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 07:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758496AbZCXLSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 07:18:11 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:52294 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbZCXLSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:18:10 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH v5 09/13] PCI: Introduce /sys/bus/pci/devices/.../remove
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alex Chiang <achiang@hp.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Johannes Berg <johannes@sipsolutions.net>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kaneshige.kenji@jp.fujitsu.com, Lai Jiangshan <laijs@cn.fujitsu.com>
In-Reply-To: <20090324034659.9e1f97dc.akpm@linux-foundation.org>
References: <20090320204327.12275.43010.stgit@bob.kio>
	 <20090320205636.12275.1825.stgit@bob.kio> <49C74FCC.7070308@jp.fujitsu.com>
	 <20090324032304.GB6175@ldl.fc.hp.com> <20090324092525.GE6605@elte.hu>
	 <20090324034659.9e1f97dc.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 12:17:07 +0100
Message-Id: <1237893427.24918.174.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-24 at 03:46 -0700, Andrew Morton wrote:
> 
> Thing is, we've always supported kevetnd-calls-flush_work().  That's what
> "morton gets to eat his hat" in run_workqueue() is all about.

Supported as in not complained about it, but its always presented a
deadlock scenario.

> Now, -mm's workqueue-avoid-recursion-in-run_workqueue.patch changes all of
> that.

See the discussions around that patch, Lai Jiangshan discovered that it
had more deadlock potential than we even suspected.

To quote:

---
On 02/06, Lai Jiangshan wrote:
>
> Oleg Nesterov wrote:
> > On 02/05, Lai Jiangshan wrote:
> >> DEADLOCK EXAMPLE for explain my above option:
> >>
> >> (work_func0() and work_func1() are work callback, and they
> >> calls flush_workqueue())
> >>
> >> CPU#0                                      CPU#1
> >> run_workqueue()                         run_workqueue()
> >>   work_func0()                            work_func1()
> >>     flush_workqueue()                       flush_workqueue()
> >>       flush_cpu_workqueue(0)                  .
> >>       flush_cpu_workqueue(cpu#1)              flush_cpu_workqueue(cpu#0)
> >>         waiting work_func1() in cpu#1           waiting work_func0 in cpu#0
> >>
> >> DEADLOCK!
> >
> > I am not sure. Note that when work_func0() calls run_workqueue(),
> > it will clear cwq->current_work, so another flush_ on CPU#1 will
> > not wait for work_func0, no?
>
> cwq->current_work is changed only when
> !list_empty(&cwq->worklist)
> in run_workqueue().
>
> so cwq->current_work may not be changed.

Ah, indeed.

Thanks for correcting me!
---

>   And that patch recently triggered a warning due to some games which
> USB was playing.  I was told this is because USB is being bad.
> 
> But I don't think we've seen a coherent description of what's actually
> _wrong_ with the current code.  flush_cpu_workqueue() has been handling
> this case for many years with no problems reported as far as I know.

Might be sheer luck, but afaik we did have some actual deadlocks due to
workqueue flushing -- a particular one I can remember was cpu-hotplug vs
cpufreq.

> So what has caused this sudden flurry of reports?  Did something change in
> lockdep?  What is this
> 
> [  537.380128]  (events){--..}, at: [<ffffffff80257fc0>] flush_workqueue+0x0/0xa0
> [  537.380128]
> [  537.380128] but task is already holding lock:
> [  537.380128]  (events){--..}, at: [<ffffffff80257648>] run_workqueue+0x108/0x230
> 
> supposed to mean?  "events" isn't a lock - it's the name of a kernel
> thread, isn't it?

No workqueue lockdep support has been in there for a while now. /me
pokes at git for a bit..

4e6045f134784f4b158b3c0f7a282b04bd816887 -- Oct 2007, ca. 2.6.24-rc1

What it does it gives the workqueue a lock-object and each worklet. It
then validates that you only get:

 workqueue
   worklet

nestings, eg. calling flush_workqueue() from a worklet will generate

 workqueue    <-.
   worklet      |
     workqueue -'

recursion, IOW the above splat.

Another thing it does is connect the lockchains of workqueue callers
with those of the worklet. eg.

---
    code path 1:
      my_function() -> lock(L1); ...; flush_workqueue(); ...
    
    code path 2:
      run_workqueue() -> my_work() -> ...; lock(L1); ...
    
    you can get a deadlock when my_work() is queued or running
    but my_function() has acquired L1 already.
---

>   If this is supposed to be deadlockable then how?
> 
> Because I don't immediately see what's wrong with e1000_remove() calling
> flush_work().  It's undesirable, and we can perhaps improve it via some
> means, but where is the bug?

I hope the above answers why flushing a workqueue from within that same
workqueue is a very bad thing.

