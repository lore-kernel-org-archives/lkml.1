Return-Path: <linux-kernel-owner+w=401wt.eu-S1752373AbZDWE62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbZDWE62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 00:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbZDWE6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 00:58:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710AbZDWE6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 00:58:19 -0400
Date: Wed, 22 Apr 2009 21:50:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Larry Woodman <lwoodman@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?Q?Fr=E9=A6=98=E9=A7=BBic?= Weisbecker 
	<fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, riel@redhat.com, rostedt@goodmis.org
Subject: Re: [Patch] mm tracepoints update - use case.
Message-Id: <20090422215055.5be60685.akpm@linux-foundation.org>
In-Reply-To: <20090423092933.F6E9.A69D9226@jp.fujitsu.com>
References: <1240402037.4682.3.camel@dhcp47-138.lab.bos.redhat.com>
	<1240428151.11613.46.camel@dhcp-100-19-198.bos.redhat.com>
	<20090423092933.F6E9.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009 09:48:04 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > On Wed, 2009-04-22 at 08:07 -0400, Larry Woodman wrote:
> > > On Wed, 2009-04-22 at 11:57 +0200, Ingo Molnar wrote:
> > > > * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > > > In past thread, Andrew pointed out bare page tracer isn't useful. 
> > > > 
> > > > (do you have a link to that mail?)

http://lkml.indiana.edu/hypermail/linux/kernel/0903.0/02674.html

And Larry's example use case here tends to reinforce what I said then.  Look:

: In addition I could see that the priority was decremented to zero and
: that 12342 pages had been reclaimed rather than just enough to satisfy
: the page allocation request.
: 
: -----------------------------------------------------------------------------
: # tracer: nop
: #
: #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
: #              | |       |          |         |
: <mem>-10723 [005]  6976.285610: mm_directreclaim_reclaimzone: reclaimed=12342, priority=0

and

: -----------------------------------------------------------------------------
: # tracer: nop
: #
: #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
: #              | |       |          |         |
:            <mem>-10723 [005]   282.776271: mm_pagereclaim_shrinkzone: reclaimed=12342
:            <mem>-10723 [005]   282.781209: mm_pagereclaim_shrinkzone: reclaimed=3540
:            <mem>-10723 [005]   282.801194: mm_pagereclaim_shrinkzone: reclaimed=7528
: -----------------------------------------------------------------------------

This diagnosis was successful because the "reclaimed" number was weird.
By sheer happy coincidence, page-reclaim is already generating the
aggregated numbers for us, and the tracer just prints it out.

If some other problem is being worked on and if there _isn't_ some
convenient already-present aggregated result for the tracer to print,
the problem won't be solved.  Unless a vast number of trace events are
emitted and problem-specific userspace code is written to aggregate
them into something which the developer can use.


