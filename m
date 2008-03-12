Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbYCLCWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbYCLCWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 22:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYCLCWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 22:22:41 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40077 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbYCLCWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 22:22:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	<20080311211004.GA30164@redhat.com>
	<1205286326.29069.16.camel@caritas-dev.intel.com>
Date: Tue, 11 Mar 2008 20:17:45 -0600
In-Reply-To: <1205286326.29069.16.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Wed, 12 Mar 2008 09:45:26 +0800")
Message-ID: <m1abl4znw6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> Yes. The entry point should be saved in dump.elf itself, this can be
> done via a user-space tool such as "makedumpfile". Because
> "makedumpfile" is also used to exclude free pages from disk image, it
> needs a communication method between two kernels (to get backup pages
> map or something like that from kernel A). We have talked about this
> before.
>
> - Your opinion is to communicate via the purgatory. (But I don't know
> how to communicate between kernel A and purgatory).

How about the return address on the stack?

> - Eric's opinion is to communicate between the user space in kernel A
> and user space in kernel B.

Purgatory is for all intents and purposes user space.  Because the
return address falls on the trampoline page we won't know it's
address before we call kexec.  But a return address and a stack
on that page should be a perfectly good way to communicate.

> - My opinion is to communicate between two kernel directly.
>
> I think as a minimal infrastructure patch, we can communicate minimal
> information between user space of two kernels. When we have consensus on
> this topic, we can use makedumpfile for both excluding free pages and
> saving the entry point. Now, we can save the entry point in a separate
> file or I can write a simple tool to do this.

We need a fixed protocol so we do not make assumptions about how things
will be implemented, allowing kernels to diverge and kinds of other
good things.

For communicating extra information from the kernel being shut down
we have elf notes.

Direct kernel to kernel communication is forbidden.  We must have
a well defined protocol.  Allowing the implementations to change
at their different speeds, and still work together.

>> May be we can have a separate load flag (--load-resume-image) to mark
>> that we are resuming an hibernated image and kexec does not have to
>> prepare commandline, does not have to prepare zero page/setup page etc.
>
> There is already similar flag in original kexec-tools implementation:
> "--args-none". If it is specified, kexec-tools does not prepare command
> line and zero page/setup page etc. I think we can just re-use this flag.
> And If it is desired an alias is good for me too.

My gut feel is we look at the image and detect what kind it is, and simply
not enable image processing after we have read the note that says it
is a resumable core or whatever.

>> I have thought through it again and try to put together some of the
>> new kexec options we can introduce to make the whole thing work. I am 
>> considering a simple case where a user boots the kernel A and then
>> launches kernel B using "kexec --load-preseve-context". Now a user
>> might save the hibernated image or might want to come back to A.
>> 
>> - kexec -l <kernel-image>
>>         Normal kexec functionality. Boot a new kernel, without preserving
>>         existing kernel's context.
>> 
>> - kexec --load-preserve-context <kernel-image>
>>         Boot a new kernel while preserving existing kernel's context.
>> 
>>         Will be used for booting kernel B for the first time.
>> 
>> - kexec --load-resume-image <resumable-core>
>
> In original kexec-tools, this can be done through:
> kexec -l --args-none <resumable-core>
>
> Do you need to define an alias for it?

Make common cases fast to use.  The UI equivalent of make the
common case fast.

Eric

