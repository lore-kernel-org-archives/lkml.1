Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbYLSTOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbYLSTOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 14:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYLSTOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 14:14:21 -0500
Received: from smtp-out.google.com ([216.239.45.13]:62909 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbYLSTOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 14:14:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:content-type:content-transfer-encoding;
	b=gnPSutoXcsl3r/jHOhWelmMiBBCgT/ple0LQD6ZkLnFLQJSeoePUnSOnCVIL7sHuE
	Ujs9HzGD3KbqhqzN5Y81Q==
MIME-Version: 1.0
Date: Fri, 19 Dec 2008 11:14:15 -0800
Message-ID: <35c90d960812191114j7a2023f9p6c37e2e04e1cef57@mail.gmail.com>
Subject: [RFC] Control of uart clock from tty client
From: Nick Pelly <npelly@google.com>
To: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arm@lists.arm.linux.org.uk, alan@redhat.com, rmk@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On embedded architectures we need to clk_enable()/clk_disable() the
bluetooth uart clock when the bluetooth chip enters/exits low power
mode, to reduce power usage.

This needs to occur independently of the linux cpu suspend/resume
paths, because many bluetooth chips (TI BRF6300 in our case) have
power states that transition independently of the linux cpu: we need
to be able to turn the BT uart off while the linux CPU is running, and
leave the BT uart on while the linux CPU is in suspend.

The BT power state is known in drivers/bluetooth/hci_ll.c which reads
headers on the BT HCI traffic to determine what power state the BT
chip is in.

Our current implementation makes calls directly from hci_ll.c into our
uart driver to tell it when it can clk_enable() / clk_disable().
Sample patch is attached.

We know that calling the uart driver directly from hci_ll.c is
unlikely to get merged upstream, because we have by-passed the tty and
serial_core layers. Are there any suggestions on how to plumb clock
control from hci_ll.c to our uart driver in a way that could get
merged upstream?

Would probably need to use an existing uart_ops (serial_core.h). But
none seem suitable:
   .ioctl uses a mutex, but we cannot sleep from hci_ll.c
   .pm is also called during suspend / resume
   .set_termios using a baud rate of zero to clk_disable() seems
workable, but how to clk_enable() ?

Anyway here is a sample patch. I've just shown how hci_ll.c calls the
msm_serial_clock_*() interface we introduced. The implementation of
msm_serial_clock_*() in msm_serial.c is fairly hefty because of our
requirement to flush the tx path before clk_disable(), and
msm_serial.c is not yet in mainline linux, so for this side of the
implementation please see:
http://android.git.kernel.org/?p=kernel/msm.git;f=drivers/serial/msm_serial.c;hb=android-msm-htc-2.6.25
http://android.git.kernel.org/?p=kernel/msm.git;f=drivers/serial/msm_serial.h;hb=android-msm-htc-2.6.25

Requesting comments on how to implement this clock control in a way
that could get merged upstream.


commit 16be2941c59b3fe089149b4cf15543
499a3e1819
Author: Nick Pelly <npelly@google.com>
Date:   Mon Jun 30 16:41:58 2008 -0700

   bluetooth: use msm_serial clock control for power management of bt uart.

   Signed-off-by: Nick Pelly <npelly@google.com>

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 075598e..f99d89d 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -90,6 +90,16 @@ config BT_HCIUART_LL

         Say Y here to compile support for HCILL protocol.

+config BT_HCIUART_LL_USE_MSM_SERIAL_CLOCK_CONTROL
+       bool "Make msm serial clock requests when the BT chip sleeps."
+       depends on SERIAL_MSM_CLOCK_CONTROL
+       default n
+       help
+         Sends requests to msm_serial to turn the uart clock on and off as the
+         Bluetooth chip enters/exists deep sleep, providing power savings.
+         This requires that the tty layer for bluetooth uses the msm_serial
+         driver.
+
 config BT_HCIBCM203X
       tristate "HCI BCM203x USB driver"
       depends on USB
diff --git a/drivers/bluetooth/hci_ll.c b/drivers/bluetooth/hci_ll.c
index b91d45a..6c4d698 100644
--- a/drivers/bluetooth/hci_ll.c
+++ b/drivers/bluetooth/hci_ll.c
@@ -45,6 +45,8 @@
 #include <linux/signal.h>
 #include <linux/ioctl.h>
 #include <linux/skbuff.h>
+#include <linux/serial_core.h>
+#include <linux/tty.h>

 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
@@ -173,6 +175,28 @@ static int ll_close(struct hci_uart *hu)
       return 0;
 }

+#ifdef CONFIG_BT_HCIUART_LL_USE_MSM_SERIAL_CLOCK_CONTROL
+void msm_serial_clock_on(struct uart_port *port);
+void msm_serial_clock_request_off(struct uart_port *port);
+
+static void __ll_msm_serial_clock_on(struct tty_struct *tty) {
+       struct uart_state *state = tty->driver_data;
+       struct uart_port *port = state->port;
+
+       msm_serial_clock_on(port);
+}
+
+static void __ll_msm_serial_clock_request_off(struct tty_struct *tty) {
+       struct uart_state *state = tty->driver_data;
+       struct uart_port *port = state->port;
+
+       msm_serial_clock_request_off(port);
+}
+#else
+static inline void __ll_msm_serial_clock_on(struct tty_struct *tty) {}
+static inline void __ll_msm_serial_clock_request_off(struct tty_struct *tty) {}
+#endif
+
 /*
 * internal function, which does common work of the device wake up process:
 * 1. places all pending packets (waiting in tx_wait_q list) in txq list.
@@ -218,6 +242,10 @@ static void ll_device_want_to_wakeup(struct hci_uart *hu)
               BT_DBG("dual wake-up-indication");
               /* deliberate fall-through - do not add break */
       case HCILL_ASLEEP:
+               /* Make sure clock is on - we may have turned clock off since
+                * receiving the wake up indicator
+         */
+               __ll_msm_serial_clock_on(hu->tty);
               /* acknowledge device wake up */
               if (send_hcill_cmd(HCILL_WAKE_UP_ACK, hu) < 0) {
                       BT_ERR("cannot acknowledge device wake up");
@@ -271,6 +299,11 @@ out:

       /* actually send the sleep ack packet */
       hci_uart_tx_wakeup(hu);
+
+       spin_lock_irqsave(&ll->hcill_lock, flags);
+       if (ll->hcill_state == HCILL_ASLEEP)
+               __ll_msm_serial_clock_request_off(hu->tty);
+       spin_unlock_irqrestore(&ll->hcill_lock, flags);
 }

 /*
@@ -322,6 +355,7 @@ static int ll_enqueue(struct hci_uart *hu, struct
sk_buff *skb)
               break;
       case HCILL_ASLEEP:
               BT_DBG("device asleep, waking up and queueing packet");
+               __ll_msm_serial_clock_on(hu->tty);
               /* save packet for later */
               skb_queue_tail(&ll->tx_wait_q, skb);
               /* awake device */
