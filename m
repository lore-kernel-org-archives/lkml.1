Return-Path: <linux-kernel-owner+w=401wt.eu-S1751293AbXAaHxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbXAaHxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 02:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbXAaHxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 02:53:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:39825 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbXAaHxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 02:53:38 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Jan Kasprzak <kas@fi.muni.cz>
Subject: Re: No mptable found (Tyan h1000E)
Date: Wed, 31 Jan 2007 02:52:16 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20070130231617.GP29697@fi.muni.cz>
In-Reply-To: <20070130231617.GP29697@fi.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701310252.16653.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 January 2007 18:16, Jan Kasprzak wrote:
> 	Hello,
> 
> 	I have a Tyan h1000E (S3970) dual-socket board, with two
> dual-core AMD Athlon 2210 CPUs (4 cores total). The problem is
> that the kernel apparently cannot detect the SMP configuration
> (after boot, /proc/cpuinfo lists only one processor).
> The full dmesg output is available at
> 
> http://www.fi.muni.cz/~kas/tmp/dmesg-h1000E.txt

ACPI: RSDP (v002 ACPIAM                                ) @ 0x00000000000f7700
ACPI: XSDT (v001 A M I  OEMXSDT  0x10000605 MSFT 0x00000097) @ 0x00000000bfff0100
ACPI: FADT (v003 A M I  OEMFACP  0x10000605 MSFT 0x00000097) @ 0x00000000bfff0290
ACPI: OEMB (v001 A M I  AMI_OEM  0x10000605 MSFT 0x00000097) @ 0x00000000bfffe040
ACPI: SRAT (v001 AMD    HAMMER   0x00000001 AMD  0x00000001) @ 0x00000000bfff3420
ACPI: SSDT (v001 A M I  POWERNOW 0x00000001 AMD  0x00000001) @ 0x00000000bfff34e0
ACPI: DSDT (v001  0AAAA 0AAAA000 0x00000000 INTL 0x02002026) @ 0x0000000000000000

This board appears to have no APIC (MADT) table -- which is what Linux uses to enumerate processors
in ACPI mode.  (doesn't have MPS either, but in ACPI mode you wouldn't use it anyway).

Are there any BIOS SETUP settings for enabling SMP or ACPI features?

I guess that /proc/interrupts shows this system running in PIC mode?

Please open a bugzilla here and attach the output from acpidump.
http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
Component: Config-Processors

Any chance you can see if Windows finds multiple processors on this board with this version of the BIOS?

This system may be proof that Linux needs to parse the DSDT to properly enumerate processors.
Though it is somewhat strange to have an SMP without an IOAPIC...

thanks,
-Len

ps. after you get the acpidump for the failing system, check for a BIOS update.

> The most interesting parts of it are probably these (with my comments
> inline marked by "---"):
> 
> [...]
> SRAT: PXM 0 -> APIC 0 -> Node 0
> SRAT: PXM 0 -> APIC 1 -> Node 0
> SRAT: PXM 1 -> APIC 2 -> Node 1
> SRAT: PXM 1 -> APIC 3 -> Node 1
> --- So the kernel can see all four APICs.
> [...]
> Bootmem setup node 0 0000000000000000-00000000bfff0000
> No mptable found.
> --- the above does not depend on MPS 1.1 or 1.4 settings in the BIOS
> [...]
> Kernel command line: ro root=/dev/md0 console=ttyS0,38400n8
> Initializing CPU#0
> PID hash table entries: 4096 (order: 12, 32768 bytes)
> Console: colour VGA+ 80x25
> Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> Checking aperture...
> CPU 0: aperture @ e8000000 size 128 MB
> CPU 1: aperture @ e8000000 size 128 MB
> --- the kernel knows something about CPU1 (presumably the second core of CPU0).
> [...]
> CPU 0/0 -> Node 0
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> SMP alternatives: switching to UP code
> Freeing SMP alternatives: 32k freed
> ACPI: Core revision 20060707
> ACPI: setting ELCR to 0200 (from 0e20)
> weird, boot CPU (#0) not listed by the BIOS.
> SMP motherboard not detected.
> Using local APIC timer interrupts.
> result 12469270
> Detected 12.469 MHz APIC timer.
> testing NMI watchdog ... OK.
> SMP disabled
> --- hmm, no SMP configuration detected after all.
> Brought up 1 CPUs
> testing NMI watchdog ... OK.
>                       ^^^ here it waits for few seconds before printing "OK."
> 
> 	I have tested it with vanilla 2.6.19.2, 2.6.20-rc6, and
> the latest Fedora kernel (2.6.19-1.2895.fc6). I have the latest BIOS
> available for this board, and the BIOS can see all four cores.
> 
> 	How can I make all four cores visible by the Linux kernel?
> Thanks,
> 
> -Yenya
> 
