Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbZKTB3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbZKTB3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 20:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbZKTB3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 20:29:44 -0500
Received: from www.tglx.de ([62.245.132.106]:40509 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbZKTB3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 20:29:43 -0500
Date: Fri, 20 Nov 2009 02:27:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
In-Reply-To: <alpine.LFD.2.00.0911191652430.2793@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0911200206570.24119@localhost.localdomain>
References: <viy9pk4xossnb6m2v041qu00.1258665258503@email.android.com>   <4B05B7AD.20500@redhat.com> <1258670580.22249.1002.camel@gandalf.stny.rr.com> <4B05DBBF.5000804@redhat.com> <alpine.LFD.2.00.0911200122190.24119@localhost.localdomain>
 <alpine.LFD.2.00.0911191652430.2793@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009, Linus Torvalds wrote:
> On Fri, 20 Nov 2009, Thomas Gleixner wrote:
> > 
> > While testing various kernel configs we found out that the problem
> > comes and goes. Finally I started to compare the gcc command line
> > options and after some fiddling it turned out that the following
> > minimal deltas change the code generator behaviour:
> > 
> > Bad:  -march=pentium-mmx                -Wa,-mtune=generic32
> > Good: -march=i686        -mtune=generic -Wa,-mtune=generic32
> > Good: -march=pentium-mmx -mtune-generic -Wa,-mtune=generic32
> > 
> > I'm not supposed to understand the logic behind that, right ?
> 
> Are you sure it's just the compiler flags?

I first captured the command line with V=1 and created a script of
it. Then I changed the -march -mtune options in that script and
compiled just that single file manually w/o changing .config or
invoking the kernel make magic.

The good ones produce:

650:   55                      push   %ebp
651:   89 e5                   mov    %esp,%ebp
653:   83 e4 f0                and    $0xfffffff0,%esp

The bad one:

000005f0 <timer_stats_update_stats>:
 5f0:   57                      push   %edi
 5f1:   8d 7c 24 08             lea    0x8(%esp),%edi
 5f5:   83 e4 f0                and    $0xfffffff0,%esp
 5f8:   ff 77 fc                pushl  -0x4(%edi)
 5fb:   55                      push   %ebp
 5fc:   89 e5                   mov    %esp,%ebp
 
> There's another configuration portion: the size of the alignment itself. 
> That's dependent on L1_CACHE_SHIFT, which in turn is taken from the kernel 
> config CONFIG_X86_L1_CACHE_SHIFT.
> 
> Maybe that value matters too - for example maybe gcc will not try to align 
> the stack if it's big?

That does not change any of the compiler options, but yes it could
have some effect via the various include magics, but all I have seen
so far is linkage.h which should not affect the compiler. And the
manual compile did not change any of this.
 
> [ Btw, looking at that, why are X86_L1_CACHE_BYTES and X86_L1_CACHE_SHIFT 
>   totally unrelated numbers? Very confusing. ]

Agreed.

> The compiler flags we use are tied to some of the same choices that choose 
> the cache shift, so the correlation you found while debugging this would 
> still hold.

Digging further tomorrow when my brain is more awake.

Thanks,

	tglx
