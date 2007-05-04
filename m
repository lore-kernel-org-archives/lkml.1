Return-Path: <linux-kernel-owner+w=401wt.eu-S1422717AbXEDTLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422717AbXEDTLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422942AbXEDTLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:11:22 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48642 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422717AbXEDTLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:11:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] Replace paravirt_probe with "platform type" boot header field
References: <1178283582.23670.67.camel@localhost.localdomain>
	<m1zm4ksn5o.fsf@ebiederm.dsl.xmission.com>
	<1178288329.23670.86.camel@localhost.localdomain>
	<m1tzussm4z.fsf@ebiederm.dsl.xmission.com>
	<463B56A0.7090805@zytor.com>
	<m1mz0kr0ux.fsf@ebiederm.dsl.xmission.com>
	<463B69AB.2030706@zytor.com>
	<m1vef8phjy.fsf@ebiederm.dsl.xmission.com>
	<463B81BC.1030504@zytor.com>
Date: Fri, 04 May 2007 13:10:08 -0600
In-Reply-To: <463B81BC.1030504@zytor.com> (H. Peter Anvin's message of "Fri,
	04 May 2007 11:55:56 -0700")
Message-ID: <m1d51gpfqn.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>> 
>> You should be able to just include linux/screen_info.h instead of duplicating
>> it inline.
>> 
>
> I'm working on it!!!!!

Sure. I meant that linux/screen_info.h should already be safe.

>> I like the use of struct header in the middle of boot_params that
>> seems like a nice maintenance device, although I'm not quite certain about
>> 
>> However you haven't documented the old swap_dev field in struct header.
>> At least rdev still knows about it, so it is probably inappropriate to
>> merge it with syssize.  Not that syssize is actually useful for anything
>> in a modern system.
>
> Actually, ROM bootloaders care about it, which is why it was expanded
> out in boot loader protocol 2.04; see the documentation.

Interesting. I missed that one.

>> So I just looked at what /sbin/kexec does so we know what to expect.
>> If I have a bzImage I just grab the first setup_sects (i.e. setup.S) and make
>> it the initial linux boot parameters, placing the command line immediately
>> afterwards.
>> 
>> If I just have a vmlinux so I have to fake it I memset
> x86_linux_faked_param_header
>> to zero, before placing in the values I care about.  And the size.  4K aka 1
> page.
>> Although I due put the command line at 2K, I think that is actually the
> historical
>> kernel usage of the zero page.
>
> Oh flippin' hell.  *STABBITY STAB STAB STAB*.

Yep, a real pain.

At this point it looks like a bug in kexec to me, and the bzImage loader
which is the primary way to boot linux doesn't have this problem.  Yea.

> All of which is just evil.  So much for "oh, the definition of the
> zeropage never changes, so it doesn't matter."

>> elilo does something similar but starts with a 16K pages and then backs up
>> 2K for the command line.
>> 
>> Gujin does something similar but also seems to place a command line at 2K.
>> 
>> So short of the first 2K we can reasonably expect new parameters to be zero
>> initialized.  Past that we need to be a little more careful.
>
> Oh flippin' hell.

And now you understand why I am surveying these things and want to get
the 32bit entry point well documented.  So the situation doesn't get worse.

Frankly while I consider what we are doing pretty sane I have always considered
the 32bit entry point at least partly experimental.  But we have enough users
of it now and enough reasons to have users of it, that it looks like we need to
do things a little more methodically.

>> And 4K seems to be our maximum size for backwards compatibility.  Although
>> we use it in a fairly sparse way, so we should be ok.
>
> Sort of.  It's pretty full.

True.  For small little extensions we have room.  For big things probably
not.

Eric
