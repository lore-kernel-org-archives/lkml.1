Return-Path: <linux-kernel-owner+w=401wt.eu-S1161509AbXEDScp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161509AbXEDScp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161505AbXEDScp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:32:45 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39789 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161509AbXEDScn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:32:43 -0400
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
Date: Fri, 04 May 2007 12:30:57 -0600
In-Reply-To: <463B69AB.2030706@zytor.com> (H. Peter Anvin's message of "Fri,
	04 May 2007 10:13:15 -0700")
Message-ID: <m1vef8phjy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>> "H. Peter Anvin" <hpa@zytor.com> writes:
>> 
>>> Eric W. Biederman wrote:
>>>> Unlikely.  Unless we expect that this offset will come in non-zero.
>>>>
>>> You might have to worry about that.  Historically, the "zero-page" was
>>> really just the setup code overwritten, and it's still true for a big
>>> chunk of it.
>>>
>>> One of the major changes in my setup code rewrite is to start out with
>>> an all-zero chunk of memory for this.
>> 
>> Well as long as we are in sync with setup.S we are fine.  The issue
>> is people generating the real-mode data from scratch, when using the
>> 32bit entry point.
>
> Point.  I'd like that interface to specify that any undefined fields
> should be zero, or we have a hopeless situation on our hands.
>
> By the way, see the following for the structure definition; prepare to barf:
>
> http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-newsetup.git;a=blob;f=arch/i386/boot/boot.h;h=41a16f96ac3476cbd969aabe5e6a792ffe8c64a0;hb=HEAD
>
> [I intend to move this into include/asm-i386/boot.h, but haven't gotten
> that far yet.  I just yesterday got the code booting on both i386 and
> x86-64, but haven't committed all the include/asm-* mods that went a
> long with that yet.  I'm also waiting for a Kbuild fix so that the boot
> directory can be shared between i386 and x86-64 without requiring a
> symlink in the source tarball.]

You should be able to just include linux/screen_info.h instead of duplicating
it inline.

I like the use of struct header in the middle of boot_params that
seems like a nice maintenance device, although I'm not quite certain about

However you haven't documented the old swap_dev field in struct header.
At least rdev still knows about it, so it is probably inappropriate to
merge it with syssize.  Not that syssize is actually useful for anything
in a modern system.

So I just looked at what /sbin/kexec does so we know what to expect.
If I have a bzImage I just grab the first setup_sects (i.e. setup.S) and make
it the initial linux boot parameters, placing the command line immediately
afterwards.

If I just have a vmlinux so I have to fake it I memset x86_linux_faked_param_header
to zero, before placing in the values I care about.  And the size.  4K aka 1 page.
Although I due put the command line at 2K, I think that is actually the historical
kernel usage of the zero page.

elilo does something similar but starts with a 16K pages and then backs up
2K for the command line.

Gujin does something similar but also seems to place a command line at 2K.

So short of the first 2K we can reasonably expect new parameters to be zero
initialized.  Past that we need to be a little more careful.

And 4K seems to be our maximum size for backwards compatibility.  Although
we use it in a fairly sparse way, so we should be ok.

Eric
