Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYAGUMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYAGUMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 15:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbYAGUMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 15:12:46 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58026 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbYAGUMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 15:12:46 -0500
Date: Mon, 7 Jan 2008 22:12:44 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <clameter@sgi.com>
cc: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       zanussi@us.ibm.com
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
In-Reply-To: <Pine.LNX.4.64.0801051202480.14866@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0801072157550.31715@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> 
 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com> 
 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org> 
 <1199314218.4497.109.camel@cinder.waste.org>  <20080103085239.GA10813@elte.hu>
  <1199378818.8274.25.camel@cinder.waste.org> 
 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>
 <1199419890.4608.77.camel@cinder.waste.org> <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0801051202480.14866@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Sat, 5 Jan 2008, Pekka J Enberg wrote:
> > So, I have this silly memory profiler derived from the kleak patches by 
> > the relayfs people and would love to try it out on an embedded workload 
> > where SLUB memory footprint is terrible. Any suggestions?

On Sat, 5 Jan 2008, Christoph Lameter wrote:
> Good idea. But have you tried to look at slabinfo?
> 
> Try to run
> 
> 	slabinfo -t
> 
> which will calculate the allocation overhead of the currently allocated 
> objects in all slab caches.

Oh, I didn't know about that. It's great for looking at the current memory 
footprint but not really suitable if you want to analyze allocation/free 
patterns.

And I think we need to look at the patterns to figure out *where* and 
*why* SLOB is better than SLUB and whether that can be fixed in SLUB or 
the callers. For example, while it's obviously true that SLUB has 
much higher internal fragmentation for kmalloc() than SLOB, it doesn't 
matter as much if the allocations are short-lived. I don't think you can 
extend the current SLUB debug mechanism to provide that but rather 
"kmalloc accounting" is needed.

The problem with my patch, though, is that due to relayfs I cannot capture 
events unless userspace is ready to read them which is why I am missing 
all the data from boot (I think systemtap has this same limitation?). So 
we need something like what Matt has except that it needs to keep track of 
every *event* and userspace must be able to access them.

			Pekka
