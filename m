Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbZCOV1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbZCOV1e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 17:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757054AbZCOV1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 17:27:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:39015 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752421AbZCOV1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 17:27:21 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX18R9RJWjeoR7fD5HyZFEywOtSmmMmd0DEqoLAWUsL
	50DyPu5XfMNb0V
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] ath5k: fix hw rate index condition
Date: Sun, 15 Mar 2009 22:27:13 +0100
User-Agent: KMail/1.9.9
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, linville@tuxdriver.com,
       davem@davemloft.net, linux-wireless@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Bob Copeland <me@bobcopeland.com>, linux-kernel@vger.kernel.org,
       bcm43xx-dev@lists.berlios.de
References: <1231336282-22283-1-git-send-email-jirislaby@gmail.com> <1231338965-796-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1231338965-796-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903152227.16676.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mittwoch, 7. Januar 2009, Jiri Slaby wrote:
> On 01/07/2009 02:51 PM, Jiri Slaby wrote:
> > Dhaval Giani wrote:
> >> I see this on current git. Not sure how to reproduce it, has happened on
> >> two random occasions. At both times, I was not connected to a wireless
> >> network, but to wired networks.
> >>
> >> ------------[ cut here ]------------
> >> WARNING: at net/mac80211/rx.c:2234 __ieee80211_rx+0x7f/0x559
> >> ...
> >> Call Trace:
> >>  [<f80d4192>] __ieee80211_rx+0x7f/0x559 [mac80211]
> >>  [<f80a19f4>] ath5k_tasklet_rx+0x4f7/0x53b [ath5k]
> >> ...
> > 
> > Hmm, maybe ath5k is culprit. Could you apply the attached patch and
> > use the kernel till the problem appears again?

It seems as if this problem wouldn't be restricted to ath5k, I just 
triggered something very similar on b43 and 2.6.29-rc8-git1 (i386, hard 
preemption):

b43-phy0: Broadcom 4306 WLAN found (core revision 5)
wmaster0 (b43): not using net_device_ops yet
phy0: Selected rate control algorithm 'minstrel'
wlan0 (b43): not using net_device_ops yet
Broadcom 43xx driver loaded [ Features: PMLR, Firmware-ID: FW13 ]
udev: renamed network interface wlan0 to wlan1
[...]
input: b43-phy0 as /devices/virtual/input/input8
b43 ssb0:0: firmware: requesting b43/ucode5.fw
b43 ssb0:0: firmware: requesting b43/pcm5.fw
b43 ssb0:0: firmware: requesting b43/b0g0initvals5.fw
b43 ssb0:0: firmware: requesting b43/b0g0bsinitvals5.fw
b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
Registered led device: b43-phy0::tx
Registered led device: b43-phy0::rx
Registered led device: b43-phy0::radio
b43-phy0: Radio turned on by software
[...]
ADDRCONF(NETDEV_UP): wlan1: link is not ready
wlan1: authenticate with AP 00:15:f2:7e:9b:7d
wlan1: authenticated
wlan1: associate with AP 00:15:f2:7e:9b:7d
wlan1: RX AssocResp from 00:15:f2:7e:9b:7d (capab=0x411 status=0 aid=2)
wlan1: associated
ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[...]
wlan1: no IPv6 routers present
b43-phy0 ERROR: PHY transmission error
b43-phy0 ERROR: PHY transmission error

[ lots of these, likely to be caused by minstrel being a little too 
  optimistic about the possible wlan rates (it was more conservative in 
  2.6.28 and didn't happen there); the distance between both stations is 
  on the upper end ]

b43-phy0 ERROR: PHY transmission error
__ratelimit: 9 callbacks suppressed
b43-phy0 ERROR: PHY transmission error
b43-phy0 ERROR: PHY transmission error
------------[ cut here ]------------
WARNING: at net/mac80211/rx.c:2234 __ieee80211_rx+0xa2/0x6a0 [mac80211]()
Hardware name: Amilo D-Series
Modules linked in: ppdev lp aes_i586 aes_generic ipv6 af_packet rfkill_input arc4 ecb b43 rfkill rng_core mac80211 cfg80211 led_class input_polldev ssb joydev pcmcia snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_device i2c_viapro serio_raw snd i2c_core pcspkr psmouse evdev soundcore via686a via_agp shpchp yenta_socket rsrc_nonstatic pcmcia_core pci_hotplug rtc_cmos battery rtc_core rtc_lib parport_pc parport ac button ext3 jbd mbcache sg sr_mod cdrom sd_mod ata_generic pata_acpi pata_via uhci_hcd ehci_hcd floppy firewire_ohci libata tulip firewire_core crc_itu_t usbcore scsi_mod thermal processor fan
Pid: 0, comm: swapper Not tainted 2.6.29-rc8-sidux-686 #1
Call Trace:
 [<c01319d7>] warn_slowpath+0x87/0xe0
 [<d00523b7>] op32_set_current_rxslot+0x27/0x40 [b43]
 [<d0052d93>] b43_dma_rx+0x193/0x420 [b43]
 [<c0124fc3>] __wake_up_common+0x43/0x70
 [<cfffcc62>] __ieee80211_rx+0xa2/0x6a0 [mac80211]
 [<c011e9a5>] default_spin_lock_flags+0x5/0x10
 [<c03a3f2e>] _spin_lock_irqsave+0x3e/0x60
 [<cffeb337>] ieee80211_tasklet_handler+0x107/0x130 [mac80211]
 [<c013692c>] tasklet_action+0x6c/0xf0
 [<c0137147>] __do_softirq+0x87/0x140
 [<c011e9a5>] default_spin_lock_flags+0x5/0x10
 [<c03a3f2e>] _spin_lock_irqsave+0x3e/0x60
 [<c0137255>] do_softirq+0x55/0x60
 [<c0137495>] irq_exit+0x75/0x90
 [<c0106378>] do_IRQ+0x48/0x90
 [<c0104527>] common_interrupt+0x27/0x2c
 [<cf8372e4>] acpi_idle_enter_simple+0x17a/0x1f4 [processor]
 [<c02fd3bf>] cpuidle_idle_call+0x6f/0xc0
 [<c0102de6>] cpu_idle+0x66/0xa0
---[ end trace c754f566bbe5ac47 ]---
------------[ cut here ]------------
WARNING: at net/mac80211/rx.c:2234 __ieee80211_rx+0xa2/0x6a0 [mac80211]()
Hardware name: Amilo D-Series
Modules linked in: ppdev lp aes_i586 aes_generic ipv6 af_packet rfkill_input arc4 ecb b43 rfkill rng_core mac80211 cfg80211 led_class input_polldev ssb joydev pcmcia snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_device i2c_viapro serio_raw snd i2c_core pcspkr psmouse evdev soundcore via686a via_agp shpchp yenta_socket rsrc_nonstatic pcmcia_core pci_hotplug rtc_cmos battery rtc_core rtc_lib parport_pc parport ac button ext3 jbd mbcache sg sr_mod cdrom sd_mod ata_generic pata_acpi pata_via uhci_hcd ehci_hcd floppy firewire_ohci libata tulip firewire_core crc_itu_t usbcore scsi_mod thermal processor fan
Pid: 0, comm: swapper Tainted: G        W  2.6.29-rc8-sidux-686 #1
Call Trace:
 [<c01319d7>] warn_slowpath+0x87/0xe0
 [<d00523b7>] op32_set_current_rxslot+0x27/0x40 [b43]
 [<d0052d93>] b43_dma_rx+0x193/0x420 [b43]
 [<d0055f15>] b43_led_turn_off+0x55/0x90 [b43]
 [<cfffcc62>] __ieee80211_rx+0xa2/0x6a0 [mac80211]
 [<c011e9a5>] default_spin_lock_flags+0x5/0x10
 [<c03a3f2e>] _spin_lock_irqsave+0x3e/0x60
 [<cffeb337>] ieee80211_tasklet_handler+0x107/0x130 [mac80211]
 [<c013692c>] tasklet_action+0x6c/0xf0
 [<c0137147>] __do_softirq+0x87/0x140
 [<c011e9a5>] default_spin_lock_flags+0x5/0x10
 [<c03a3f2e>] _spin_lock_irqsave+0x3e/0x60
 [<c0137255>] do_softirq+0x55/0x60
 [<c0137495>] irq_exit+0x75/0x90
 [<c0106378>] do_IRQ+0x48/0x90
 [<c0104527>] common_interrupt+0x27/0x2c
 [<cf8372e4>] acpi_idle_enter_simple+0x17a/0x1f4 [processor]
 [<c02fd3bf>] cpuidle_idle_call+0x6f/0xc0
 [<c0102de6>] cpu_idle+0x66/0xa0
---[ end trace c754f566bbe5ac48 ]---
------------[ cut here ]------------
WARNING: at net/mac80211/rx.c:2234 __ieee80211_rx+0xa2/0x6a0 [mac80211]()
Hardware name: Amilo D-Series
Modules linked in: ppdev lp aes_i586 aes_generic ipv6 af_packet rfkill_input arc4 ecb b43 rfkill rng_core mac80211 cfg80211 led_class input_polldev ssb joydev pcmcia snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_device i2c_viapro serio_raw snd i2c_core pcspkr psmouse evdev soundcore via686a via_agp shpchp yenta_socket rsrc_nonstatic pcmcia_core pci_hotplug rtc_cmos battery rtc_core rtc_lib parport_pc parport ac button ext3 jbd mbcache sg sr_mod cdrom sd_mod ata_generic pata_acpi pata_via uhci_hcd ehci_hcd floppy firewire_ohci libata tulip firewire_core crc_itu_t usbcore scsi_mod thermal processor fan
Pid: 1873, comm: kjournald Tainted: G        W  2.6.29-rc8-sidux-686 #1
Call Trace:
 [<c01319d7>] warn_slowpath+0x87/0xe0
 [<d00523b7>] op32_set_current_rxslot+0x27/0x40 [b43]
 [<d0052d93>] b43_dma_rx+0x193/0x420 [b43]
 [<cfffcc62>] __ieee80211_rx+0xa2/0x6a0 [mac80211]
 [<c011e9a5>] default_spin_lock_flags+0x5/0x10
 [<c03a3f2e>] _spin_lock_irqsave+0x3e/0x60
 [<cffeb337>] ieee80211_tasklet_handler+0x107/0x130 [mac80211]
 [<c013692c>] tasklet_action+0x6c/0xf0
 [<c0137147>] __do_softirq+0x87/0x140
 [<c011e9a5>] default_spin_lock_flags+0x5/0x10
 [<c03a3f2e>] _spin_lock_irqsave+0x3e/0x60
 [<c0137255>] do_softirq+0x55/0x60
 [<c0137495>] irq_exit+0x75/0x90
 [<c0106378>] do_IRQ+0x48/0x90
 [<c01d3f44>] generic_block_bmap+0x54/0x70
 [<c0104527>] common_interrupt+0x27/0x2c
 [<cfbf723c>] __journal_file_buffer+0xdc/0x1d0 [jbd]
 [<cfbf7397>] journal_file_buffer+0x67/0xc0 [jbd]
 [<cfbfe102>] journal_write_metadata_buffer+0x1e2/0x3dc [jbd]
 [<cfbf9e26>] journal_commit_transaction+0x806/0x1120 [jbd]
 [<c013bcc7>] lock_timer_base+0x27/0x60
 [<cfbfd82c>] kjournald+0xac/0x1f0 [jbd]
 [<c01464b0>] autoremove_wake_function+0x0/0x50
 [<cfbfd780>] kjournald+0x0/0x1f0 [jbd]
 [<c01460e9>] kthread+0x39/0x70
 [<c01460b0>] kthread+0x0/0x70
 [<c0104793>] kernel_thread_helper+0x7/0x14
---[ end trace c754f566bbe5ac49 ]---
__ratelimit: 21 callbacks suppressed
b43-phy0 ERROR: PHY transmission error
[...]

Sometimes even the firmware crashes and gets reloaded continously.

wlan1     IEEE 802.11bg  ESSID:"soyuz"
          Mode:Managed  Frequency:2.422 GHz  Access Point: 00:15:F2:7E:9B:7D
          Bit Rate=18 Mb/s   Tx-Power=20 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Encryption key:<wpa2psk> [3]   Security mode:open
          Power Management:off
          Link Quality=53/100  Signal level:-75 dBm  Noise level=-65 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

Setting a fixed wlan rate (like 11M) seems to avoid this problem.

> I don't think this will print anything, the rate won't be 32, it's rather
> too high. Could you apply also the appended debug one?

I will apply this patch and give it some more testing tomorrow evening, 
this problem is almost 100% reproducable for me at the end of my router's
range and doesn't happen in closer proximity.

> ---
>  net/mac80211/rx.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 7175ae8..5e17e57 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -2230,8 +2230,10 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
>  		 * MCS aware. */
>  		rate = &sband->bitrates[sband->n_bitrates - 1];
>  	} else {
> -		if (WARN_ON(status->rate_idx < 0 ||
> -			    status->rate_idx >= sband->n_bitrates))
> +		if (WARN(status->rate_idx < 0 ||
> +			    status->rate_idx >= sband->n_bitrates,
> +			    "RATE=%u, BAND=%x\n", status->rate_idx,
> +			    sband->n_bitrates))
>  			return;
>  		rate = &sband->bitrates[status->rate_idx];
>  	}

Regards
	Stefan Lippers-Hollmann
