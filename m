Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbYJAGCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbYJAGCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 02:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYJAGBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 02:01:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35285 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbYJAGBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 02:01:55 -0400
Date: Wed, 1 Oct 2008 08:01:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Pekka Paalanen <pq@iki.fi>, Frederic Weisbecker <fweisbec@gmail.com>,
       Martin Bligh <mbligh@google.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/2] ring_buffer: implement new locking
Message-ID: <20081001060126.GB25703@elte.hu>
References: <20081001042951.412019606@goodmis.org> <20081001043908.306306212@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001043908.306306212@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> The old "lock always" scheme had issues with lockdep, and was not very 
> efficient anyways.
> 
> This patch does a new design to be partially lockless on writes. 
> Writes will add new entries to the per cpu pages by simply disabling 
> interrupts. When a write needs to go to another page than it will grab 
> the lock.
> 
> A new "read page" has been added so that the reader can pull out a 
> page from the ring buffer to read without worrying about the writer 
> writing over it. This allows us to not take the lock for all reads. 
> The lock is now only taken when a read needs to go to a new page.
> 
> This is far from lockless, and interrupts still need to be disabled, 
> but it is a step towards a more lockless solution, and it also solves 
> a lot of the issues that were noticed by the first conversion of 
> ftrace to the ring buffers.
> 
> Note: the ring_buffer_{un}lock API has been removed.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  include/linux/ring_buffer.h |    3 
>  kernel/trace/ring_buffer.c  |  298 +++++++++++++++++++++++++-------------------
>  kernel/trace/trace.c        |  113 +++++++++++-----
>  3 files changed, 247 insertions(+), 167 deletions(-)

applied to tip/tracing/ring-buffer, thanks Steve!

the simplification factor is significant as well - both in linecount and 
in locking complexity. A robust tracer almost never wants to impose 
heavy locking semantics - a good way to disable/enable it on a per CPU 
basis is more than enough to 'freeze' the trace and get it out to the 
user.

Perhaps, before we free trace buffers, we should do an RCU sync to make 
sure no access can linger? Right now we dont seem to free buffers 
anywhere.

	Ingo
