Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbYE3Fu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbYE3Fu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYE3FuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:50:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160AbYE3FuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:50:15 -0400
Date: Thu, 29 May 2008 22:49:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 00/41] cpu alloc / cpu ops v3: Optimize per cpu access
Message-Id: <20080529224959.3297a4f1.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0805292224540.12329@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com>
	<20080529215827.b659d032.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0805292159360.12107@schroedinger.engr.sgi.com>
	<20080529222143.5d7aa1e5.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0805292224540.12329@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 22:27:53 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Thu, 29 May 2008, Andrew Morton wrote:
> 
> > > The per cpu memory use by subsystems is typically quite small. We already 
> > > have an 8k limitation for percpu space for modules. And that does not seem 
> > > to be a problem.
> > 
> > eh?  That's DEFINE_PERCPU memory, not alloc_pecpu() memory?
> 
> No. The module subsystem has its own alloc_percpu subsystem that the 
> cpu_alloc replaces.

That is to support DEFINE_PER_CPU, not alloc_percpu().

> > > We could do that yes.
> > 
> > Phew.
> 
> But its going to be even more complicated and I have a hard time managing 
> the complexity here. Could someone take pieces off my hand?

It could be done later on.

> > > But then per cpu data is not frequently allocated and freed.
> > 
> > I think it is, in the TCP case.  And that's the only one I looked at.
> 
> Which tcp case?

The one you just deleted from my reply :(

> > Plus who knows what lies ahead of us?
> 
> Well invariably we will end up with cpu area defragmentation.... Sigh.
> 
> > I don't think there is presently any upper limit on alloc_percpu()?  It
> > uses kmalloc() and kmalloc_node()?
> > 
> > Even if there is some limit, is it an unfixable one?
> 
> No there is no limit. It just wastes lots of space (pointer arrays, 
> alignment etc) that we could use to configure sufficiently large per cpu 
> areas.

Christoph, please.  An allocator which is of fixed size and which is
vulnerable to internal fragmentation is a huge problem!  The kernel is
subject to wildly varying workloads both between different users and in
the hands of a single user.

If we were to merge all this code and then run into the problems which
I fear then we are tremendously screwed.  We must examine this
exhaustively, in the most paranoid fashion.

