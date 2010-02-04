Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab0BDGdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 01:33:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55689 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab0BDGdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 01:33:53 -0500
Date: Thu, 4 Feb 2010 07:33:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC GIT PULL] perf/trace/lock optimization/scalability
 improvements
Message-ID: <20100204063306.GA12807@elte.hu>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com>
 <1265193196.24455.390.camel@laptop>
 <20100203220735.GD5068@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203220735.GD5068@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, Feb 03, 2010 at 11:33:16AM +0100, Peter Zijlstra wrote:
> > On Wed, 2010-02-03 at 10:14 +0100, Frederic Weisbecker wrote:
> > > - event injection support
> > 
> > I like the idea, I'm just not sure about the name and API details.
> >
> > I would like to call it something like collection support, and the API 
> > should have an iterator like interface.
> > 
> > That is, it should not blindly dump all events from a collection at once, 
> > praying the output buffer is large enough, but either dump a specified 
> > number and/or stop dumping when the buffer is full. Allowing a second 
> > invocation to continue where it left off after the buffer content has 
> > been consumed.
> 
> 
> Yeah I agree. But my worry is there are induced races in this scheme. But 
> probably tight enough that we don't care much.
> 
> Consider dumping the task list content:
> 
> A -> B -> C -> D
> 
> You open a "task" event. And ask to inject it one by one,
> you first dump A, and B disappear, then you'll miss it
> but you can still get C and D if they don't disappear.
> 
> As I said it is tight enough that we don't care. If B disappears
> so early, it means it won't have a determinant role in the profiling
> anyway (at worst few isolated events in the beginning).

We probably dont care - /proc is racy in the same fashion (you can miss 
tasks), still 'top' has been able to cope for a decade.

If we cared, it would be possible to construct a dump-collection-state 
sequence along the lines of:

 activate init/deinit events
 initiate dump

anything that got missed by the dump will be covered by the init/deinit event 
flow. In that sense it's important that init/deinit and dumping uses similar 
state structure - possibly the same event (as your solution did).

A 'dump' of a collection is basically the artificial replay of all its init 
events.

	Ingo
