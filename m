Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbZGHSge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbZGHSge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 14:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbZGHSg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 14:36:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:36106 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbZGHSg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 14:36:26 -0400
Subject: Re: [PATCH 1/3] Increase lockdep limits: MAX_STACK_TRACE_ENTRIES
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dave Jones <davej@redhat.com>
Cc: Joao Correia <joaomiguelcorreia@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <20090708172248.GB2521@redhat.com>
References: <a5d9929e0907070825j1dda6584t93196e2730dedc5c@mail.gmail.com>
	 <1246980836.9777.5.camel@twins>
	 <a5d9929e0907070838q7ed3306du3bb7880e47d7207b@mail.gmail.com>
	 <1246981444.9777.11.camel@twins>
	 <a5d9929e0907070850v72cd4da4y1cbbb10fddebd575@mail.gmail.com>
	 <1246982101.9777.15.camel@twins>  <20090708172248.GB2521@redhat.com>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:36:04 +0200
Message-Id: <1247078164.16156.18.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 13:22 -0400, Dave Jones wrote:
> On Tue, Jul 07, 2009 at 05:55:01PM +0200, Peter Zijlstra wrote:
>  > On Tue, 2009-07-07 at 16:50 +0100, Joao Correia wrote:
>  > 
>  > > >> Yes. Anything 2.6.31 forward triggers this immediatly during init
>  > > >> process, at random places.
>  > > >
>  > > > Not on my machines it doesn't.. so I suspect its something weird in
>  > > > your .config or maybe due to some hardware you have that I don't that
>  > > > triggers different drivers or somesuch.
>  > > 
>  > > I am not the only one reporting this, and it happens, for example,
>  > > with a stock .config from a Fedora 11 install.
>  > > 
>  > > It may, of course, be a funny driver interaction yes, but other than
>  > > stripping the box piece by piece, how would one go about debugging
>  > > this otherwise?
>  > 
>  > One thing to do is stare (or share) at the output
>  > of /proc/lockdep_chains and see if there's some particularly large
>  > chains in there, or many of the same name or something.
> 
> I don't see any long chains, just lots of them.
> 29065 lines on my box that's hitting MAX_STACK_TRACE_ENTRIES 
> 
>  > /proc/lockdep_stats might also be interesting, mine reads like:
>  
>  lock-classes:                         1518 [max: 8191]
>  direct dependencies:                  7142 [max: 16384]

Since we have 7 states per class, and can take one trace per state, and
also take one trace per dependency, this would yield a max of:

  7*1518+7142 = 17768 stack traces

With the current limit of 262144 stack-trace entries, that would leave
us with and avg depth of:

  262144/17768 = 14.75

Now since we would not use all states for each class, we'd likely have a
little more, but that would still suggest we have rather deep stack
traces on avg.

Looking at a lockdep dump hch gave me I can see that that is certainly
possible, I see tons of very deep callchains.

/me wonders if we're getting significantly deeper..

OK I guess we can raise this one, does doubling work? That would get us
around 29 entries per trace..

Also, Dave do these distro init scrips still load every module on the
planet or are we more sensible these days?

module load/unload cycles are really bad for lockdep resources.

--

As a side node, I see that each and every trace ends with a -1 entry:

...
[ 1194.412158]    [<c01f7990>] do_mount+0x3c0/0x7c0
[ 1194.412158]    [<c01f7e14>] sys_mount+0x84/0xb0
[ 1194.412158]    [<c01221b1>] syscall_call+0x7/0xb
[ 1194.412158]    [<ffffffff>] 0xffffffff

Which seems to come from:

void save_stack_trace(struct stack_trace *trace)
{
        dump_trace(current, NULL, NULL, 0, &save_stack_ops, trace);
        if (trace->nr_entries < trace->max_entries)
                trace->entries[trace->nr_entries++] = ULONG_MAX;
}
EXPORT_SYMBOL_GPL(save_stack_trace);

commit 006e84ee3a54e393ec6bef2a9bc891dc5bde2843 seems involved,..

Anybody got clue?

