Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbXLLWz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbXLLWz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 17:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbXLLWzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 17:55:13 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54707 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbXLLWzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 17:55:11 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Huang, Ying" <ying.huang@intel.com>,
       akpm@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm -v2] x86 boot : export boot_params via sysfs
References: <1197449991.14443.88.camel@caritas-dev.intel.com>
	<20071212174613.GC16049@kroah.com> <47602044.9010104@zytor.com>
	<20071212185935.GA5941@kroah.com> <47603109.6080909@zytor.com>
	<20071212222146.GC16474@kroah.com>
Date: Wed, 12 Dec 2007 15:52:51 -0700
In-Reply-To: <20071212222146.GC16474@kroah.com> (Greg KH's message of "Wed, 12
	Dec 2007 14:21:46 -0800")
Message-ID: <m1ejdrttj0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Wed, Dec 12, 2007 at 11:05:45AM -0800, H. Peter Anvin wrote:
>> Greg KH wrote:
>>>> This is a binary structure defined by protocol;
>>> What protocol?  Is this a "standard" documented somewhere?
>>
>> Yes, see Documentation/i386/* (although some of it is documented by 
>> reference to include/asm-x86/boot_params.h).
>
> Ah, so the structure has changed over the years, making this not so much
> a "firmware" field as originally thought :)

The structure has grown and fields have been added in a backwards
compatible way.  It is very much an ABI from the bootloader to the
kernel.

>> I believe kexec currently tries to reconstitute it from what data is 
>> available to it.  This is incomplete, though, and has been flagged as a 
>> problem for kexec.
>
> Can't kexec get this from within the kernel itself when it is running?
> It doesn't need to get this from userspace, does it?

/proc/kmem?  All of this work happens in user space.  The kexec
syscall interface is just load these chunks of data at this these
addresses and finally jump to this address.

All of the interesting kexec work happens in user space, and it needs
to stay that way.  Otherwise we loose the flexibility and simplicity
on the kernel side.

>> It can pick it up from <asm/boot_params.h> (which is now userspace-safe); 
>> or it can decode it itself.  Programs like kexec can pass through most of 
>> the data without examining it, this is the main reason for having it as a 
>> blob.
>
> I just don't want kernel structures exported in binary fashions in
> sysfs.  If there are specific portions that kexec currently can't figure
> out, why not just export those fields?

So all of the fields are binary.
The entire structure is binary.
The native format is binary.

So either we need to export the processed and chewed up version of the
information like we do today in /proc/iomem.  Or we need to export the
raw binary format.

> And, by exporting the different fields (yeah, lots of files, no big
> deal), you can handle the change in the structure over time much easier
> than trying to "know" the layout of the binary blob.

Well /sbin/kexec fundamentally has to "know" the layout of that binary
blob because it generates it and hands it to the kernel.

Greg I think I am with you on this one.  If something other then
/sbin/kexec is going to use that information we need to split it
by field, although I expect the fields to remain binary.  Things
like the e820 memory map and most of the other fields are binary
structures defined to be returned by the firmware so at that level
we have extremely well defined binary blobs, that may possibly
be used for other things.

/sbin/kexec needs to retain the ability to parse and understand the
information because frequently it needs to change little things like
the memory map and the command line and possibly other things so it
can't blindly pass this information through.

Eric
