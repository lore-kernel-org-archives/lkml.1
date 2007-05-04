Return-Path: <linux-kernel-owner+w=401wt.eu-S1161358AbXEDSWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161358AbXEDSWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161434AbXEDSWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:22:30 -0400
Received: from gw.goop.org ([64.81.55.164]:44255 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161358AbXEDSW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:22:28 -0400
Message-ID: <463B79E6.8000908@goop.org>
Date: Fri, 04 May 2007 11:22:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3] boot bzImages under paravirt
References: <1178283582.23670.67.camel@localhost.localdomain>	<1178283724.23670.70.camel@localhost.localdomain>	<1178284052.23670.75.camel@localhost.localdomain>	<m1ps5gslfm.fsf@ebiederm.dsl.xmission.com> <463B4E12.50703@goop.org>	<463B551E.8030701@zytor.com> <463B5B90.20308@goop.org>	<m1irb8r0gl.fsf@ebiederm.dsl.xmission.com>	<463B683C.5090308@zytor.com> <m16478qyxx.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m16478qyxx.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> Gujin seems to have a near-zero user community, so if they have to rev
>> their code it wouldn't be a big deal (the author keeps trying to push
>> some crack-smoking "Gujin native" patches into the kernel, too), 
>> breaking ELILO would hurt anyone using Intel Macs.
>>     
>
> I'm thinking we just make the code start.
> startup_32:
> 	movl	%cs, %eax
>         testl   $3, %eax
>         jnz     1f
>   

I'm not really happy about using this as a way to distinguish paravirt
from non-paravirt in general.  At some point we're going to be running
paravirt kernels in ring0 within a VT/SVM container - but they'll still
be completely paravirtualized kernels.

I think a better approach is to just do it purely based on the boot
params platform field.  Ie, something along the lines of:

	if (boot_params.version < new_enough)
		goto native_boot;
	else {
		for (int i = 0; i < nplatforms; i++)
			if (boot_params.platform == platforms[i].id)
				goto *platforms[i].startup
		panic();
	}


> But that won't work if we want to support relocatability.
> Because we can't load a gdt if we don't know where we are.
>
> To find out where we are we need %ss and %ds, at which point
> we might as well assume we have %es to.
>   

Yes, we won't make it far without ss and ds, and while we could avoid
string instructions, you'd have to be a pretty short-sighted bootloader
author to set ss and ds without also setting es.

> So be it then.  The next rev of the boot protocol gets to be partially
> incompatible, and we just assume that %cs, %ds, %es, %ss meet our
> basic requirements.  I'm pretty certain from what I saw only Gujin
> is going to suffer  :(
>   

I missed what Gujin does wrong here?


    J
