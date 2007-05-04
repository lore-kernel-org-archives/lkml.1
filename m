Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbXEDO5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbXEDO5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbXEDO5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:57:52 -0400
Received: from gw.goop.org ([64.81.55.164]:49703 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384AbXEDO5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:57:51 -0400
Message-ID: <463B49F0.401@goop.org>
Date: Fri, 04 May 2007 07:57:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: always clear bss
References: <463AED07.1000505@goop.org> <m1r6pwu806.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1r6pwu806.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>
>   
>> When the paravirt dispatcher gets run immediately on entry to
>> startup_32, the bss isn't cleared.  This happens to work if the
>> hypervisor's domain builder loaded the complete kernel image and
>> cleared the bss for us, but this may not always be true (for example,
>> if we're running out of a decompressed bzImage).
>>
>> Change head.S so that it unconditionally clears the bss before doing
>> the paravirt dispatch or continuing on to normal native boot.
>>
>> There are a couple of points to note:
>>  - We can't, in general, load the segment registers before paravirt
>>    dispatch, because we could be running with a non-standard gdt and
>>    segment selectors.  In practice though, all code which ends up
>>    jumping into startup_32 will have already set the segment registers
>>    up to sane values, so we don't need to do it again.
>>  - Paging may or may not be enabled, and if enabled we may or may not
>>    be mapped to the proper kernel virtual address.  To deal with this,
>>    we compare the kernel's linked address with where we're actually
>>    running, and use that to offset the bss pointer.
>>     

BTW, I should have marked this as an RFC comment, rather than an actual
submission.  We don't need it for .22.

> NAK.  
>
> Skipping the segment register load is likely fine.
> Supporting V!=P at startup_32 is not.
>   

Why?

> Assuming that we have a stack at startup_32 is not.
>
> If you want to figure out where the kernel is loaded you can do
> (from arch/i386/boot/head.S)
>   

Yes, that's more or less the same code, aside from using 0x40(%esi) as a
stack.  Would that be OK here?

    J
