Return-Path: <linux-kernel-owner+w=401wt.eu-S1161364AbXEDRbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161364AbXEDRbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031435AbXEDRbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:31:10 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44958 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031432AbXEDRbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:31:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3] boot bzImages under paravirt
References: <1178283582.23670.67.camel@localhost.localdomain>
	<1178283724.23670.70.camel@localhost.localdomain>
	<1178284052.23670.75.camel@localhost.localdomain>
	<m1ps5gslfm.fsf@ebiederm.dsl.xmission.com> <463B4E12.50703@goop.org>
	<463B551E.8030701@zytor.com> <463B5B90.20308@goop.org>
	<m1irb8r0gl.fsf@ebiederm.dsl.xmission.com>
	<463B683C.5090308@zytor.com>
Date: Fri, 04 May 2007 11:30:02 -0600
In-Reply-To: <463B683C.5090308@zytor.com> (H. Peter Anvin's message of "Fri,
	04 May 2007 10:07:08 -0700")
Message-ID: <m16478qyxx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>> 
>> We have real mystery historical cases in Gujin and ELILO.  So it
>> probably makes sense at this point to force a gdt reload if we can and
>> otherwise require all of the segments %ds, %es, %fs, %gs to be loaded
>> with a valid segment, that we can reach everything we need to touch
>> from.
>> 
>
> I think we should avoid using %fs and %gs (no use for them, anyway); but
> I think it's a decent expectation to have %cs, %ds, %es, and %ss set up.

Yes we have no need for %fs and %gs.  Lumping them in with the rest is
just extra helpfulness.

Basically be conservative in what you send (all segments).
Be liberal in what you accept (%cs,%ds,%es,%ss) and less if
we can get away with it.

> Gujin seems to have a near-zero user community, so if they have to rev
> their code it wouldn't be a big deal (the author keeps trying to push
> some crack-smoking "Gujin native" patches into the kernel, too), 
> breaking ELILO would hurt anyone using Intel Macs.

I'm thinking we just make the code start.
startup_32:
	movl	%cs, %eax
        testl   $3, %eax
        jnz     1f

	lgdt boot_gdt_descr - __PAGE_OFFSET
	movl $(__BOOT_DS),%eax
	movl %eax,%ds
	movl %eax,%es
	movl %eax,%fs
	movl %eax,%gs
        movl %eax,%ss
1:

But that won't work if we want to support relocatability.
Because we can't load a gdt if we don't know where we are.

To find out where we are we need %ss and %ds, at which point
we might as well assume we have %es to.

I think that will work in the elilo case but we can't reload them.
As silly elilo loaded a new gdt but not it's segments...

So be it then.  The next rev of the boot protocol gets to be partially
incompatible, and we just assume that %cs, %ds, %es, %ss meet our
basic requirements.  I'm pretty certain from what I saw only Gujin
is going to suffer  :(

Yep it is long past time that we document what needs to happen for
the 32bit entry point of the linux kernel.

Eric
