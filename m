Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbYEDIRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbYEDIRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 04:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYEDIRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 04:17:03 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:52632 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731AbYEDIQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 04:16:59 -0400
To: devzero@web.de, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] NULL pointer dereference in uart_write_room().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <261636618@web.de>
	<200805022300.GIB30385.FJOVHQSMFtOOFL@I-love.SAKURA.ne.jp>
In-Reply-To: <200805022300.GIB30385.FJOVHQSMFtOOFL@I-love.SAKURA.ne.jp>
Message-Id: <200805041716.DDG43279.JOSMHVFOFFQLOt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 4 May 2008 17:16:55 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

First report: http://lkml.org/lkml/2008/4/22/42

Second report: http://lkml.org/lkml/2008/5/2/22

> > since this seems to get any attention - should we put this in kernel bugzilla at bugzilla.kernel.org ?
> 
> Today, I found that this bug is triggered by CONFIG_SERIAL_8250_PNP=m .

I know nothing about the serial code, so call chains shown below might contain errors.

(1) The kernel sets up /dev/ttyS0 by "console=ttyS0,115200n8" boot parameter.

(2) 8250_pnp.ko is loaded by "modprobe 8250_pnp".

(3) serial_pnp_probe() is called by someone. I couldn't find who is calling.

(4) serial8250_register_port() is called by serial_pnp_probe().

(5) uart_remove_one_port() is called by serial8250_register_port()
    since ttyS0 is already in use but it is requested to be once removed.

(6) tty_vhangup() is called by uart_remove_one_port().
    I used panic() to print tty_vhangup() is about to be called.

(7) do_tty_hangup() is called by tty_vhangup().

(8) tty_fasync() is called by do_tty_hangup() since
    ttyS0 is in use by "console=ttyS0,115200n8" boot parameter.
    But since tty_fasync() can't wait for completion of pending printk(),
    a thread is created or an event is enqueued?

(9) "state->info = NULL;" is performed by uart_remove_one_port().

(10) Some thread attempts to call output routines such as uart_start(),
     transmit_chars(), uart_write_room(). But it results in NULL pointer
     dereferences because of (9).

---------- first error ----------

Starting udev : BUG: unable to handle kernel NULL pointer dereference at 00000008
IP: [<c026bed2>] __uart_start+0x12/0x40
Oops: 0000 [#1] SMP 
Modules linked in: sr_mod cdrom piix ide_pci_generic evdev sg evbug container thermal ac psmouse processor serio_raw button 8250_pnp parport_pc parport ata_piix ata_generic pcnet32 libata mii intel_agp i2c_piix4 i2c_core agpgart dock ide_disk ide_core mptspi scsi_transport_spi mptscsih mptbase sd_mod scsi_mod

Pid: 883, comm: start_udev Not tainted (2.6.25 #2)
EIP: 0060:[<c026bed2>] EFLAGS: 00010046 CPU: 0
EIP is at __uart_start+0x12/0x40
EAX: df8503c0 EBX: c0488900 ECX: df3d8c00 EDX: 00000000
ESI: df3d8c00 EDI: c0488900 EBP: ded0bec4 ESP: ded0bec0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process start_udev (pid: 883, ti=ded0a000 task=df2e50b0 task.ti=ded0a000)
Stack: 00000296 ded0bed8 c026c3dc 00000001 00000001 df3d8c00 ded0bee0 c026c408 
       ded0bf1c c025b024 dec3bc00 df398240 df3d8d18 dec3bc00 c025772f 00000000 
       df2e50b0 c011f330 df3d8d1c df3d8d1c 00000001 df3d8c00 df398240 ded0bf50 
Call Trace:
 [<c026c3dc>] ? uart_start+0x2c/0x50
 [<c026c408>] ? uart_flush_chars+0x8/0x10
 [<c025b024>] ? write_chan+0x1d4/0x310
 [<c025772f>] ? tty_ldisc_ref_wait+0xf/0xa0
 [<c011f330>] ? default_wake_function+0x0/0x10
 [<c02587b7>] ? tty_write+0x127/0x1c0
 [<c025ae50>] ? write_chan+0x0/0x310
 [<c025a194>] ? redirected_tty_write+0x74/0x80
 [<c0180906>] ? vfs_write+0x96/0x130
 [<c013030e>] ? recalc_sigpending+0xe/0x30
 [<c025a120>] ? redirected_tty_write+0x0/0x80
 [<c0180f9d>] ? sys_write+0x3d/0x70
 [<c0105c4e>] ? sysenter_past_esp+0x5f/0x85
 =======================
Code: d0 d1 3d c0 e8 e0 1d ff ff 85 db 75 9c e9 4f ff ff ff 90 90 90 90 90 90 90 55 89 c1 89 e5 53 8b 80 44 01 00 00 8b 50 10 8b 58 14 <8b> 42 08 3b 42 0c 74 10 8b 42 04 85 c0 74 09 f6 81 c8 00 00 00 
EIP: [<c026bed2>] __uart_start+0x12/0x40 SS:ESP 0068:ded0bec0
---[ end trace a115fb9b8eb378b3 ]---

---------- second error ----------

Starting udev : BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<c026f447>] transmit_chars+0x17/0xe0
Oops: 0000 [#1] SMP 
Modules linked in: 8250_pnp(+) ac ata_piix(+) processor ata_generic button libata intel_agp pcnet32 i2c_piix4 mii agpgart i2c_core dock ide_disk ide_core mptspi mptscsih mptbase scsi_transport_spi sd_mod scsi_mod

Pid: 1712, comm: modprobe Not tainted (2.6.25 #3)
EIP: 0060:[<c026f447>] EFLAGS: 00010046 CPU: 0
EIP is at transmit_chars+0x17/0xe0
EAX: 00000000 EBX: c0488900 ECX: 00000000 EDX: 00000000
ESI: c0488900 EDI: c0488220 EBP: df04df28 ESP: df04df1c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 1712, ti=df04c000 task=dfa350b0 task.ti=df04c000)
Stack: c0488900 c04889a4 c0488220 df04df5c c0271971 d1f58daf 00001000 00000004 
       00000000 00000000 00000000 00000246 00000060 df36ab20 00000000 00000000 
       df04df74 c0159f81 00000004 c03ec080 00000004 00000000 df04df8c c015b6df 
Call Trace:
 [<c0271971>] ? serial8250_interrupt+0x121/0x150
 [<c0159f81>] ? handle_IRQ_event+0x31/0x60
 [<c015b6df>] ? handle_level_irq+0x6f/0xe0
 [<c01089cf>] ? do_IRQ+0x4f/0x90
 [<c0180f2d>] ? sys_read+0x3d/0x70
 [<c010665f>] ? common_interrupt+0x23/0x28
 [<c0105bf2>] ? sysenter_past_esp+0x3/0x85
 =======================
Code: c2 89 c2 83 ca 20 83 e1 10 0f 45 c2 c3 8d b4 26 00 00 00 00 55 89 e5 57 56 89 c6 53 8b 50 24 0f b6 40 18 84 c0 0f 85 ae 00 00 00 <8b> 02 f6 80 c8 00 00 00 03 0f 85 93 00 00 00 8d 5a 04 8b 43 04 
EIP: [<c026f447>] transmit_chars+0x17/0xe0 SS:ESP 0068:df04df1c
Kernel panic - not syncing: Fatal exception in interrupt

---------- third error ----------

Starting udev : BUG: unable to handle kernel NULL pointer dereference at 0000000c
IP: [<c026c03d>] uart_write_room+0xd/0x20
Oops: 0000 [#1] SMP 
Modules linked in: sr_mod cdrom piix ide_pci_generic container evdev sg evbug thermal ac button processor psmouse serio_raw parport_pc ata_piix 8250_pnp parport ata_generic libata intel_agp agpgart dock i2c_piix4 pcnet32 mii i2c_core ide_disk ide_core mptspi scsi_transport_spi mptscsih mptbase sd_mod scsi_mod

Pid: 883, comm: start_udev Not tainted (2.6.25 #4)
EIP: 0060:[<c026c03d>] EFLAGS: 00010202 CPU: 1
EIP is at uart_write_room+0xd/0x20
EAX: df850000 EBX: 00000001 ECX: df3f291c EDX: 00000000
ESI: 00000001 EDI: df3f2800 EBP: dec49f1c ESP: dec49ee4
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process start_udev (pid: 883, ti=dec48000 task=dec3b0b0 task.ti=dec48000)
Stack: c025af4b df3b1000 df80f840 df3f2918 df3b1000 c025772f 00000000 dec3b0b0 
       c011f330 df3f291c df3f291c 00000001 df3f2800 df80f840 dec49f50 c02587b7 
       00000001 00000001 b7f7b000 c025ae50 df3f280c 00000000 00000001 00000000 
Call Trace:
 [<c025af4b>] ? write_chan+0xfb/0x310
 [<c025772f>] ? tty_ldisc_ref_wait+0xf/0xa0
 [<c011f330>] ? default_wake_function+0x0/0x10
 [<c02587b7>] ? tty_write+0x127/0x1c0
 [<c025ae50>] ? write_chan+0x0/0x310
 [<c025a194>] ? redirected_tty_write+0x74/0x80
 [<c0180906>] ? vfs_write+0x96/0x130
 [<c013030e>] ? recalc_sigpending+0xe/0x30
 [<c025a120>] ? redirected_tty_write+0x0/0x80
 [<c0180f9d>] ? sys_write+0x3d/0x70
 [<c0105c4e>] ? sysenter_past_esp+0x5f/0x85
 =======================
Code: 5d c3 8b 40 10 81 48 10 00 00 00 02 eb db 81 49 10 00 00 00 04 eb c2 8d b4 26 00 00 00 00 55 8b 80 44 01 00 00 89 e5 5d 8b 50 10 <8b> 42 0c 83 e8 01 2b 42 08 25 ff 0f 00 00 c3 8d 74 26 00 55 8b 
EIP: [<c026c03d>] uart_write_room+0xd/0x20 SS:ESP 0068:dec49ee4
---[ end trace fcd8e4a9aa582405 ]---





The below is the patch which I used for analyzing this bug.
This patch is NOT a correct fix.
I can't go further, so please put this in kernel bugzilla if you want.

Regards.

---
 drivers/serial/8250.c        |    9 ++++++++-
 drivers/serial/8250_pnp.c    |    2 ++
 drivers/serial/serial_core.c |   15 +++++++++++++--
 3 files changed, 23 insertions(+), 3 deletions(-)

--- linux-2.6.25.orig/drivers/serial/8250.c
+++ linux-2.6.25/drivers/serial/8250.c
@@ -1354,9 +1354,13 @@ ignore_char:
 
 static void transmit_chars(struct uart_8250_port *up)
 {
-	struct circ_buf *xmit = &up->port.info->xmit;
+	struct circ_buf *xmit;
 	int count;
 
+	if (!up || !up->port.info)
+		return;
+	xmit = &up->port.info->xmit;
+
 	if (up->port.x_char) {
 		serial_outp(up, UART_TX, up->port.x_char);
 		up->port.icount.tx++;
@@ -2813,6 +2817,8 @@ int serial8250_register_port(struct uart
 
 	uart = serial8250_find_match_or_unused(port);
 	if (uart) {
+		printk("********** about to call uart_remove_one_port **********\n");
+		dump_stack();
 		uart_remove_one_port(&serial8250_reg, &uart->port);
 
 		uart->port.iobase       = port->iobase;
@@ -2828,6 +2834,7 @@ int serial8250_register_port(struct uart
 		if (port->dev)
 			uart->port.dev = port->dev;
 
+		printk("********** about to call uart_add_one_port **********\n");
 		ret = uart_add_one_port(&serial8250_reg, &uart->port);
 		if (ret == 0)
 			ret = uart->port.line;
--- linux-2.6.25.orig/drivers/serial/serial_core.c
+++ linux-2.6.25/drivers/serial/serial_core.c
@@ -92,7 +92,12 @@ static void uart_stop(struct tty_struct 
 static void __uart_start(struct tty_struct *tty)
 {
 	struct uart_state *state = tty->driver_data;
-	struct uart_port *port = state->port;
+	struct uart_port *port;
+	if (!state || !state->info)
+		return;
+	port = state->port;
+	if (!port)
+		return;
 
 	if (!uart_circ_empty(&state->info->xmit) && state->info->xmit.buf &&
 	    !tty->stopped && !tty->hw_stopped)
@@ -522,6 +527,8 @@ static int uart_write_room(struct tty_st
 {
 	struct uart_state *state = tty->driver_data;
 
+	if (!state || !state->info)
+		return 1;
 	return uart_circ_chars_free(&state->info->xmit);
 }
 
@@ -2410,14 +2417,18 @@ int uart_remove_one_port(struct uart_dri
 	tty_unregister_device(drv->tty_driver, port->line);
 
 	info = state->info;
-	if (info && info->tty)
+	if (info && info->tty) {
+		panic("********** about to call tty_vhangup **********\n");
+		dump_stack();
 		tty_vhangup(info->tty);
+	}
 
 	/*
 	 * All users of this port should now be disconnected from
 	 * this driver, and the port shut down.  We should be the
 	 * only thread fiddling with this port from now on.
 	 */
+	printk("********** about to set state->info = NULL; **********\n");
 	state->info = NULL;
 
 	/*
--- linux-2.6.25.orig/drivers/serial/8250_pnp.c
+++ linux-2.6.25/drivers/serial/8250_pnp.c
@@ -466,6 +466,8 @@ serial_pnp_probe(struct pnp_dev *dev, co
 	port.uartclk = 1843200;
 	port.dev = &dev->dev;
 
+	printk("********** about to call serial8250_register_port **********\n");
+	dump_stack();
 	line = serial8250_register_port(&port);
 	if (line < 0)
 		return -ENODEV;
