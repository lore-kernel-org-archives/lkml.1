Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbYGPRQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbYGPRQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 13:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYGPRQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 13:16:04 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:32361 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbYGPRQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 13:16:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HpWuVn68B/kw56NDNmx+ZMQqbd6ml+g4VIEqHt6g0u0LkeCPw92lxmzvnP9LI0CLu2
         yQedB0w6Yid0HOrXSDqvthBBPSCCCEoCOpo2/jxNSpinR45MH6XQgsj6gcPufsr2049c
         jbgUMEnSNfDnhzNfhajXnMtu/nD7L/Y1khaR4=
Date: Wed, 16 Jul 2008 21:13:21 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "MadLoisae@gmx.net" <MadLoisae@gmx.net>
Cc: linux-kernel@vger.kernel.org, santiago@crfreenet.org
Subject: Re: kernel oops with framebuffer device vt8623fb
Message-ID: <20080716171321.GA5146@martell.zuzino.mipt.ru>
References: <487E2911.5090701@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487E2911.5090701@gmx.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 07:00:02PM +0200, MadLoisae@gmx.net wrote:
> I've updated my machine from 2.6.25.11 to 2.6.26 and I think I've found a 
> problem.
>
> If I load the module vt8623fb i get a kernel oops, if the VIA 8623 display 
> framebuffer driver is compiled direct into kernel the system hangs up very 
> early at booting the kernel.

Of course, info->dev is NULL, info was just kzallocated!

Do
	git-revert 20e061fb750d36ec0ffcb2e44ed7dafa9018223b

rebuild, reboot to confirm.

> BUG: unable to handle kernel NULL pointer dereference at 000000b8
> IP: [<c02a39c0>] dev_driver_string+0x0/0x29
> *pde = 00000000
> Oops: 0000 [#1]
> Modules linked in: vt8623fb(+) svgalib vgastate budget_av saa7146_vv 
> videobuf_dma_sg videobuf_core budget_core saa7146 ttpci_eeprom tda10021 
> tda10023 tda1004x
>
> Pid: 3657, comm: modprobe Not tainted (2.6.26 #5)
> EIP: 0060:[<c02a39c0>] EFLAGS: 00010286 CPU: 0
> EIP is at dev_driver_string+0x0/0x29
> EAX: 00000000 EBX: f8e57e00 ECX: 00000010 EDX: 00000004
> ESI: 0000008c EDI: f5fe9c00 EBP: 00000000 ESP: ec041de0
> DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process modprobe (pid: 3657, ti=ec040000 task=ec03d8d0 task.ti=ec040000)
> Stack: f8e56408 f7d44000 c0185b44 f5fe9e34 00000010 04d440b4 000719d4 
> f8e57e90
>       f8e57e60 f7d44000 c02a5daa c0250f4a f7d4404c 00000000 f8e57e90 
> c02a5d34
>       f7d4404c f7d440f4 f8e57e90 c02a5de1 00000000 f8e57e90 f8e57e90 
> c02a560d
> Call Trace:
> [<f8e56408>] vt8623_pci_probe+0x283/0x45b [vt8623fb]
> [<c0185b44>] sysfs_create_link+0x85/0xc5
> [<c02a5daa>] __driver_attach+0x0/0x55
> [<c0250f4a>] pci_device_probe+0x36/0x57
> [<c02a5d34>] driver_probe_device+0xb4/0x12a
> [<c02a5de1>] __driver_attach+0x37/0x55
> [<c02a560d>] bus_for_each_dev+0x34/0x56
> [<c02a5bd0>] driver_attach+0x11/0x13
> [<c02a5daa>] __driver_attach+0x0/0x55
> [<c02a5963>] bus_add_driver+0x8a/0x1a7
> [<c02419f0>] kset_find_obj+0x18/0x40
> [<c02a5f39>] driver_register+0x6d/0xc1
> [<c02510e0>] __pci_register_driver+0x2b/0x57
> [<c012f73f>] sys_init_module+0x14cd/0x161e
> [<c0110b49>] do_page_fault+0x228/0x537
> [<c024265d>] prio_tree_insert+0x1b/0x1dd
> [<f8e4a021>] svga_tilecopy+0x0/0x100 [svgalib]
> [<c01035c1>] sysenter_past_esp+0x6a/0x99
> =======================
> Code: 5a 85 c0 59 79 20 68 24 d7 5d c0 b9 1b 87 4a c0 31 d2 b8 e8 0e 4e c0 
> 53 e8 09 47 e7 ff 5a 59 eb 05 b8 ed ff ff ff 5b c3 90 90 90 <8b> 90 b8 00 
> 00 00 85 d2 75 0a 8b 90 b4 00 00 00 85 d2 74 03 8b
> EIP: [<c02a39c0>] dev_driver_string+0x0/0x29 SS:ESP 0068:ec041de0

