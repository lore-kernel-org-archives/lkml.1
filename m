Return-Path: <linux-kernel-owner+w=401wt.eu-S1760439AbYGBBPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760439AbYGBBPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbYGBBPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:15:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37757 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756179AbYGBBPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:15:44 -0400
Message-ID: <486AD6BD.9080600@sgi.com>
Date: Tue, 01 Jul 2008 18:15:41 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<485ACD92.8050109@sgi.com> <485AD138.4010404@goop.org>	<485ADA12.5010505@sgi.com> <485ADC73.60009@goop.org>	<485BDB04.4090709@sgi.com> <485BE80E.10209@goop.org>	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>	<486A9D4F.8010508@goop.org> <m1skutffn4.fsf@frodo.ebiederm.org> <486AA72B.6010401@goop.org> <486AC9D9.9030506@zytor.com>
In-Reply-To: <486AC9D9.9030506@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>>
>> Yes, and there's no reason we couldn't do the same on 64-bit, aside
>> from the stack-protector's use of %gs:40.  There's no code-size cost
>> in large offsets, since they're always 32-bits anyway (there's no
>> short absolute addressing mode).
>>
>> If we manually generate %gs-relative references to percpu data, then
>> it's no different to what we do with 32-bit, whether it be a specific
>> symbol address or using the TLS relocations.
>>
> 
> If we think the problem is the zero-basing triggering linker bugs, we
> should probably just use a small offset, like 64 (put a small dummy
> section before the .percpu.data section to occupy this section.)
> 
> I'm going to play with this a bit and see if I come up with something
> sanish.
> 
>     -hpa

One interesting thing I've discovered is the gcc --version may make a
difference.

The kernel panic that occurred from Ingo's config, I was able to replicate
with GCC 4.2.0 (which is on our devel server).  But this one complained
about not being able to handle the STACK-PROTECTOR option so I moved
everything to another machine that has 4.2.4, and now it seems that it
works fine.  I'm still re-verifying that the source bits and config options 
are identical (it was a later git-remote update), and that in fact it is
the gcc --version, but that may be the conclusion.  (My code also has some
patches submitted but not yet included in the tip/master tree.  Curiously
just enabling some debug options changed the footprint of the panic.)

Are we allowed to insist on a specific level of GCC for compiling the
kernel?

Thanks,
Mike
