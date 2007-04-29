Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbXD2PNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbXD2PNH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 11:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbXD2PNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 11:13:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37716 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbXD2PND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 11:13:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
References: <20070428758.455116000@suse.de>
	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>
	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>
Date: Sun, 29 Apr 2007 09:11:52 -0600
In-Reply-To: <4634483E.9030307@goop.org> (Jeremy Fitzhardinge's message of
	"Sun, 29 Apr 2007 00:24:46 -0700")
Message-ID: <m14pmz8bbb.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Eric W. Biederman wrote:
>> All it does is set a flag that tells a bootloader.
>> "Hey. I can run when loaded a non-default address, and this is what
>>  you have to align me to."
>>
>> All relocation processing happens in the kernel itself.
>>   
>
> Is it possible to decompress and extract the kernel image from the
> bzImage without executing it?  Ie, is there enough information to find
> the compressed data part of the bzImage by inspection?
>
> At some point we'll need to change the Xen domain builder to handle
> bzImage files, and it would be best if we didn't need to run them.

/sbin/kexec bzImage ....

There is a 32bit entry point that is reasonably well specified
you can use.  I'm guessing you want to recover the 64bit ELF,
with all of your nice ELF notes etc.  vmlinux is run through
"objcopy -O binary" as part of the bzImage build process so all
of the ELF metadata is lost.

I have several ideas on how we can make this work but first I have to
ask what is it that you are trying to accomplish?

<rant>
  Right now I'm a little frustrated that insanity below slipped into
  head.S right after the 32bit entry point after the review said
  use the normal linux parameters for parameter passing.
  
  > #ifdef CONFIG_PARAVIRT
  >         movl %cs, %eax
  >         testl $0x3, %eax
  >         jnz startup_paravirt
  > #endif
  
  The whole thing should be based on a value in the linux parameter block
  pointed to by %esi, instead of the insane preserve all registers and
  attempt to be super compatible with everyone.

  Yes we do need a branch there, but no we don't need to be changing 
  the format we pass arguments to the kernel in.
</rant>

Anyway since it seems there is interest in going farther in tweaking
the linux boot process let's open thread up to what is needed/wanted
for future enhancements to linux booting, and let's see if we can
design something that works and isn't brain dead.

Eric
