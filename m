Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbYKAW35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbYKAW35 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 18:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYKAW3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 18:29:48 -0400
Received: from archer.toppoint.de ([217.70.197.1]:37605 "EHLO mail.toppoint.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbYKAW3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 18:29:47 -0400
Date: Sat, 1 Nov 2008 23:28:54 +0100
From: Wilfried Klaebe <linux-kernel@lebenslange-mailadresse.de>
To: isdn4linux@listserv.isdn4linux.de
Cc: kkeil@suse.de, calle@calle.de, linux-kernel@vger.kernel.org
Subject: [PATCH] b1isa: fix b1isa_exit() to really remove registered capi
	controllers
Message-ID: <20081101222853.GA14831@kaos.in-kiel.de>
Mail-Followup-To: isdn4linux@listserv.isdn4linux.de, kkeil@suse.de,
	calle@calle.de, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[resend; changed To:, kkeil added to CC:]

On "/etc/init.d/capiutils stop", this oops happened.

The oops happens on reading /proc/capi/controllers because
capi_ctrl->procinfo is called for the wrongly not unregistered
controller, which points to b1isa_procinfo(), which was removed on
module unload.

b1isa_exit() did not call b1isa_remove() for its controllers because
io[0] == 0 on module unload despite having been 0x340 on module load.

Besides, just removing the controllers that where added on module
load time and not those that were added later via b1isa_add_card() is
wrong too - the place where all added cards are found is isa_dev[].

relevant dmesg lines:

[    0.000000] Linux version 2.6.27.4 (w@shubashi) (gcc version 4.3.2 (Debian 4.3.2-1) ) #3 Thu Oct 30 16:49:03 CET 2008

[   67.403555] CAPI Subsystem Rev 1.1.2.8
[   68.529154] capifs: Rev 1.1.2.3
[   68.563292] capi20: Rev 1.1.2.7: started up with major 68 (middleware+capifs)
[   77.026936] b1: revision 1.1.2.2
[   77.049992] b1isa: revision 1.1.2.3
[   77.722655] kcapi: Controller [001]: b1isa-340 attached
[   77.722671] b1isa: AVM B1 ISA at i/o 0x340, irq 5, revision 255
[   81.272669] b1isa-340: card 1 "B1" ready.
[   81.272683] b1isa-340: card 1 Protocol: DSS1
[   81.272689] b1isa-340: card 1 Linetype: point to multipoint
[   81.272695] b1isa-340: B1-card (3.11-03) now active
[   81.272702] kcapi: card [001] "b1isa-340" ready.

[  153.721281] kcapi: card [001] down.
[  154.151889] BUG: unable to handle kernel paging request at e87af000
[  154.152081] IP: [<e87af000>]
[  154.153292] *pde = 2655b067 *pte = 00000000 
[  154.153307] Oops: 0000 [#1] 
[  154.153360] Modules linked in: rfcomm l2cap ppdev lp ipt_MASQUERADE tun capi capifs kernelcapi ac battery nfsd exportfs nfs lockd nfs_acl sunrpc sit tunnel4 bridge stp llc ipt_REJECT ipt_LOG xt_tcpudp xt_state iptable_filter iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables x_tables nls_utf8 isofs nls_base zlib_inflate loop ipv6 netconsole snd_via82xx dvb_usb_dib0700 gameport dib7000p dib7000m dvb_usb snd_ac97_codec ac97_bus dvb_core mt2266 snd_pcm tuner_xc2028 dib3000mc dibx000_common mt2060 dib0070 snd_page_alloc snd_mpu401_uart snd_seq_midi snd_seq_midi_event btusb snd_rawmidi bluetooth snd_seq snd_timer snd_seq_device snd via686a i2c_viapro soundcore i2c_core parport_pc parport button dm_mirror dm_log dm_snapshot floppy sg ohci1394 uhci_hcd ehci_hcd 8139too mii ieee1394 usbcore sr_mod cdrom sd_mod thermal processor fan [last unloaded: b1]
[  154.153360] 
[  154.153360] Pid: 4132, comm: capiinit Not tainted (2.6.27.4 #3)
[  154.153360] EIP: 0060:[<e87af000>] EFLAGS: 00010286 CPU: 0
[  154.153360] EIP is at 0xe87af000
[  154.153360] EAX: e6b9ccc8 EBX: e6b9ccc8 ECX: e87a0c67 EDX: e87af000
[  154.153360] ESI: e142bbc0 EDI: e87a56e0 EBP: e0505f0c ESP: e0505ee4
[  154.153360]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  154.153360] Process capiinit (pid: 4132, ti=e0504000 task=d1196cf0 task.ti=e0504000)
[  154.153360] Stack: e879f650 00000246 e0505ef4 c01472eb e0505f0c 00000246 e7001780 fffffff4 
[  154.153360]        fffffff4 e142bbc0 e0505f48 c01a56c6 00000400 b805e000 d102dc80 e142bbe0 
[  154.153360]        00000000 e87a56e0 00000246 e12617ac 00000000 00000000 e1261760 fffffffb 
[  154.153360] Call Trace:
[  154.153360]  [<e879f650>] ? controller_show+0x20/0x90 [kernelcapi]
[  154.153360]  [<c01472eb>] ? trace_hardirqs_on+0xb/0x10
[  154.153360]  [<c01a56c6>] ? seq_read+0x126/0x2f0
[  154.153360]  [<c01a55a0>] ? seq_read+0x0/0x2f0
[  154.153360]  [<c01c033c>] ? proc_reg_read+0x5c/0x90
[  154.153360]  [<c0189919>] ? vfs_read+0x99/0x140
[  154.153360]  [<c01c02e0>] ? proc_reg_read+0x0/0x90
[  154.153360]  [<c0189a7d>] ? sys_read+0x3d/0x70
[  154.153360]  [<c0103c3d>] ? sysenter_do_call+0x12/0x35
[  154.153360]  =======================
[  154.153360] Code:  Bad EIP value.
[  154.153360] EIP: [<e87af000>] 0xe87af000 SS:ESP 0068:e0505ee4
[  154.153360] ---[ end trace 23750b6c2862de94 ]---

Signed-off-by: Wilfried Klaebe <linux-kernel@lebenslange-mailadresse.de>

diff -pru linux-2.6.27.4.ori/drivers/isdn/hardware/avm/b1isa.c linux-2.6.27.4/drivers/isdn/hardware/avm/b1isa.c
--- linux-2.6.27.4/drivers/isdn/hardware/avm/b1isa.c	2008-10-10 00:13:53.000000000 +0200
+++ linux-2.6.27.4.fixed/drivers/isdn/hardware/avm/b1isa.c	2008-10-30 15:55:03.000000000 +0100
@@ -233,10 +233,8 @@ static void __exit b1isa_exit(void)
 	int i;
 
 	for (i = 0; i < MAX_CARDS; i++) {
-		if (!io[i])
-			break;
-
-		b1isa_remove(&isa_dev[i]);
+		if (isa_dev[i].resource[0].start)
+			b1isa_remove(&isa_dev[i]);
 	}
 	unregister_capi_driver(&capi_driver_b1isa);
 }
