Return-Path: <linux-kernel-owner+w=401wt.eu-S934707AbYBGVI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934707AbYBGVI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbYBGUxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:53:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:38708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933543AbYBGUxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:53:02 -0500
Date: Thu, 7 Feb 2008 12:47:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
       Stefano Brivio <stefano.brivio@polimi.it>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 34/45] b43legacy: fix PIO crash
Message-ID: <20080207204759.GI16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="b43legacy-fix-pio-crash.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stefano Brivio <stefano.brivio@polimi.it>

patch 0cd67d48b519c3d8d89d238fab1cf68a5289638a in mainline.

Fix the crash reported below, which seems to happen on bcm4306 rev. 2 devices
only while using PIO:

Oops: 0000 [#1] PREEMPT
Modules linked in: b43(F) rfkill(F) led_class(F) input_polldev(F) arc4 b43legacy mac80211 cfg80211 i915 drm snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device ohci1394 ieee1394 ssb pcmcia snd_intel8x0m ehci_hcd uhci_hcd evdev

Pid: 0, comm: swapper Tainted: GF	(2.6.24st3 #2)
EIP: 0060:[<f90f667b>] EFLAGS: 00010002 CPU: 0
EIP is at b43legacy_pio_handle_txstatus+0xbb/0x210 [b43legacy]
EAX: 0000049b EBX: f11f8044 ECX: 00000001 EDX: 00000000
ESI: f1ff8000 EDI: 00000000 EBP: f11f8040 ESP: c04f4ef4
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c04f4000 task=c0488300 task.ti=c04b8000)
Stack: f90f2788 c05009f0 c0500900 000010f7 f1053823 c04f4f24 dfb8e800 00000003
       f1368000 00000007 00000296 f90f1975 00001000 010c0800 01000000 00000007
       f90f6391 f11f8000 00000082 c04f4f4a 00000000 00004fd0 10f70000 8c061000
Call Trace:
 [<f90f2788>] b43legacy_debugfs_log_txstat+0x48/0xb0 [b43legacy]
 [<f90f1975>] b43legacy_handle_hwtxstatus+0x75/0x80 [b43legacy]
 [<f90f6391>] b43legacy_pio_rx+0x201/0x280 [b43legacy]
 [<f90e4fa3>] b43legacy_interrupt_tasklet+0x2e3/0x870 [b43legacy]
 [<c0123567>] tasklet_action+0x27/0x60
 [<c01237b4>] __do_softirq+0x54/0xb0
 [<c010686b>] do_softirq+0x7b/0xe0
 [<c01457c0>] handle_level_irq+0x0/0x110
 [<c01457c0>] handle_level_irq+0x0/0x110
 [<c0123758>] irq_exit+0x38/0x40
 [<c0106953>] do_IRQ+0x83/0xd0
 [<c011812f>] __update_rq_clock+0x4f/0x180
 [<c0104b4f>] common_interrupt+0x23/0x28
 [<c011007b>] wakeup_code+0x7b/0xde
 [<c02b1039>] acpi_processor_idle+0x24a/0x3c9
 [<c01025c7>] cpu_idle+0x47/0x80
 [<c04b9ad5>] start_kernel+0x205/0x290
 [<c04b9360>] unknown_bootoption+0x0/0x1f0
 =======================
Code: 0f 00 00 81 fb ff 00 00 00 0f 87 36 01 00 00 8d 04 db 85 ff 8d 6c c6 40 8d 5d 04 0f 85 ef 00 00 00 fe 4e 0e 0f b7 46 0c 8b 53 04 <8b> 4a 50 29 c8 83 e8 52 66 89 46 0c 8b 54 24 14 80 7a 0b 00 74
EIP: [<f90f667b>] b43legacy_pio_handle_txstatus+0xbb/0x210 [b43legacy] SS:ESP 0068:c04f4ef4
Kernel panic - not syncing: Fatal exception in interrupt

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43legacy/pio.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/b43legacy/pio.c
+++ b/drivers/net/wireless/b43legacy/pio.c
@@ -486,6 +486,9 @@ void b43legacy_pio_handle_txstatus(struc
 	queue = parse_cookie(dev, status->cookie, &packet);
 	B43legacy_WARN_ON(!queue);
 
+	if (!packet->skb)
+		return;
+
 	queue->tx_devq_packets--;
 	queue->tx_devq_used -= (packet->skb->len +
 				sizeof(struct b43legacy_txhdr_fw3));

-- 
