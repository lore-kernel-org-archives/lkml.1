Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbZD2QBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbZD2QBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 12:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZD2QAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 12:00:47 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:53297 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183AbZD2QAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 12:00:46 -0400
Date: Wed, 29 Apr 2009 18:00:41 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: BUG: NULL pointer dereference in try_to_del_timer_sync()
Message-ID: <20090429160041.GE6291@buzzloop.caiaq.de>
References: <20090428235551.862ee0d1.akpm@linux-foundation.org> <Pine.LNX.4.44L0.0904291147230.24643-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904291147230.24643-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 11:49:32AM -0400, Alan Stern wrote:
> > > [10982.240510]  [<c022f0b6>] ? try_to_del_timer_sync+0x15/0x4f
> > > [10982.240516]  [<c022f515>] ? del_timer_sync+0x5c/0x6c
> > > [10982.240521]  [<f86930c6>] ? ftdi_close+0xc5/0xe9 [ftdi_sio]
> > > [10982.240540]  [<f85c0a32>] ? serial_close+0x86/0x12d [usbserial]
> > > [10982.240553]  [<c03cb413>] ? tty_release_dev+0x176/0x3fa
> > > [10982.240561]  [<c023aefb>] ? lock_hrtimer_base+0x18/0x33
> > > [10982.240568]  [<c0244ca4>] ? trace_hardirqs_off+0xb/0xd
> > > [10982.240576]  [<c051feed>] ? _spin_unlock_irqrestore+0x42/0x58
> > > [10982.240582]  [<c028e4ff>] ? vfs_ioctl+0x22/0x69
> > > [10982.240589]  [<c028e998>] ? do_vfs_ioctl+0x452/0x48b
> > > [10982.240594]  [<c03cb6a9>] ? tty_release+0x12/0x1c
> > > [10982.240598]  [<c02843ab>] ? __fput+0xca/0x175
> > > [10982.240604]  [<c028446f>] ? fput+0x19/0x1b
> > > [10982.240608]  [<c0281b1d>] ? filp_close+0x51/0x5b
> > > [10982.240612]  [<c0281b91>] ? sys_close+0x6a/0xa4
> > > [10982.240616]  [<c02029c8>] ? sysenter_do_call+0x12/0x36
> > > [10982.240623] Code: 40 f7 d0 83 e0 f2 5b c9 c3 55 31 c9 31 d2 64 a1 00 f0 73 c0 89 e5 e8 05 6f 00 00 c9 c3 55 89 e5 57 89 c7 56 53 83 ec 04 89 55 f0 <8b> 5f 14 89 de 83 e6 fe 74 22 89 f0 e8 8b 11 2f 00 8b 55 f0 89 
> > > [10982.240675] EIP: [<c022eefd>] lock_timer_base+0xe/0x3e SS:ESP 0068:ea10fe44
> > > [10982.240681] CR2: 0000000000000090
> > > [10982.240685] ---[ end trace ca8d2f0f6a72aeeb ]---
> > 
> > usb-serial went splat.
> 
> Looks like the ftdi_sio driver doesn't use proper reference counting 
> for its private data structure.  Does this patch help?

Nope, it doesn't. However, the backtrace is somewhat different now:

[  196.131549] BUG: unable to handle kernel NULL pointer dereference at
00000080
[  196.131555] IP: [<c022f0fc>] del_timer+0xc/0x4e
[  196.131565] *pde = 00000000 
[  196.131569] Oops: 0000 [#1] PREEMPT SMP 
[  196.131574] last sysfs file:
/sys/devices/pci0000:00/0000:00:0f.0/0000:06:00.0/resource
[  196.131579] Modules linked in: nvidia(P) ppdev lp nfsd exportfs nfs
lockd nfs_acl auth_rpcgss sunrpc dm_crypt dm_mod aes_generic cryptoloop
loop snd_usb_caiaq snd_rawmidi snd_pcm pl2303 ftdi_sio usbserial
snd_timer snd_page_alloc via_rhine mii psmouse i2c_nforce2 pcspkr
forcedeth parport_pc thermal button [last unloaded: nvidia]
[  196.131622] 
[  196.131627] Pid: 4103, comm: cu Tainted: P        W  (2.6.30-rc3 #1)
MS-7260
[  196.131631] EIP: 0060:[<c022f0fc>] EFLAGS: 00210282 CPU: 1
[  196.131634] EIP is at del_timer+0xc/0x4e
[  196.131637] EAX: 00000080 EBX: 00000080 ECX: c051e362 EDX: 00000080
[  196.131640] ESI: 00000000 EDI: 00000000 EBP: ef749e00 ESP: ef749df4
[  196.131644]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  196.131647] Process cu (pid: 4103, ti=ef748000 task=ef42ca70
task.ti=ef748000)
[  196.131650] Stack:
[  196.131652]  00000000 000004b2 00000064 ef749e74 c02355bc 00000080
00000000 00000068
[  196.131662]  00200246 00000000 00000002 00000074 00000000 f8693ec8
f716582c 00000000
[  196.131673]  f8693ec8 f71657f8 ef749e60 00200246 00200046 00000001
f7165818 f71657f8
[  196.131684] Call Trace:
[  196.131687]  [<c02355bc>] ? __cancel_work_timer+0x2c/0x190
[  196.131695]  [<f8693ec8>] ? ftdi_close+0x43/0xe4 [ftdi_sio]
[  196.131712]  [<f8693ec8>] ? ftdi_close+0x43/0xe4 [ftdi_sio]
[  196.131725]  [<c0245b36>] ? trace_hardirqs_on+0xb/0xd
[  196.131730]  [<c023572b>] ? cancel_delayed_work_sync+0xb/0xd
[  196.131736]  [<f8693f4a>] ? ftdi_close+0xc5/0xe4 [ftdi_sio]
[  196.131748]  [<f85c1a32>] ? serial_close+0x86/0x12d [usbserial]
[  196.131760]  [<c03cb413>] ? tty_release_dev+0x176/0x3fa
[  196.131766]  [<c023aefb>] ? lock_hrtimer_base+0x18/0x33
[  196.131773]  [<c0244ca4>] ? trace_hardirqs_off+0xb/0xd
[  196.131780]  [<c051feed>] ? _spin_unlock_irqrestore+0x42/0x58
[  196.131786]  [<c028e4ff>] ? vfs_ioctl+0x22/0x69
[  196.131792]  [<c028e998>] ? do_vfs_ioctl+0x452/0x48b
[  196.131796]  [<c03cb6a9>] ? tty_release+0x12/0x1c
[  196.131801]  [<c02843ab>] ? __fput+0xca/0x175
[  196.131807]  [<c028446f>] ? fput+0x19/0x1b
[  196.131811]  [<c0281b1d>] ? filp_close+0x51/0x5b
[  196.131816]  [<c0281b91>] ? sys_close+0x6a/0xa4
[  196.131820]  [<c02029c8>] ? sysenter_do_call+0x12/0x36
[  196.131826] Code: 10 c7 43 04 00 02 20 00 c7 03 00 00 00 00 8b 55 f4
89 c8 e8 c2 0d 2f 00 59 5b 89 f0 5e c9 c3 55 89 e5 56 31 f6 53 89 c3 83
ec 04 <83> 38 00 74 36 8d 55 f4 31 f6 e8 e4 fd ff ff 8b 13 89 c1 85 d2 
[  196.131881] EIP: [<c022f0fc>] del_timer+0xc/0x4e SS:ESP 0068:ef749df4
[  196.131886] CR2: 0000000000000080
[  196.131891] ---[ end trace e9230dfd36625f80 ]---
[  196.264818] hub 1-3:1.0: debounce: port 4: total 100ms stable 100ms
status 0x100

It's unreleated to the nvidia driver, btw. I tried it without, and the
problem persists.

Daniel
