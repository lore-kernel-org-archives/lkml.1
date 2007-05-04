Return-Path: <linux-kernel-owner+w=401wt.eu-S1161625AbXEDSuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161625AbXEDSuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161481AbXEDSuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:50:06 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43537 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161605AbXEDStr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:49:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>,
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
	<m16478qyxx.fsf@ebiederm.dsl.xmission.com> <463B79E6.8000908@goop.org>
Date: Fri, 04 May 2007 12:48:08 -0600
In-Reply-To: <463B79E6.8000908@goop.org> (Jeremy Fitzhardinge's message of
	"Fri, 04 May 2007 11:22:30 -0700")
Message-ID: <m1odl0pgrb.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Eric W. Biederman wrote:
>>> Gujin seems to have a near-zero user community, so if they have to rev
>>> their code it wouldn't be a big deal (the author keeps trying to push
>>> some crack-smoking "Gujin native" patches into the kernel, too), 
>>> breaking ELILO would hurt anyone using Intel Macs.
>>>     
>>
>> I'm thinking we just make the code start.
>> startup_32:
>> 	movl	%cs, %eax
>>         testl   $3, %eax
>>         jnz     1f
>>   
>
> I'm not really happy about using this as a way to distinguish paravirt
> from non-paravirt in general.  At some point we're going to be running
> paravirt kernels in ring0 within a VT/SVM container - but they'll still
> be completely paravirtualized kernels.

That wasn't paravirt detection that was do I have permissions to load
the gdt.

Basically we have two choices.   Either unconditionally demand
that %cs %ds %es and %ss are loaded, and so we remove all descriptor
loading.

Or we can do:
startup_32:
	movl	%cs, %eax
	testl	$3, %eax
        jnz     1f

	movl $(__BOOT_DS),%eax
	movl %eax,%ds
	movl %eax,%es
	movl %eax,%fs
	movl %eax,%gs
	movl %eax,%ss

1:

Which only demands that the segments be loaded when we aren't in ring0.
At least historically that is safe for the linux kernel but really weird.

Since there is only one fringe bootloader that cares I'm thinking just
removing all segment loading and assume we have the equivalent of
BOOT_DS in the segments probably makes the most sense.

I'm thinking that our next protocol version probably needs to be 3.0
given the significance of the change, and the fact we are breaking
in a very small ways backwards compatibility.

> I think a better approach is to just do it purely based on the boot
> params platform field.  Ie, something along the lines of:
>
> 	if (boot_params.version < new_enough)
> 		goto native_boot;
> 	else {
> 		for (int i = 0; i < nplatforms; i++)
> 			if (boot_params.platform == platforms[i].id)
> 				goto *platforms[i].startup
> 		panic();
> 	}

I think it is much better to test the boot_params.platform field where
we care.  If the platform is a native x86 subarch we don't need
a magic startup function.  If the platform is Xen or lguest
we can at best copy our boot parameters and jump to their custom
startup routines.

Eric
