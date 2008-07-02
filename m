Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbYGBBlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbYGBBlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757184AbYGBBlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:41:37 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53763 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbYGBBlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:41:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Travis <travis@sgi.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
	<485BDB04.4090709@sgi.com> <485BE80E.10209@goop.org>
	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>
	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>
	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>
	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>
	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>
	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>
	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>
	<486A9D4F.8010508@goop.org> <m1skutffn4.fsf@frodo.ebiederm.org>
	<486AA72B.6010401@goop.org> <486AC9D9.9030506@zytor.com>
	<486AD6BD.9080600@sgi.com>
Date: Tue, 01 Jul 2008 18:32:38 -0700
In-Reply-To: <486AD6BD.9080600@sgi.com> (Mike Travis's message of "Tue, 01 Jul
	2008 18:15:41 -0700")
Message-ID: <m17ic5f4uh.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Travis <travis@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3075]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu area
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:

> H. Peter Anvin wrote:
>> Jeremy Fitzhardinge wrote:
>>>
>>> Yes, and there's no reason we couldn't do the same on 64-bit, aside
>>> from the stack-protector's use of %gs:40.  There's no code-size cost
>>> in large offsets, since they're always 32-bits anyway (there's no
>>> short absolute addressing mode).
>>>
>>> If we manually generate %gs-relative references to percpu data, then
>>> it's no different to what we do with 32-bit, whether it be a specific
>>> symbol address or using the TLS relocations.
>>>
>> 
>> If we think the problem is the zero-basing triggering linker bugs, we
>> should probably just use a small offset, like 64 (put a small dummy
>> section before the .percpu.data section to occupy this section.)
>> 
>> I'm going to play with this a bit and see if I come up with something
>> sanish.
>> 
>>     -hpa
>
> One interesting thing I've discovered is the gcc --version may make a
> difference.
>
> The kernel panic that occurred from Ingo's config, I was able to replicate
> with GCC 4.2.0 (which is on our devel server).  But this one complained
> about not being able to handle the STACK-PROTECTOR option so I moved
> everything to another machine that has 4.2.4, and now it seems that it
> works fine.  I'm still re-verifying that the source bits and config options 
> are identical (it was a later git-remote update), and that in fact it is
> the gcc --version, but that may be the conclusion.  (My code also has some
> patches submitted but not yet included in the tip/master tree.  Curiously
> just enabling some debug options changed the footprint of the panic.)
>
> Are we allowed to insist on a specific level of GCC for compiling the
> kernel?

Depends on the root cause.  If it turns out to be something that is buggy
in gcc and we can't work around.  We might do something.  I don't recall
that kind of thing happening often.  I think our minimum gcc is currently
gcc-3.4.

Eric
