Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbZBTMqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbZBTMqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 07:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZBTMqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 07:46:14 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:46188 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbZBTMqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 07:46:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=K2hWMSxqBARa5zsLMk7q5C6IcTbvMrsCOTNACvN6M/7LmmPqh5Z/eftrcVth5FBJ3c
         ZpaeJnj1qVjHFrLiRDzPuw7A09Kf0D7RoEowaPIqtTnt1VGdNAbRi09yZ8qlsIzno0WU
         ZXxPaJFvTtrL90aM7eEVbpIrGdFWadpSfGdfE=
Message-ID: <499EA5F6.2060206@gmail.com>
Date: Fri, 20 Feb 2009 20:45:42 +0800
From: Dave Young <hidave.darkstar@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081010)
MIME-Version: 1.0
To: marcel@holtmann.org
CC: davem@davemloft.net, linux-kernel@vger.kernel.org,
       linux-bluetooth@vger.kernel.org
Subject: [PATCH] bluetooth: move back hci_conn_del_sysfs to hci_conn_del 
 avoid device destruct too early
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following commit introduce a regression:

	commit 7d0db0a373195385a2e0b19d1f5e4b186fdcffac
	Author: Marcel Holtmann <marcel@holtmann.org>
	Date:   Mon Jul 14 20:13:51 2008 +0200

		[Bluetooth] Use a more unique bus name for connections

I get panic as following (by netconsole):

[ 2709.344034] usb 5-1: new full speed USB device using uhci_hcd and address 4
[ 2709.505776] usb 5-1: configuration #1 chosen from 1 choice
[ 2709.569207] Bluetooth: Generic Bluetooth USB driver ver 0.4
[ 2709.570169] usbcore: registered new interface driver btusb
[ 2845.742781] BUG: unable to handle kernel paging request at 6b6b6c2f
[ 2845.742958] IP: [<c015515c>] __lock_acquire+0x6c/0xa80
[ 2845.743087] *pde = 00000000 
[ 2845.743206] Oops: 0002 [#1] SMP 
[ 2845.743377] last sysfs file: /sys/class/bluetooth/hci0/hci0:6/type
[ 2845.743742] Modules linked in: btusb netconsole snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss rfcomm l2cap bluetooth vfat fuse snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm pl2303 snd_timer psmouse usbserial snd 3c59x e100 serio_raw soundcore i2c_i801 intel_agp mii agpgart snd_page_alloc rtc_cmos rtc_core thermal processor rtc_lib button thermal_sys sg evdev
[ 2845.743742] 
[ 2845.743742] Pid: 0, comm: swapper Not tainted (2.6.29-rc5-smp #54) Dell DM051                   
[ 2845.743742] EIP: 0060:[<c015515c>] EFLAGS: 00010002 CPU: 0
[ 2845.743742] EIP is at __lock_acquire+0x6c/0xa80
[ 2845.743742] EAX: 00000046 EBX: 00000046 ECX: 6b6b6b6b EDX: 00000002
[ 2845.743742] ESI: 6b6b6b6b EDI: 00000000 EBP: c064fd14 ESP: c064fcc8
[ 2845.743742]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 2845.743742] Process swapper (pid: 0, ti=c064e000 task=c05d1400 task.ti=c064e000)
[ 2845.743742] Stack:
[ 2845.743742]  c05d1400 00000002 c05d1400 00000001 00000002 00000000 f65388dc c05d1400
[ 2845.743742]  6b6b6b6b 00000292 c064fd0c c0153732 00000000 00000000 00000001 f700fa50
[ 2845.743742]  00000046 00000000 00000000 c064fd40 c0155be6 00000000 00000002 00000001
[ 2845.743742] Call Trace:
[ 2845.743742]  [<c0153732>] ? trace_hardirqs_on_caller+0x72/0x1c0
[ 2845.743742]  [<c0155be6>] ? lock_acquire+0x76/0xa0
[ 2845.743742]  [<c03e1aad>] ? skb_dequeue+0x1d/0x70
[ 2845.743742]  [<c046c885>] ? _spin_lock_irqsave+0x45/0x80
[ 2845.743742]  [<c03e1aad>] ? skb_dequeue+0x1d/0x70
[ 2845.743742]  [<c03e1aad>] ? skb_dequeue+0x1d/0x70
[ 2845.743742]  [<c03e1f94>] ? skb_queue_purge+0x14/0x20
[ 2845.743742]  [<f8171f5a>] ? hci_conn_del+0x10a/0x1c0 [bluetooth]
[ 2845.743742]  [<f81399c9>] ? l2cap_disconn_ind+0x59/0xb0 [l2cap]
[ 2845.743742]  [<f81795ce>] ? hci_conn_del_sysfs+0x8e/0xd0 [bluetooth]
[ 2845.743742]  [<f8175758>] ? hci_event_packet+0x5f8/0x31c0 [bluetooth]
[ 2845.743742]  [<c03dfe19>] ? sock_def_readable+0x59/0x80
[ 2845.743742]  [<c046c14d>] ? _read_unlock+0x1d/0x20
[ 2845.743742]  [<f8178aa9>] ? hci_send_to_sock+0xe9/0x1d0 [bluetooth]
[ 2845.743742]  [<c015388b>] ? trace_hardirqs_on+0xb/0x10
[ 2845.743742]  [<f816fa6a>] ? hci_rx_task+0x2ba/0x490 [bluetooth]
[ 2845.743742]  [<c0133661>] ? tasklet_action+0x31/0xc0
[ 2845.743742]  [<c013367c>] ? tasklet_action+0x4c/0xc0
[ 2845.743742]  [<c0132eb7>] ? __do_softirq+0xa7/0x170
[ 2845.743742]  [<c0116dec>] ? ack_apic_level+0x5c/0x1c0
[ 2845.743742]  [<c0132fd7>] ? do_softirq+0x57/0x60
[ 2845.743742]  [<c01333dc>] ? irq_exit+0x7c/0x90
[ 2845.743742]  [<c01055bb>] ? do_IRQ+0x4b/0x90
[ 2845.743742]  [<c01333d5>] ? irq_exit+0x75/0x90
[ 2845.743742]  [<c010392c>] ? common_interrupt+0x2c/0x34
[ 2845.743742]  [<c010a14f>] ? mwait_idle+0x4f/0x70
[ 2845.743742]  [<c0101c05>] ? cpu_idle+0x65/0xb0
[ 2845.743742]  [<c045731e>] ? rest_init+0x4e/0x60
[ 2845.743742] Code: 0f 84 69 02 00 00 83 ff 07 0f 87 1e 06 00 00 85 ff 0f 85 08 05 00 00 8b 4d cc 8b 49 04 85 c9 89 4d d4 0f 84 f7 04 00 00 8b 75 d4 <f0> ff 86 c4 00 00 00 89 f0 e8 56 a9 ff ff 85 c0 0f 85 6e 03 00 
[ 2845.743742] EIP: [<c015515c>] __lock_acquire+0x6c/0xa80 SS:ESP 0068:c064fcc8
[ 2845.743742] ---[ end trace 4c985b38f022279f ]---
[ 2845.743742] Kernel panic - not syncing: Fatal exception in interrupt
[ 2845.743742] ------------[ cut here ]------------
[ 2845.743742] WARNING: at kernel/smp.c:329 smp_call_function_many+0x151/0x200()
[ 2845.743742] Hardware name: Dell DM051                   
[ 2845.743742] Modules linked in: btusb netconsole snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss rfcomm l2cap bluetooth vfat fuse snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm pl2303 snd_timer psmouse usbserial snd 3c59x e100 serio_raw soundcore i2c_i801 intel_agp mii agpgart snd_page_alloc rtc_cmos rtc_core thermal processor rtc_lib button thermal_sys sg evdev
[ 2845.743742] Pid: 0, comm: swapper Tainted: G      D    2.6.29-rc5-smp #54
[ 2845.743742] Call Trace:
[ 2845.743742]  [<c012e076>] warn_slowpath+0x86/0xa0
[ 2845.743742]  [<c015041b>] ? trace_hardirqs_off+0xb/0x10
[ 2845.743742]  [<c0146384>] ? up+0x14/0x40
[ 2845.743742]  [<c012e661>] ? release_console_sem+0x31/0x1e0
[ 2845.743742]  [<c046c8ab>] ? _spin_lock_irqsave+0x6b/0x80
[ 2845.743742]  [<c015041b>] ? trace_hardirqs_off+0xb/0x10
[ 2845.743742]  [<c046c900>] ? _read_lock_irqsave+0x40/0x80
[ 2845.743742]  [<c012e7f2>] ? release_console_sem+0x1c2/0x1e0
[ 2845.743742]  [<c0146384>] ? up+0x14/0x40
[ 2845.743742]  [<c015041b>] ? trace_hardirqs_off+0xb/0x10
[ 2845.743742]  [<c046a3d7>] ? __mutex_unlock_slowpath+0x97/0x160
[ 2845.743742]  [<c046a563>] ? mutex_trylock+0xb3/0x180
[ 2845.743742]  [<c046a4a8>] ? mutex_unlock+0x8/0x10
[ 2845.743742]  [<c015b991>] smp_call_function_many+0x151/0x200
[ 2845.743742]  [<c010a1a0>] ? stop_this_cpu+0x0/0x40
[ 2845.743742]  [<c015ba61>] smp_call_function+0x21/0x30
[ 2845.743742]  [<c01137ae>] native_smp_send_stop+0x1e/0x50
[ 2845.743742]  [<c012e0f5>] panic+0x55/0x110
[ 2845.743742]  [<c01065a8>] oops_end+0xb8/0xc0
[ 2845.743742]  [<c010668f>] die+0x4f/0x70
[ 2845.743742]  [<c011a8c9>] do_page_fault+0x269/0x610
[ 2845.743742]  [<c011a660>] ? do_page_fault+0x0/0x610
[ 2845.743742]  [<c046cbaf>] error_code+0x77/0x7c
[ 2845.743742]  [<c015515c>] ? __lock_acquire+0x6c/0xa80
[ 2845.743742]  [<c0153732>] ? trace_hardirqs_on_caller+0x72/0x1c0
[ 2845.743742]  [<c0155be6>] lock_acquire+0x76/0xa0
[ 2845.743742]  [<c03e1aad>] ? skb_dequeue+0x1d/0x70
[ 2845.743742]  [<c046c885>] _spin_lock_irqsave+0x45/0x80
[ 2845.743742]  [<c03e1aad>] ? skb_dequeue+0x1d/0x70
[ 2845.743742]  [<c03e1aad>] skb_dequeue+0x1d/0x70
[ 2845.743742]  [<c03e1f94>] skb_queue_purge+0x14/0x20
[ 2845.743742]  [<f8171f5a>] hci_conn_del+0x10a/0x1c0 [bluetooth]
[ 2845.743742]  [<f81399c9>] ? l2cap_disconn_ind+0x59/0xb0 [l2cap]
[ 2845.743742]  [<f81795ce>] ? hci_conn_del_sysfs+0x8e/0xd0 [bluetooth]
[ 2845.743742]  [<f8175758>] hci_event_packet+0x5f8/0x31c0 [bluetooth]
[ 2845.743742]  [<c03dfe19>] ? sock_def_readable+0x59/0x80
[ 2845.743742]  [<c046c14d>] ? _read_unlock+0x1d/0x20
[ 2845.743742]  [<f8178aa9>] ? hci_send_to_sock+0xe9/0x1d0 [bluetooth]
[ 2845.743742]  [<c015388b>] ? trace_hardirqs_on+0xb/0x10
[ 2845.743742]  [<f816fa6a>] hci_rx_task+0x2ba/0x490 [bluetooth]
[ 2845.743742]  [<c0133661>] ? tasklet_action+0x31/0xc0
[ 2845.743742]  [<c013367c>] tasklet_action+0x4c/0xc0
[ 2845.743742]  [<c0132eb7>] __do_softirq+0xa7/0x170
[ 2845.743742]  [<c0116dec>] ? ack_apic_level+0x5c/0x1c0
[ 2845.743742]  [<c0132fd7>] do_softirq+0x57/0x60
[ 2845.743742]  [<c01333dc>] irq_exit+0x7c/0x90
[ 2845.743742]  [<c01055bb>] do_IRQ+0x4b/0x90
[ 2845.743742]  [<c01333d5>] ? irq_exit+0x75/0x90
[ 2845.743742]  [<c010392c>] common_interrupt+0x2c/0x34
[ 2845.743742]  [<c010a14f>] ? mwait_idle+0x4f/0x70
[ 2845.743742]  [<c0101c05>] cpu_idle+0x65/0xb0
[ 2845.743742]  [<c045731e>] rest_init+0x4e/0x60
[ 2845.743742] ---[ end trace 4c985b38f02227a0 ]---
[ 2845.743742] ------------[ cut here ]------------
[ 2845.743742] WARNING: at kernel/smp.c:226 smp_call_function_single+0x8e/0x110()
[ 2845.743742] Hardware name: Dell DM051                   
[ 2845.743742] Modules linked in: btusb netconsole snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss rfcomm l2cap bluetooth vfat fuse snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm pl2303 snd_timer psmouse usbserial snd 3c59x e100 serio_raw soundcore i2c_i801 intel_agp mii agpgart snd_page_alloc rtc_cmos rtc_core thermal processor rtc_lib button thermal_sys sg evdev
[ 2845.743742] Pid: 0, comm: swapper Tainted: G      D W  2.6.29-rc5-smp #54
[ 2845.743742] Call Trace:
[ 2845.743742]  [<c012e076>] warn_slowpath+0x86/0xa0
[ 2845.743742]  [<c012e000>] ? warn_slowpath+0x10/0xa0
[ 2845.743742]  [<c015041b>] ? trace_hardirqs_off+0xb/0x10
[ 2845.743742]  [<c0146384>] ? up+0x14/0x40
[ 2845.743742]  [<c012e661>] ? release_console_sem+0x31/0x1e0
[ 2845.743742]  [<c046c8ab>] ? _spin_lock_irqsave+0x6b/0x80
[ 2845.743742]  [<c015041b>] ? trace_hardirqs_off+0xb/0x10
[ 2845.743742]  [<c046c900>] ? _read_lock_irqsave+0x40/0x80
[ 2845.743742]  [<c012e7f2>] ? release_console_sem+0x1c2/0x1e0
[ 2845.743742]  [<c0146384>] ? up+0x14/0x40
[ 2845.743742]  [<c015b7be>] smp_call_function_single+0x8e/0x110
[ 2845.743742]  [<c010a1a0>] ? stop_this_cpu+0x0/0x40
[ 2845.743742]  [<c026d23f>] ? cpumask_next_and+0x1f/0x40
[ 2845.743742]  [<c015b95a>] smp_call_function_many+0x11a/0x200
[ 2845.743742]  [<c010a1a0>] ? stop_this_cpu+0x0/0x40
[ 2845.743742]  [<c015ba61>] smp_call_function+0x21/0x30
[ 2845.743742]  [<c01137ae>] native_smp_send_stop+0x1e/0x50
[ 2845.743742]  [<c012e0f5>] panic+0x55/0x110
[ 2845.743742]  [<c01065a8>] oops_end+0xb8/0xc0
[ 2845.743742]  [<c010668f>] die+0x4f/0x70
[ 2845.743742]  [<c011a8c9>] do_page_fault+0x269/0x610
[ 2845.743742]  [<c011a660>] ? do_page_fault+0x0/0x610
[ 2845.743742]  [<c046cbaf>] error_code+0x77/0x7c
[ 2845.743742]  [<c015515c>] ? __lock_acquire+0x6c/0xa80
[ 2845.743742]  [<c0153732>] ? trace_hardirqs_on_caller+0x72/0x1c0
[ 2845.743742]  [<c0155be6>] lock_acquire+0x76/0xa0
[ 2845.743742]  [<c03e1aad>] ? skb_dequeue+0x1d/0x70
[ 2845.743742]  [<c046c885>] _spin_lock_irqsave+0x45/0x80
[ 2845.743742]  [<c03e1aad>] ? skb_dequeue+0x1d/0x70
[ 2845.743742]  [<c03e1aad>] skb_dequeue+0x1d/0x70
[ 2845.743742]  [<c03e1f94>] skb_queue_purge+0x14/0x20
[ 2845.743742]  [<f8171f5a>] hci_conn_del+0x10a/0x1c0 [bluetooth]
[ 2845.743742]  [<f81399c9>] ? l2cap_disconn_ind+0x59/0xb0 [l2cap]
[ 2845.743742]  [<f81795ce>] ? hci_conn_del_sysfs+0x8e/0xd0 [bluetooth]
[ 2845.743742]  [<f8175758>] hci_event_packet+0x5f8/0x31c0 [bluetooth]
[ 2845.743742]  [<c03dfe19>] ? sock_def_readable+0x59/0x80
[ 2845.743742]  [<c046c14d>] ? _read_unlock+0x1d/0x20
[ 2845.743742]  [<f8178aa9>] ? hci_send_to_sock+0xe9/0x1d0 [bluetooth]
[ 2845.743742]  [<c015388b>] ? trace_hardirqs_on+0xb/0x10
[ 2845.743742]  [<f816fa6a>] hci_rx_task+0x2ba/0x490 [bluetooth]
[ 2845.743742]  [<c0133661>] ? tasklet_action+0x31/0xc0
[ 2845.743742]  [<c013367c>] tasklet_action+0x4c/0xc0
[ 2845.743742]  [<c0132eb7>] __do_softirq+0xa7/0x170
[ 2845.743742]  [<c0116dec>] ? ack_apic_level+0x5c/0x1c0
[ 2845.743742]  [<c0132fd7>] do_softirq+0x57/0x60
[ 2845.743742]  [<c01333dc>] irq_exit+0x7c/0x90
[ 2845.743742]  [<c01055bb>] do_IRQ+0x4b/0x90
[ 2845.743742]  [<c01333d5>] ? irq_exit+0x75/0x90
[ 2845.743742]  [<c010392c>] common_interrupt+0x2c/0x34
[ 2845.743742]  [<c010a14f>] ? mwait_idle+0x4f/0x70
[ 2845.743742]  [<c0101c05>] cpu_idle+0x65/0xb0
[ 2845.743742]  [<c045731e>] rest_init+0x4e/0x60
[ 2845.743742] ---[ end trace 4c985b38f02227a1 ]---
[ 2845.743742] Rebooting in 3 seconds..


My logitec bluetooth mouse trying connect to pc, but
pc side reject the connection again and again. then panic happens. 

The reason is due to hci_conn_del_sysfs now called in hci_event_packet,
the del work is done in a workqueue, so it's possible done before
skb_queue_purge called.

I move the hci_conn_del_sysfs after skb_queue_purge just as that before
marcel's commit.

Remove the hci_conn_del_sysfs in hci_conn_hash_flush as well due to
hci_conn_del will deal with the work. 

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
net/bluetooth/hci_conn.c  |    4 ++--
net/bluetooth/hci_event.c |    2 --
2 files changed, 2 insertions(+), 4 deletions(-)

diff -uprN a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
--- a/net/bluetooth/hci_conn.c	2009-02-20 20:31:47.000000000 +0800
+++ b/net/bluetooth/hci_conn.c	2009-02-20 20:32:10.000000000 +0800
@@ -280,6 +280,8 @@ int hci_conn_del(struct hci_conn *conn)
 
 	skb_queue_purge(&conn->data_q);
 
+	hci_conn_del_sysfs(conn);
+
 	return 0;
 }
 
@@ -542,8 +544,6 @@ void hci_conn_hash_flush(struct hci_dev 
 
 		c->state = BT_CLOSED;
 
-		hci_conn_del_sysfs(c);
-
 		hci_proto_disconn_ind(c, 0x16);
 		hci_conn_del(c);
 	}
diff -uprN a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
--- a/net/bluetooth/hci_event.c	2009-02-20 20:31:58.000000000 +0800
+++ b/net/bluetooth/hci_event.c	2009-02-20 20:32:10.000000000 +0800
@@ -1009,8 +1009,6 @@ static inline void hci_disconn_complete_
 	if (conn) {
 		conn->state = BT_CLOSED;
 
-		hci_conn_del_sysfs(conn);
-
 		hci_proto_disconn_ind(conn, ev->reason);
 		hci_conn_del(conn);
 	}
