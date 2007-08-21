Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbXHUJ1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbXHUJ1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 05:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbXHUJ0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 05:26:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64803 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbXHUJ0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 05:26:53 -0400
Message-ID: <012101c7e3d5$492d4030$b4fefea9@andrey>
From: "Andrey Kamchatnikov" <andrey.kamchatnikov@tec-venture.de>
To: <linux-kernel@vger.kernel.org>
Subject: SDRAM problem
Date: Tue, 21 Aug 2007 11:25:58 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Provags-ID: V01U2FsdGVkX18DM6XaUT0GnQ4henkA5DEAdnY3whCGS37WIvi
 5AuYayRWwiD0+utIQeKAEMeXybmU3dLuUR12UpL/uBUdXw/gzO
 h8BSwq+d8Vrm4Z0LaDoSW9dyUbgpxZHbxkD3O/1j0AxTsCcIaQ
 P2A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have CPU - Intel PXA255, Linux-2.6.17, 4 SDRAM 2Mx16x4 (32Mb at one CS, 
32MB at another). The problem is that there is a gap in 32Mb between two 
SDRAMs. If I write in booting string mem=64M and work with a file bigger 
then 20Mb, then Linux crash has occured. As I understand correct, the second 
SDRAM is not available.

I tried in the boot command line the next strings: "mem=32M at 0xa0000000 
mem=32M at 0xa4000000",
"mem=32M@0xa0000000 mem=32M@0xa4000000"

I tried also to add to mashine start routine:

static void __init fixup_my(struct machine_desc *desc,
                struct tag *tags, char **cmdline, struct meminfo *mi)
{
        mi->bank[0].start = 0xa0000000;
        mi->bank[0].size = (32*1024*1024);
        mi->bank[0].node = 0;

        mi->bank[1].start = 0xa4000000;
        mi->bank[1].size = (32*1024*1024);
        mi->bank[1].node = 1;

        mi->nr_banks=2;
}

MACHINE_START(My, MACHINE_NAME)
        .phys_io        = PXA_PHYS_IO_BASE,
        .io_pg_offst    = (PXA_IO_BASE >> 18) & 0xfffc,
        .fixup          = fixup_my,
        .boot_params    = PHYS_OFFSET+0x1000,
        .map_io         = my_map_io,
        .init_irq       = pxa_init_irq,
        .timer          = &pxa_timer,
        .init_machine   = my_init,
MACHINE_END

but did not get any successful results. My board loaded completly, correctly 
recognizes 64MB memory but available only 32MB (see next strings below):

Memory: 32MB 32MB = 64MB total
Memory: 29660KB available (2248K code, 415K data, 100K init)


I have read somewhere about ARCH_DISCONTIGMEM_ENABLE flag, which must be 
activated. But loading stoped at the next string (see below)

RedBoot> fis load linux
RedBoot> exec
Using base address 0xa0108000 and length 0x00180000
Uncompressing 
Linux....................................................................................... 
done, booting the kernel.
Linux version 2.6.17-my (root@linux) (gcc-Version 3.4.3) #1180 Fri Aug 10 
09:17:33 CEST 2007
CPU: XScale-PXA255 [69052d06] revision 6 (ARMv5TE)
Machine: My Board
Warning: bad configuration page, trying to continue
Ignoring unrecognised tag 0x00000000
Memory policy: ECC disabled, Data cache writeback
Memory clock: 99.53MHz (*27)
Run Mode clock: 199.07MHz (*2)
Turbo Mode clock: 199.07MHz (*1.0, inactive)
CPU0: D VIVT undefined 5 cache
CPU0: I cache: 32768 bytes, associativity 32, 32 byte lines, 32 sets
CPU0: D cache: 32768 bytes, associativity 32, 32 byte lines, 32 sets
Built 2 zonelists
Kernel command line: init=/linuxrc root=1f02 rootfstype=jffs2 ro 
console=ttyS2,38400
PID hash table entries: 512 (order: 9, 2048 bytes)
Console: colour dummy device 80x30
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
....

Could someone please  help how to make the second SDRAM workable?

Thanks,

Andy

