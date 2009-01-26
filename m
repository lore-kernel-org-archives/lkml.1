Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbZAZR5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbZAZR5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZAZR53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:57:29 -0500
Received: from smtp.ultrahosting.com ([74.213.174.254]:48064 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbZAZR53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:57:29 -0500
Date: Mon, 26 Jan 2009 12:46:49 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator
In-Reply-To: <200901240409.27449.nickpiggin@yahoo.com.au>
Message-ID: <alpine.DEB.1.10.0901261241070.22291@qirst.com>
References: <20090114150900.GC25401@wotan.suse.de> <alpine.DEB.1.10.0901231042380.32253@qirst.com> <20090123161017.GC14517@wotan.suse.de> <200901240409.27449.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2009, Nick Piggin wrote:

> > > SLUB can directly free an object to any slab page. "Queuing" on free via
> > > the per cpu slab is only possible if the object came from that per cpu
> > > slab. This is typically only the case for objects that were recently
> > > allocated.
> >
> > Ah yes ok that's right. But then you don't get LIFO allocation
> > behaviour for those cases.
>
> And actually really this all just stems from conceptually in fact you
> _do_ switch to a different queue (from the one being allocated from)
> to free the object if it is on a different page. Because you have a
> set of queues (a queue per-page). So freeing to a different queue is
> where you lose LIFO property.

Yes you basically go for locality instead of LIFO if the free does not hit
the per cpu slab. If the object is not in the per cpu slab then it is
likely that it had a long lifetime and thus LIFOness does not matter
too much. It is likely that many objects from that slab are going to be
freed at the same time. So the first free warms up the "queue" of the page
you are freeing to.

This is an increasingly important feature since memory chips prefer
allocations next to each other. Same page accesses are faster
in recent memory subsystems than random accesses across memory. LIFO used
to be better but we are increasingly getting into locality of access being
very important for access. Especially with the NUMA characteristics of the
existing AMD and upcoming Nehalem processors this will become much more
important.
