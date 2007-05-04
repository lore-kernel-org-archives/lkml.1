Return-Path: <linux-kernel-owner+w=401wt.eu-S1161532AbXEDSzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161532AbXEDSzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161605AbXEDSzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:55:15 -0400
Received: from gw.goop.org ([64.81.55.164]:34069 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161532AbXEDSzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:55:13 -0400
Message-ID: <463B8193.3010101@goop.org>
Date: Fri, 04 May 2007 11:55:15 -0700
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
References: <1178283582.23670.67.camel@localhost.localdomain>	<1178283724.23670.70.camel@localhost.localdomain>	<1178284052.23670.75.camel@localhost.localdomain>	<m1ps5gslfm.fsf@ebiederm.dsl.xmission.com> <463B4E12.50703@goop.org>	<463B551E.8030701@zytor.com> <463B5B90.20308@goop.org>	<m1irb8r0gl.fsf@ebiederm.dsl.xmission.com>	<463B683C.5090308@zytor.com>	<m16478qyxx.fsf@ebiederm.dsl.xmission.com> <463B79E6.8000908@goop.org> <m1odl0pgrb.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1odl0pgrb.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> I'm not really happy about using this as a way to distinguish paravirt
>> from non-paravirt in general.  At some point we're going to be running
>> paravirt kernels in ring0 within a VT/SVM container - but they'll still
>> be completely paravirtualized kernels.
>>     
>
> That wasn't paravirt detection that was do I have permissions to load
> the gdt.
>   

Well, a paravirtualized ring0 kernel may still have special constraints
on how the gdt can be set up (page-aligned, read-only, etc).

> Basically we have two choices.   Either unconditionally demand
> that %cs %ds %es and %ss are loaded, and so we remove all descriptor
> loading.
>   

Yep.  At least if the boot-version is new enough to boot this way.  The
old native-boot path can reload as much as it likes.

>> I think a better approach is to just do it purely based on the boot
>> params platform field.  Ie, something along the lines of:
>>
>> 	if (boot_params.version < new_enough)
>> 		goto native_boot;
>> 	else {
>> 		for (int i = 0; i < nplatforms; i++)
>> 			if (boot_params.platform == platforms[i].id)
>> 				goto *platforms[i].startup
>> 		panic();
>> 	}
>>     
>
> I think it is much better to test the boot_params.platform field where
> we care.  If the platform is a native x86 subarch we don't need
> a magic startup function.  If the platform is Xen or lguest
> we can at best copy our boot parameters and jump to their custom
> startup routines.
>   

Why not just treat them all in the same way?  Especially if we start
sweeping other non-virtual architectures like voyager/visws/etc into the
same mechanism.

My idea was that "goto native_boot" would jump to code which assumes
it's running on real hardware, where there's no problem reloading
gdt/segment registers, etc.

    J
