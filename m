Return-Path: <linux-kernel-owner+w=401wt.eu-S1759829AbZEMLWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829AbZEMLWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 07:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758674AbZEMLVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 07:21:55 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:34676 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758358AbZEMLVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 07:21:53 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       USB list <linux-usb@vger.kernel.org>
Subject: [PATCH] usb-serial: ftdi: don't dereference NULL pointer
Date: Wed, 13 May 2009 13:21:43 +0200
Message-Id: <1242213703-3004-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FTDI USB serial driver dereferences its priv structure in
ftdi_close() without checking for NULL pointer conditions, see the Oops
attached.

The flaw can be reproduced using the following steps:

 - connect an FTDI serial converter
 - run cu -l ttyUSB0
 - disconnect the device
 - hit enter in the cu session

The root cause for this is that ftdi_sio_port_remove() is called upon
the devices disconnect which sets the private pointer to NULL, but the
device remains opened until 'cu' gets a write error and subsequently
closes the device.

As we can't call cancel_delayed_work_sync() from ftdi_close() anymore,
do that from ftdi_sio_port_remove() now.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: USB list <linux-usb@vger.kernel.org>

May 13 11:57:07 jup kernel: [   66.355293] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disconnected from ttyUSB0
May 13 11:57:07 jup kernel: [   66.382115] drivers/usb/serial/ftdi_sio.c: ftdi_shutdown
May 13 11:57:07 jup kernel: [   66.382119] ftdi_sio 1-4.4:1.0: device disconnected
May 13 11:57:07 jup kernel: [   66.396103] usb 1-4.4:1.0: uevent
May 13 11:57:07 jup kernel: [   66.397329] usb 1-4.4: uevent
May 13 11:57:07 jup kernel: [   66.525618] hub 1-4:1.0: debounce: port 4: total 100ms stable 100ms status 0x100
May 13 11:57:08 jup kernel: [   66.958471] drivers/usb/serial/usb-serial.c: serial_close - port 0
May 13 11:57:08 jup kernel: [   66.958477] drivers/usb/serial/ftdi_sio.c: ftdi_close
May 13 11:57:08 jup kernel: [   66.958491] BUG: unable to handle kernel NULL pointer dereference at 00000080
May 13 11:57:08 jup kernel: [   66.962419] IP: [<c022f054>] del_timer+0xc/0x4e
May 13 11:57:08 jup kernel: [   66.962419] *pde = 00000000
May 13 11:57:08 jup kernel: [   67.000022] Oops: 0000 [#1] PREEMPT SMP
May 13 11:57:08 jup kernel: [   67.000022] last sysfs file: /sys/devices/pci0000:00/0000:00:02.1/usb1/1-4/1-4.4/idProduct
May 13 11:57:08 jup kernel: [   67.000022] Modules linked in: ftdi_sio usbserial ppdev lp cpufreq_userspace cpufreq_conservative cpufreq_powersave cpufreq_stats cpufreq_ondemand
freq_table nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc dm_crypt dm_mod aes_generic cryptoloop loop snd_usb_caiaq snd_rawmidi snd_pcm snd_timer via_rhine snd_page_alloc psm
ouse pcspkr forcedeth mii i2c_nforce2 parport_pc thermal button processor
May 13 11:57:08 jup kernel: [   67.000022]
May 13 11:57:08 jup kernel: [   67.000022] Pid: 2859, comm: cu Tainted: G        W  (2.6.30-rc5 #3) MS-7260
May 13 11:57:08 jup kernel: [   67.000022] EIP: 0060:[<c022f054>] EFLAGS: 00010282 CPU: 1
May 13 11:57:08 jup kernel: [   67.000022] EIP is at del_timer+0xc/0x4e
May 13 11:57:08 jup kernel: [   67.000022] EAX: 00000080 EBX: 00000080 ECX: 00000006 EDX: 00000080
May 13 11:57:08 jup kernel: [   67.000022] ESI: 00000000 EDI: 00000000 EBP: f5829e00 ESP: f5829df4
May 13 11:57:08 jup kernel: [   67.000022]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
May 13 11:57:08 jup kernel: [   67.000022] Process cu (pid: 2859, ti=f5828000 task=f58e92b0 task.ti=f5828000)
May 13 11:57:08 jup kernel: [   67.000022] Stack:
May 13 11:57:08 jup kernel: [   67.000022]  0000000f 000004bd 00000064 f5829e74 c023550f 00000080 00000007 00000068
May 13 11:57:08 jup kernel: [   67.000022]  c0245738 f58e92b0 f58e92b0 00000074 f58e92b0 00000007 f5829e44 c0245738
May 13 11:57:08 jup kernel: [   67.000022]  00000006 f58e92b0 c051d90a f66b817c f5829e54 c024597c f66b8198 f66b8178
May 13 11:57:08 jup kernel: [   67.000022] Call Trace:
May 13 11:57:08 jup kernel: [   67.000022]  [<c023550f>] ? __cancel_work_timer+0x2c/0x190
May 13 11:57:08 jup kernel: [   67.000022]  [<c0245738>] ? mark_held_locks+0x43/0x5b
May 13 11:57:08 jup kernel: [   67.000022]  [<c0245738>] ? mark_held_locks+0x43/0x5b
May 13 11:57:08 jup kernel: [   67.000022]  [<c051d90a>] ? __mutex_unlock_slowpath+0xe9/0x105
May 13 11:57:08 jup kernel: [   67.000022]  [<c024597c>] ? trace_hardirqs_on_caller+0xff/0x120
May 13 11:57:08 jup kernel: [   67.000022]  [<c02459a8>] ? trace_hardirqs_on+0xb/0xd
May 13 11:57:08 jup kernel: [   67.000022]  [<c023567e>] ? cancel_delayed_work_sync+0xb/0xd
May 13 11:57:08 jup kernel: [   67.000022]  [<f97e0c77>] ? ftdi_close+0xbc/0xdb [ftdi_sio]
May 13 11:57:08 jup kernel: [   67.000022]  [<f978f8a2>] ? serial_close+0x7d/0x124 [usbserial]
May 13 11:57:08 jup kernel: [   67.000022]  [<c03cb028>] ? tty_release_dev+0x176/0x3fa
May 13 11:57:08 jup kernel: [   67.000022]  [<c028e16b>] ? vfs_ioctl+0x22/0x69
May 13 11:57:08 jup kernel: [   67.000022]  [<c028e604>] ? do_vfs_ioctl+0x452/0x48b
May 13 11:57:08 jup kernel: [   67.000022]  [<c03cb2be>] ? tty_release+0x12/0x1c
May 13 11:57:08 jup kernel: [   67.000022]  [<c0284097>] ? __fput+0xca/0x175
May 13 11:57:08 jup kernel: [   67.000022]  [<c028415b>] ? fput+0x19/0x1b
May 13 11:57:08 jup kernel: [   67.000022]  [<c0281805>] ? filp_close+0x51/0x5b
May 13 11:57:08 jup kernel: [   67.000022]  [<c0281879>] ? sys_close+0x6a/0xa4
May 13 11:57:08 jup kernel: [   67.000022]  [<c02029c8>] ? sysenter_do_call+0x12/0x36
May 13 11:57:08 jup kernel: [   67.000022] Code: 10 c7 43 04 00 02 20 00 c7 03 00 00 00 00 8b 55 f4 89 c8 e8 da 03 2f 00 59 5b 89 f0 5e c9 c3 55 89 e5 56 31 f6 53 89 c3 83 ec 04
<83> 38 00 74 36 8d 55 f4 31 f6 e8 e4 fd ff ff 8b 13 89 c1 85 d2
May 13 11:57:08 jup kernel: [   67.000022] EIP: [<c022f054>] del_timer+0xc/0x4e SS:ESP 0068:f5829df4
May 13 11:57:08 jup kernel: [   67.000022] CR2: 0000000000000080
May 13 11:57:08 jup kernel: [   67.001177] ---[ end trace 5f3b95b2cbba4930 ]---
---
 drivers/usb/serial/ftdi_sio.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 0ab8474..aa9643b 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1492,6 +1492,7 @@ static int ftdi_sio_port_remove(struct usb_serial_port *port)
 	 */
 
 	if (priv) {
+		cancel_delayed_work_sync(&priv->rx_work);
 		usb_set_serial_port_data(port, NULL);
 		kref_put(&priv->kref, ftdi_sio_priv_release);
 	}
@@ -1601,11 +1602,14 @@ static void ftdi_close(struct tty_struct *tty,
 	mutex_unlock(&port->serial->disc_mutex);
 
 	/* cancel any scheduled reading */
-	cancel_delayed_work_sync(&priv->rx_work);
+	if (priv)
+		cancel_delayed_work_sync(&priv->rx_work);
 
 	/* shutdown our bulk read */
 	usb_kill_urb(port->read_urb);
-	kref_put(&priv->kref, ftdi_sio_priv_release);
+
+	if (priv)
+		kref_put(&priv->kref, ftdi_sio_priv_release);
 } /* ftdi_close */
 
 
-- 
1.6.2.1

