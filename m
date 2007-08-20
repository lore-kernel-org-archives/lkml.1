Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbXHTDUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbXHTDUS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 23:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbXHTDUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 23:20:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:31995 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbXHTDUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 23:20:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,283,1183359600"; 
   d="scan'208";a="281147230"
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, Aaron Durbin <adurbin@google.com>
In-Reply-To: <46C5C8C4.4060407@zytor.com>
References: <1186990219.22431.37.camel@caritas-dev.intel.com>
	 <20070815154245.500c572c.akpm@linux-foundation.org>
	 <1187250664.15063.0.camel@caritas-dev.intel.com> <46C45B22.5090701@suse.de>
	 <1187313920.28497.1.camel@caritas-dev.intel.com>
	 <46C5C8C4.4060407@zytor.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 20 Aug 2007 11:20:31 +0800
Message-Id: <1187580031.27947.67.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 20 Aug 2007 03:19:54.0602 (UTC) FILETIME=[FA7344A0:01C7E2D8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-17 at 09:11 -0700, H. Peter Anvin wrote:
> Huang, Ying wrote:
> >>
> >> Has the zero page documentation and version numbering project
> >> made any progress? I think we cannot merge this without at least
> >> the version number
> > 
> 
> More than that.  You need to be able to boot a 32-bit kernel on a 64-bit
> system, so anything that breaks that is a nonstarter.  Of course, if EFI
> itself inherently breaks that, then, well, that's just another reason to
> avoid EFI like the plague, but I can't think that even EFI is that broken.

The 32-bit EFI runtime service and 64-bit EFI runtime service is not
binary compatible. So, it is difficult for 32-bit Linux kernel to
support 64-bit EFI runtime service on x86_64 machine with 64-bit EFI
firmware. The 32-bit Linux kernel must switch between 32-bit mode and
64-bit mode before and after calling EFI runtime service. It is a little
complex too for 64-bit Linux kernel to support 32-bit EFI runtime
service on x86_64 machine with 32-bit EFI firmware.

But EFI runtime service is not essential for Linux booting, the Linux
kernel can boot (even operate) normally without EFI runtime service
support.

Summary, on x86_64 machine:

firmware	Linux kernel		boot		runtime service
------------------------------------------------------------------------
EFI-64		32-bit			Yes		No
EFI-64		64-bit			Yes		Yes
EFI-32		32-bit			Yes		Yes
EFI-32		64-bit			Yes		No

So, Why we add support for EFI runtime service? I think there are at
least following reasons:

1. Some legacy hardware (such as CMOS clock) may be replaced silently in
the future when most legacy BIOS is replaced by EFI firmware. With EFI
runtime service, the new hardware can be supported immediately.

2. EFI variable service can be used to store some information cross
rebooting, such as the OOPS information can be saved into flash through
EFI variable service as proposed by Andi Kleen.

3. EFI reboot service can be used to support warm reboot.

The problem remains is that should we support 32-bit EFI runtime service
in 64-bit Linux kernel, or should we support 64-bit EFI runtime service
in 32-bit Linux kernel? I think we can add these supports later if
needed.

> > OK, I will work on the zero page documentation and version numbering
> > project.
> 
> There already is documentation (Documentation/i386/zero-page.txt); as
> far as version numbering, that means sticking in a field with a number,
> and adding a magic number (since there isn't anything that guarantees
> that fields are otherwise zero.)
> 
> Anything that conforms to the updated standard should guarantee
> undefined fields are zero.

Yes. This is necessary for extensibility.

> However, we also have an immediate need to define how to grow past 4K,
> and if we're going to have a major revision in mechanism I would like to
> see that happen now.
> 
> I propose that, in addition to the aforementioned version number and
> magic fields, we add a pointer, which should be the last pointer added
> that doesn't point into I/O space or reserved memory (i.e. memory that
> is off limit anyway for the operating system.)
> 
> This pointer should point to a linked list of suggested form:
> 
> struct setup_data {
> 	u64 next;
> 	u32 type;
> 	u32 len;
> 	u8 data[];
> };
> 
> This can thus encapsulate large objects as necessary, and the early
> kernel entry can linearize them if it needs to move them out of the way.
>  Better yet, this information can be made available to sysfs for
> debuggability, and/or use by kexec.

This is a good interface. It is extensible. In the future, when we need
more boot information, we can just define a new type.

And with this interface, it is not necessary to export the "zero page
protocol" as a external boot protocol (ABI) of the kernel. So, I
proposed that:

1. Keep "zero page" as a internal interface, even make that explicitly
in the document.
2. Increase the version number of standard boot protocol.
3. Append this pointer (pointed to linked list of struct setup_data) to
standard boot protocol.
4. Define a set of types of struct setup_data, each for one zero_page
field.
5. The kernel 16-bit setup code generates "linked list of struct
setup_data" instead of generating "zero page". On machine with BIOS
other than legacy BIOS (such as EFI, LinuxBIOS, etc), the bootloader
(incuding kexec) generates the "linked list of struct setup_data"
instead of generating "zero page" too.
6. In kernel early booting code, the "zero page" is generated from the
"linked list of struct setup_data".
7. In the future, most booting code uses "linked list of struct
setup_data" directly instead of "zero page".

So, we need not define a new boot protocol, just extend the standard
boot protocol. The version number and magic need not to be added to
"zero page". But, at the same time, the bootloader on EFI, LinuxBIOS and
kexec must be changed accordingly.

> I haven't heard anything from the kexec people on this, and they are the
> main users of the PM entrypoint as far as I can tell.
> 
> Also, is there a maintainer for 32-bit EFI?

As far as I know, There is no maintainer for 32-bit EFI.

Best Regards,
Huang Ying
