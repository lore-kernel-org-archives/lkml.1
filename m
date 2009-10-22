Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbZJVSdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbZJVSdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 14:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbZJVSc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 14:32:58 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:63336 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756485AbZJVSc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 14:32:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlQGAHZC4EpGGN1W/2dsb2JhbACBUpo2wDiEPwSBXXs
Date: Thu, 22 Oct 2009 14:32:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "David S. Miller" <davem@davemloft.net>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: sparc64 cmpxchg is not a full memory barrier anymore ?
Message-ID: <20091022183242.GA19307@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 14:24:41 up 65 days,  5:14,  3 users,  load average: 0.88, 0.33,
	0.28
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

I took a look at the current sparc64 cmpxchg implementation in the Linux
kernel and stumbled on this commit:

commit 293666b7a17cb7a389fc274980439212386a19c4
Author: David S. Miller <davem@davemloft.net>
Date:   Sat Nov 15 13:33:25 2008 -0800

    sparc64: Stop using memory barriers for atomics and locks.
    
    The kernel always executes in the TSO memory model now,
    so none of this stuff is necessary any more.
    
    With helpful feedback from Nick Piggin.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

Reading p. 152 A.9 Compare and Swap, I see that the cas instruction does
not imply a memory barrier.

Reading http://docs.sun.com/app/docs/doc/801-6678/6i11oelck?a=view

I see that:

"TSO guarantees that the store, FLUSH, and atomic load-store
instructions of all processors appear to be executed by memory serially
in a single order called the memory order. Furthermore, the sequence of
store, FLUSH, and atomic load-store instructions in the memory order for
a given processor is identical to the sequence in which they were issued
by the processor."

So it provides no guarantee whatsoever wrt loads. However, reading
Documentation/memory-barriers.txt:

"Whilst they are technically interprocessor interaction considerations,
atomic operations are noted specially as some of them imply full memory
barriers and some don't, but they're very heavily relied on as a group
throughout the kernel." -> cmpxchg is part of them.

The same applies to the other atomic instructions we find in this list.
How is the correct ordering of loads wrt to cmxchg (and other atomic
ops) still ensured by this modification?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
