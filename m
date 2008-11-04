Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbYKDDOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbYKDDOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 22:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYKDDOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 22:14:32 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:4095 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbYKDDOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 22:14:31 -0500
Date: Mon, 3 Nov 2008 22:14:00 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, mickflemm@gmail.com, jirislaby@gmail.com,
       lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org, proski@gnu.org,
       michael+ath5k@stapelberg.de
Subject: [PATCH] ath5k: correct handling of rx status fields
Message-ID: <20081104031400.GA14502@hash.localnet>
References: <1225652938-6244-1-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225652938-6244-1-git-send-email-me@bobcopeland.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ath5k_rx_status fields rs_antenna and rs_more are u8s, but we
were setting them with bitwise ANDs of 32-bit values.

As a consequence, jumbo frames would not be discarded as intended.
Then, because the hw rate value of such frames is zero, and, since
63266a653589e1a237527479f10212ea77ce7844 "ath5k: rates cleanup",
we do not fall back to the basic rate, such packets would trigger
the following WARN_ON:

------------[ cut here ]------------
WARNING: at net/mac80211/rx.c:2192 __ieee80211_rx+0x4d/0x57e [mac80211]()
Modules linked in: ath5k af_packet sha256_generic aes_i586 aes_generic cbc loop i915 drm binfmt_misc acpi_cpufreq fan container nls_utf8 hfsplus dm_crypt dm_mod kvm_intel kvm fuse sbp2 snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy snd_seq_oss arc4 joydev hid_apple ecb snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device usbhid appletouch mac80211 sky2 snd ehci_hcd ohci1394 bitrev crc32 sr_mod cdrom rtc sg uhci_hcd snd_page_alloc cfg80211 ieee1394 thermal ac battery processor button evdev unix [last unloaded: ath5k]
Pid: 0, comm: swapper Tainted: G        W  2.6.28-rc2-wl #14
Call Trace:
 [<c0123d1e>] warn_on_slowpath+0x41/0x5b
 [<c012005d>] ? sched_debug_show+0x31e/0x9c6
 [<c012489f>] ? vprintk+0x369/0x389
 [<c0309539>] ? _spin_unlock_irqrestore+0x54/0x58
 [<c011cd8f>] ? try_to_wake_up+0x14f/0x15a
 [<f81918cb>] __ieee80211_rx+0x4d/0x57e [mac80211]
 [<f828872a>] ath5k_tasklet_rx+0x5a1/0x5e4 [ath5k]
 [<c013b9cd>] ? clockevents_program_event+0xd4/0xe3
 [<c01283a9>] tasklet_action+0x94/0xfd
 [<c0127d19>] __do_softirq+0x8c/0x13e
 [<c0127e04>] do_softirq+0x39/0x55
 [<c0128082>] irq_exit+0x46/0x85
 [<c010576c>] do_IRQ+0x9a/0xb2
 [<c010461c>] common_interrupt+0x28/0x30
 [<f80e934a>] ? acpi_idle_enter_bm+0x2ad/0x31b [processor]
 [<c02976bf>] cpuidle_idle_call+0x65/0x9a
 [<c010262c>] cpu_idle+0x76/0xa6
 [<c02fb402>] rest_init+0x62/0x64

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

v2
  - different subject and patch description
  - use !! instead of mask + shift for rs_more
  - remove unneeded changes to desc.h

 drivers/net/wireless/ath5k/desc.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath5k/desc.c b/drivers/net/wireless/ath5k/desc.c
index dd13740..5e362a7 100644
--- a/drivers/net/wireless/ath5k/desc.c
+++ b/drivers/net/wireless/ath5k/desc.c
@@ -531,10 +531,10 @@ static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
 		AR5K_5210_RX_DESC_STATUS0_RECEIVE_SIGNAL);
 	rs->rs_rate = AR5K_REG_MS(rx_status->rx_status_0,
 		AR5K_5210_RX_DESC_STATUS0_RECEIVE_RATE);
-	rs->rs_antenna = rx_status->rx_status_0 &
-		AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA;
-	rs->rs_more = rx_status->rx_status_0 &
-		AR5K_5210_RX_DESC_STATUS0_MORE;
+	rs->rs_antenna = AR5K_REG_MS(rx_status->rx_status_0,
+		AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA);
+	rs->rs_more = !!(rx_status->rx_status_0 &
+		AR5K_5210_RX_DESC_STATUS0_MORE);
 	/* TODO: this timestamp is 13 bit, later on we assume 15 bit */
 	rs->rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
 		AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
@@ -607,10 +607,10 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 		AR5K_5212_RX_DESC_STATUS0_RECEIVE_SIGNAL);
 	rs->rs_rate = AR5K_REG_MS(rx_status->rx_status_0,
 		AR5K_5212_RX_DESC_STATUS0_RECEIVE_RATE);
-	rs->rs_antenna = rx_status->rx_status_0 &
-		AR5K_5212_RX_DESC_STATUS0_RECEIVE_ANTENNA;
-	rs->rs_more = rx_status->rx_status_0 &
-		AR5K_5212_RX_DESC_STATUS0_MORE;
+	rs->rs_antenna = AR5K_REG_MS(rx_status->rx_status_0,
+		AR5K_5212_RX_DESC_STATUS0_RECEIVE_ANTENNA);
+	rs->rs_more = !!(rx_status->rx_status_0 &
+		AR5K_5212_RX_DESC_STATUS0_MORE);
 	rs->rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
 		AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
 	rs->rs_status = 0;
-- 
1.5.4.2.182.gb3092


