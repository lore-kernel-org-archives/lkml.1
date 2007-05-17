Return-Path: <linux-kernel-owner+w=401wt.eu-S1761589AbXEQAbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589AbXEQAbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 20:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbXEQAbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 20:31:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60815 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755702AbXEQAbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 20:31:41 -0400
Date: Wed, 16 May 2007 17:24:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/2] scalable rw_mutex
Message-Id: <20070516172435.bd3270bd.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705161639010.12688@schroedinger.engr.sgi.com>
References: <20070511131541.992688403@chello.nl>
	<20070511132321.895740140@chello.nl>
	<20070511093108.495feb70.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705111006470.32716@schroedinger.engr.sgi.com>
	<20070511110522.ed459635.akpm@linux-foundation.org>
	<p73odkpeusf.fsf@bingen.suse.de>
	<20070512110624.9ac3aa44.akpm@linux-foundation.org>
	<20070516162829.23f9b1c4.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705161639010.12688@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 16:40:59 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 16 May 2007, Andrew Morton wrote:
> 
> > (I hope.  Might have race windows in which the percpu_counter_sum() count is
> > inaccurate?)
> 
> The question is how do these race windows affect the locking scheme?

The race to which I refer here is if another CPU is running
percpu_counter_sum() in the window between the clearing of the bit in
cpu_online_map and the CPU_DEAD callout.  Maybe that's too small to care
about in the short-term, dunno.

Officially we should fix that by taking lock_cpu_hotplug() in
percpu_counter_sum(), but I hate that thing.

I was thinking of putting a cpumask into the counter.  If we do that then
there's no race at all: everything happens under fbc->lock.  This would be
a preferable fix, if we need to fix it.

But I'd prefer that freezer-based cpu-hotplug comes along and saves us
again.



umm, actually, we can fix the race by using CPU_DOWN_PREPARE instead of
CPU_DEAD.  Because it's OK if percpu_counter_sum() looks at a gone-away
CPU's slot.
