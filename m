Return-Path: <linux-kernel-owner+w=401wt.eu-S932082AbZELItV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbZELItV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 04:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbZELItG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 04:49:06 -0400
Received: from green.ailair.fr ([91.121.209.168]:3083 "EHLO green.ailair.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbZELItE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 04:49:04 -0400
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.27.2] datagram handling routines : mapping/unmapping paged data in soft IRQ
X-MimeOLE: Produced By Microsoft Exchange V6.0.6619.12
Date: Tue, 12 May 2009 10:48:37 +0200
Message-ID: <54466B0E862D654998371DCA86B6FE2F4B6DC1@adept-srv2.adept.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.27.2] datagram handling routines : mapping/unmapping paged data in soft IRQ
Thread-Index: AcnSkWZDUfGp9vdtQOabKnTPJP1ulgARvXqA
From: "Luc Goria" <Luc.Goria@adept-telecom.fr>
To: "David Miller" <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi David,

My company, based in France, develops, manufactures and markets VoIP communication platforms.
I'm working on a specific module to manage RTP and RTCP packets at kernel level.
The kernel crash occurs when the system is running as a Xen DomU because data received in socket buffers are paged.

Here is the kernel panic trace :

[   88.182707] rtp: module license 'unspecified' taints kernel.
[   88.183663] Registering RTP char device.
[   88.188233] Registering High Resolution Timer char device.
[   88.188261] hrtimer: High Resolution Timer started for ticks
[  144.300026] ------------[ cut here ]------------
[  144.300041] kernel BUG at arch/x86/mm/highmem_32.c:15!
[  144.300050] invalid opcode: 0000 [#1] 
[  144.300060] Modules linked in: hrtimer rtp(P) af_packet ext3 jbd mbcache thermal_sys fuse
[  144.300096] 
[  144.300103] Pid: 0, comm: swapper Tainted: P        W (2.6.27.2 #9)
[  144.300113] EIP: 0061:[<c011c8e2>] EFLAGS: 00010206 CPU: 0
[  144.300125] EIP is at kunmap+0x12/0x50
[  144.300132] EAX: c043e000 EBX: 00000000 ECX: 00000000 EDX: c7074d80
[  144.300141] ESI: 0000001e EDI: 0000001e EBP: 0000004c ESP: c043fd14
[  144.300155]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0069
[  144.300162] Process swapper (pid: 0, ti=c043e000 task=c040f3a0 task.ti=c043e000)
[  144.300170] Stack: c028fb7f c043fd60 00000000 c043fea0 d8f12a80 00000000 00000000 c7074d80 
[  144.300198]        0000002e d8f12a80 d8ee0c00 00000000 c043fe84 c02d4317 0000002e 00000001 
[  144.300224]        00000044 00000044 00000001 00000000 00000040 c042cb40 c043fe84 c043fe84 
[  144.300251] Call Trace:
[  144.300257]  [<c028fb7f>] skb_copy_datagram_iovec+0xcf/0x1e0
[  144.300271]  [<c02d4317>] udp_recvmsg+0xb7/0x290
[  144.300281]  [<c0289687>] sock_common_recvmsg+0x47/0x70
[  144.300292]  [<c028796c>] sock_recvmsg+0x12c/0x140
[  144.300302]  [<c0136871>] run_posix_cpu_timers+0x21/0x8e0
[  144.300313]  [<c01357e0>] autoremove_wake_function+0x0/0x50
[  144.300323]  [<c01064bb>] xen_vcpuop_set_next_event+0x3b/0x70
[  144.300334]  [<c013d913>] clockevents_program_event+0xa3/0x110
[  144.300344]  [<c013e09d>] tick_dev_program_event+0x3d/0xc0
[  144.300354]  [<c013e184>] tick_program_event+0x14/0x20
[  144.300363]  [<c0138d39>] hrtimer_interrupt+0x159/0x190
[  144.300373]  [<e08409f9>] rtp_do_timer+0xa9/0x140 [rtp]
[  144.300385]  [<c012c0b4>] run_timer_softirq+0x144/0x1b0
[  144.300396]  [<e0840950>] rtp_do_timer+0x0/0x140 [rtp]
[  144.300406]  [<e0840950>] rtp_do_timer+0x0/0x140 [rtp]
[  144.300417]  [<c01280c2>] __do_softirq+0x52/0xa0
[  144.300427]  [<c0128155>] do_softirq+0x45/0x50
[  144.300435]  [<c0128475>] irq_exit+0x45/0x60
[  144.300444]  [<c010a92c>] do_IRQ+0x3c/0x70
[  144.300454]  [<c0106565>] xen_restore_fl_direct_end+0x0/0x3
[  144.300464]  [<c0138dfb>] hrtimer_get_next_event+0x8b/0xd0
[  144.300475]  [<c023b80c>] xen_evtchn_do_upcall+0x9c/0xe0
[  144.300485]  [<c0109683>] xen_do_upcall+0x7/0xc
[  144.300495]  [<c01023a7>] _stext+0x3a7/0x1000
[  144.300504]  [<c010369f>] xen_safe_halt+0xf/0x20
[  144.300513]  [<c0104960>] xen_idle+0x20/0x40
[  144.300522]  [<c01076f1>] cpu_idle+0x31/0x70
[  144.300535]  =======================
[  144.300541] Code: e8 c4 fe ff ff 83 c4 08 5b c3 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90 90 89 c2 89 e0 25 00 e0 ff ff f7 40 14 00 ff ff 0f 74 04 <0f> 0b eb fe 8b 02 c1 e8 1e 69 c0 98 02 00 00 05 40 0f 43 c0 2b 
[  144.300704] EIP: [<c011c8e2>] kunmap+0x12/0x50 SS:ESP 0069:c043fd14
[  144.300720] Kernel panic - not syncing: Fatal exception in interrupt


> -----Message d'origine-----
> De:	David Miller [SMTP:davem@davemloft.net]
> Date:	mardi 12 mai 2009 01:37
> À:	Luc Goria
> Cc:	netdev@vger.kernel.org; linux-kernel@vger.kernel.org; alan@redhat.com
> Objet:	Re: [PATCH 2.6.27.2] datagram handling routines : mapping/unmapping paged data in soft IRQ> 
> 
> From: "Luc Goria" <Luc.Goria@adept-telecom.fr>
> Date: Mon, 11 May 2009 15:32:21 +0200
> 
> > 
> > Kernel crashes when a network module tries to copy a datagram to iovec in soft IRQ with paged data.
> > The problem is that kunmap function can't be called in IRQ.
> > All calls to kmap/kunmap fonctions are replaced by calls to kmap_skb_frag/kunmap_skb_frag when paged data are involved.
> > 
> >  <<datagram.c.patch>> 
> > Signed-off-by: Luc GORIA <luc.goria@adept-telecom.fr>
> 
> What network module does this?  You're not supposed to.
> 
