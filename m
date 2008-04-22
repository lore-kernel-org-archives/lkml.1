Return-Path: <linux-kernel-owner+w=401wt.eu-S932703AbYDVB30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbYDVB30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 21:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761600AbYDVB25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 21:28:57 -0400
Received: from relay2.sgi.com ([192.48.171.30]:43690 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756696AbYDVB2y (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 21:28:54 -0400
Date: Tue, 22 Apr 2008 11:28:19 +1000
From: David Chinner <dgc@sgi.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080422012819.GT108924158@sgi.com>
References: <20080419142329.GA5339@elte.hu> <200804210945.24479.vda.linux@googlemail.com> <480C96BC.4020400@sandeen.net> <200804212151.02241.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804212151.02241.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 09:51:02PM +0200, Denys Vlasenko wrote:
> On Monday 21 April 2008 15:29, Eric Sandeen wrote:
> > > Some number has to be picked. Why fitting in 4k is "bad" and fitting
> > > in 8k is "not bad"?
> > 
> > 
> > Because well-written code in several subsystems, used in combination in
> > common configurations, does not always fit, that is why.
> > 
> > Show me the "bug" in an nfs+xfs+md+scsi writeback stack oops
> 
> Why nfs+xfs+md+ide works?

Luck?

With 4k stacks, you really don't need NFS at all - you just have
enter memory reclaim at the wrong time (i.e. when something else
was already consuming 2/3rds of the 4k stack).

> Does scsi intrinsically require more stack than ide?

<shrug>

> Why xfs code is said to be 5 timed bigged than e.g. reiserfs?
> Does it have to be that big?

If we cut the bulkstat code out, the handle interface, the
preallocation, the journalled quota, the delayed allocation, all the
runtime validation, the shutdown code, the debug code, the tracing
code, etc, then we might get down to the same size reiser....

> Does it really have to eat lots of stack?

Writeback is done under ENOMEM pressure, and XFS can't provide the
guarantees mempools need to work. That leaves the stack as the only
place we can put the things we need. e.g. the args structures that
tell the allocator what to do and retain state between subsequent
low level allocation calls use ~250 bytes of stack just by
themselves....

We've already chopped off the low hanging fruit, added noinline to
every function definition to prevent compiler heuristics from
blowing out stack usage by 25% and reduced use of temporary
variables as much as possible. There's very little fat left to trim,
and still we can't reliably fit in 4k stacks.

Patches are welcome - I'd be over the moon if any of the known 4k
stack advocates sent a stack reduction patch for XFS, but it seems
that actually trying to fix the problems is much harder than
resending a one line patch every few months....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
