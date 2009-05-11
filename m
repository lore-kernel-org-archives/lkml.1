Return-Path: <linux-kernel-owner+w=401wt.eu-S1760079AbZEKWZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079AbZEKWZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759888AbZEKWZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:25:45 -0400
Received: from smtp-out.google.com ([216.239.45.13]:46615 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401AbZEKWZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:25:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ljb2ZSNdnQhUeuLYltK6MIJtMcKyt3BJ6otsiOVXnaw2KtEbc509njhGfFF8+8lqt
	h+amRFdEa+Z/PoUAXHg1A==
Date: Mon, 11 May 2009 15:25:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Jack Steiner <steiner@sgi.com>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86: fix node_possible_map logic -v2
In-Reply-To: <4A0894A5.9000209@zytor.com>
Message-ID: <alpine.DEB.2.00.0905111509570.2234@chino.kir.corp.google.com>
References: <4A05269D.8000701@kernel.org> <4A0527CB.4020807@kernel.org> <20090511175312.GA27905@sgi.com> <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com> <4A0894A5.9000209@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, H. Peter Anvin wrote:

> > In your example of two cpus (0-1) that are remote to the system's only
> > memory and two cpus (2-3) that have affinity to that memory, it appears as
> > though the kernel is considering cpus 2-3 and the memory to be a node and
> > cpus 0-1 to be a memoryless node.
> > 
> > That's a pretty useless scenario for memoryless node support, actually,
> > unless there's a third node with memory that cpus 0-1 have a different
> > distance to.  cpus 0-1 have no memory that is local, so the "remote" memory
> > should be considered local to them.
> > 
> 
> Should it?  It seems to me that CPUs 0-1 should be antipreferentially
> scheduled, since they will have slower access to the memory than CPUs 2-3.
> Since in this case all the memory is in the same place you could argue that
> SMP distances could do the same job, which is of course true.
> 
> However, consider now:
> 
> CPU [0-1]	- no memory
> CPU [2-3]	- memory
> CPU [4-5]	- memory
> 
> Each node is equidistant, but for the memory nodes there is differences
> between their own local memory and the remote memory.
> 
> CPU [0-1] cannot be considered local in either node, since they are further
> away from the memory than either, and furthermore, unlike either of the memory
> nodes, they have no preference for memory from either of the other two nodes
> (quite on the contrary; they would probably benefit from drawing from both.)
> 

Right, there's no difference from Jack's scenario if the three nodes are 
equiadistant.  I was thinking of a topology where cpu 0-1 was closer to, 
for example, cpu 2-3's memory than cpu 4-5's.

The particular topology you're referring to should have a slit that 
describes the relative distances in each direction differently.  The pxms 
that these cpus belong to will always be local to itself, but ACPI 3.0 
allows distances for different directions between the same pxms to be 
different.

That means it's possible that cpus 0-1 above have local distance to all 
memory and cpus 2-3 (and cpus 4-5) have remote distance to all nodes other 
than itself.

numactl --hardware would show something like this:

		0	1	2
	0	10	10	10
	1	20	10	20
	2	20	20	10

which is valid according to the ACPI specification.  This is based on the 
pxms to which the cpus belong so this topology would describe all members 
of those pxms and not just memory.
