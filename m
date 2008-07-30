Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbYG3IQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbYG3IQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 04:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYG3IQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 04:16:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362AbYG3IQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 04:16:22 -0400
Date: Wed, 30 Jul 2008 01:16:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roberto Oppedisano <roppedisano@infracomspa.it>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: 2.6.26-00000-g8be1a6d - WARNING: at
 drivers/base/power/main.c:82
Message-Id: <20080730011616.b68393bc.akpm@linux-foundation.org>
In-Reply-To: <20080728113321.GA10610@infracomspa.it>
References: <20080728113321.GA10610@infracomspa.it>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 13:33:21 +0200 Roberto Oppedisano <roppedisano@infracomspa.it> wrote:

> More info on request.
> 

Let's cc linux-usb, as that appears to be the subsystem which triggered
this:

int device_pm_add(struct device *dev)
{
	int error;

	pr_debug("PM: Adding info for %s:%s\n",
		 dev->bus ? dev->bus->name : "No Bus",
		 kobject_name(&dev->kobj));
	mutex_lock(&dpm_list_mtx);
	if (dev->parent) {
		if (dev->parent->power.status >= DPM_SUSPENDING) {
			dev_warn(dev, "parent %s is sleeping, will not add\n",
				dev->parent->bus_id);
			WARN_ON(true);
		}

WARN_ON.

Also, I assume that your kernel did print that "parent %s is sleeping"
message, but you trimmed it off.  That would probably be useful
information.

Thanks.

> 
> [29429.039959] ------------[ cut here ]------------
> [29429.039959] WARNING: at drivers/base/power/main.c:82
> device_pm_add+0x4d/0xb1()
> [29429.039959] Modules linked in: tun radeon drm rfcomm l2cap usblp ipv6
> cpufreq_ondemand cpufreq_stats cpufreq_userspace cpufreq_powersave
> ipt_recent xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntrack
> iptable_filter ip_tables x_tables vfat fat fuse acpi_cpufreq freq_table
> usbserial microcode snd_intel8x0m pcmcia snd_intel8x0 snd_ac97_codec
> ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_oss snd_seq_midi
> snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd
> soundcore snd_page_alloc yenta_socket rsrc_nonstatic ipw2200 pcmcia_core
> hci_usb i2c_i801 bluetooth video output battery ac button evdev usbhid
> ohci1394 8139cp uhci_hcd ehci_hcd ieee1394 usbcore sg sr_mod cdrom
> thermal processor fan
> [29429.039959] Pid: 10544, comm: s2ram Tainted: G        W
> 2.6.26-00000-g8be1a6d #1
> [29429.039959]  [<c011b733>] warn_on_slowpath+0x40/0x63
> [29429.039959]  [<c01e93b7>] sprintf+0x1d/0x20
> [29429.039959]  [<c011bfc9>] vprintk+0x1cd/0x274
> [29429.039959]  [<c011ba65>] try_acquire_console_sem+0xa/0x2a
> [29429.039959]  [<c019e631>] sysfs_find_dirent+0x13/0x23
> [29429.039959]  [<c019e107>] sysfs_add_file_mode+0x4c/0x6a
> [29429.039959]  [<c019f8cd>] internal_create_group+0xda/0x139
> [29429.039959]  [<c011c084>] printk+0x14/0x18
> [29429.039959]  [<c023ee00>] device_pm_add+0x4d/0xb1
> [29429.039959]  [<c023aacb>] device_add+0x340/0x4ad
> [29429.039959]  [<f887599e>] usb_create_ep_files+0x1ed/0x26b [usbcore]
> [29429.039959]  [<c019d850>] sysfs_hash_and_remove+0x44/0x50
> [29429.039959]  [<f887533f>] usb_create_sysfs_intf_files+0x5a/0x72
> [usbcore]
> [29429.039959]  [<f887272c>] usb_set_interface+0x137/0x140 [usbcore]
> [29429.039959]  [<f8871923>] usb_disable_interface+0x1e/0x2f [usbcore]
> [29429.039959]  [<f88737e6>] usb_unbind_interface+0x46/0x62 [usbcore]
> [29429.039959]  [<c023bf5d>] __device_release_driver+0x58/0x76
> [29429.039959]  [<c023bf93>] device_release_driver+0x18/0x21
> [29429.039959]  [<f887323f>] usb_driver_release_interface+0x3c/0x76
> [usbcore]
> [29429.039959]  [<f88b37b6>] hci_usb_disconnect+0x35/0x62 [hci_usb]
> [29429.039959]  [<f88737d6>] usb_unbind_interface+0x36/0x62 [usbcore]
> [29429.039959]  [<c023bf5d>] __device_release_driver+0x58/0x76
> [29429.039959]  [<c023bf93>] device_release_driver+0x18/0x21
> [29429.039959]  [<f887323f>] usb_driver_release_interface+0x3c/0x76
> [usbcore]
> [29429.039959]  [<f8873292>] usb_rebind_intf+0x19/0x4e [usbcore]
> [29429.039959]  [<f887332d>] do_unbind_rebind+0x4d/0x5a [usbcore]
> [29429.039959]  [<f887342a>] usb_external_resume_device+0xf0/0xf6
> [usbcore]
> [29429.039959]  [<c023ea2c>] device_resume+0x85/0x2f4
> [29429.039959]  [<c01391c9>] suspend_devices_and_enter+0xd5/0x10d
> [29429.039959]  [<c0139312>] enter_state+0xcf/0x11c
> [29429.039959]  [<c01393ec>] state_store+0x8d/0xa1
> [29429.039959]  [<c013935f>] state_store+0x0/0xa1
> [29429.039959]  [<c01e58af>] kobj_attr_store+0x18/0x1c
> [29429.039959]  [<c019de6f>] sysfs_write_file+0xa4/0xd8
> [29429.039959]  [<c019ddcb>] sysfs_write_file+0x0/0xd8
> [29429.039959]  [<c016816a>] vfs_write+0x83/0xf6
> [29429.039959]  [<c0168597>] sys_write+0x3c/0x63
> [29429.039959]  [<c01038da>] syscall_call+0x7/0xb
> [29429.039959]  =======================
> [29429.039959] ---[ end trace fa351609edb352dc ]---

