Return-Path: <linux-kernel-owner+w=401wt.eu-S1759453AbZBMAbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453AbZBMAbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 19:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbZBMAau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 19:30:50 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58323 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbZBMAas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 19:30:48 -0500
Date: Fri, 13 Feb 2009 09:29:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@tglx.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: Re: [patch] rt: res_counter fix, v2
Message-Id: <20090213092932.a503c4a7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090213085640.704caf34.kamezawa.hiroyu@jp.fujitsu.com>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	<20090212005032.GA4788@nowhere>
	<20090212021257.GB4697@nowhere>
	<20090212101650.GA1096@elte.hu>
	<20090212102113.GA10031@elte.hu>
	<20090212194644.98d275cf.kamezawa.hiroyu@jp.fujitsu.com>
	<20090212112854.GD31613@elte.hu>
	<20090212165833.GB6298@balbir.in.ibm.com>
	<20090213085640.704caf34.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Feb 2009 08:56:40 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 12 Feb 2009 22:28:33 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * Ingo Molnar <mingo@elte.hu> [2009-02-12 12:28:54]:
> > 
> > > 
> > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > 
> > > > On Thu, 12 Feb 2009 11:21:13 +0100
> > > > Ingo Molnar <mingo@elte.hu> wrote:
> > > The question is, are these local IRQ flags manipulations really needed
> > > in this code, and if yes, why?
> > 
> > We needed the local IRQ flags, since these counters are updated from
> > page fault context and from reclaim context with lru_lock held with
> > IRQ's disabled. I've been thinking about replacing the spin lock with
> > seq lock, but have not gotten to it yet.
> > 
> Hmm ?  I can't understand. Why we have to disable IRQ here again ?
> And,
>   - try_to_unmap() is called in shrink_page_list(),  there, no zone->lru_lock.
>   - page fault path doesn't hold zone->lru_lock.
> 
> My concern is only shmem. But I think it doesn't call charge() within lock, actually

Clarification :)
  res_counter_charge() is called from
    - page fault 
        => under down_read(mmap_sem), lock_page() may be held.  IRQ=ENABLED)
    - add_to_page_cache
        => under lock_page(), mapping->tree_lock is *not* held, IRQ=DISABLED
    - shmem
        => info->lock is held, we use __GFP_NOWAIT here. IRQ=ENABLED
    - shmem
        => info->lock is *not* held with GFP_KERNEL here, IRQ=ENABLED.
    - migration
        => under lock_page() and mmap_sem, IRQ=ENABLED

  res_counter_uncharge() is called from
    - page_remove_rmap()//(Only when ANON)
         => anon_vma->lock and pte_lock(),lock_page() can be held. IRQ=ENABLED?
    - remove_from_page_cache()
         => lock_page() and mapping->tree_lock is held, IRQ=DISABLED.

Summary:
   "Charge" is considered as heavy operation and the call path is placed where the
    thread can sleep, AMAP.
   "Uncharge" is considered as light operation and call path is under some # of
    spinlocks.


Bye,
-Kame

