Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbYCSTuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbYCSTuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbYCSTdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:33:22 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:27544 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850AbYCSTdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:33:19 -0400
Subject: Re: [BUG?] 2.6.25-rc[23]-mm1 cgroup list corruption under load
	with VM Scalability patches
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Paul Menage <menage@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <6599ad830803051309g22d5b746ta30c4f28a394572c@mail.gmail.com>
References: <1204745828.6244.31.camel@localhost>
	 <6599ad830803051309g22d5b746ta30c4f28a394572c@mail.gmail.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 18 Mar 2008 14:10:11 -0400
Message-Id: <1205863811.5032.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-05 at 13:09 -0800, Paul Menage wrote:
> On Wed, Mar 5, 2008 at 11:37 AM, Lee Schermerhorn
> <Lee.Schermerhorn@hp.com> wrote:
> > list_del corruption in cgroup_exit() on 16 cpu, 32GB ia64 NUMA platform.
> >
> >  I've been seeing this for a while now, but we've had known problems
> >  [page leaks, ...] with the VM scalability series.  Now the system
> >  appears to be running very well with these patches under stress loads
> >  that would hang it or cause OOM kill of tests with plenty of swap space
> >  left.  Eventually, [after 40-45 minutes], I hit a list corruption in
> >  cgroup_exit().
> >
> >  I can't say for sure that our patches aren't causing this, but I've been
> >  unable to keep the system up long enough under the stress load w/o the
> >  splitlru+noreclaim patches to hit the problem.
> >
> >  I looked in the mailing lists and found one other thread related to
> >  cgroup list corruption:
> >
> >         http://marc.info/?l=linux-kernel&m=119263666823236&w=4
> >
> >  Paul looked into this and couldn't see anywhere that the lists are
> >  manipulate w/o holding the css set lock.  I concur.  I did find one
> >  possible race in enabling the task cg_lists [see patch below], but this
> >  did not solve the problem.  And I did not hit the printk in the patch.
> 
> No, that's not a (malign) race - cgroup_enable_task_cg_lists() is
> idempotent. In the case that you see, every thread seen in the
> do_each_thread() loop will already have a non-empty cg_list field, so
> it will be a no-op. So adding the additional check isn't wrong but
> it's not needed.
> 
> I'll look again at the code to try to figure out where the problem is.

Paul:

just wanted to let you know that I did manage to hit this list
corruption--same stack trace:  cgroup_exit() from do_exit() ...--on
25-rc3-mm1 WITHOUT any of the vm scalability [split-lru/noreclaim-mlock]
patches applied.  This occurred ~9 minutes into a fairly heavy 'usex'
load on my 16 cpu ia64 platform.

An x86_64 version [w/ prebuilt binaries of the tools used] of the stress
load is available here:

	http://free.linux.hp.com/~lts/Temp/

There's a README there describing the contents of the tarball.  I
haven't tried this load on an x86_64 recently, so I don't know if it
will trigger the problem there.   

Lee

