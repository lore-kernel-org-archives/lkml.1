Return-Path: <linux-kernel-owner+w=401wt.eu-S1751616AbYJSOLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbYJSOLX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 10:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbYJSOLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 10:11:16 -0400
Received: from connectmail.carleton.ca ([134.117.2.12]:58398 "EHLO
	connectmail.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbYJSOLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 10:11:15 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Oct 2008 10:11:15 EDT
Date: Sun, 19 Oct 2008 10:06:13 -0400
From: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Regression in 2.6.27: "irq 18: nobody cared" on Toshiba Satellite A100
To: linux-kernel@vger.kernel.org
Message-id: <48FB3ED5.60904@superonline.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

As you might guess from the subject line, since I started to use 2.6.27-rcX
series, I began to get "irq 18: nobody cared" messages in dmesg. Currently I am
using 2.6.27.2 with Sidux on this laptop, which is a Toshiba Satellite A100.
I have reproduced this problem with vanilla and sidux's kernels.

The timing of this message is strange. For example, yesterday, the message
was printed at 3:00 am. I rebooted yesterday, and today it was printed at 5:30 am.
I was sleeping at both of these times, and the computer was doing nothing.

Here's the "nobody cared" message from dmesg: (Printed at 3:00 am yesterday.)

--- 8< ---
irq 18: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.27-1.slh.2-sidux-686 #1
 [<c016d514>] __report_bad_irq+0x24/0x90
 [<c016d802>] note_interrupt+0x282/0x2c0
 [<c016cb40>] handle_IRQ_event+0x30/0x60
 [<c016df73>] handle_fasteoi_irq+0xb3/0xe0
 [<c010717b>] do_IRQ+0x3b/0x70
 [<c0104993>] common_interrupt+0x23/0x28
 [<f8849348>] acpi_idle_enter_simple+0x1ac/0x224 [processor]
 [<c02c1265>] menu_select+0x35/0xd0
 [<c02bffd3>] cpuidle_idle_call+0x73/0xd0
 [<c0102dad>] cpu_idle+0x6d/0x140
 =======================
handlers:
[<f8890830>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<f88c5940>] (sdhci_irq+0x0/0x610 [sdhci])
[<f8afa8e0>] (yenta_interrupt+0x0/0xf0 [yenta_socket])
[<f8bd4640>] (tifm_7xx1_isr+0x0/0x140 [tifm_7xx1])
Disabling IRQ #18
--- >8 ---

The most detectable effect of this problem is that when I get the "nobody cared"
message in dmesg, my USB keyboard (which is attached to one of the USB ports
on the rear panel of the laptop) starts to react very slowly. When I disconnect
it, the removal of the keyboard is recognized by the kernel. However, when I
reconnect it to the same port, nothing happens - no messages in dmesg. The USB
ports on the right side of the laptop do not have this problem.

Please note that I have never seen this "nobody cared" message before
2.6.27-rcX series, and I have never needed to use the "irqpoll" option,
so I believe that this is a kernel regression. I have been using this
laptop without problems since 2.6.20 or so.

I look forward to getting this regression fixed, and I am willing to
recompile the kernel with different configurations, try patches, etc.

Regards,

M. Vefa Bicakci
=== Notes ===
Note 1: This "nobody cared" message was printed in two cases - once when the
"sdhci_pci" module was loaded and once when it was not loaded. In both of the
cases, "sdhci" module was loaded. Here's the message from dmesg when the
sdhci_pci module was *not* loaded: (Printed at 5:00 am today.)

--- 8< ---
irq 18: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.27.2 #1
 [<c016d484>] __report_bad_irq+0x24/0x90
 [<c016d772>] note_interrupt+0x282/0x2c0
 [<c016cab0>] handle_IRQ_event+0x30/0x60
 [<c016dee3>] handle_fasteoi_irq+0xb3/0xe0
 [<c010717b>] do_IRQ+0x3b/0x70
 [<c0104993>] common_interrupt+0x23/0x28
 [<f8849348>] acpi_idle_enter_simple+0x1ac/0x224 [processor]
 [<c02c0a45>] menu_select+0x35/0xd0
 [<c02bf7b3>] cpuidle_idle_call+0x73/0xd0
 [<c0102dad>] cpu_idle+0x6d/0x140
 =======================
handlers:
[<f8890830>] (usb_hcd_irq+0x0/0x80 [usbcore])
[<f8ae0640>] (tifm_7xx1_isr+0x0/0x140 [tifm_7xx1])
[<f8c4a8e0>] (yenta_interrupt+0x0/0xf0 [yenta_socket])
Disabling IRQ #18
--- >8 ---

Note 2: Another interesting thing which might be relevant is the following
message which appears in dmesg some time after I boot:

--- 8< ---
hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
--- >8 ---


