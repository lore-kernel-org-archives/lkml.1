Return-Path: <linux-kernel-owner+w=401wt.eu-S1761148AbYA1OVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761148AbYA1OVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 09:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbYA1OVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 09:21:46 -0500
Received: from mx1.suse.de ([195.135.220.2]:56414 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222AbYA1OVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 09:21:44 -0500
Subject: Re: [PATCH] Allocate pnp resources dynamically via krealloc
	-	working version
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>
In-Reply-To: <479CD935.3070906@keyaccess.nl>
References: <1200772810.3708.42.camel@queen>
	 <84144f020801191623i2ad344a8t1c40969578793d13@mail.gmail.com>
	 <1201109917.20940.214.camel@queen.suse.de>  <479CD935.3070906@keyaccess.nl>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Mon, 28 Jan 2008 15:21:43 +0100
Message-Id: <1201530103.20940.413.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-01-27 at 20:19 +0100, Rene Herman wrote:
> On 23-01-08 18:38, Thomas Renninger wrote:
> 
> > isapnp is totally untested. Also the sysfs is rather untested.
> 
> If nobody beats me to it I'll debug this myself later on, but as a quick 
> heads up:
I think I know what is going on.
While pnpbios and pnpacpi theoretically do not have limits, isapnp has
spec restrictions (AFAIK, I have not read this up, but taken over from
previous implementation...).
Therefore in isapnp I wanted to stay with:
#define PNP_MAX_PORT            8
#define PNP_MAX_MEM             4
#define PNP_MAX_IRQ             2
#define PNP_MAX_DMA             2
but I have forgotten to malloc one portion for each at init time, or
even better one portion as soon as one is needed.
As said, isapnp is more or less untested, thanks a lot for trying out.
I will send an updated version soon.

Thanks,

    Thomas

> pnp: the driver 'cs4236_isapnp' has been registered
> cs4236_isapnp 01:01.00: driver attached
> cs4236_isapnp 01:01.02: driver attached
> cs4236_isapnp 01:01.03: driver attached
> pnp: Port resource 0 not allocated, cannot assign value
> pnp: Port resource 1 not allocated, cannot assign value
> pnp: Port resource 2 not allocated, cannot assign value
> pnp: Irq resource 0 not allocated, cannot assign value
> pnp: DMA resource 0 not allocated, cannot assign value
> pnp: DMA resource 1 not allocated, cannot assign value
> BUG: unable to handle kernel NULL pointer dereference at virtual address 
> 0000000c
> printing eip: c10e76d9 *pde = 00000000
> Oops: 0000 [#1] PREEMPT
> Modules linked in: snd_cs4236 snd_opl3_lib snd_hwdep snd_cs4236_lib 
> snd_mpu401_uart snd_rawmidi snd_seq_device snd_cs4231_lib snd_pcm snd_timer 
> snd_page_alloc snd soundcore nfsd lockd nfs_acl sunrpc exportfs
> 
> Pid: 1353, comm: modprobe Not tainted (2.6.24-local #2)
> EIP: 0060:[<c10e76d9>] EFLAGS: 00010246 CPU: 0
> EIP is at isapnp_set_resources+0x4d/0x132
> EAX: 00000000 EBX: 00000000 ECX: e3c8f000 EDX: 00000000
> ESI: 00000000 EDI: ef8f5964 EBP: ef8f5800 ESP: e3c8fe5c
>   DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process modprobe (pid: 1353, ti=e3c8f000 task=ed2c2f90 task.ti=e3c8f000)
> Stack: ef8f5800 ef8f5888 f0a4e0a4 ed349000 c10e48c8 c10e373a f0a4e0c0 ef8f5800
>         ef8f5800 00000000 c10e5101 ef8f5800 f0a4b559 00000286 00000001 f0a4d780
>         c10e330d c12b7c6c ef8f5e00 ed37f140 ed3491bc ef8f5e00 ed37f140 f0a4e0a4
> Call Trace:
>   [<c10e48c8>] pnp_start_dev+0x55/0x9e
>   [<c10e373a>] pnp_request_card_device+0x9b/0xbe
>   [<c10e5101>] pnp_activate_dev+0x23/0x39
>   [<f0a4b559>] snd_cs423x_pnpc_detect+0xe4/0x35f [snd_cs4236]
>   [<c10e330d>] pnp_alloc+0xe/0x25
>   [<c10e3652>] card_probe+0xba/0x107
>   [<c10e3b75>] pnp_register_card_driver+0xa3/0xb3
>   [<f08de02f>] alsa_card_cs423x_init+0x2f/0x4f [snd_cs4236]
>   [<c103258a>] sys_init_module+0x1379/0x149b
>   [<c104773a>] unmap_region+0xe5/0x100
>   [<c1003d62>] syscall_call+0x7/0xb
>   =======================
> Code: ff ff ff c7 85 54 01 00 00 01 00 00 00 eb 18 0f b7 12 8d 44 1b 60 43 
> 83 c6 1c 0f b6 c0 e8 ce fd ff ff 83 fb 08 74 13 89 f2 03 17 <8b> 42 0c 25 00 
> 01 00 20 3d 00 01 00 00 74 d5 31 db 31 f6 eb 25
> EIP: [<c10e76d9>] isapnp_set_resources+0x4d/0x132 SS:ESP 0068:e3c8fe5c
> ---[ end trace f836fd70d1d20199 ]---
> 
> Rene.

