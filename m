Return-Path: <linux-kernel-owner+w=401wt.eu-S1758166AbZEKVeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbZEKVeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbZEKVeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:34:02 -0400
Received: from relay3.sgi.com ([192.48.156.57]:48946 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754451AbZEKVeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:34:00 -0400
Date: Mon, 11 May 2009 16:33:54 -0500
From: Jack Steiner <steiner@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86: fix node_possible_map logic -v2
Message-ID: <20090511213354.GD553@sgi.com>
References: <4A05269D.8000701@kernel.org> <4A0527CB.4020807@kernel.org> <20090511175312.GA27905@sgi.com> <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 12:27:49PM -0700, David Rientjes wrote:
> On Mon, 11 May 2009, Jack Steiner wrote:
> 
> > Do we have a clear and unambiguous definition of what a node really is?
> > In this case, is a board (socket) with cpus, a unique PXM but no memory
> > considered a node. Even though it has no memory, it is a node (depending on the
> > definition of "node") for purposes such as scheduling. The memoryless node also
> > has local IO buses that want to direct interrupts to node-local cpus.
> > 
> 
> In your example of two cpus (0-1) that are remote to the system's only 
> memory and two cpus (2-3) that have affinity to that memory, it appears as 
> though the kernel is considering cpus 2-3 and the memory to be a node and 
> cpus 0-1 to be a memoryless node.

Correct.


> 
> That's a pretty useless scenario for memoryless node support, actually, 
> unless there's a third node with memory that cpus 0-1 have a different 
> distance to. 

Yes, a large number of nodes exist. Most have memory but some do not.


> cpus 0-1 have no memory that is local, so the "remote" 
> memory should be considered local to them.

The cpus without local memory will obviously have to use memory from other
nodes. But the problem seems to be more complex. 

Cpus also belong to nodes. The cpu_to_node_map[] provides the mapping.
I have not tried it, but I wonder what happens if you offline all of the
memory of a node (probably not possible so this may be hypothetical for now).
Should offlining all node memory change the node that a cpu on the node
are associated with? That does not seem right.

Does offlining all node memory clear the entry in the node_data[] array?


> 
> I don't know who has been pushing the memoryless node support, but it 
> appears as though it hasn't been fully tested yet.

Agree. FWIW, it works ok in 2.6.27. I need to bisect to find where the regression
occurred.


> The NULL pglist_data 
> here for node 0 seems appropriate since you don't need it unless you're 
> describing memory, but the kernel implies that if a bit is set in 
> node_online_map or node_possible_map that it has this associated data.

> 
> Added Andi Kleen to the cc list.
