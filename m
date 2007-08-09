Return-Path: <linux-kernel-owner+w=401wt.eu-S938791AbXHIQmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938791AbXHIQmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 12:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933626AbXHIQml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 12:42:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933522AbXHIQmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 12:42:39 -0400
Message-ID: <46BB4281.7010803@redhat.com>
Date: Thu, 09 Aug 2007 12:36:17 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de, heiko.carstens@de.ibm.com,
       davem@davemloft.net, schwidefsky@de.ibm.com, wensong@linux-vs.org,
       horms@verge.net.au, wjiang@resilience.com, cfriesen@nortel.com,
       zlynx@acm.org, rpjday@mindspring.com, jesper.juhl@gmail.com
Subject: Re: [PATCH 1/24] make atomic_read() behave consistently on alpha
References: <20070809132442.GA13042@shell.boston.redhat.com> <20070809143255.GA8424@linux.vnet.ibm.com> <46BB2A5A.5090006@redhat.com> <20070809150445.GB8424@linux.vnet.ibm.com> <46BB31A6.4080507@redhat.com> <20070809161024.GC8424@linux.vnet.ibm.com>
In-Reply-To: <20070809161024.GC8424@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> The compiler is within its rights to read a 32-bit quantity 16 bits at
> at time, even on a 32-bit machine.  I would be glad to help pummel any
> compiler writer that pulls such a dirty trick, but the C standard really
> does permit this.

Yes, but we don't write code for these compilers.  There are countless pieces of 
kernel code which would break in this condition, and there doesn't seem to be 
any interest in fixing this.

> Use of volatile does in fact save you from the compiler pushing stores out
> of loops regardless of whether you are also doing reads.  The C standard
> has the notion of sequence points, which occur at various places including
> the ends of statements and the control expressions for "if" and "while"
> statements.  The compiler is not permitted to move volatile references
> across a sequence point.  Therefore, the compiler is not allowed to
> push a volatile store out of a loop.  Now the CPU might well do such a
> reordering, but that is a separate issue to be dealt with via memory
> barriers.  Note that it is the CPU and I/O system, not the compiler,
> that is forcing you to use reads to flush writes to MMIO registers.

Sequence points enforce read-after-write ordering, not write-after-write.  We 
flush writes with reads for MMIO because of this effect as well as the CPU/bus 
effects.

> And you would be amazed at what compiler writers will do in order to
> get an additional fraction of a percent out of SpecCPU...

Probably not :)

> In short, please retain atomic_set()'s volatility, especially on those
> architectures that declared the atomic_t's counter to be volatile.

Like i386 and x86_64?  These used to have volatile in the atomic_t declaration. 
  We removed it, and the sky did not fall.

	-- Chris
