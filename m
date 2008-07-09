Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbYGIIwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbYGIIwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 04:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbYGIIwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 04:52:03 -0400
Received: from ns2.suse.de ([195.135.220.15]:46066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910AbYGIIwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 04:52:00 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: "Brown, Len" <len.brown@intel.com>
Subject: Re: Check for BIOS bugs - Original Subject: Re: [PATCH 23/70] ACPICA: Workaround for reversed _PRT entries from BIOS
Date: Wed, 9 Jul 2008 10:51:55 +0200
User-Agent: KMail/1.9.9
Cc: "Arjan van de Ven" <arjan@linux.intel.com>, "Pavel Machek" <pavel@suse.cz>,
       "Len Brown" <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       "Moore, Robert" <robert.moore@intel.com>,
       "Lin, Ming M" <ming.m.lin@intel.com>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Huang Cheng" <cheng.huang@intel.com>, firmwarekit-discuss@bughost.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <1213947852-10924-1-git-send-email-lenb@kernel.org> <48738A65.9060905@linux.intel.com> <960B77DF2E6D974DBE24FD066EAEE8DAD90886@azsmsx422.amr.corp.intel.com>
In-Reply-To: <960B77DF2E6D974DBE24FD066EAEE8DAD90886@azsmsx422.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807091051.57322.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2008 21:34:55 Brown, Len wrote:
> >>>> Some BIOSs erroneously reverse the _PRT SourceName and the
> >>>> SourceIndex.  Detect and repair this problem. MS ACPI also allows
> >>>> and repairs this problem, thus ACPICA must also.
> >>>
> >>> It would be great to have an interface to report this as a
> >
> >BIOS defect.
> >
> >>> Something like:
> >>>
> >>> FIRMWARE_BUG_ON(FIRM_WARN, "erroneously reversed the _PRT
> >
> >source_name", ACPI_
> >
> >>> Bug);
> >>>
> >>> FIRMWARE_BUG_ON(severity, description, component);
> >>
> >> Yes, please.
>
> I'm not excited about maintaining
> maintaining linux-as-a-firmware-diagnostic --
> particularly when...
Above is not for ACPI only. But ACPI is probably a candidate which should make 
use of it.
>
> 1. it clutters the code for normail machines
It is the only disadvantage, "cluttering" the code.
On the other hand, this is an advantage.
While comments like "/* this must not happen, out of spec, etc. */"
should normally be added,
kernel developers tend to return -ENODEV and that's it.
A FIRMWARE_BUG("Description") would be compiled out on a
production kernel, compiled in for a kernel on which linuxfirmwarekit
boots or other debug kernels and would nicely document,
not clutter the code.

> 2. finding the bug is pointless,
No.
> because even 
>    if you fix one machine, you are guaranteed to
>    not fix all machines and thus must maintain
>    the workaround anyway.
I expect you want HP to fix their critical shut down temperature of 256 C?
If we would have known this, we had made them fix this and a lot other things 
also.
This is one of dozens of examples...

> >> I'd also like HARDWARE_BUG_ON(), with similar usage.
> >>
> >> With all the preload-linux-on-foo project, we have some
> >> chance to make
> >> BIOS vendors fix their stuff if we can easily diagnose errors in
> >> there.
>
> These customers should be running
> http://linuxfirmwarekit.org/
It is not worth much.
At least currently and a firmware bug interface to the kernel is about to 
change this.

1) linuxfirmwarekit is parsing dmesg..., these messages are changing
    all the time in the kernel.
    S390 AFAIK currently indexes all printks to avoid a simple space cleanup
    to mix up messges. It is not needed to go that far...
2) The rest is done through userspace plugins written in shell/perl or C.
     But most firmware bugs are absorbed by the kernel already. So there
     is nothing we could tell OEMs they should correct.
3) 2+3 is unmaintainable. There is enough work in the kernel, now we should
    write a linuxfirmwarekit plugin for every firmwarebug we find?!?
4) I tried to convince our kernel people to write linuxfirmwarekit plugins
     with exactly zero response. Hmm wrong, Frank wrote a thermal zone
    checker, some hundred lines of fragile shell code, it would have been less
    than ten lines in the kernel, just add some FIRMWARE_BUG(..) in the right
    if/else conditions. And it's not worth much anymore as soon as
    thermal_zone is moving to sysfs.

> We do maintain some degree of "high-road ACPI spec checking"
> with the "acpi=strict" boot option.  If we do more of this,
> I think it should stay under that option.
In the linuxfirmwarekit the ACPI tables are dumped, disassembled and 
recompiled. The errors and warnings are printed out as ACPI BIOS errors.
This works out.
The iasl compiler still is a bit too noisy and cannot disassemble SSDTs 
correctly (maybe it got fixed, don't know), but this can work out.

The problem is that you only find syntactical bugs.
But there are *a lot* bugs like e.g. critical temperature of 256 C. Or If this 
object exists, that object must exist. Logic ACPI BIOS bugs can only be found 
in the kernel itself at runtime.
Ahh Bjorn is in CC..., Wrong opregion declarations and PNP resource 
declarations are rather common. I mean theoretically you can find this in 
userspace. Not with disassembling and recompiling but with interpreting the 
tables in userspace... Again unmaintainable and who should do the checking?
The guy who writes the kernel code...

I really like the idea of the linuxfirmwarekit and tried to push it, but I do 
not see any future for it without kernel support.

       Thomas
