Return-Path: <linux-kernel-owner+w=401wt.eu-S1759634AbZEKVVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634AbZEKVVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbZEKVUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:20:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46218 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbZEKVUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:20:55 -0400
Message-ID: <4A0894A5.9000209@zytor.com>
Date: Mon, 11 May 2009 14:12:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Jack Steiner <steiner@sgi.com>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] x86: fix node_possible_map logic -v2
References: <4A05269D.8000701@kernel.org> <4A0527CB.4020807@kernel.org> <20090511175312.GA27905@sgi.com> <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0905111218520.23739@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> 
> In your example of two cpus (0-1) that are remote to the system's only 
> memory and two cpus (2-3) that have affinity to that memory, it appears as 
> though the kernel is considering cpus 2-3 and the memory to be a node and 
> cpus 0-1 to be a memoryless node.
> 
> That's a pretty useless scenario for memoryless node support, actually, 
> unless there's a third node with memory that cpus 0-1 have a different 
> distance to.  cpus 0-1 have no memory that is local, so the "remote" 
> memory should be considered local to them.
> 

Should it?  It seems to me that CPUs 0-1 should be antipreferentially 
scheduled, since they will have slower access to the memory than CPUs 
2-3.  Since in this case all the memory is in the same place you could 
argue that SMP distances could do the same job, which is of course true.

However, consider now:

CPU [0-1]	- no memory
CPU [2-3]	- memory
CPU [4-5]	- memory

Each node is equidistant, but for the memory nodes there is differences 
between their own local memory and the remote memory.

CPU [0-1] cannot be considered local in either node, since they are 
further away from the memory than either, and furthermore, unlike either 
of the memory nodes, they have no preference for memory from either of 
the other two nodes (quite on the contrary; they would probably benefit 
from drawing from both.)

 > I don't know who has been pushing the memoryless node support, but it
 > appears as though it hasn't been fully tested yet.  The NULL
 > pglist_data here for node 0 seems appropriate since you don't need it
 > unless you're describing memory, but the kernel implies that if a bit
 > is set in node_online_map or node_possible_map that it has this
 > associated data.

No doubt there is still bugs.

	-hpa
