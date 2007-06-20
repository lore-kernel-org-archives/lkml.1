Return-Path: <linux-kernel-owner+w=401wt.eu-S1758999AbXFTS2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999AbXFTS2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbXFTS2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:28:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56132 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754420AbXFTS2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:28:22 -0400
Date: Wed, 20 Jun 2007 11:28:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, tim.c.chen@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: Change in default vm_dirty_ratio
In-Reply-To: <1182363174.2701.2.camel@laptopd505.fenrus.org>
Message-ID: <alpine.LFD.0.98.0706201119410.3593@woody.linux-foundation.org>
References: <1182201271.4883.22.camel@localhost.localdomain> 
 <20070618164711.9de1c38e.akpm@linux-foundation.org>  <20070620042434.GC12096@redhat.com>
  <20070619214407.dfff0ca6.akpm@linux-foundation.org>  <1182328536.21117.24.camel@twins>
  <alpine.LFD.0.98.0706201015370.3593@woody.linux-foundation.org>
 <1182363174.2701.2.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Jun 2007, Arjan van de Ven wrote:
> 
> maybe that needs to be fixed? If you stopped dirtying after the initial
> bump.. is there a reason for the kernel to dump all that data to the
> disk in such a way that it disturbs interactive users?

No. I would argue that the kernel should try to trickle things out, so 
that it doesn't disturb anything, and a "big dump" becomes a "steady 
trickle".

And that's what "vm_dirty_ratio" is all about.

> so the question maybe is.. is the vm tunable the cause or the symptom of
> the bad experience?

No, the vm tunable is exactly what it's all about.

Do a big "untar", and what you *want* to see is not "instant dump, 
followed by long pause". 

A much *smoother* behaviour is generally preferable, and most of the time 
that's true even if it may be lower throughput in the end!

Of course, "synchronous writes" are *really* smooth (you never allow any 
dumps at *all* to build up), so this is about a balance - not about 
"perfect smoothness" vs "best throughput", but about a heuristic that 
finds a reasonable middle ground.

There is no "perfect". There is only "stupid heuristics". Maybe the 
"vm_dirty_ratio" is a bit *too* stupid, but it definitely is needed in 
some form.

It can actually be more than just a "performance" vs "smoothness" issue: 
the 40% thing was actually a *correctness* issue too, back when we coutned 
it as a percentage of total memory. A highmem machine would allow 40% of 
all memory free and it was all in low memory, and that literally caused 
lockups.

So the dirty_ratio is not *only* about smoothness, it's also simply about 
the fact that the kernel must not allow too much memory to be dirtied, 
because that leads to out-of-memory deadlocks and other nasty issues. So 
it's not *purely* a tunable. 

		Linus
