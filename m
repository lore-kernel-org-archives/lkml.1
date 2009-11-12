Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZKLWx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZKLWx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 17:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbZKLWxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 17:53:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44203 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771AbZKLWxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 17:53:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on resume (was: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related to preempt_count leakage in keventd)
Date: Thu, 12 Nov 2009 23:55:11 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc6-tst; KDE/4.3.1; x86_64; ; )
Cc: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>
References: <200911091250.31626.rjw@sisk.pl> <200911122153.12419.rjw@sisk.pl> <alpine.LFD.2.00.0911122153320.24119@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0911122153320.24119@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <200911122355.11675.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 November 2009, Thomas Gleixner wrote:
> On Thu, 12 Nov 2009, Rafael J. Wysocki wrote:
> 
> > On Thursday 12 November 2009, Thomas Gleixner wrote:
> > > On Wed, 11 Nov 2009, Oleg Nesterov wrote:
> > > > Well, yes. Because any buggy user can easily kill the system, and we
> > > > constantly have the bugs like this one.
> > > > 
> > > > I think we should teach workqueue.c to use debugobjects.c at least.
> > > 
> > > Here you go. Would be interesting to know whether it catches the
> > > problem at hand.
> > 
> > How would I tell if it did?
> 
> Apply the patch, enable debugobjects and try to reproduce the failure
> - w/o the fix patch of course :)
> 
> debugobjects should catch the attempt to free the memory which holds
> the work_struct, cancel it and print a backtrace where this happened.

I got the appended trace, so I guess it works.

Thanks,
Rafael


[   92.775800] PM: Finishing wakeup.
[   92.775803] Restarting tasks ... 
[   92.776020] usb 5-2: USB disconnect, address 3
[   92.800258] done.
Nov 12 23:40:53 tosh bluetoothd[3424]: HCI dev 0 unregistered
Nov 12 23:40:53 tosh bluetoothd[3424]: Unregister path: /org/bluez/3424/hci0
Nov 12 23:40:53 tosh bluetoothd[3424]: Unregistered interface org.bluez.NetworkPeer on path /org/bluez/3424/hci0
Nov 12 23:40:53 tosh bluetoothd[3424]: Unregistered interface org.bluez.NetworkHub on path /org/bluez/3424/hci0
Nov 12 23:40:53 tosh bluetoothd[3424]: Unregistered interface org.bluez.NetworkRouter on path /org/bluez/3424/hci0
[   93.028345] ------------[ cut here ]------------
[   93.028525] WARNING: at /home/rafael/src/linux-2.6/lib/debugobjects.c:255 debug_print_object+0x4f/0x57()
[   93.028833] Hardware name: PORTEGE R500
[   93.028997] ODEBUG: free active object type: work_struct
[   93.029174] Modules linked in: af_packet ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit bnep sco rfcomm l2cap crc16 snd_pcm_oss snd_mixer_oss snd_seq binfmt_misc snd_seq_device ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables cpufreq_conservative cpufreq_ondemand ip6table_filter cpufreq_userspace ip6_tables cpufreq_powersave x_tables acpi_cpufreq ipv6 freq_table microcode fuse loop sr_mod cdrom dm_mod snd_hda_codec_realtek btusb arc4 bluetooth snd_hda_intel ecb snd_hda_codec iwlagn snd_hwdep iwlcore sdhci_pci snd_pcm pcmcia mac80211 toshiba_acpi snd_timer joydev sdhci firewire_ohci option usbhid video snd rtc_cmos yenta_socket cfg80211 backlight mmc_core firewire_core rsrc_nonstatic iTCO_wdt soundcore psmouse rtc_core usb_storage hid usbserial output battery ac button led_class e1000e rtc_lib pcmcia_core rfkill crc_itu_t iTCO_vendor_
support snd_page_alloc serio_raw intel_agp uinput sg ehci_hcd uhci_hcd sd_mod crc_t10dif usbcore ext3 jbd fan ahci libata thermal processor
[   93.032029] Pid: 1185, comm: khubd Not tainted 2.6.32-rc6-tst #176
[   93.032029] Call Trace:
[   93.032029]  [<ffffffff8116b773>] ? debug_print_object+0x4f/0x57
[   93.032029]  [<ffffffff81040df6>] warn_slowpath_common+0x77/0x8f
[   93.032029]  [<ffffffff81040e83>] warn_slowpath_fmt+0x64/0x66
[   93.032029]  [<ffffffff81294f96>] ? _spin_lock_irq+0x17/0x30
[   93.032029]  [<ffffffff812951cb>] ? _spin_unlock_irq+0x2b/0x36
[   93.032029]  [<ffffffff81294fc7>] ? _spin_lock_irqsave+0x18/0x34
[   93.032029]  [<ffffffff81295202>] ? _spin_unlock_irqrestore+0x2c/0x37
[   93.032029]  [<ffffffff81164caa>] ? __up_read+0x84/0x8c
[   93.032029]  [<ffffffff81294fc7>] ? _spin_lock_irqsave+0x18/0x34
[   93.038521]  [<ffffffff8116b773>] debug_print_object+0x4f/0x57
[   93.038521]  [<ffffffff8116bae4>] debug_check_no_obj_freed+0x98/0x15e
[   93.038521]  [<ffffffff81295202>] ? _spin_unlock_irqrestore+0x2c/0x37
[   93.039180]  [<ffffffff810c8d7c>] kfree+0x71/0x88
[   93.039282]  [<ffffffffa03d36f1>] btusb_destruct+0x10/0x12 [btusb]
[   93.039282]  [<ffffffffa03d36d0>] btusb_disconnect+0x81/0x92 [btusb]
[   93.039282]  [<ffffffffa00c6612>] usb_unbind_interface+0x5e/0xe1 [usbcore]
[   93.039282]  [<ffffffff811ebead>] __device_release_driver+0x70/0xbe
[   93.039282]  [<ffffffff811ebfc6>] device_release_driver+0x1e/0x2b
[   93.040317]  [<ffffffff811ebb46>] bus_remove_device+0x83/0x92
[   93.040317]  [<ffffffff811e9940>] device_del+0x12e/0x170
[   93.040317]  [<ffffffffa00c3adf>] usb_disable_device+0x76/0xf5 [usbcore]
[   93.040317]  [<ffffffffa00becfb>] usb_disconnect+0x96/0xfa [usbcore]
[   93.040317]  [<ffffffffa00bf927>] hub_thread+0x493/0xe2c [usbcore]
[   93.040317]  [<ffffffff81058465>] ? autoremove_wake_function+0x0/0x38
[   93.040317]  [<ffffffff81293de6>] ? preempt_schedule+0x3b/0x41
[   93.040317]  [<ffffffffa00bf494>] ? hub_thread+0x0/0xe2c [usbcore]
[   93.040317]  [<ffffffff8105823e>] kthread+0x69/0x71
[   93.040317]  [<ffffffff8100c16a>] child_rip+0xa/0x20
[   93.042128]  [<ffffffff810581d5>] ? kthread+0x0/0x71
[   93.042393]  [<ffffffff8100c160>] ? child_rip+0x0/0x20
[   93.042478] ---[ end trace 6915b286c29296ce ]---

