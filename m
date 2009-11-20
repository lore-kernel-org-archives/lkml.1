Return-Path: <linux-kernel-owner+w=401wt.eu-S1757016AbZKTBB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbZKTBB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 20:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756718AbZKTBB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 20:01:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756831AbZKTBB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 20:01:27 -0500
Date: Thu, 19 Nov 2009 16:59:37 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: Jeff Law <law@redhat.com>, rostedt@goodmis.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       David Daney <ddaney@caviumnetworks.com>, Andrew Haley <aph@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, feng.tang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, jakub@redhat.com,
       gcc@gcc.gnu.org
Subject: Re: BUG: GCC-4.4.x changes the function frame on some functions
In-Reply-To: <alpine.LFD.2.00.0911200122190.24119@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0911191652430.2793@localhost.localdomain>
References: <viy9pk4xossnb6m2v041qu00.1258665258503@email.android.com>   <4B05B7AD.20500@redhat.com> <1258670580.22249.1002.camel@gandalf.stny.rr.com> <4B05DBBF.5000804@redhat.com> <alpine.LFD.2.00.0911200122190.24119@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 20 Nov 2009, Thomas Gleixner wrote:
> 
> While testing various kernel configs we found out that the problem
> comes and goes. Finally I started to compare the gcc command line
> options and after some fiddling it turned out that the following
> minimal deltas change the code generator behaviour:
> 
> Bad:  -march=pentium-mmx                -Wa,-mtune=generic32
> Good: -march=i686        -mtune=generic -Wa,-mtune=generic32
> Good: -march=pentium-mmx -mtune-generic -Wa,-mtune=generic32
> 
> I'm not supposed to understand the logic behind that, right ?

Are you sure it's just the compiler flags?

There's another configuration portion: the size of the alignment itself. 
That's dependent on L1_CACHE_SHIFT, which in turn is taken from the kernel 
config CONFIG_X86_L1_CACHE_SHIFT.

Maybe that value matters too - for example maybe gcc will not try to align 
the stack if it's big?

[ Btw, looking at that, why are X86_L1_CACHE_BYTES and X86_L1_CACHE_SHIFT 
  totally unrelated numbers? Very confusing. ]

The compiler flags we use are tied to some of the same choices that choose 
the cache shift, so the correlation you found while debugging this would 
still hold.

			Linus

