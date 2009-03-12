Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbZCLCrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbZCLCrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbZCLCrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:47:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbZCLCri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:47:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
	Breakpoint interfaces
In-Reply-To: Ingo Molnar's message of  Tuesday, 10 March 2009 15:09:50 +0100 <20090310140950.GD3850@elte.hu>
References: <20090305043440.189041194@linux.vnet.ibm.com>
	<20090305043801.GC17747@in.ibm.com>
	<20090310140950.GD3850@elte.hu>
X-Zippy-Says: ..  he dominates the DECADENT SUBWAY SCENE.
Message-Id: <20090312024617.3F392FC3B6@magilla.sf.frob.com>
Date: Wed, 11 Mar 2009 19:46:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps it would help if asm-generic/hw_breakpoint.h had some kerneldoc
comments for the arch-specific functions that the arch's asm/hw_breakpoint.h
must define (in the style of asm-generic/syscall.h).  I note that Ingo
didn't have any comments about asm-generic/hw_breakpoint.h in his review.
Its purpose should be to make any arch maintainer understand why the API it
specifies for each arch to meet makes sense across the arch's.

> why this redirection, why dont just use the structure as-is? If 
> there's any arch weirdness then that arch should have 
> arch-special accessors - not the generic code.

The fields of arch_hw_breakpoint are arch-specific.  Another arch's
struct will not have .type and .len fields at all.  e.g., on powerpc
there is just one size supported, so hw_breakpoint_get_len() would be an
inline returning a constant.  Its type is encoded in low bits of the
address word, and the arch implementation may not want to use bit-field
called .type for that (and if it did, it couldn't use a bit-field called
.address with the meaning you'd want it to have).  

Having any fields in arch_hw_breakpoint at all be part of the API
restricts the arch implementation unreasonably.  So it has accessors to
fetch them instead.  (Arguably we could punt those accessors from the
API for hw_breakpoint users, but the arch-independent part of the
hw_breakpoint implementation might still want them, I'm not sure.)
Likewise, they need to be filled in by setters or by explicit type/len
arguments to the registration calls.  This appears to be a tenet we
worked out the first time around that has gotten lost in the shuffle
more recently.

I think it would be illustrative to have a second arch implementation to
compare to the x86 one.  Ingo has a tendency to pretend everything is an
x86 until shown the concrete evidence.  The obvious choice is powerpc.
Its facility is very simple, so the arch-specific part of the
implementation should be trivial--it's the "base case" of simplest
available hw_breakpoint arch, really.  Also, it happens that Prasad's
employer is interested in having that support.

For example, a sensible powerpc implementation would clearly demonstrate
why you need accessors or at least either pre-registration setters or
explicit type/len arguments in registration calls.


Thanks,
Roland
