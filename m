Return-Path: <linux-kernel-owner+w=401wt.eu-S1751910AbZCIM5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbZCIM5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 08:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZCIM5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 08:57:14 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:53674 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZCIM5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 08:57:13 -0400
Date: Mon, 9 Mar 2009 12:56:57 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [TIP,BISECTED] Negative nice values have become big positive numbers
Message-ID: <20090309125657.GA20369@silver.sucs.org>
References: <20090308231850.GB24445@silver.sucs.org> <alpine.DEB.2.00.0903081944470.2203@gandalf.stny.rr.com> <20090309070824.GA9516@elte.hu> <20090309084132.GA5914@nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090309084132.GA5914@nowhere>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 09:41:34AM +0100, Frederic Weisbecker wrote:
> On Mon, Mar 09, 2009 at 08:08:24AM +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > On Sun, 8 Mar 2009, Sitsofe Wheeler wrote:
> > > > Formally negative nice values have started become very big in positive
> > > > integers in -tip kernels:
> > > > 
> > > >     2 root      15 2147483647     0    0    0 S  0.0  0.0   0:00.00 kthreadd    
> > > 
> > > Is this the output of top?
> > 
> > seems so.
> > 
> > > > I've just finished bisecting down to this commit:
> > > > 
> > > > commit 1427cdf0592368bdec57276edaf714040ee8744f
> > > 
> > > I find it hard to believe that this would cause normal nice 
> > > values to be messed up. The only file that could could come 
> > > close to messing with nice values in top is ftrace.h:
> > 
> > Correct - maybe it's these two nearby commits that cause the 
> > problems:
> > 
> >  fef20d9: vsprintf: unify the format decoding layer for its 3 users
> >  4370aa4: vsprintf: add binary printf
> > 
> > they do affect generic code. If we broke vsnprintf (which the 
> > nice value output code uses) then that might be a plausible 
> > explanation.

OK I've just rebisected (and reverted) this down to the following:

commit fef20d9c1380f04ba9492d6463148db07b413708
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Fri Mar 6 17:21:50 2009 +0100

    vsprintf: unify the format decoding layer for its 3 users

    An new optimization is making its way to ftrace. Its purpose is to
    make trace_printk() consuming less memory and be faster.

    Written by Lai Jiangshan, the approach is to delay the formatting
    job from tracing time to output time.

    Currently, a call to trace_printk() will format the whole string and
    insert it into the ring buffer. Then you can read it on /debug/tracing/trace
    file.

    The new implementation stores the address of the format string and
    the binary parameters into the ring buffer, making the packet more compact
    and faster to insert.
    Later, when the user exports the traces, the format string is retrieved
    with the binary parameters and the formatting job is eventually done.

    The new implementation rewrites a lot of format decoding bits from
    vsnprintf() function, making now 3 differents functions to maintain
    in their duplicated parts of printf format decoding bits.

    Suggested by Ingo Molnar, this patch tries to factorize the most
    possible common bits from these functions.
    The real common part between them is the format decoding. Although
    they do somewhat similar jobs, their way to export or import the parameters
    is very different. Thus, only the decoding layer is extracted, unless you see
    other parts that could be worth factorized.

    Changes in V2:

    - Address a suggestion from Linus to group the format_decode() parameters inside
      a structure.

    Changes in v3:

    - Address other cleanups suggested by Ingo and Linus such as passing the
      printf_spec struct to the format helpers: pointer()/number()/string()
      Note that this struct is passed by copy and not by address. This is to
      avoid side effects because these functions often change these values and the
      changes shoudn't be persistant when a callee helper returns.
      It would be too risky. 

    - Various cleanups (code alignement, switch/case instead of if/else fountains).

    - Fix a bug that printed the first format specifier following a %p

    Changes in v4:

    - drop unapropriate const qualifier loss while casting fmt to a char *
      (thanks to Vegard Nossum for having pointed this out).

    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Acked-by: Steven Rostedt <rostedt@goodmis.org>
    LKML-Reference: <1236356510-8381-6-git-send-email-fweisbec@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

Here's the new bisect log:
# bad: [546e5354a6e4ec760ac03ef1148e9a4762abb5f5] Merge branch 'core/printk' into tracing/ftrace
# good: [78ff7fae04554b49d29226ed12536268c2500d1f] x86: implement atomic text_poke() via fixmap
git bisect start '546e5354a6e4ec760ac03ef1148e9a4762abb5f5' '78ff7fae04554b49d29226ed12536268c2500d1f'
# good: [16097439703bcd38e9fe5608c12add6dacb825ea] Merge branches 'tracing/ftrace' and 'tracing/function-graph-tracer' into tracing/core
git bisect good 16097439703bcd38e9fe5608c12add6dacb825ea
# good: [4370aa4aa75391a5e2e06bccb0919109f725ed8e] vsprintf: add binary printf
git bisect good 4370aa4aa75391a5e2e06bccb0919109f725ed8e
# good: [bc722f508a5bcbb65a7bb0c7ce8e3934f5763a1a] Merge branch 'tip/tracing/ftrace' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace into tracing/ftrace
git bisect good bc722f508a5bcbb65a7bb0c7ce8e3934f5763a1a
# bad: [fef20d9c1380f04ba9492d6463148db07b413708] vsprintf: unify the format decoding layer for its 3 users
git bisect bad fef20d9c1380f04ba9492d6463148db07b413708

Apologies for getting it wrong the first time round (I did say I hadn't
actually reverted the commit though ;)... The problem is that doing
blind bisection actually takes a large amount of time along with plenty
of reboots (additionally the makefile changed enough that oldconfig need
to have prompts answered in many cases) and I was trying to go as fast
as possible (I found the problem late in the evening and wanted to send
something before I fell asleep). Is there an IRC channel people testing
-tip hang out in? I tried #fedora-devel and #fedora-kernel but most of
the folks there were asleep or not testing -tip kernels.

-- 
Sitsofe | http://sucs.org/~sits/
