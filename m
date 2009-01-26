Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbZAZVhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbZAZVhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:37:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZAZVgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:36:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752019AbZAZVgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:36:53 -0500
Date: Mon, 26 Jan 2009 13:35:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: oleg@redhat.com, a.p.zijlstra@chello.nl, rusty@rustcorp.com.au,
       travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-Id: <20090126133551.fab5e27a.akpm@linux-foundation.org>
In-Reply-To: <20090126212727.GA13670@elte.hu>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com>
	<20090116191108.533053000@polaris-admin.engr.sgi.com>
	<20090124001537.7cfde78e.akpm@linux-foundation.org>
	<200901261711.43943.rusty@rustcorp.com.au>
	<20090125230130.bcdab2e5.akpm@linux-foundation.org>
	<20090126171618.GA32091@elte.hu>
	<20090126103529.cb124a58.akpm@linux-foundation.org>
	<20090126202022.GA8867@elte.hu>
	<20090126130046.37b8f34e.akpm@linux-foundation.org>
	<20090126212727.GA13670@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 22:27:27 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > So if it's generic it ought to be implemented in a generic way - not a 
> > > "dont use from any codepath that has a lock held that might 
> > > occasionally also be held in a keventd worklet". (which is a totally 
> > > unmaintainable proposition and which would just cause repeat bugs 
> > > again and again.)
> > 
> > That's different.  The core fault here lies in the keventd workqueue 
> > handling code.  If we're flushing work A then we shouldn't go and block 
> > behind unrelated work B.
> 
> the blocking is inherent in the concept of "a queue of worklets handled by 
> a single thread".
> 
> If a worklet is blocked then all other work performed by that thread is 
> blocked as well. So by waiting on a piece of work in the queue, we wait 
> for all prior work queued up there as well.
> 
> The only way to decouple that and to make them independent (and hence 
> independently flushable) is to create more parallel flows of execution: 
> i.e. by creating another thread (another workqueue).
> 

Nope.  As I said, the caller of flush_work() can detach the work item
and run it directly.
