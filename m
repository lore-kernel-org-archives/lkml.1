Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbYJNUOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbYJNUOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYJNUNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:13:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752483AbYJNUNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:13:50 -0400
Date: Tue, 14 Oct 2008 13:13:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [2.6.26 Power5 64bit] oops in ._spin_unlock_irqrestore
Message-Id: <20081014131312.924d7a2e.akpm@linux-foundation.org>
In-Reply-To: <20081010140622.GA22427@vanheusden.com>
References: <20081010140622.GA22427@vanheusden.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

> On Fri, 10 Oct 2008 16:06:23 +0200 Folkert van Heusden <folkert@vanheusden.com> wrote:
> Hi,
> 
> While running my modrobe/rmmod script I got the following oops on a
> Linux LPAR on a Power5 system:
> 
> [ 1867.960287] ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 (April 24, 2007)
> [ 1867.961133] ipr 0000:c0:01.0: Found IOA with IRQ: 321
> [ 1867.967519] ipr 0000:c0:01.0: Initializing IOA.
> [ 1867.979202] Unable to handle kernel paging request for data at address 0xd00000000012b838
> [ 1867.979220] Faulting instruction address: 0xc0000000002de1c8
> [ 1867.979232] Oops: Kernel access of bad area, sig: 11 [#1]
> [ 1867.979243] SMP NR_CPUS=32 NUMA pSeries
> [ 1867.979265] Modules linked in: ipr(+) loop windfarm_max6690_sensor sr_mod sg evdev snd_pcm snd_timer snd_hwdep compat_ioctl32 serio libps2 dm_log cdrom snd_usb_lib snd_page_alloc libata firmware_class snd_rawmidi snd_seq_device videodev dm_mod v4l1_compat ipv6 snd soundcore ibmveth ext3 jbd mbcache sd_mod ibmvscsic scsi_transport_srp scsi_tgt scsi_mod windfarm_smu_sat windfarm_cpufreq_clamp windfarm_core [last unloaded: atkbd]
> [ 1867.979488] NIP: c0000000002de1c8 LR: d000000000130878 CTR: c0000000002de1a8
> [ 1867.979500] REGS: c0000000fc40fb40 TRAP: 0300   Not tainted  (2.6.26-1-powerpc64)
> [ 1867.979510] MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24000022  XER: 20000001
> [ 1867.979533] DAR: d00000000012b838, DSISR: 0000000040000000
> [ 1867.979543] TASK = c0000000fbc1d620[959] 'kseriod' THREAD: c0000000fc40c000 CPU: 7
> [ 1867.979554] GPR00: d000000000130878 c0000000fc40fdc0 c0000000005f9578 d00000000012b830
> [ 1867.979583] GPR04: 0000000000000000 d00000000012b830 c0000000005dc458 c00000000000ffa0
> [ 1867.979602] GPR08: c0000000fc40faf0 0000000000000003 d000000000134048 c0000000002de1a8
> [ 1867.979637] GPR12: d000000000130ca8 c000000000624200 0000000000000000 0000000000000000
> [ 1867.979678] GPR16: 0000000000000000 0000000000000000 0000000000000000 4000000001c00000
> [ 1867.979715] GPR20: c0000000005200c0 0000000002120330 00000000006b6000 c000000000520330
> [ 1867.979743] GPR24: 00000000021200c0 c000000000628a30 c00000000051ed28 0000000000000000
> [ 1867.979782] GPR28: 0000000000000001 c0000000fb61a540 c00000000059e558 d00000000012b7e0
> [ 1867.979813] NIP [c0000000002de1c8] .driver_attach+0x20/0x40
> [ 1867.979839] LR [d000000000130878] .serio_thread+0x1fc/0x42c [serio]
> [ 1867.979869] Call Trace:
> [ 1867.979881] [c0000000fc40fdc0] [c0000000003d8624] ._spin_unlock_irqrestore+0x50/0x64 (unreliable)
> [ 1867.979927] [c0000000fc40fe40] [d000000000130878] .serio_thread+0x1fc/0x42c [serio]
> [ 1867.979955] [c0000000fc40ff00] [c0000000000890f8] .kthread+0x78/0xc4
> [ 1867.979979] [c0000000fc40ff90] [c0000000000252ac] .kernel_thread+0x4c/0x68
> [ 1867.980015] Instruction dump:
> [ 1867.980028] eb81ffe0 eba1ffe8 7c0803a6 4e800020 7c0802a6 fbc1fff0 ebc2b670 7c651b78
> [ 1867.980070] 38800000 f8010010 f821ff81 e8de8010 <e8630008> 4bfff5e1 60000000 38210080
> [ 1867.985180] ---[ end trace 16968366a5589005 ]---
> 
> The trigger script can be found here: http://www.vanheusden.com/pyk/
> 

It looks more like a bug in the input code than powerpc.
