Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbXHVBSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbXHVBSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 21:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbXHVBSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 21:18:09 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:42654 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbXHVBSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 21:18:08 -0400
Date: Tue, 21 Aug 2007 21:18:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070822011805.GB4124@Krystal>
References: <20070821231216.GA29691@Krystal> <Pine.LNX.4.64.0708211614370.6062@schroedinger.engr.sgi.com> <20070821233938.GD29691@Krystal> <Pine.LNX.4.64.0708211640430.6225@schroedinger.engr.sgi.com> <20070821234702.GE29691@Krystal> <Pine.LNX.4.64.0708211649260.6886@schroedinger.engr.sgi.com> <20070822000323.GG29691@Krystal> <Pine.LNX.4.64.0708211704260.7852@schroedinger.engr.sgi.com> <20070822002616.GA1400@Krystal> <Pine.LNX.4.64.0708211731410.3354@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708211731410.3354@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:13:55 up 23 days,  1:32,  3 users,  load average: 0.54, 0.33, 0.28
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Tue, 21 Aug 2007, Mathieu Desnoyers wrote:
> 
> > As I am going back through the initial cmpxchg_local implementation, it
> > seems like it was executing __slab_alloc() with preemption disabled,
> > which is wrong. new_slab() is not designed for that.
> 
> The version I send you did not use preemption.
> 
> We need to make a decision if we want to go without preemption and cmpxchg 
> or with preemption and cmpxchg_local.
> 

I don't expect any performance improvements with cmpxchg() over irq
disable/restore. I think we'll have to use cmpxchg_local

Also, we may argue that locked cmpxchg will have more scalability impact
than cmpxchg_local. Actually, I expect the LOCK prefix to have a bigger
scalability impact than the irq save/restore pair.

> If we really want to do this then the implementation of all of these 
> components need to result in competitive performance on all platforms.
> 

The minor issue I see here is on architectures where we have to simulate
cmpxchg_local with irq save/restore. Depending on how we implement the
code, it may result in two irq save/restore pairs instead of one, which
could make the code slower. However, if we are clever enough in our
low-level primitive usage, I think we could make the code use
cmpxchg_local when available and fall back on only _one_ irq disabled
section surrounding the whole code for other architectures.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
