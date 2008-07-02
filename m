Return-Path: <linux-kernel-owner+w=401wt.eu-S1761377AbYGBBvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377AbYGBBvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757590AbYGBBvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:51:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38481 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757381AbYGBBvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:51:04 -0400
Message-ID: <486ADF06.1020006@sgi.com>
Date: Tue, 01 Jul 2008 18:51:02 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<485BDB04.4090709@sgi.com> <485BE80E.10209@goop.org>	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>	<486A9D4F.8010508@goop.org> <m1skutffn4.fsf@frodo.ebiederm.org>	<486AA72B.6010401@goop.org> <486AC9D9.9030506@zytor.com>	<486AD6BD.9080600@sgi.com> <m17ic5f4uh.fsf@frodo.ebiederm.org>
In-Reply-To: <m17ic5f4uh.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Mike Travis <travis@sgi.com> writes:
> 
>> H. Peter Anvin wrote:
>>> Jeremy Fitzhardinge wrote:
>>>> Yes, and there's no reason we couldn't do the same on 64-bit, aside
>>>> from the stack-protector's use of %gs:40.  There's no code-size cost
>>>> in large offsets, since they're always 32-bits anyway (there's no
>>>> short absolute addressing mode).
>>>>
>>>> If we manually generate %gs-relative references to percpu data, then
>>>> it's no different to what we do with 32-bit, whether it be a specific
>>>> symbol address or using the TLS relocations.
>>>>
>>> If we think the problem is the zero-basing triggering linker bugs, we
>>> should probably just use a small offset, like 64 (put a small dummy
>>> section before the .percpu.data section to occupy this section.)
>>>
>>> I'm going to play with this a bit and see if I come up with something
>>> sanish.
>>>
>>>     -hpa
>> One interesting thing I've discovered is the gcc --version may make a
>> difference.
>>
>> The kernel panic that occurred from Ingo's config, I was able to replicate
>> with GCC 4.2.0 (which is on our devel server).  But this one complained
>> about not being able to handle the STACK-PROTECTOR option so I moved
>> everything to another machine that has 4.2.4, and now it seems that it
>> works fine.  I'm still re-verifying that the source bits and config options 
>> are identical (it was a later git-remote update), and that in fact it is
>> the gcc --version, but that may be the conclusion.  (My code also has some
>> patches submitted but not yet included in the tip/master tree.  Curiously
>> just enabling some debug options changed the footprint of the panic.)
>>
>> Are we allowed to insist on a specific level of GCC for compiling the
>> kernel?
> 
> Depends on the root cause.  If it turns out to be something that is buggy
> in gcc and we can't work around.  We might do something.  I don't recall
> that kind of thing happening often.  I think our minimum gcc is currently
> gcc-3.4.
> 
> Eric

Ouch.  How far into it do we need to investigate?  I can surely compare the
vmlinux object files, but I'm not cognizant enough about the linker internals
to examine much more than that.

But hey, maybe gcc-3.4 will work ok...?  ;-)

[Or it may be the stack-protector thing is introducing better code?  I'll try
some more config options tomorrow to see if that affects anything.]

Cheers,
Mike
