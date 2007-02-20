Return-Path: <linux-kernel-owner+w=401wt.eu-S1161071AbXBTXTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161071AbXBTXTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 18:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161076AbXBTXTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 18:19:21 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53312 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161071AbXBTXTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 18:19:20 -0500
Date: Tue, 20 Feb 2007 15:19:19 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: SLAB cache reaper on isolated cpus
In-Reply-To: <45DB7AB1.5010304@qualcomm.com>
Message-ID: <Pine.LNX.4.64.0702201514470.17866@schroedinger.engr.sgi.com>
References: <20070129011301.GA844@tv-sign.ru>
 <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com>
 <20070129171923.GA138@tv-sign.ru> <Pine.LNX.4.64.0701290922390.28330@schroedinger.engr.sgi.com>
 <20070129182742.GA158@tv-sign.ru> <45DB404C.4070305@qualcomm.com>
 <Pine.LNX.4.64.0702201041340.14643@schroedinger.engr.sgi.com>
 <20070220200550.GA85@tv-sign.ru> <45DB669B.2010307@qualcomm.com>
 <Pine.LNX.4.64.0702201334361.17198@schroedinger.engr.sgi.com>
 <45DB6FC7.60502@qualcomm.com> <Pine.LNX.4.64.0702201402420.17433@schroedinger.engr.sgi.com>
 <45DB7AB1.5010304@qualcomm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007, Max Krasnyansky wrote:

> Suppose I need to isolate a CPU. We already support at the scheduler and 
> irq levels (irq affinity). But I want to go a bit further and avoid 
> doing kernel work on isolated cpus as much as possible. For example I 
> would not want to schedule work queues and stuff on them. Currently 
> there are just a few users of the schedule_delayed_work_on(). cpufreq 
> (don't care for isolation purposes), oprofile (same here) and slab. For 
> the slab it'd be nice to run the reaper on some other CPU. But you're 
> saying that locking depends on CPU pinning. Is there any other option 
> besides disabling cache reap ? Is there a way for example to constraint 
> the slabs on CPU X to not exceed N megs ?

There is no way to constrain the amount of slab work. In order to make the 
above work we would have to disable the per cpu caches for a certain cpu. 
Then there would be no need to run the cache reaper at all.

To some extend such functionality already exists. F.e. kmalloc_node() 
already bypasses the per cpu caches (most of the time).  kmalloc_node will 
have to take a spinlock on a shared cacheline on each invocation. kmalloc 
does only touch per cpu data during regular operations. Thus kmalloc() is much 
faster than kmalloc_node() and the cachelines for kmalloc() can be kept in 
the per cpu cache.

If we could disable all per cpu caches for certain cpus then you could 
make this work. All slab OS interference would be off the processor.
