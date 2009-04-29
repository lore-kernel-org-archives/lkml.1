Return-Path: <linux-kernel-owner+w=401wt.eu-S1759097AbZD2Ptv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097AbZD2Ptv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 11:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756663AbZD2Ptg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 11:49:36 -0400
Received: from netrider.rowland.org ([192.131.102.5]:56117 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758589AbZD2Pte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 11:49:34 -0400
Date: Wed, 29 Apr 2009 11:49:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Daniel Mack <daniel@caiaq.de>, LKML <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: BUG: NULL pointer dereference in try_to_del_timer_sync()
In-Reply-To: <20090428235551.862ee0d1.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0904291147230.24643-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009, Andrew Morton wrote:

> (cc linux-usb)
> 
> On Tue, 28 Apr 2009 10:14:16 +0200 Daniel Mack <daniel@caiaq.de> wrote:
> 
> > This happened more than once in the last 12h on my desktop machine with
> > the kernel snapshot as of ce8a7424d23a36f043 (yesterday). It's not
> > reproducible, otherwise I would have bisected it.
> > 
> > Daniel
> > 
> > 
> > [10982.240372] BUG: unable to handle kernel NULL pointer dereference at 00000090
> > [10982.240383] IP: [<c022eefd>] lock_timer_base+0xe/0x3e
> > [10982.240396] *pde = 00000000 
> > [10982.240400] Oops: 0000 [#2] PREEMPT SMP 
> > [10982.240405] last sysfs file: /sys/devices/pci0000:00/0000:00:02.1/usb1/1-3/idProduct
> > [10982.240411] Modules linked in: cbc nvidia(P) ppdev lp nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc dm_crypt dm_mod aes_generic cryptoloop loop snd_usb_caiaq snd_rawmidi pl2303 snd_pcm ftdi_sio usbserial snd_timer snd_page_alloc psmouse pcspkr i2c_nforce2 via_rhine mii forcedeth parport_pc thermal button [last unloaded: nvidia]
> > [10982.240449] 
> > [10982.240455] Pid: 22809, comm: cu Tainted: P      D    (2.6.30-rc3 #1) MS-7260
> > [10982.240458] EIP: 0060:[<c022eefd>] EFLAGS: 00210286 CPU: 1
> > [10982.240462] EIP is at lock_timer_base+0xe/0x3e
> > [10982.240465] EAX: 0000007c EBX: 0000007c ECX: c022f4b9 EDX: ea10fe5c
> > [10982.240468] ESI: ffffffff EDI: 0000007c EBP: ea10fe54 ESP: ea10fe44
> > [10982.240471]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > [10982.240475] Process cu (pid: 22809, ti=ea10e000 task=ea779270 task.ti=ea10e000)
> > [10982.240477] Stack:
> > [10982.240479]  ea10fe5c 0000007c ffffffff 0000007c ea10fe68 c022f0b6 00200246 00000094
> > [10982.240488]  00200246 ea10fe7c c022f515 000004b2 f66b4c00 00000000 ea10fe94 f86930c6
> > [10982.240497]  22222222 f869c310 f66b4c00 ea0bf000 ea10feb8 f85c0a32 edc52f00 f66b4ce4
> > [10982.240507] Call Trace:
> > [10982.240510]  [<c022f0b6>] ? try_to_del_timer_sync+0x15/0x4f
> > [10982.240516]  [<c022f515>] ? del_timer_sync+0x5c/0x6c
> > [10982.240521]  [<f86930c6>] ? ftdi_close+0xc5/0xe9 [ftdi_sio]
> > [10982.240540]  [<f85c0a32>] ? serial_close+0x86/0x12d [usbserial]
> > [10982.240553]  [<c03cb413>] ? tty_release_dev+0x176/0x3fa
> > [10982.240561]  [<c023aefb>] ? lock_hrtimer_base+0x18/0x33
> > [10982.240568]  [<c0244ca4>] ? trace_hardirqs_off+0xb/0xd
> > [10982.240576]  [<c051feed>] ? _spin_unlock_irqrestore+0x42/0x58
> > [10982.240582]  [<c028e4ff>] ? vfs_ioctl+0x22/0x69
> > [10982.240589]  [<c028e998>] ? do_vfs_ioctl+0x452/0x48b
> > [10982.240594]  [<c03cb6a9>] ? tty_release+0x12/0x1c
> > [10982.240598]  [<c02843ab>] ? __fput+0xca/0x175
> > [10982.240604]  [<c028446f>] ? fput+0x19/0x1b
> > [10982.240608]  [<c0281b1d>] ? filp_close+0x51/0x5b
> > [10982.240612]  [<c0281b91>] ? sys_close+0x6a/0xa4
> > [10982.240616]  [<c02029c8>] ? sysenter_do_call+0x12/0x36
> > [10982.240623] Code: 40 f7 d0 83 e0 f2 5b c9 c3 55 31 c9 31 d2 64 a1 00 f0 73 c0 89 e5 e8 05 6f 00 00 c9 c3 55 89 e5 57 89 c7 56 53 83 ec 04 89 55 f0 <8b> 5f 14 89 de 83 e6 fe 74 22 89 f0 e8 8b 11 2f 00 8b 55 f0 89 
> > [10982.240675] EIP: [<c022eefd>] lock_timer_base+0xe/0x3e SS:ESP 0068:ea10fe44
> > [10982.240681] CR2: 0000000000000090
> > [10982.240685] ---[ end trace ca8d2f0f6a72aeeb ]---
> 
> usb-serial went splat.

Looks like the ftdi_sio driver doesn't use proper reference counting 
for its private data structure.  Does this patch help?

Alan Stern



Index: 2.6.30-rc3/drivers/usb/serial/ftdi_sio.c
===================================================================
--- 2.6.30-rc3.orig/drivers/usb/serial/ftdi_sio.c
+++ 2.6.30-rc3/drivers/usb/serial/ftdi_sio.c
@@ -56,6 +56,7 @@ static __u16 vendor = FTDI_VID;
 static __u16 product;
 
 struct ftdi_private {
+	struct kref kref;
 	ftdi_chip_type_t chip_type;
 				/* type of device, either SIO or FT8U232AM */
 	int baud_base;		/* baud base clock for divisor setting */
@@ -1468,6 +1469,13 @@ static void ftdi_shutdown(struct usb_ser
 	dbg("%s", __func__);
 }
 
+static void ftdi_sio_priv_release(struct kref *k)
+{
+	struct ftdi_private *priv = container_of(k, struct ftdi_private, kref);
+
+	kfree(priv);
+}
+
 static int ftdi_sio_port_remove(struct usb_serial_port *port)
 {
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
@@ -1482,7 +1490,7 @@ static int ftdi_sio_port_remove(struct u
 
 	if (priv) {
 		usb_set_serial_port_data(port, NULL);
-		kfree(priv);
+		kref_put(&priv->kref, ftdi_sio_priv_release);
 	}
 
 	return 0;
@@ -1547,7 +1555,8 @@ static int ftdi_open(struct tty_struct *
 		dev_err(&port->dev,
 			"%s - failed submitting read urb, error %d\n",
 			__func__, result);
-
+	else
+		kref_get(&priv->kref);
 
 	return result;
 } /* ftdi_open */
@@ -1589,11 +1598,11 @@ static void ftdi_close(struct tty_struct
 	mutex_unlock(&port->serial->disc_mutex);
 
 	/* cancel any scheduled reading */
-	cancel_delayed_work(&priv->rx_work);
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&priv->rx_work);
 
 	/* shutdown our bulk read */
 	usb_kill_urb(port->read_urb);
+	kref_put(&priv->kref, ftdi_sio_priv_release);
 } /* ftdi_close */
 
 

