Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbXEJSIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbXEJSIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 14:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbXEJSIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 14:08:34 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34567 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbXEJSId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 14:08:33 -0400
Message-ID: <46435F8A.1040203@zytor.com>
Date: Thu, 10 May 2007 11:08:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
CC: "Antonino A. Daplas" <adaplas@gmail.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>, Matt Domsch <Matt_Domsch@dell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPar>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: x86 setup rewrite tree ready for flamage^W review
References: <464158E9.2000207@zytor.com> <1178806235.18785.1189115515@webmail.messagingengine.com>
In-Reply-To: <1178806235.18785.1189115515@webmail.messagingengine.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
 > Hi!
> 
> Only tiny sparks^Wremarks, I'm afraid. ;)
> 
> I've briefly looked at the new code in arch/i386/boot and as far 
> as I can determine in a short amount of time all functionality is
> basically there, with the exception of the 'scan' functionality for 
> bios modes. Maybe it is not needed anymore? I have used this 
> functionality to find non-standard modes recently (for a kernel 
> crash during boot).

As far as I could tell, "scan" simply caused the nonstandard video
driver scan modules (unsafe probes) to be invoked.  Since those modules
are no longer present, there appeared to be no need for them.  The VGA
and VESA probes are safe.

> Random remarks about config-differences:
> 
> The new code does not use VIDEO_SELECT and X86_SPEEDSTEP_SMI
> (i386-only): both parts are always compiled in. The new code uses FB:
> the old code allowed setting a graphics mode, even without FB support.
> Shared config options that affect the code generation: EDD, RELOCATABLE,
> FIRMWARE_EDID, and APM (i386-only). Some code also depends on X86_ELAN
> and X86_VOYAGER.

I was considering also making the MCA code dependent on CONFIG_MCA, but
realized it would be better to have it at least be compiled, to prevent
bitrot.  It could be added back in to add a handful of bytes.

> Allnoconfig realmode kernel part increases by about 3.5 kb:
> old x86_64:  Boot sector 512 bytes. / Setup is 4737 bytes.
> new x86_64:  Setup is 8808 bytes (padded to 9216 bytes).
> old i386:  Boot sector 512 bytes. / Setup is 4842 bytes.
> new i386:  Setup is 8776 bytes (padded to 9216 bytes).
> 
> When all relevant options are enabled about 1.5 kb:
> old x86_64:  Boot sector 512 bytes. / Setup is 7394 bytes.
> new x86_64:  Setup is 9672 bytes (padded to 9728 bytes).
> old i386:  Boot sector 512 bytes. / Setup is 7649 bytes.
> new i386:  Setup is 9896 bytes (padded to 10240 bytes).
> 
> So the code explosion is not too bad. Although... it is helps quite a
> bit that the old setup contains a chunk of slightly more than 3 kb of
> zeros which has disappeared with the new code. On the other hand, the
> new code provides a valuable debugging tool in the form of a printf
> function.
> 
> $ size arch/i386/boot/setup.elf
>    text    data     bss     dec     hex filename
>    9768      96    6056   15920    3e30 setup.elf
> 
> How much memory should we expect to be available? Is the assert for
> 32 kb for text+data+bss in setup.ld reasonable? Is it guaranteed
> that the bootloader stores the commandline after _end?

Yes, it is, at least by a bootloader that follows protocol.  I don't
know of any bootloader that are out of spec in that regard.

> The amount of code that depends on config options is relatively small.
> Would it make sense to just compile everything independent of config
> options and determine what should be done at run-time? And/or separate
> the bootcode related config-options and put them under EMBEDDED/TINY?

It doesn't, because e.g. Voyager needs special A20 code, etc.  I guess
we could dynamically detect Voyager and then do that, but that would
require testing.

> If space is not that much of an issue, could you imagine putting
> the decompression/relocation/misc.c code in setup too? This would
> make it easier to start thinking of a new kernel image format without
> breaking bootloaders that use a bzImage in the intended way.

I don't think that's either desirable or practical.  That code really
wants ready addressability of the whole image.

	-hpa
