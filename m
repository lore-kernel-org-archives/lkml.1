Return-Path: <linux-kernel-owner+w=401wt.eu-S1759431AbXJXOMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431AbXJXOMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbXJXOLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:11:53 -0400
Received: from mail.softservecom.com ([195.160.232.17]:54175 "EHLO
	mail.softservecom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296AbXJXOLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:11:50 -0400
Subject: Re: USB: FIx locks and urb->status in adutux
From: Vitaliy Ivanov <vitalivanov@gmail.com>
Reply-To: vitalivanov@gmail.com
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org, netwiz@crc.id.au,
       vitalivanov@gmail.com
In-Reply-To: <20071023185302.5ce9d187.zaitcev@redhat.com>
References: <20071022203447.db6d7950.zaitcev@redhat.com>
	 <200710231138.38266.oliver@neukum.org>
	 <20071023185302.5ce9d187.zaitcev@redhat.com>
Content-Type: text/plain
Message-Id: <1193234987.13750.21.camel@dell1.softservecom.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.5 (1.4.5-1) 
Date: Wed, 24 Oct 2007 17:09:47 +0300
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Oct 2007 14:09:47.0260 (UTC) FILETIME=[88BC73C0:01C81647]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pete,

On Wed, 2007-10-24 at 04:53, Pete Zaitcev wrote:

1)
> +/*
> + * The locking scheme is a vanilla 3-lock:
> + *   adu_device.buflock: A spinlock, covers what IRQs touch.
> + *   adutux_mutex:       A Static lock to cover open_count. It would also cover
> + *                       any globals, but we don't have them in 2.6.
> + *   adu_device.mtx:     A mutex to hold across sleepers like copy_from_user.
> + *                       It covers all of adu_device, except the open_count
> + *                       and what .buflock covers.
> + */

>  static void adu_abort_transfers(struct adu_device *dev)
>  {
...
> +	mutex_lock(&dev->mtx);
... 
> +	mutex_unlock(&dev->mtx);

>  }

Don't you think it's needed? You call adu_abort_transfers from adu_release only where it's locked by adutux_mutex.


2)
Also one issue. adu_write has:

	/* send off the urb */
	usb_fill_int_urb(
		dev->interrupt_out_urb,
		dev->udev,
		usb_sndintpipe(dev->udev, dev->interrupt_out_endpoint->bEndpointAddress),
		dev->interrupt_out_buffer,
		bytes_to_write,
		adu_interrupt_out_callback,
		dev,
		dev->interrupt_in_endpoint->bInterval);

Seems like there should be not:
dev->interrupt_in_endpoint->bInterval
but:
dev->interrupt_out_endpoint->bInterval

Typo? Seems like that.




I just tried your patch on the adutux from 2.6.24-rc1 but on my 2.6.20.7. It failed with the following message:

-----------------
[176188.466898] drivers/usb/misc/adutux.c : adu_open : enter 
[176188.468000] drivers/usb/misc/adutux.c : adu_open : open count 1 
[176188.468601] drivers/usb/misc/adutux.c : adu_open : leave, return value 0  
[176188.486218] drivers/usb/misc/adutux.c :  adu_interrupt_in_callback : enter, status 0 
[176188.486269] drivers/usb/misc/adutux.c: adu_interrupt_in_callback - length = 8, data = 00 00 00 00 00 00 00 00 
[176188.486430] drivers/usb/misc/adutux.c: adu_interrupt_in_callback - length = 8, data = 00 00 00 00 00 00 00 00 
[176188.486482] drivers/usb/misc/adutux.c :  adu_interrupt_in_callback : leave, status 0 
[176191.303853] drivers/usb/misc/adutux.c :  adu_write : enter, count = 8 
[176193.301872] drivers/usb/misc/adutux.c : adu_write - command timed out. 
[176193.301912] drivers/usb/misc/adutux.c :  adu_write : leave, return value -110 
[176200.425157] drivers/usb/misc/adutux.c :  adu_write : enter, count = 8 
[176200.425776] list_add corruption. next->prev should be prev (c15e6c30), but was 00000000. (next=c58bdf5c).
[176200.425776] list_add corruption. next->prev should be prev (c15e6c30), but was 00000000. (next=c58bdf5c).
[176200.426475] ------------[ cut here ]------------
[176200.426475] ------------[ cut here ]------------
[176200.426536] kernel BUG at lib/list_debug.c:27!
[176200.426536] kernel BUG at lib/list_debug.c:28!
[176200.426647] invalid opcode: 0000 [#1]
[176200.426647] invalid opcode: 0000 [#1]
[176200.426736] Modules linked in: adutux(F) ppdev autofs4 hidp rfcomm l2cap bluetooth sunrpc xt_tcpudp iptable_filter ip_tables x_tables dm_multipath video button battery asus_acpi backlight ac ipv6 lp parport_pc parport floppy nvram uhci_hcd sg snd_ens1371 gameport snd_rawmidi snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm pcnet32 snd_timer snd pcspkr mii soundcore i2c_piix4 i2c_core snd_page_alloc dm_snapshot dm_zero dm_mirror dm_mod ext3 jbd mptspi scsi_transport_spi mptscsih sd_mod scsi_mod mptbase
[176200.426736] Modules linked in: adutux(F) ppdev autofs4 hidp rfcomm l2cap bluetooth sunrpc xt_tcpudp iptable_filter ip_tables x_tables dm_multipath video button battery asus_acpi backlight ac ipv6 lp parport_pc parport floppy nvram uhci_hcd sg snd_ens1371 gameport snd_rawmidi snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm pcnet32 snd_timer snd pcspkr mii soundcore i2c_piix4 i2c_core snd_page_alloc dm_snapshot dm_zero dm_mirror dm_mod ext3 jbd mptspi scsi_transport_spi mptscsih sd_mod scsi_mod mptbase
[176200.427025] CPU:    0
[176200.427025] CPU:    0
[176200.427027] EIP:    0060:[<c01e31a2>]    Tainted: GF     VLI
[176200.427027] EIP:    0060:[<c01e31a2>]    Tainted: GF     VLI
[176200.427029] EFLAGS: 00010082   (2.6.20.7 #1)
[176200.427029] EFLAGS: 00010082   (2.6.20.7 #1)
[176200.427405] EIP is at __list_add+0x29/0x60
[176200.427405] EIP is at __list_add+0x29/0x60
[176200.427448] eax: 00000071   ebx: c58bdf5c   ecx: c0117787   edx: d10e0ab0
[176200.427448] eax: 00000071   ebx: c58bdf5c   ecx: c0117787   edx: d10e0ab0
[176200.427481] esi: c15e6c08   edi: 00000296   ebp: c58bded8   esp: c58bdec0
[176200.427481] esi: c15e6c08   edi: 00000296   ebp: c58bded8   esp: c58bdec0
[176200.427503] ds: 007b   es: 007b   ss: 0068
[176200.427503] ds: 007b   es: 007b   ss: 0068
[176200.427532] Process aducmd (pid: 14413, ti=c58bd000 task=d10e0ab0 task.ti=c58bd000)
[176200.427532] Process aducmd (pid: 14413, ti=c58bd000 task=d10e0ab0 task.ti=c58bd000)
[176200.427555] Stack: c03b2a10 c15e6c30 00000000 c58bdf5c c58bdf50 c15e6c08 c58bdee0 c01e31e3 
[176200.427555] Stack: c03b2a10 c15e6c30 00000000 c58bdf5c c58bdf50 c15e6c08 c58bdee0 c01e31e3 
[176200.427647]        c58bdef4 c012bc4b 00000000 c58bdf50 c58bdf44 c58bdf70 e03437a0 e0344ebb 
[176200.427647]        c58bdef4 c012bc4b 00000000 c58bdf50 c58bdf44 c58bdf70 e03437a0 e0344ebb 
[176200.427662]        e0344950 00000008 c02280a9 c58bdf20 c58bdf40 00000008 bf8aceef c15e6b38 
[176200.427662]        e0344950 00000008 c02280a9 c58bdf20 c58bdf40 00000008 bf8aceef c15e6b38 
[176200.427687] Call Trace:
[176200.427687] Call Trace:
[176200.427739]  [<c0103be8>] show_trace_log_lvl+0x1a/0x2f
[176200.427739]  [<c0103be8>] show_trace_log_lvl+0x1a/0x2f
[176200.427780]  [<c0103c98>] show_stack_log_lvl+0x9b/0xa3
[176200.427780]  [<c0103c98>] show_stack_log_lvl+0x9b/0xa3
[176200.427788]  [<c0103e32>] show_registers+0x192/0x268
[176200.427788]  [<c0103e32>] show_registers+0x192/0x268
[176200.427793]  [<c0103ff7>] die+0xef/0x204
[176200.427793]  [<c0103ff7>] die+0xef/0x204
[176200.427798]  [<c03167cf>] do_trap+0x79/0x91
[176200.427798]  [<c03167cf>] do_trap+0x79/0x91
[176200.427833]  [<c010459c>] do_invalid_op+0x97/0xa1
[176200.427833]  [<c010459c>] do_invalid_op+0x97/0xa1
[176200.427838]  [<c03165ac>] error_code+0x74/0x7c
[176200.427838]  [<c03165ac>] error_code+0x74/0x7c
[176200.427843]  [<c01e31e3>] list_add+0xa/0xf
[176200.427843]  [<c01e31e3>] list_add+0xa/0xf
[176200.427848]  [<c012bc4b>] add_wait_queue+0x1f/0x2d
[176200.427848]  [<c012bc4b>] add_wait_queue+0x1f/0x2d
[176200.427857]  [<e03437a0>] adu_write+0xef/0x3f9 [adutux]
[176200.427857]  [<e03437a0>] adu_write+0xef/0x3f9 [adutux]
[176200.428151]  [<c01636f9>] vfs_write+0xaf/0x163
[176200.428151]  [<c01636f9>] vfs_write+0xaf/0x163
[176200.428184]  [<c0163c45>] sys_write+0x3d/0x61
[176200.428184]  [<c0163c45>] sys_write+0x3d/0x61
[176200.428189]  [<c0102ce4>] syscall_call+0x7/0xb
[176200.428189]  [<c0102ce4>] syscall_call+0x7/0xb
[176200.428231]  =======================
[176200.428231]  =======================
[176200.428270] Code: 5d c3 55 89 e5 56 53 89 c3 83 ec 10 8b 41 04 39 d0 74 1c 89 4c 24 0c 89 54 24 04 89 44 24 08 c7 04 24 10 2a 3b c0 e8 40 8b f3 ff <0f> 0b eb fe 8b 32 39 ce 74 1c 89 54 24 0c 89 74 24 08 89 4c 24 
[176200.428270] Code: 5d c3 55 89 e5 56 53 89 c3 83 ec 10 8b 41 04 39 d0 74 1c 89 4c 24 0c 89 54 24 04 89 44 24 08 c7 04 24 10 2a 3b c0 e8 40 8b f3 ff <0f> 0b eb fe 8b 32 39 ce 74 1c 89 54 24 0c 89 74 24 08 89 4c 24 
[176200.428270] EIP: [<c01e31a2>] __list_add+0x29/0x60 SS:ESP 0068:c58bdec0
[176200.428270] EIP: [<c01e31a2>] __list_add+0x29/0x60 SS:ESP 0068:c58bdec0
[176200.428593]  <3>BUG: sleeping function called from invalid context at kernel/rwsem.c:20
[176200.428593]  <3>BUG: sleeping function called from invalid context at kernel/rwsem.c:20
[176200.428798] in_atomic():0, irqs_disabled():1
[176200.428798] in_atomic():0, irqs_disabled():1
[176200.428847] no locks held by aducmd/14413.
[176200.428847] no locks held by aducmd/14413.
[176200.428918] irq event stamp: 0
[176200.428918] irq event stamp: 0
[176200.428939] hardirqs last  enabled at (0): [<00000000>] 0x0
[176200.428939] hardirqs last  enabled at (0): [<00000000>] 0x0
[176200.429038] hardirqs last disabled at (0): [<c0119746>] copy_process+0x2e5/0x1194
[176200.429038] hardirqs last disabled at (0): [<c0119746>] copy_process+0x2e5/0x1194
[176200.429094] softirqs last  enabled at (0): [<c0119746>] copy_process+0x2e5/0x1194
[176200.429094] softirqs last  enabled at (0): [<c0119746>] copy_process+0x2e5/0x1194
[176200.429148] softirqs last disabled at (0): [<00000000>] 0x0
[176200.429148] softirqs last disabled at (0): [<00000000>] 0x0
[176200.429231]  [<c0103be8>] show_trace_log_lvl+0x1a/0x2f
[176200.429231]  [<c0103be8>] show_trace_log_lvl+0x1a/0x2f
[176200.429239]  [<c010414d>] show_trace+0x12/0x14
[176200.429239]  [<c010414d>] show_trace+0x12/0x14
[176200.429244]  [<c01041d1>] dump_stack+0x16/0x18
[176200.429244]  [<c01041d1>] dump_stack+0x16/0x18
[176200.429249]  [<c0117bca>] __might_sleep+0xc9/0xcf
[176200.429249]  [<c0117bca>] __might_sleep+0xc9/0xcf
[176200.429254]  [<c012e495>] down_read+0x18/0x50
[176200.429254]  [<c012e495>] down_read+0x18/0x50
[176200.429262]  [<c013e297>] acct_collect+0x3b/0x144
[176200.429262]  [<c013e297>] acct_collect+0x3b/0x144
[176200.429271]  [<c011daa5>] do_exit+0x1b6/0x707
[176200.429271]  [<c011daa5>] do_exit+0x1b6/0x707
[176200.429276]  [<c01040e6>] die+0x1de/0x204
[176200.429276]  [<c01040e6>] die+0x1de/0x204
[176200.429281]  [<c03167cf>] do_trap+0x79/0x91
[176200.429281]  [<c03167cf>] do_trap+0x79/0x91
[176200.429286]  [<c010459c>] do_invalid_op+0x97/0xa1
[176200.429286]  [<c010459c>] do_invalid_op+0x97/0xa1
[176200.429291]  [<c03165ac>] error_code+0x74/0x7c
[176200.429291]  [<c03165ac>] error_code+0x74/0x7c
[176200.429295]  [<c01e31e3>] list_add+0xa/0xf
[176200.429295]  [<c01e31e3>] list_add+0xa/0xf
[176200.429301]  [<c012bc4b>] add_wait_queue+0x1f/0x2d
[176200.429301]  [<c012bc4b>] add_wait_queue+0x1f/0x2d
[176200.429306]  [<e03437a0>] adu_write+0xef/0x3f9 [adutux]
[176200.429306]  [<e03437a0>] adu_write+0xef/0x3f9 [adutux]
[176200.429313]  [<c01636f9>] vfs_write+0xaf/0x163
[176200.429313]  [<c01636f9>] vfs_write+0xaf/0x163
[176200.429318]  [<c0163c45>] sys_write+0x3d/0x61
[176200.429318]  [<c0163c45>] sys_write+0x3d/0x61
[176200.429323]  [<c0102ce4>] syscall_call+0x7/0xb
[176200.429323]  [<c0102ce4>] syscall_call+0x7/0xb
[176200.429328]  =======================
-----------------

I'm not sure whether it's because I'm trying it on 2.6.20.7 and not on 2.6.24-rc1.
Will check it on 2.6.24-rc1 asap and let you know.

Best,
Vitaliy

