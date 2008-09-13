Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbYIMBiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbYIMBiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 21:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbYIMBhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 21:37:53 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:28280 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217AbYIMBhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 21:37:52 -0400
Message-ID: <f488382f0809121837n69cf4bc5i3dfa04cbf671957b@mail.gmail.com>
Date: Fri, 12 Sep 2008 18:37:50 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: frustrating ath9k issues in 2.6.27-rc6-00036-ga551b98 (Linus pristine tree)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heya folks,

I'm having some problems with ath9k in the 2.6.27-rc6 kernel. First of
all, it incorrectly reports the connection bitrate as 1 megabit per
second:

wlan0     IEEE 802.11abgn  ESSID:"Introversion"
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:1E:52:79:4D:01
          Bit Rate=1 Mb/s   Tx-Power=23 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Encryption key: [snip]   Security mode:open
          Power Management:off
          Link Quality=67/100  Signal level:-52 dBm  Noise level=-95 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

Second, it will randomly drop the connection (could it possibly be
related to the message ' wlan0 (WE) : Wireless Event too big (320)'?).
One time, the connection dropped and I couldn't get it to reassociate,
and the dmesg showed the following:

[53963.201797] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[53964.809889] wlan0: authenticate with AP 00:1e:52:79:4d:01
[53964.811598] wlan0: authenticated
[53964.811742] wlan0: associate with AP 00:1e:52:79:4d:01
[53965.011340] wlan0: associate with AP 00:1e:52:79:4d:01
[53965.211343] wlan0: associate with AP 00:1e:52:79:4d:01
[53965.411345] wlan0: association with AP 00:1e:52:79:4d:01 timed out
[53976.532464] wlan0: authenticate with AP 00:1e:52:79:4d:01
[53976.542516] wlan0: authenticate with AP 00:1e:52:79:4d:01
[53976.751331] wlan0: authenticate with AP 00:1e:52:79:4d:01
[53976.752757] wlan0: authenticated
[53976.752762] wlan0: associate with AP 00:1e:52:79:4d:01
[53976.760374] wlan0: RX AssocResp from 00:1e:52:79:4d:01 (capab=0x431
status=0 aid=1)
[53976.760380] wlan0: associated
[53976.760721] wlan0 (WE) : Wireless Event too big (320)
[53976.772243] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready

So I figured I'd try unloading and reloading the ath9k module. This
was the result:

[53997.493777] ath9k: driver unloaded
[54001.098532] ath9k: 0.1
[54001.098833] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[54001.099013] ath9k 0000:03:00.0: setting latency timer to 64
[54001.233825] phy1: Selected rate control algorithm 'ath9k_rate_control'
[54001.236980] phy1: Atheros 5416: mem=0xffffc20000060000, irq=17
[54002.136218] irq 17: nobody cared (try booting with the "irqpoll" option)
[54002.136229] Pid: 0, comm: swapper Tainted: P
2.6.27-rc6-00036-ga551b98 #2
[54002.136234]
[54002.136235] Call Trace:
[54002.136241]  <IRQ>  [<ffffffff80265231>] __report_bad_irq+0x3d/0x81
[54002.136258]  [<ffffffff80265477>] note_interrupt+0x202/0x267
[54002.136265]  [<ffffffff80265bfc>] handle_fasteoi_irq+0xba/0xe4
[54002.136273]  [<ffffffff8020e7ff>] do_IRQ+0x115/0x191
[54002.136279]  [<ffffffff8020bc01>] ret_from_intr+0x0/0xa
[54002.136283]  <EOI>  [<ffffffff802541bb>] ?
tick_nohz_stop_sched_tick+0x2c5/0x2d4
[54002.136296]  [<ffffffff8020a69f>] ? cpu_idle+0x2d/0xed
[54002.136304]  [<ffffffff8060d741>] ? rest_init+0x75/0x77
[54002.136309]
[54002.136312] handlers:
[54002.136315] [<ffffffffa0209016>] (ath_isr+0x0/0x160 [ath9k])
[54002.136340] Disabling IRQ #17

And finally, I'm most certainly not getting 802.11n connection speeds
with this driver. The connection speed seems to be about equivalent to
802.11g (54mb/s), but I can't tell for certain with the messed up
bitrate reporting from iwconfig.

-- 
- Steven
