Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbYFUBLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbYFUBLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 21:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYFUBK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 21:10:59 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63953 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751260AbYFUBK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 21:10:58 -0400
Date: Sat, 21 Jun 2008 02:09:00 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
In-Reply-To: <20080620122714.GA9332@srcf.ucam.org>
Message-ID: <Pine.LNX.4.55.0806202241120.19614@cliff.in.clinika.pl>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806201353.59083.rjw@sisk.pl>
 <20080620115714.GC8637@srcf.ucam.org> <200806201422.12659.rjw@sisk.pl>
 <20080620122714.GA9332@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008, Matthew Garrett wrote:

> > Ah, indeed, thanks for the hint.  This is the output of
> 
> Right. My recollection of this is somewhat hazy, so here's something I 
> wrote a couple of years ago:
> 
> "If you dig through the DSDT code for the 6125, you'll find a bit where 
> it writes 0x14 to 0xfec00000 and then checks whether offset 0x12 from 
> there is 1. In other words, it's checking if pin 2 of the io-apic is 
> masked. If it's not masked (that is, offset 0x12 is 0 and irq 2 is 
> enabled) it sets another bit in a register. This is then checked by the 
> thermal zone code which as a result sets the thermal trip temperatures 
> to 16 degrees Celsius. This bites when the acpi_skip_timer_override 
> option is used in Linux."
> 
> I have no idea what this code is for, but it's pretty clear that Windows 
> sets it up in such a way that this isn't true.

 Thanks, that is a very useful insight indeed.  I went through the effort
to locate a DSDT dump for the nx6325.  Here are the relevant parts, first
the definition:

OperationRegion (C253, SystemMemory, 0xFEC00000, 0x14)
Field (C253, ByteAcc, NoLock, Preserve)
{
    C08B,   8,
    Offset (0x10),
    Offset (0x12),
    C08C,   1
}

So now we have got a block defined, which corresponds to the location of
the I/O APIC and is 0x14 bytes long.  That is not top quality code, I
would say, but surely it achieves what it is meant to.  Within that block 
two fields are defined:

1. An 8-bit one at the byte offset 0 -- that corresponds to the index
   register.

2. A 1-bit one at the byte offset 0x12 -- that corresponds to the bit #16 
   of the data register, which for redirection entries is the mask 
   register.

 And then we have a method elsewhere, which uses the above definition:

Method (_INI, 0, NotSerialized)
{
    C084 ()
    Store (0x00, \_SB.C074.C089.C08A)
    Store (0x14, C08B)
    If (LEqual (C08C, 0x00))
    {
        Store (0x01, \_SB.C074.C089.C08A)
    }
}

_SB.C074.C089.C08A refers to a piece of 8-bit data at an offset of 0xf0 
accessed through an index and data registers located at 0x72 and 0x73 in 
the port I/O space.  That's probably an extended part of the NVRAM 
associated with the RTC.

 That location is referred from two places as follows:

If (LEqual (\_SB.C074.C089.C08A, 0x01))
{
    Store (0x0B4B, Local2)
}

which is obviously that 16C trip point mentioned, overriding the result 
of the method obtained from the respective device in the usual way, and:

If (LEqual (\_SB.C074.C089.C08A, 0x00))
{
    \_SB.C074.C0E3.C149.C195 (0x00)
}

elsewhere which sets a location in the embedded controller which seems
related to battery control.  Overall my guts feeling is it's some
debugging or leftover code meant for a different configuration.

 This is further confirmed by another block defined next to the one quoted
above:

OperationRegion (C254, SystemIO, 0x21, 0x01)
Field (C254, ByteAcc, NoLock, Preserve)
{
    C255,   1
}

which quite similarly defines a mask for the 8254 timer interrupt in the
master 8259A.  This is nowhere used though -- any references may have been
removed with the I/O APIC part not adjusted accordingly.  Note that the
I/O APIC mask defined above is not quite a mask for the 8254 timer
interrupt in this system (as it is the ExtINTA 8259A cascade), but it is a
common location for one.

 Anyway, it's clear it's firmware that is at fault here and not hardware.  
There are actually two bugs -- first is described above and the other one
is the IRQ0 override, which is clearly incorrect.  The piece of hardware
comes from a reputable vendor, so it should be possible to submit a bug
report for the firmware.  Anybody happens to know the appropriate contact?

 Meanwhile we may consider implementing a workaround.  I think one that 
does not hurt competent vendors would be preferable.  The DSDT containing 
the rubbish described here is marked with an OEM ID: "HP    " and OEM 
Table ID: "SB400".  These keys could be used to remove IRQ0 information
from the IRQ tables.  Our code is prepared to handle such a case.  
Something easy to do for a seasoned ACPI fiddler, I suppose. ;)

 Windows does not trigger this bug, because it stays away from the 8254 on 
APIC platforms and uses the RTC for the timer instead I am told.

  Maciej
