Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbZGHTs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbZGHTs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 15:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbZGHTst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 15:48:49 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:43497 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbZGHTss convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 15:48:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VpFZp6ITrNHFKzvszP0e3sXsFbLDcfEENoT7jgUxE0N5WZ4zCgGModtd+KTYY0nIsk
         778oz8gIEQCW7fXQPM82+r+fskDpaH1rqUFy5an50apfFu/jWXHGyEAcUIB7bbP1W7Ub
         l+kjM8dvfN7MfNBfMwiBgp1SQtcCJ2Tb5KoSc=
MIME-Version: 1.0
In-Reply-To: <1247078164.16156.18.camel@laptop>
References: <a5d9929e0907070825j1dda6584t93196e2730dedc5c@mail.gmail.com> 
	<1246980836.9777.5.camel@twins> <a5d9929e0907070838q7ed3306du3bb7880e47d7207b@mail.gmail.com> 
	<1246981444.9777.11.camel@twins> <a5d9929e0907070850v72cd4da4y1cbbb10fddebd575@mail.gmail.com> 
	<1246982101.9777.15.camel@twins> <20090708172248.GB2521@redhat.com> 
	<1247078164.16156.18.camel@laptop>
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Wed, 8 Jul 2009 20:48:26 +0100
Message-ID: <a5d9929e0907081248q51e1fcfekff4c1b814e512184@mail.gmail.com>
Subject: Re: [PATCH 1/3] Increase lockdep limits: MAX_STACK_TRACE_ENTRIES
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 8, 2009 at 7:36 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> On Wed, 2009-07-08 at 13:22 -0400, Dave Jones wrote:
>> On Tue, Jul 07, 2009 at 05:55:01PM +0200, Peter Zijlstra wrote:
>>  > On Tue, 2009-07-07 at 16:50 +0100, Joao Correia wrote:
>>  >
>>  > > >> Yes. Anything 2.6.31 forward triggers this immediatly during init
>>  > > >> process, at random places.
>>  > > >
>>  > > > Not on my machines it doesn't.. so I suspect its something weird in
>>  > > > your .config or maybe due to some hardware you have that I don't that
>>  > > > triggers different drivers or somesuch.
>>  > >
>>  > > I am not the only one reporting this, and it happens, for example,
>>  > > with a stock .config from a Fedora 11 install.
>>  > >
>>  > > It may, of course, be a funny driver interaction yes, but other than
>>  > > stripping the box piece by piece, how would one go about debugging
>>  > > this otherwise?
>>  >
>>  > One thing to do is stare (or share) at the output
>>  > of /proc/lockdep_chains and see if there's some particularly large
>>  > chains in there, or many of the same name or something.
>>
>> I don't see any long chains, just lots of them.
>> 29065 lines on my box that's hitting MAX_STACK_TRACE_ENTRIES
>>
>>  > /proc/lockdep_stats might also be interesting, mine reads like:
>>
>>  lock-classes:                         1518 [max: 8191]
>>  direct dependencies:                  7142 [max: 16384]
>
> Since we have 7 states per class, and can take one trace per state, and
> also take one trace per dependency, this would yield a max of:
>
>  7*1518+7142 = 17768 stack traces
>
> With the current limit of 262144 stack-trace entries, that would leave
> us with and avg depth of:
>
>  262144/17768 = 14.75
>
> Now since we would not use all states for each class, we'd likely have a
> little more, but that would still suggest we have rather deep stack
> traces on avg.
>
> Looking at a lockdep dump hch gave me I can see that that is certainly
> possible, I see tons of very deep callchains.
>
> /me wonders if we're getting significantly deeper..
>
> OK I guess we can raise this one, does doubling work? That would get us
> around 29 entries per trace..
>
> Also, Dave do these distro init scrips still load every module on the
> planet or are we more sensible these days?
>
> module load/unload cycles are really bad for lockdep resources.
>
> --
>
> As a side node, I see that each and every trace ends with a -1 entry:
>
> ...
> [ 1194.412158]    [<c01f7990>] do_mount+0x3c0/0x7c0
> [ 1194.412158]    [<c01f7e14>] sys_mount+0x84/0xb0
> [ 1194.412158]    [<c01221b1>] syscall_call+0x7/0xb
> [ 1194.412158]    [<ffffffff>] 0xffffffff
>
> Which seems to come from:
>
> void save_stack_trace(struct stack_trace *trace)
> {
>        dump_trace(current, NULL, NULL, 0, &save_stack_ops, trace);
>        if (trace->nr_entries < trace->max_entries)
>                trace->entries[trace->nr_entries++] = ULONG_MAX;
> }
> EXPORT_SYMBOL_GPL(save_stack_trace);
>
> commit 006e84ee3a54e393ec6bef2a9bc891dc5bde2843 seems involved,..
>
> Anybody got clue?
>
>

Im in no way pretending to understand all the details on this system,
but i do know there has been, as of late, an effort to make the init
process do more things at once, ie, load more modules in parallel to
speed up the process. Can't that be at least partially responsible for
this? Even if its just making some other problem more obvious?

Joao Correia
