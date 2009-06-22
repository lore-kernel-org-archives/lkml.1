Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbZFVMFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbZFVMFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbZFVMFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:05:12 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31860 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZFVMFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:05:11 -0400
Date: Mon, 22 Jun 2009 14:04:46 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <E4D3F24EA6C9E54F817833EAE0D912AC0228288428@bssrvexch01.BS.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-US
Content-transfer-encoding: 7BIT
Accept-Language: en-US
Thread-topic: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
Thread-index: AcnzMaJ2F25GNeSlQoi88DT6WBqLnQ==
acceptlanguage: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I would like to ask if someone has successfully used g_serial USB gadget driver with kernel 2.6.29 or 2.6.30? I'm developing a low level hardware driver for USB gadgets on ARM S3C6410 platform. This driver is working quite fine (I've used it a lot with g_ether CDC/RNDIS ethernet gadget driver). During my development I've found the following bug in g_serial driver:

On Linux host:

# cat /dev/ttyACM0

On device:

# cat >/dev/ttyGS0
[ 1897.350000] BUG: sleeping function called from invalid context at kernel/mutex.c:94
[ 1897.360000] in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper
[ 1897.370000] [<c0024afc>] (unwind_backtrace+0x0/0xdc) from [<c0267218>] (mutex_lock+0x14/0x30)
[ 1897.380000] [<c0267218>] (mutex_lock+0x14/0x30) from [<c014ceac>] (echo_char_raw+0x1c/0x48)
[ 1897.390000] [<c014ceac>] (echo_char_raw+0x1c/0x48) from [<c014ecdc>] (n_tty_receive_buf+0x9dc/0xec4)
[ 1897.390000] [<c014ecdc>] (n_tty_receive_buf+0x9dc/0xec4) from [<c01513bc>] (flush_to_ldisc+0x104/0x1b0)
[ 1897.400000] [<c01513bc>] (flush_to_ldisc+0x104/0x1b0) from [<bf001ce8>] (gs_rx_push+0x118/0x1cc [g_serial])
[ 1897.410000] [<bf001ce8>] (gs_rx_push+0x118/0x1cc [g_serial]) from [<c003c7c0>] (tasklet_action+0x78/0xc8)
[ 1897.420000] [<c003c7c0>] (tasklet_action+0x78/0xc8) from [<c003cc54>] (__do_softirq+0x6c/0xf4)
[ 1897.430000] [<c003cc54>] (__do_softirq+0x6c/0xf4) from [<c003cd20>] (irq_exit+0x44/0x5c)
[ 1897.440000] [<c003cd20>] (irq_exit+0x44/0x5c) from [<c001e054>] (_text+0x54/0x6c)
[ 1897.450000] [<c001e054>] (_text+0x54/0x6c) from [<c001ea28>] (__irq_svc+0x48/0x9c)
[ 1897.450000] Exception stack(0xc0349f70 to 0xc0349fb8)
[ 1897.460000] 9f60:                                     00000001 00000000 f4100000 00000021
[ 1897.470000] 9f80: c002032c c0348000 c002032c c036c8c4 5001aab8 410fb766 5001aa84 00000000
[ 1897.480000] 9fa0: c0349fc0 c0349fb8 c0020394 c0020398 20000013 ffffffff
[ 1897.480000] [<c001ea28>] (__irq_svc+0x48/0x9c) from [<c0020394>] (default_idle+0x68/0x7c)
[ 1897.490000] [<c0020394>] (default_idle+0x68/0x7c) from [<c0020300>] (cpu_idle+0x30/0x5c)
[ 1897.500000] [<c0020300>] (cpu_idle+0x30/0x5c) from [<c0008a68>] (start_kernel+0x1f8/0x244)
[ 1897.510000] [<c0008a68>] (start_kernel+0x1f8/0x244) from [<50008034>] (0x50008034)
[ 1897.520000] ------------[ cut here ]------------
[ 1897.520000] WARNING: at kernel/mutex.c:207 __mutex_lock_slowpath+0x6c/0x2c8()
[ 1897.530000] Modules linked in: g_serial
[ 1897.530000] [<c0024afc>] (unwind_backtrace+0x0/0xdc) from [<c0037ed4>] (warn_slowpath_common+0x4c/0x80)
[ 1897.540000] [<c0037ed4>] (warn_slowpath_common+0x4c/0x80) from [<c026687c>] (__mutex_lock_slowpath+0x6c/0x2c8)
[ 1897.550000] [<c026687c>] (__mutex_lock_slowpath+0x6c/0x2c8) from [<c0267220>] (mutex_lock+0x1c/0x30)
[ 1897.560000] [<c0267220>] (mutex_lock+0x1c/0x30) from [<c014ceac>] (echo_char_raw+0x1c/0x48)
[ 1897.570000] [<c014ceac>] (echo_char_raw+0x1c/0x48) from [<c014ecdc>] (n_tty_receive_buf+0x9dc/0xec4)
[ 1897.580000] [<c014ecdc>] (n_tty_receive_buf+0x9dc/0xec4) from [<c01513bc>] (flush_to_ldisc+0x104/0x1b0)
[ 1897.590000] [<c01513bc>] (flush_to_ldisc+0x104/0x1b0) from [<bf001ce8>] (gs_rx_push+0x118/0x1cc [g_serial])
[ 1897.600000] [<bf001ce8>] (gs_rx_push+0x118/0x1cc [g_serial]) from [<c003c7c0>] (tasklet_action+0x78/0xc8)
[ 1897.610000] [<c003c7c0>] (tasklet_action+0x78/0xc8) from [<c003cc54>] (__do_softirq+0x6c/0xf4)
[ 1897.620000] [<c003cc54>] (__do_softirq+0x6c/0xf4) from [<c003cd20>] (irq_exit+0x44/0x5c)
[ 1897.620000] [<c003cd20>] (irq_exit+0x44/0x5c) from [<c001e054>] (_text+0x54/0x6c)
[ 1897.630000] [<c001e054>] (_text+0x54/0x6c) from [<c001ea28>] (__irq_svc+0x48/0x9c)
[ 1897.640000] Exception stack(0xc0349f70 to 0xc0349fb8)
[ 1897.640000] 9f60:                                     00000001 00000000 f4100000 00000021
[ 1897.650000] 9f80: c002032c c0348000 c002032c c036c8c4 5001aab8 410fb766 5001aa84 00000000
[ 1897.660000] 9fa0: c0349fc0 c0349fb8 c0020394 c0020398 20000013 ffffffff
[ 1897.670000] [<c001ea28>] (__irq_svc+0x48/0x9c) from [<c0020394>] (default_idle+0x68/0x7c)
[ 1897.680000] [<c0020394>] (default_idle+0x68/0x7c) from [<c0020300>] (cpu_idle+0x30/0x5c)
[ 1897.680000] [<c0020300>] (cpu_idle+0x30/0x5c) from [<c0008a68>] (start_kernel+0x1f8/0x244)
[ 1897.690000] [<c0008a68>] (start_kernel+0x1f8/0x244) from [<50008034>] (0x50008034)
[ 1897.700000] ---[ end trace 6355fd65cb30f602 ]---

At USB protocol level everything looks fine (I've used in-kernel usb logger in Linux host machine). This looks like a bug somewhere in tty handling code. Is this problem known?

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


