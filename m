Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbYAQWSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbYAQWSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbYAQWSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:18:00 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:21516 "EHLO
	outbound3-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752317AbYAQWR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:17:59 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Date: Thu, 17 Jan 2008 23:16:42 +0100
From: "Andreas Herrmann3" <andreas.herrmann3@amd.com>
To: "Ingo Molnar" <mingo@elte.hu>
cc: "Venki Pallipadi" <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug
 fixes
Message-ID: <20080117221642.GF12631@alberich.amd.com>
References: <20080116023955.597433000@intel.com>
 <20080116185748.GA11244@alberich.amd.com>
 <20080116203328.GA17869@linux-os.sc.intel.com>
 <20080117191211.GA12631@alberich.amd.com>
 <20080117203600.GB27778@elte.hu>
 <20080117210301.GC12631@alberich.amd.com>
 <20080117211308.GA7858@elte.hu>
 <20080117214228.GD12631@alberich.amd.com>
MIME-Version: 1.0
In-Reply-To: <20080117214228.GD12631@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Jan 2008 22:16:27.0094 (UTC)
 FILETIME=[9A4E4760:01C85956]
X-WSS-ID: 6B910C3407S8366567-12-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 10:42:28PM +0100, Andreas Herrmann3 wrote:
> On Thu, Jan 17, 2008 at 10:13:08PM +0100, Ingo Molnar wrote:
> > 
> > * Andreas Herrmann3 <andreas.herrmann3@amd.com> wrote:
> > 
> > > Yes.
> > > 
> > > Meanwhile I have figured out that it is some ACPI stuff that maps the 
> > > page cached. I've changed the ioremap's in drivers/acpi/osl.c to 
> > > ioremap_nocache. See attached patch.
> > > 
> > > Now the machine boots without conflicts.
> > 
> > ah, nice!
> > 
> > but in general we must be robust enough in this case and just degrade 
> > any overlapping page to UC (and emit a warning perhaps) - instead of 
> > failing the ioremap and thus failing the driver (and the bootup).
> > 
> > Does my third patch (which falls back to UC in case of attribute 
> > conflicts, also attached below) instead of your ioremap_nocache() patch 
> > solve your bootup problem too?
> 
> I'll check this asap

Ok, here is the result:

sata_sil 0000:00:12.0: version 2.3
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level, low) -> IRQ 22
ioremap_nocache: addr c0403000, size 200
swapper:1 conflicting cache attribute c0403000-c0404000 uncached<->default
Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
 [<ffffffff8102905d>] ? reserve_mat
1a5/0x221
PGD 0 
Oops: 0000 [1] SMP 
CPU 3 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.24-rc8-gd294e9ed-dirty #1
RIP: 0010:[<ffffffff8102905d>]  [<ffffffff8102905d>] ? reserve_mattr+0x1a5/0x221
RSP: 0018:ffff810077581c60  EFLAGS: 00010282
RAX: 000000000000004e RBX: ffff8100775a7a00 RCX: 0000000000004c12
RDX: 000000000000a9a9 RSI: 0000000000000018 RDI: ffffffff8153bed4
RBP: 0000000000000000 R08: ffffffff81540fe7 R09: ffffffff81329d70
R10: 0000000000000000 R11: 0000000000000000 R12: 00000000c0404000
R13: 0000000000000018 R14: 00000000c0403000 R15: 00000000c0403000
FS:  0000000000000000(0000) GS:ffff8100775d6bc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001001000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff810077580000, task ffff810077564790)
Stack:  ffffffff81411900 0000000000001000 0000000000001000 00000000c0404000
 ffffc200008ac000 00000000c0403000 ffff8100775a7a40 ffffffff810281e9
 0000000000000018 0000000000000005 ffff810077631680 ffff8100777b7800
Call Trace:
 [<ffffffff810281e9>] __ioremap+0xc2/0x11a
 [<ffffffff8114a6b0>] pcim_iomap+0x43/0x53
 [<ffffffff8114a74f>] pcim_iomap_regions+0x8f/0x104
 [<ffffffff811fba72>] sil_init_one+0xb0/0x1eb
 [<ffffffff81150f98>] pci_device_probe+0xd1/0x138
 [<ffffffff811a4d9c>] driver_probe_device+0xe1/0x16a
 [<ffffffff811a4f6d>] __driver_attach+0x90/0xcd
 [<ffffffff811a4edd>] __driver_attach+0x0/0xcd
 [<ffffffff811a4edd>] __driver_attach+0x0/0xcd
 [<ffffffff811a4149>] bus_for_each_dev+0x43/0x6e
 [<ffffffff811a44c9>] bus_add_driver+0x77/0x1be
 [<ffffffff8115116e>] __pci_register_driver+0x58/0x8a
 [<ffffffff814d2634>] kernel_init+0x170/0x2e0
 [<ffffffff8100cb58>] child_rip+0xa/0x12
 [<ffffffff814d24c4>] kernel_init+0x0/0x2e0
 [<ffffffff8100cb4e>] child_rip+0x0/0x12


Code: 00 49 89 c9 48 81 c6 e0 02 00 00 48 89 3c 24 31 c0 4d 89 e0 4c 89 f1 48 c7 c7 c3 97 3e 81 e8 71 ef 00 00 48 c7 43 10 18 00 00 00 <48> 83 3c 25 00 00 00 00 00 74 36 48 c7 04 25 00 00 00 00 18 00 
RIP  [<ffffffff8102905d>] ? reserve_mattr+0x1a5/0x221
 RSP <ffff810077581c60>
CR2: 0000000000000000
---[ end trace 5516cbea98bb72f9 ]---
Kernel panic - not syncing: Attempted to kill init!



I should have reviewed your patch.
I guess it must be

  "if (fattr)"  instead of  "if (*fattr)"

I'll give it another try ...


Andreas



