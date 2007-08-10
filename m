Return-Path: <linux-kernel-owner+w=401wt.eu-S934019AbXHJNDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934019AbXHJNDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756685AbXHJNDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:03:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:18045 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997AbXHJNDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:03:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,245,1183359600"; 
   d="scan'208";a="261402838"
Subject: Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
From: "Huang, Ying" <ying.huang@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: Etienne Lorrain <etienne_lorrain@yahoo.fr>, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <200708091901.11146.ak@suse.de>
References: <183884.85434.qm@web26915.mail.ukl.yahoo.com>
	 <200708091251.21726.ak@suse.de>
	 <851fc09e0708090709s4f4fbbf9r91a7300a773f985a@mail.gmail.com>
	 <200708091901.11146.ak@suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 10 Aug 2007 21:03:15 +0800
Message-Id: <1186750995.7841.66.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 10 Aug 2007 13:02:59.0034 (UTC) FILETIME=[C6AA73A0:01C7DB4E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-09 at 19:01 +0200, Andi Kleen wrote:
> > Yes, there is no official 32bit external entry point. But on EFI
> > platform, the 16bit entry point can not be used because there is no
> > 16bit BIOS call available. So, I think it is necessary to define a
> > 32bit external entry point.
> 
> Ok. How do you collect all the data in the zero page then?
> There's much more in there than just the memory map.

Now all the data in the zero page and standard boot protocol are
collected by the EFI bootloader. The EFI bootloader does this through
calling the EFI boot services. If the data is intended to be collected
in kernel setup code, the EFI boot services must be used inside kernel
setup code to collect the data.

> Anyways for EFI the best way is probably to define a EFI entry
> point that does the same work as the real mode code today just
> using EFI services.

So, for booting Linux kernel on EFI platform, the process you proposed
(named process A in the letter) will be as follow:

1. Bootloader loads the Linux kernel image into memory
2. Bootloader setups the parameter defined in standard boot protocol
(need some extension for EFI)
3. Bootloader jumps to kernel EFI 32bit/64bit entry point
4. Kernel EFI setup code collects the data in the zero pages through
calling the EFI boot services
5. Kernel EFI setup code jumps to decompressor entry point
6. Kernel decompressor jumps to kernel entry point (startup_64), which
then jumps to x86_64_start_kernel
7. The EFI memory map is converted to E820 map in x86_64_start_kernel,
and the result is stuffed into zero page.
8. Kernel booting up continues with the E820 map and other data of zero
page.

The process of current EFI implementation (named process B in the
letter) is as follow:

1. Bootloader loads the Linux kernel image into memory
2. Bootloader setups the parameter defined in standard boot protocol
3. Bootloader collects the data in the zero pages through calling the
EFI boot services
4. Bootloader converts EFI memory map to E820 map, the result is stuffed
into zero page.
5. Bootloader jumps to kernel decompressor entry point
6. Kernel decompressor jumpto kernel entry point (startup_64), which
jumps to x86_64_start_kernel
7. Kernel booting up continues with the E820 map and other data of zero
page.

Compares the above two process, we can find that the main difference
lies in:
1. Boot protocol. The process A uses standard boot protocol with some
EFI extension + EFI 32bit. The process B uses the standard boot protocol
+ zero page protocol (which is internal now).
2. In process A, the zero page data setupping and E820 converting are
done by kernel, while in process B, these are done done by bootloader.

The advantages of process A:
1. The zero page protocol can be made internal, so it is more
extensible.

The advantages of process B:
1. The EFI boot support code of Linux kernel is minimal. In fact,
current EFI boot support patch only adds a frame buffer driver. And I do
not see any more needed except some firmware information (ACPI root
pointer, SMBIOS pointer, etc) maybe need to be passed through zero page.

The issues of process A:
1. To support multiple BIOS/bootloader with one kernel binary image,
multiple setup binaries must be integrated into kernel binary image. At
end, the layout of the bzImage of Linux kernel may become as follow:
bootsect + lagacy BIOS setup + EFI32 setup + EFI64 setup + LinuxBIOS
setup + kexec setup + decompressor + vmlinux binary
That is, there is one "setup" for each BIOS type. Because the EFI32 and
EFI64 is not bianry compatible, two EFI setup is needed at least for
i386 kernel.

> And for kexec :- well need a proper protocol.

It seems that the only way for kexec is to use the standard boot
protocol + zero page protocol. If this is true, the zero page protocol
should be made external, so EFI can use it too.

> > > kexec can use the 32bit entry, but only because it is in tree so
it can be fixed
> > > up for any changes.
> > 
> > The kexec uses the 32bit entry point in a user space tool named
> > kexec-tools, not in the kernel.
> 
> Ah i didn't realize this. Ok then kexec is also quite broken.
> Somehow this must have been missed this fundamental flaw when this
code was 
> reviewed.
> 
> > 
> > > If you want to use it you would need to define some versionable
protocol
> > > first similar to the real mode boot protocol. That would require
some work
> > > and some thought to make sure it is forwards and backwards
compatible.
> > 
> > I think at least the following should be done to make it a external
> > boot protocol.
> > 
> > 1. A version number field should be added.
> > 2. The pointers (especially these come from firmware) should be
64bit
> > to make the entry point can be used for both 32bit and 64bit
platform.
> 
> 32bit pointers are not too bad; it needs to be all physical anyways
> because kernel virtual mapping can change any time.

Yes, all pointers should be physical. But some pointers come from
firmware such as ACPI root pointer, EFI system table pointer should be
64bit, because we can not control the actual position pointed to.
 
> > 3. More complete and formal document.
> > 
> > Can you kindly tell me what's more should be done?
> 
> It's a minimum start. But at least for EFI I still think it's better
> to just move that code back into the kernel. Just cleanly separated.

Best Regards,
Huang Ying
