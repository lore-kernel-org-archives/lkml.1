Return-Path: <linux-kernel-owner+w=401wt.eu-S1763499AbZCYQSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763499AbZCYQSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 12:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbZCYQSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 12:18:25 -0400
Received: from waste.org ([66.93.16.53]:35542 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbZCYQSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 12:18:23 -0400
Subject: Re: [PATCH 2/5] mm: remove unlikly NULL from kfree
From: Matt Mackall <mpm@selenic.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Hua Zhong <hzhong@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <alpine.DEB.2.00.0903251105030.5675@gandalf.stny.rr.com>
References: <20090325051920.406564281@goodmis.org>
	 <20090325052023.071564146@goodmis.org>
	 <84144f020903250034j24e1782bt5f73809b9349346c@mail.gmail.com>
	 <009101c9ad20$1ae231c0$50a69540$@com>
	 <1237968394.30175.12.camel@penberg-laptop>
	 <84144f020903250651o13c723cgf64643091459a5ac@mail.gmail.com>
	 <alpine.DEB.2.00.0903251039590.5675@gandalf.stny.rr.com>
	 <1237993145.30175.34.camel@penberg-laptop>
	 <alpine.DEB.2.00.0903251103070.5675@gandalf.stny.rr.com>
	 <alpine.DEB.2.00.0903251105030.5675@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 11:14:18 -0500
Message-Id: <1237997658.2132.193.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 11:08 -0400, Steven Rostedt wrote:
> On Wed, 25 Mar 2009, Steven Rostedt wrote:
> 
> > 
> > On Wed, 25 Mar 2009, Pekka Enberg wrote:
> > 
> > > Hi Steven,
> > > 
> > > On Wed, 25 Mar 2009, Pekka Enberg wrote:
> > > > > OK, so according to Steven, audit_syscall_exit() is one such call-site
> > > > > that shows up in the traces. I don't really understand what's going on
> > > > > there but if it is sane, maybe that warrants the removal of unlikely()
> > > > > from kfree(). Hmm?
> > > 
> > > On Wed, 2009-03-25 at 10:47 -0400, Steven Rostedt wrote:
> > > > After disabling AUDIT_SYSCALLS I have this:
> > > > 
> > > >  # cat /debug/tracing/trace | sort -u
> > > > 
> > > > record_nulls: ptr=(null) (ext3_get_acl+0x1e0/0x3f0 [ext3])
> > > > record_nulls: ptr=(null) (free_bitmap+0x29/0x70)
> > > > record_nulls: ptr=(null) (free_tty_struct+0x1d/0x40)
> > > > record_nulls: ptr=(null) (ftrace_graph_exit_task+0x1e/0x20)
> > > > record_nulls: ptr=(null) (inet_sock_destruct+0x1cb/0x2a0)
> > > > record_nulls: ptr=(null) (ip_cork_release+0x24/0x50)
> > > > record_nulls: ptr=(null) (keyctl_join_session_keyring+0x5a/0x70)
> > > > record_nulls: ptr=(null) (key_user_lookup+0x183/0x220)
> > > > record_nulls: ptr=(null) (kobject_set_name_vargs+0x43/0x50)
> > > > record_nulls: ptr=(null) (netlink_release+0x1a4/0x2f0)
> > > > record_nulls: ptr=(null) (release_sysfs_dirent+0x20/0xc0)
> > > > record_nulls: ptr=(null) (sysfs_open_file+0x1c8/0x3e0)
> > > > record_nulls: ptr=(null) (tty_write+0x16a/0x290)
> > > > 
> > > > I added a hook to only record when NULL is passed into kfree.
> > > > 
> > > > Also note, that after disabling AUDIT_SYSCALLS I now only have roughly 7% 
> > > > NULL hit rate. Still, unlikely is probably not a benefit here.
> > > 
> > > Thanks for doing this. Do you mean that 93% hit ratio is not enough to
> > > be a performance gain?
> > 
> > I think it was Christoph Lameter (good you Cc'd him) told me that anything 
> > less that 99% is not worthy of a (un)likely macro.
> > 
> > I honestly don't know.
> 
> I think the theory is that gcc and the CPU can handle normal branch 
> predictions well. But if you use one of the prediction macros, gcc 
> (and some archs) behaves differently, such that taking the wrong branch 
> can cost more than the time saved with all the other correct hits.
> 
> Again, I'm not sure. I haven't done the bench marks. Perhaps someone else 
> is more apt at knowing the details here.

>From first principles, we can make a reasonable model of branch
prediction success with a branch cache:

               hot cache     cold cache  cold cache  cold cache 
               w|w/o hint                good hint   bad hint
p near 0       +             +           +           -
p near .5      0             0           0           0
p near 1       +             -           +           -

(this assumes the CPU is biased against branching in the cold cache
case)

Branch prediction miss has a penalty measured in some smallish number of
cycles. So the impact in cycles/sec[1] is (p(miss) * penalty) * (calls /
sec). Because the branch cache kicks in and hides our unlikely hint with
a hot cache, we can't get a high calls/sec, so to have much impact,
we've got to have a very high probably of a missed branch (p near 1)
_and_ cold cache. 

So for CPUs with a branch cache, unlikely hints only make sense in
fairly extreme cases. And I think that includes most CPU families these
days as it's pretty much required to get much advantage from making the
CPU clock faster than the memory bus. 

We'd have a lot of trouble benchmarking this meaningfully as hot caches
kill the effect. And it would of course depend directly on a given CPU's
branch cache size and branch miss penalty, numbers that vary from model
to model. So I think unless we can confidently state that a branch is
rarely taken, there's very little upside to adding unlikely.

On the other hand, there's also very little downside until our hint is
grossly inaccurate. So there's a huge hysteresis here: if p is < .99,
not much point adding unlikely. If p is > .1, not much point removing
it.

[1] Note that cycles/sec is dimensionless as cycles and seconds are both
measures of time. So impact here is in units of very small fractions of
a percent.
-- 
http://selenic.com : development and support for Mercurial and Linux


