Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbZE0JPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbZE0JPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 05:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757488AbZE0JPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 05:15:13 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:44683 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030AbZE0JPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 05:15:11 -0400
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Jamie Lokier <jamie@shareable.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20090527012243.GB29692@Krystal>
References: <20090524131636.GB3159@n2100.arm.linux.org.uk>
	 <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org>
	 <20090525151724.GA14321@Krystal>
	 <20090525161941.GA3667@n2100.arm.linux.org.uk>
	 <20090526145950.GB26713@n2100.arm.linux.org.uk>
	 <20090526153654.GA17096@Krystal>
	 <20090526155906.GC26713@n2100.arm.linux.org.uk>
	 <20090526172322.GB19443@Krystal>
	 <20090526182310.GG26713@n2100.arm.linux.org.uk>
	 <20090527012243.GB29692@Krystal>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 27 May 2009 10:14:46 +0100
Message-Id: <1243415686.1947.24.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2009 09:14:47.0853 (UTC) FILETIME=[951205D0:01C9DEAB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 21:22 -0400, Mathieu Desnoyers wrote:
> So, my questions is : is ARMv7 weak memory ordering model as weak as
> Alpha ?

I'm not familiar with Alpha but ARM allows a weakly ordered memory
system (starting with ARMv6), it's up to the processor implementer to
decide how weak but within the ARM ARM restrictions (section A3.8.2).

I think the main difference with Alpha is that ARM doesn't do
speculative writes, only speculative reads. The write cannot become
visible to other observers in the same shareability domain before the
instruction occurs in program order. But because of the write buffer,
there is no guarantee on the order of two writes becoming visible to
other observers in the same shareability domain. The reads from normal
memory can happen speculatively (with a few restrictions)

Summarising from the ARM ARM, there are two terms used:

        Address dependency - an address dependency exists when the value
        returned by a read access is used to compute the virtual address
        of a subsequent read or write access.
        
        Control dependency - a control dependency exists when the data
        value returned by a read access is used to determine the
        condition code flags, and the values of the flags are used for
        condition code checking to determine the address of a subsequent
        read access.
        
The (simplified) memory ordering restrictions of two explicit accesses
(where multiple observers are present and in the same shareability
domain):

      * If there is an address dependency then the two memory accesses
        are observed in program order by any observer
      * If the value returned by a read access is used as data written
        by a subsequent write access, then the two memory accesses are
        observed in program order
      * It is impossible for an observer of a memory location to observe
        a write access to that memory location if that location would
        not be written to in a sequential execution of a program

Outside of these restrictions, the processor implementer can do whatever
it makes the CPU faster. To ensure the relative ordering between memory
accesses (either read or write), the software should have DMB
instructions.

-- 
Catalin

