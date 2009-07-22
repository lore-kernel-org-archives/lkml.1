Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbZGVRDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbZGVRDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZGVRDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:03:43 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:39640 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752620AbZGVRDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:03:43 -0400
Subject: Re: [RFC PATCH] kmemleak: Scan all thread stacks
From: Catalin Marinas <catalin.marinas@arm.com>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090722161809.GH6757@linux.vnet.ibm.com>
References: <20090717093359.8288.45464.stgit@pc1117.cambridge.arm.com>
	 <20090717164346.GC5131@elte.hu>
	 <1247849826.6313.64.camel@pc1117.cambridge.arm.com>
	 <1247850069.6522.91.camel@laptop>
	 <20090722161809.GH6757@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 22 Jul 2009 18:03:29 +0100
Message-Id: <1248282209.31275.68.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jul 2009 17:03:30.0534 (UTC) FILETIME=[56A09860:01CA0AEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 09:18 -0700, Paul E. McKenney wrote:
> On Fri, Jul 17, 2009 at 07:01:09PM +0200, Peter Zijlstra wrote:
> > On Fri, 2009-07-17 at 17:57 +0100, Catalin Marinas wrote:
> > > On Fri, 2009-07-17 at 18:43 +0200, Ingo Molnar wrote:
> > > > * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > > > 2. Is it safe to use rcu_read_lock() and task_lock() when scanning the
> > > > >    corresponding kernel stack (thread_info structure)? The loop doesn't
> > > > >    do any modification to the task list. The reason for this is to
> > > > >    allow kernel preemption when scanning the stacks.
> > > > 
> > > > you cannot generally preempt while holding the RCU read-lock.
> > > 
> > > This may work with rcupreempt enabled. But, with classic RCU is it safe
> > > to call schedule (or cond_resched) while holding the RCU read-lock?
> > 
> > No.
> 
> What Peter said!  ;-)
> 
> However, you might be able to use SRCU (http://lwn.net/Articles/202847/),
> which does allow blocking within read-side critical sections.

Thanks for the suggestion. But this would mean that the task_struct
creation/deletion code should use the SRCU as well which I wouldn't
modify. I'm also not entirely sure this could replace
read_lock(&tasklist_lock)/read_unlock (as per the initial question).

The simplest fix for kmemleak is to not traverse the task list at all -
http://lkml.org/lkml/2009/7/20/55. The patch is just like any other
kmemleak annotation in the kernel.

Thanks.

-- 
Catalin

