Return-Path: <linux-kernel-owner+w=401wt.eu-S1763704AbXHVOmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763704AbXHVOmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 10:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757638AbXHVOmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 10:42:00 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39613 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386AbXHVOl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 10:41:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, Aaron Durbin <adurbin@google.com>
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
References: <1187313920.28497.1.camel@caritas-dev.intel.com>
	<46C5C8C4.4060407@zytor.com>
	<1187580031.27947.67.camel@caritas-dev.intel.com>
	<46C9CB89.7020603@zytor.com> <20070821113310.GF32640@bingen.suse.de>
	<46CAC168.7090102@zytor.com> <20070821114548.GI32640@bingen.suse.de>
	<86802c440708211658j1fb2a8caj41e1bb8bffa4baf4@mail.gmail.com>
	<20070822012216.GN32640@bingen.suse.de>
	<86802c440708212343x3b1438d3m4bbbfbd04db1f1ef@mail.gmail.com>
	<20070822111155.GP32640@bingen.suse.de>
Date: Wed, 22 Aug 2007 08:41:27 -0600
In-Reply-To: <20070822111155.GP32640@bingen.suse.de> (Andi Kleen's message of
	"Wed, 22 Aug 2007 13:11:55 +0200")
Message-ID: <m1absjpr6w.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

> On Tue, Aug 21, 2007 at 11:43:38PM -0700, Yinghai Lu wrote:
>> On 8/21/07, Andi Kleen <ak@suse.de> wrote:
>> > > current LinuxBIOS's path: the elfboot in LinuxBIOS will prepare the
>> > > e820 table, and jump to startup_32 in kernel. is that not good and
>> > > simple?
>> >
>> > The problem is that the zero page cannot be changed at all in this
>> > setup. Or rather it can be only changed by breaking LinuxBios.
>> 
>> So you want to construct e820 table in x86_boot_params from LinuxBIOS
>> memmap in head64.c?
>
> The short term fix is probably to just add a version number to
> the zero page and make sure new changes only add stuff to the
> end and the kernel has reasonable compat code for old versions.
>
> Then LinuxBIOS would need to be changed to supply that version number.

To clear up a small misconception.  It isn't LinuxBIOS but the LinuxBIOS
bootloaders that need to be changed.  A subtle distinction. 

> Perhaps it could also include a checksum just to detect old BIOS
> that don't supply a version number.
>
> Long term I'm not sure. Adding LinuxBIOS specific tables also doesn't
> sound very attractive.

Second thinking of this as the empty_zero_page is probably the wrong
mental model of how things work.

At least until HPA's recent changes bzImage is organized as follows:

bootsector (512 bytes)
Various boot protocol variables.
  Some filled in or read by bootloaders 
  some filled in by the real mode code.
real mode code.
32bit Data+Code to load at 1MB.

The empty zero page really is the first 4K or whatever of
the current setup.S.  Any sane bootloader loading the bzImage
will just load the 16bit portion and overwrite the variables
it knows how to fill in.

To ensure there was enough space the code did:

> trampoline:    call    start_of_setup
>                .align 16
>                                        # The offset at this point is 0x240
>                .space  (0xeff-0x240+1) # E820 & EDD space (ending at 0xeff)

We already have the boot protocol revision and if this is something we
are going to support that should be enough of a revision field.  If
the bootloader can't support what the kernel is doing the bootloader
should just give up.  We have major and minor fields there so we can
distinguish between compatible and incompatible changes as well.

Further that arrangement ensures all of the data fields are initialized.

Further there is no 4K limit when used that way except as a convention
and as an implementation detail.  The bootloaders don't care.  The
have to load all of the 16bit real mode section.

I need to review HPA changes a little more from his rewrite in C.
I think he messed up with the guarantee of initialization in that
rewrite, but I'm not quite certain.

Eric

