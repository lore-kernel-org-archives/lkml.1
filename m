Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbYJBOaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbYJBOaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 10:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbYJBOaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 10:30:08 -0400
Received: from twin.jikos.cz ([213.151.79.26]:42480 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbYJBOaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 10:30:06 -0400
Date: Thu, 2 Oct 2008 16:28:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Jesse Brandeburg <jesse.brandeburg@intel.com>
cc: linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org, kkeil@suse.de,
       agospoda@redhat.com, arjan@linux.intel.com, david.graham@intel.com,
       bruce.w.allan@intel.com, john.ronciak@intel.com,
       Thomas Gleixner <tglx@linutronix.de>, chris.jones@canonical.com,
       tim.gardner@intel.com, airlied@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>, Olaf Kirch <okir@suse.de>
Subject: Re: [RFC PATCH 07/12] e1000e: debug contention on NVM SWFLAG
In-Reply-To: <20080930031952.22950.45228.stgit@jbrandeb-bw.jf.intel.com>
Message-ID: <Pine.LNX.4.64.0810021624380.1887@twin.jikos.cz>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
 <20080930031952.22950.45228.stgit@jbrandeb-bw.jf.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008, Jesse Brandeburg wrote:

> From: Thomas Gleixner <tglx@linutronix.de>
> 
> This patch adds a mutex to the e1000e driver that would help
> catch any collisions of two e1000e threads accessing hardware
> at the same time.
> 
> description and patch updated by Jesse
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
> 
>  drivers/net/e1000e/ich8lan.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/e1000e/ich8lan.c b/drivers/net/e1000e/ich8lan.c
> index a076079..57c6d2f 100644
> --- a/drivers/net/e1000e/ich8lan.c
> +++ b/drivers/net/e1000e/ich8lan.c
> @@ -366,6 +366,9 @@ static s32 e1000_get_variants_ich8lan(struct e1000_adapter *adapter)
>  	return 0;
>  }
>  
> +static DEFINE_MUTEX(nvm_mutex);
> +static pid_t nvm_owner = -1;
> +
>  /**
>   *  e1000_acquire_swflag_ich8lan - Acquire software control flag
>   *  @hw: pointer to the HW structure
> @@ -379,6 +382,15 @@ static s32 e1000_acquire_swflag_ich8lan(struct e1000_hw *hw)
>  	u32 extcnf_ctrl;
>  	u32 timeout = PHY_CFG_TIMEOUT;
>  
> +	WARN_ON(preempt_count());
> +
> +	if (!mutex_trylock(&nvm_mutex)) {
> +		WARN(1, KERN_ERR "e1000e mutex contention. Owned by pid %d\n",
> +		     nvm_owner);
> +		mutex_lock(&nvm_mutex);
> +	}
> +	nvm_owner = current->pid;
> +
>  	while (timeout) {
>  		extcnf_ctrl = er32(EXTCNF_CTRL);
>  		extcnf_ctrl |= E1000_EXTCNF_CTRL_SWFLAG;
> @@ -393,6 +405,8 @@ static s32 e1000_acquire_swflag_ich8lan(struct e1000_hw *hw)
>  
>  	if (!timeout) {
>  		hw_dbg(hw, "FW or HW has locked the resource for too long.\n");
> +		nvm_owner = -1;
> +		mutex_unlock(&nvm_mutex);
>  		return -E1000_ERR_CONFIG;
>  	}
>  
> @@ -414,6 +428,9 @@ static void e1000_release_swflag_ich8lan(struct e1000_hw *hw)
>  	extcnf_ctrl = er32(EXTCNF_CTRL);
>  	extcnf_ctrl &= ~E1000_EXTCNF_CTRL_SWFLAG;
>  	ew32(EXTCNF_CTRL, extcnf_ctrl);
> +
> +	nvm_owner = -1;
> +	mutex_unlock(&nvm_mutex);
>  }

A few minutes ago, I have actually just hit this, while debugging the 
issue on a kernel that had this patch included. 

I was not successful reproducing it yet though, but still it might be a 
pointer into direction where the real bug is.

15:49:07 linux-pr0e dhclient: Listening on LPF/eth1/00:15:58:c6:4a:ff
15:49:07 linux-pr0e dhclient: Sending on   LPF/eth1/00:15:58:c6:4a:ff
15:49:07 linux-pr0e dhclient: Sending on   Socket/fallback
15:49:07 linux-pr0e dhclient: DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 3
15:49:10 linux-pr0e dhclient: DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 8
15:49:18 linux-pr0e dhclient: DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 9
15:49:27 linux-pr0e dhclient: DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 9
15:49:36 linux-pr0e dhclient: DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 17
15:49:53 linux-pr0e dhclient: DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 12
15:50:05 linux-pr0e dhclient: DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 3
15:50:08 linux-pr0e dhclient: No DHCPOFFERS received.
15:50:08 linux-pr0e dhclient: No working leases in persistent database - sleeping.
15:50:52 linux-pr0e kernel: ------------[ cut here ]------------
15:50:52 linux-pr0e kernel: WARNING: at drivers/net/e1000e/ich8lan.c:424 e1000_acquire_swflag_ich8lan+0x5a/0xdc [e1000e]()
15:50:52 linux-pr0e kernel: e1000e mutex contention. Owned by pid 4162
15:50:52 linux-pr0e kernel: Modules linked in: af_packet i915 drm ipv6 snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq microcode fuse loop dm_mod tulip arc4 ecb snd_hda_intel snd_pcm crypto_blkcipher rtc_cmos snd_timer ppdev iwl3945 thinkpad_acpi pcmcia uvcvideo parport_pc rtc_core snd_page_alloc video rfkill i2c_i801 mac80211 iTCO_wdt compat_ioctl32 rtc_lib yenta_socket pcspkr joydev ohci1394 snd_hwdep rsrc_nonstatic output i2c_core btusb parport battery led_class videodev ac ieee1394 v4l1_compat e1000e wmi iTCO_vendor_support pcmcia_core button snd soundcore intel_agp cfg80211 bluetooth sg sr_mod cdrom sd_mod crc_t10dif ehci_hcd uhci_hcd usbcore edd ext3 mbcache jbd fan ide_pci_generic ide_core ata_generic ata_piix ahci pata_acpi libata scsi_mod dock thermal processor
15:50:52 linux-pr0e kernel: Pid: 7, comm: events/0 Tainted: G          2.6.27-rc7-7.10-default #1
15:50:52 linux-pr0e kernel: 
15:50:52 linux-pr0e kernel: Call Trace:
15:50:52 linux-pr0e kernel:  [<ffffffff8020e41e>] show_trace_log_lvl+0x41/0x58
15:50:52 linux-pr0e kernel:  [<ffffffff80493716>] dump_stack+0x69/0x6f
15:50:52 linux-pr0e kernel:  [<ffffffff8023ee54>] warn_slowpath+0xb4/0xdc
15:50:52 linux-pr0e kernel:  [<ffffffffa022ce2e>] e1000_acquire_swflag_ich8lan+0x5a/0xdc [e1000e]
15:50:52 linux-pr0e kernel:  [<ffffffffa02317ba>] e1000e_read_phy_reg_igp+0x19/0x64 [e1000e]
15:50:52 linux-pr0e kernel:  [<ffffffffa02319f8>] e1000e_phy_has_link_generic+0x50/0xcc [e1000e]
15:50:52 linux-pr0e kernel:  [<ffffffffa02306f9>] e1000e_check_for_copper_link+0x24/0x86 [e1000e]
15:50:52 linux-pr0e kernel:  [<ffffffffa0236982>] e1000_watchdog_task+0x5c/0x5eb [e1000e]
15:50:52 linux-pr0e kernel:  [<ffffffff8024ecdb>] run_workqueue+0xa4/0x14c
15:50:52 linux-pr0e kernel:  [<ffffffff8024ee5b>] worker_thread+0xd8/0xe7
15:50:52 linux-pr0e kernel:  [<ffffffff80251fe5>] kthread+0x47/0x73
15:50:52 linux-pr0e kernel:  [<ffffffff8020d7a9>] child_rip+0xa/0x11
15:50:52 linux-pr0e kernel: 
15:50:52 linux-pr0e kernel: ---[ end trace 6f68a3c748ede326 ]---
15:51:25 linux-pr0e dhclient: DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 3
15:51:28 linux-pr0e dhclient: DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 8
15:51:36 linux-pr0e dhclient: DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 13
15:51:49 linux-pr0e dhclient: DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 13
15:52:02 linux-pr0e dhclient: DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 18
15:52:15 linux-pr0e kernel: Machine check events logged

-- 
Jiri Kosina
SUSE Labs

