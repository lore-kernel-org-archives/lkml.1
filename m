Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbYF0MnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbYF0MnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbYF0Mmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:42:51 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:44715 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbYF0Mmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:42:49 -0400
Message-ID: <4864E043.5030706@linux.vnet.ibm.com>
Date: Fri, 27 Jun 2008 18:12:43 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080505)
MIME-Version: 1.0
To: David Woodhouse <david.woodhouse@intel.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel-testers@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh <jaswinder@infradead.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: linux-next: Tree for June 26
References: <20080627010842.e1a0c4b5.sfr@canb.auug.org.au> <200806270138.53895.rjw@sisk.pl> <1214563913.10393.180.camel@pmac.infradead.org>
In-Reply-To: <1214563913.10393.180.camel@pmac.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Fri, 2008-06-27 at 01:38 +0200, Rafael J. Wysocki wrote:
>> commit 423c982fffb1cd95c8cdd654ce5ab59351ba41f5
>> Author: Jaswinder Singh <jaswinder@infradead.org>
>> Date:   Wed Jun 18 19:58:33 2008 +0530
>>
>>     firmware: convert tg3 driver to request_firmware()
>>
>> breaks my nx6325.
>>
>> Apparently, with this patch applied the tg3 has a NULL pointer dereference
>> somewhere, but I can only see the first line of the oops, afterwards the box
>> hangs solid.
> 
> That's a 5705, isn't it? So using the 'tso5' firmware?
> 
> Is that firmware available (did you either build it into your kernel, or
> run 'make INSTALL_FW_PATH=/lib/firmware firmware_install')? 
> 
> Not that it matters; I suspect the driver isn't trying to load it at
> all. Can you test this patch, please?
> 
> (There are more cleanups I want to do to the error paths here, but those
> should be harmless and irrelevant: http://david.woodhou.se/tg3.patch )
> 
> diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
> index a70147d..bad784b 100644
> --- a/drivers/net/tg3.c
> +++ b/drivers/net/tg3.c
> @@ -12234,11 +12234,6 @@ static int __devinit tg3_init_one(struct pci_dev *pdev,
> 
>  	if (tp->tg3_flags2 & TG3_FLG2_HW_TSO) {
>  		tp->tg3_flags2 |= TG3_FLG2_TSO_CAPABLE;
> -
> -		if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5705)
> -			fw_name = "tigon/tg3_tso5.bin";
> -		else
> -			fw_name = "tigon/tg3_tso.bin";
>  	}
>  	else if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5700 ||
>  	    GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5701 ||
> @@ -12248,6 +12243,13 @@ static int __devinit tg3_init_one(struct pci_dev *pdev,
>  		tp->tg3_flags2 &= ~TG3_FLG2_TSO_CAPABLE;
>  	} else {
>  		tp->tg3_flags2 |= TG3_FLG2_TSO_CAPABLE | TG3_FLG2_TSO_BUG;
> +		printk("this code path would have forgotten to load the firmware\n");
> +	}
> +	if (tp->tg3_flags2 & TG3_FLG2_TSO_CAPABLE) {
> +		if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5705)
> +			fw_name = "tigon/tg3_tso5.bin";
> +		else
> +			fw_name = "tigon/tg3_tso.bin";
>  	}
> 
>  	if (fw_name) {
> 
Hi David,

Thanks, the patch fixes the kernel panic on x86_64 boxes. (the panic message
is listed below)

Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff803be1e8>] tg3_reset_hw+0xf48/0x154b
PGD add0067 PUD ad1a067 PMD 0 
Oops: 0000 [1] SMP 
last sysfs file: /sys/class/net/eth1/address
CPU 2 
Modules linked in: battery ac lp parport_pc parport nvram amd_rng rng_core i2c_amd756 i2c_core pcspkr button
Pid: 1919, comm: ip Not tainted 2.6.26-rc8-next-20080627-autotest #1
RIP: 0010:[<ffffffff803be1e8>]  [<ffffffff803be1e8>] tg3_reset_hw+0xf48/0x154b
RSP: 0018:ffff81000ad21d38  EFLAGS: 00010246
RAX: 000000000040a026 RBX: 000000000001f800 RCX: 0000000000000000
RDX: 0000000000000006 RSI: 0000000000005400 RDI: ffff81003d4e8740
RBP: ffff81003d4e8740 R08: 0000000000000002 R09: 0000000000000008
R10: 0000000000000009 R11: ffffffff804773d9 R12: 0000000001000008
R13: 00000000000003fe R14: ffff81003d4e8748 R15: 0000000000000000
FS:  00007f600a2586f0(0000) GS:ffff81003f99e800(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000008 CR3: 000000000c0c6000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ip (pid: 1919, threadinfo ffff81000ad20000, task ffff81003d519db0)
Stack:  ffff81003d4e8740 0000000000000074 0000000000000028 ffff000880340430
 ffff81003d4e8740 ffff81003d4e8800 ffff81003d4e8740 0000000000001002
 0000000000000000 ffff81003d4e8748 ffff81003d4e8000 ffffffff803c2a7a
Call Trace:
 [<ffffffff803c2a7a>] tg3_open+0x29a/0x5e8
 [<ffffffff80317af4>] selinux_capable+0x87/0x90
 [<ffffffff80486e13>] dev_open+0x6b/0x9e
 [<ffffffff80484fd8>] dev_change_flags+0xa6/0x15d
 [<ffffffff804c42ed>] devinet_ioctl+0x243/0x59e
 [<ffffffff80278baf>] handle_mm_fault+0x32b/0x6a5
 [<ffffffff80479488>] sock_ioctl+0x1d4/0x1f8
 [<ffffffff8029eb09>] vfs_ioctl+0x21/0x6b
 [<ffffffff8029edaf>] do_vfs_ioctl+0x25c/0x275
 [<ffffffff8029ee19>] sys_ioctl+0x51/0x70
 [<ffffffff8020bcfb>] system_call_after_swapgs+0x7b/0x80


Code: ef e8 63 a0 ff ff 8b 85 88 07 00 00 a8 20 0f 84 06 01 00 00 a9 00 00 01 08 0f 85 fb 00 00 00 48 8b 8d 48 0b 00 00 be 00 54 00 00 <48> 8b 51 08 8b 42 04 48 83 c2 0c 0f c8 89 04 24 8b 01 b9 00 40 
RIP  [<ffffffff803be1e8>] tg3_reset_hw+0xf48/0x154b
 RSP <ffff81000ad21d38>
CR2: 0000000000000008
---[ end trace beeca7990caa7b8a ]---
Kernel panic - not syncing: Aiee, killing interrupt handler!
Pid: 1919, comm: ip Tainted: G      D   2.6.26-rc8-next-20080627-autotest #1

Call Trace:
 [<ffffffff802336e3>] panic+0x86/0x144
 [<ffffffff802530a9>] kallsyms_lookup+0x49/0x80
 [<ffffffff803be1e8>] tg3_reset_hw+0xf48/0x154b
 [<ffffffff80234256>] printk+0x4e/0x56
 [<ffffffff80234256>] printk+0x4e/0x56
 [<ffffffff802367d6>] do_exit+0x71/0x67c
 [<ffffffff804fdbe1>] oops_begin+0x0/0x8c
 [<ffffffff804ffafb>] do_page_fault+0x77b/0x834
 [<ffffffff804fd829>] error_exit+0x0/0x51
 [<ffffffff804773d9>] pci_conf1_write+0x0/0xdb
 [<ffffffff803be1e8>] tg3_reset_hw+0xf48/0x154b
 [<ffffffff803be0b3>] tg3_reset_hw+0xe13/0x154b
 [<ffffffff803c2a7a>] tg3_open+0x29a/0x5e8
 [<ffffffff80317af4>] selinux_capable+0x87/0x90
 [<ffffffff80486e13>] dev_open+0x6b/0x9e
 [<ffffffff80484fd8>] dev_change_flags+0xa6/0x15d
 [<ffffffff804c42ed>] devinet_ioctl+0x243/0x59e
 [<ffffffff80278baf>] handle_mm_fault+0x32b/0x6a5
 [<ffffffff80479488>] sock_ioctl+0x1d4/0x1f8
 [<ffffffff8029eb09>] vfs_ioctl+0x21/0x6b
 [<ffffffff8029edaf>] do_vfs_ioctl+0x25c/0x275
 [<ffffffff8029ee19>] sys_ioctl+0x51/0x70
 [<ffffffff8020bcfb>] system_call_after_swapgs+0x7b/0x80



-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
