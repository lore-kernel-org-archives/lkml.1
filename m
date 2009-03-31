Return-Path: <linux-kernel-owner+w=401wt.eu-S1762377AbZCaGNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762377AbZCaGNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbZCaGNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:13:10 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:36868 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757922AbZCaGNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:13:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18897.46177.528910.51044@cargo.ozlabs.ibm.com>
Date: Tue, 31 Mar 2009 17:12:49 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] perf_counter: provide generic callchain bits
In-Reply-To: <20090330171024.254266860@chello.nl>
References: <20090330170701.856843742@chello.nl>
	<20090330171024.254266860@chello.nl>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

>  				include_tid    :  1, /* include the tid       */
>  				mmap           :  1, /* include mmap data     */
>  				munmap         :  1, /* include munmap data   */
> +				callchain      :  1, /* add callchain data    */

Interesting, I would have put callchain (and include_tid, also) in
hw_event.record_type rather than as individual 1-bit fields.  The
present arrangement where some selection of what goes into the ring
buffer is in record_type and some is in individual bits seems a bit
awkward.  Plus, with the current arrangement I can't get both the IP
and the values of the other group members, which I might reasonable
want.

I think either we make record_type bit-significant, or we define
individual bits in hw_event for recording the IP and other group
members.

There are a couple of other things I want to be able to record on an
event - we have registers on powerpc that give information about the
event that caused the interrupt, and it would be nice to be able to
record them.  (These registers include instruction and data addresses
associated with the event; the instruction address can be further on
from where the interrupt was taken because of out-of-order instruction
execution and because interrupts might be hard-disabled at the point
where the interrupt becomes pending.)

Those registers would need bits in record_type or in the hw_event to
indicate that we want them recorded.

Paul.
