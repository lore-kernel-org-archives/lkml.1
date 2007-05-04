Return-Path: <linux-kernel-owner+w=401wt.eu-S1031383AbXEDQr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031383AbXEDQr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031386AbXEDQr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:47:26 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37259 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031383AbXEDQrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:47:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3] boot bzImages under paravirt
References: <1178283582.23670.67.camel@localhost.localdomain>
	<1178283724.23670.70.camel@localhost.localdomain>
	<1178284052.23670.75.camel@localhost.localdomain>
	<m1ps5gslfm.fsf@ebiederm.dsl.xmission.com> <463B4E12.50703@goop.org>
Date: Fri, 04 May 2007 10:46:13 -0600
In-Reply-To: <463B4E12.50703@goop.org> (Jeremy Fitzhardinge's message of "Fri,
	04 May 2007 08:15:30 -0700")
Message-ID: <m1r6pwr0yy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Eric W. Biederman wrote:
>> Ok.  Although we can hoist the bss zeroing, if everything needs it.
>>   
>
> It will if we're booting out of bzImage; the bss won't be clear in that
> case.
>
>> Hmm.  I'm wondering about the segment reload and how much of a problem
>> that is.  My memory says that segment reloads are not actually a
>> privileged operation, so we may be able to support this even in
>> paravirt mode.  How hard would that be to support?  The segment
>> we reload is a fixed part of our boot protocol.
>>   
>
> The problem is not the reloads themselves, but what you're reloading
> them with.  If we come up under Xen, then it will provide a default GDT
> and pre-load the segments with flat 4G(-ish) selectors - but the
> selectors won't be the normal Linux ones.
>
> So if we reload using a constant selector, then that will break under
> Xen. But if we do a:
>
>     mov %cs, %eax
>     mov %eax, %ds
>     // etc

Hmm. If we made that:
	mov	%cs, %eax
	add	$0x10, %eax
	mov	%eax, %ds

That is likely even backwards compatible.  If you don't mind having a fixed
offset between the code and the data segments.  As I recall code and data
are not interchangeable.

I'm trying to remember the reason for the reloads.

As I recall loadlin intercepts code32_start from head.S and so it
can do things just after we have switched to protected mode.  Because
historically we didn't load the segments before this jump loadlin had
to do it.  The code of loadlin appears to reload all of the segments
just like head.S does and then not touch them.

My two bootloaders that enter the kernel at the 32bit entry point already
load the segments as well.

Gujin looks like it loads just %es and %ds.

It is hard to tell with elilo what it sets up, it preserves the
descriptors from EFI, but sets up a linux boot protocol gdt.

Since setup.S finally does the right thing in loading segment
registers.  It looks to me like we need to sit down and document
the 32bit kernel interface, as it is today, and then extend
things to just replicate %ds into the other segments, and kill
any lss instructions.

That is trivially compatible with our expectations of vmlinux.  For
the bzImage 32bit entry point it is a bit of an extension, but except
for para-virtualization solutions I don't know of anything that
doesn't support bzImage and vmlinux with the same code.

I like it a lot better then trying to derive %ds from %cs.

At the same time we are doing this it would be good to drop our
boot protocol version into an ELF note so people booting vmlinux
can discover when we have relaxed various restrictions and which
fields in the real mode data we support.

Eric
