Return-Path: <linux-kernel-owner+w=401wt.eu-S964897AbXBLM3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964897AbXBLM3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 07:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964900AbXBLM3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 07:29:47 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36816 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964897AbXBLM3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 07:29:46 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Cc: vgoyal@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Re : [PATCH] Compressed ia32 ELF file generation for loading by Gujin 1/3
References: <687898.45581.qm@web26907.mail.ukl.yahoo.com>
Date: Mon, 12 Feb 2007 05:29:31 -0700
In-Reply-To: <687898.45581.qm@web26907.mail.ukl.yahoo.com> (Etienne Lorrain's
	message of "Mon, 12 Feb 2007 11:42:21 +0100 (CET)")
Message-ID: <m17iuny2xg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Etienne Lorrain <etienne_lorrain@yahoo.fr> writes:

> --- "Eric W. Biederman" wrote:
>> So I really don't care if we move whole real mode section into a note
>> or if we just put a pointer to it into a note.  What is important is
>> that we use a note to find it.
>
>  Well, we can advertise by a note the section number or the section
> name which contains the real-mode code, but finding the section of
> type SHT_PROGBITS having SHF_EXECINSTR flags linked at zero is not
> that difficult to do: it is what Gujin does right now when it does
> not find the program header linked at zero.

What I was thinking is that in the not we place the physical address
and length that we load the real mode code at.  My assumption being
that we have marked the real mode code __init or the equivalent,
so we always load and just ignore it later on.

>> Which means that we could do something goofy in the linker script
>> like we do with the current vdso.  So we could give it a virtual
>> address of 0 and a physical address in the init code section.
>
>  Gujin loads at the physical address, i.e. kernel is loaded at
> 0x100000 and not 0xC0100000, is that wrong?

No.  For practical purposes we can say virtual addresses are for
the code and the kernel.  Physical addresses are for the loader.

>  I am not sure playing these games with addresses is cleaner than
> not loading a section which is not in the program header.

It is some cleaner.  I won't call it perfectly clean, but it is
better.  It keeps everything but argument generation generic,
and there is already precedent in things like the vdso.

Playing the games with the addresses does allow the existing debugging
tools to work without problem because the end users of the code all
examine the virtual not the physical address.

>> For me the objective is not so much reusing the existing tools
>> (although that is a plus) but more to be able to build a unified
>> binary that can be used for everything, and will give us the freedom
>> to do interesting things with the kernel in the future, and hopefully
>> something that is more or less usable by portable bootloaders.  Having
>> a different file format and different rules for different
>> architectures is a pain.
>
>  For me the objective is to have a reasonable bootloader,
> I will not have the time to port back and test with every other
> bootloader some transfert of code from Gujin to an ELF looking
> like bzImage file.

I agree I want a reasonable bootloader as well.

With ELF we get a single file format that works on multiple
architectures and for multiple OS-s, with well understood rules.  This
allows for a broader audience who can review and maintain the code.
In addition to the real possibility of multi-architecture or multi-os
bootloaders.

What ELF cannot standardize is the how we pass the initial arguments.
ELF does standardize the initial parameters for unix executables but
the requirements of arguments to kernels, and the years of practice
are quite different.

ELF should make it much easier for people implementing simple
stand-alone executables for testing.  As you don't even need a linker
script or any fancy games if you don't take arguments.   Similarly
the switch from linux to multi-boot that almost standard is just
supporting a different argument passing format.

Eric
