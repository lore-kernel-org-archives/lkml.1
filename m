Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbYKQWxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbYKQWxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 17:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYKQWxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 17:53:43 -0500
Received: from ozlabs.org ([203.10.76.45]:37153 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbYKQWxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:53:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18721.62958.479215.822513@cargo.ozlabs.ibm.com>
Date: Tue, 18 Nov 2008 09:53:34 +1100
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large stack usage in fs code (especially for PPC64)
In-Reply-To: <alpine.LFD.2.00.0811171300410.18283@nehalem.linux-foundation.org>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com>
	<alpine.LFD.2.00.0811171300410.18283@nehalem.linux-foundation.org>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> The ppc people run databases, and they don't care about sane people 

And HPC apps, and all sorts of other things...

> telling them the big pages suck. It's made worse by the fact that they 
> also have horribly bad TLB fills on their broken CPU's, and years and 

Taking page faults at a 4k granularity also sucks.  A lot of the
performance improvement from using 64k pages comes just from executing
the page fault path (and other paths in the mm code) less frequently.
That's why we see a performance improvement from 64k pages even on
machines that don't support 64k pages in hardware (like the 21%
reduction in system time on a kernel compile that I reported earlier).
That has nothing to do with TLB miss times or anything to do with the
MMU.

I'd love to be able to use a 4k base page size if I could still get
the reduction in page faults and the expanded TLB reach that we get
now with 64k pages.  If we could allocate the page cache for large
files with order-4 allocations wherever possible that would be a good
start.  I think Christoph Lameter had some patches in that direction
but they didn't seem to get very far.

> years of telling people that the MMU on ppc's are sh*t has only been 
> reacted to with "talk to the hand, we know better".

Well, it's been reacted to with "AIX can use small pages where it
makes sense, and large pages where that makes sense, so why can't
Linux?"

> I suspect the PPC people need to figure out some way to handle this in 
> their broken setups (since I don't really expect them to finally admit 
> that they were full of sh*t with their big pages), but since I think it's 
> a ppc bug, I'm not at all interested in a fix that penalizes the _good_ 
> case.

Looks like we should make the stack a bit larger.

Paul.
