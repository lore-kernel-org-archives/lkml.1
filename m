Return-Path: <linux-kernel-owner+w=401wt.eu-S932775AbYB1XfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775AbYB1XfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 18:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932162AbYB1XfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 18:35:05 -0500
Received: from ns1.suse.de ([195.135.220.2]:51357 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759842AbYB1XfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 18:35:01 -0500
Date: Fri, 29 Feb 2008 00:36:11 +0100
From: Holger Macht <hmacht@suse.de>
To: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] libata: Register for dock events when the drive is
	inside a dock station
Message-ID: <20080228233610.GA3808@homac>
Mail-Followup-To: Tejun Heo <htejun@gmail.com>,
	Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Kristen Carlson Accardi <kristen.c.accardi@intel.com>
References: <20080214125615.GD9708@homac.suse.de> <47BC5F44.605@garzik.org> <20080221115305.GB5032@homac.suse.de> <47BE26A0.2040708@gmail.com> <20080226101551.GB10721@homac.suse.de> <47C6804A.50705@gmail.com> <20080228110927.GA5745@homac.suse.de> <47C6B1B1.2040602@gmail.com> <20080228155817.GB5593@homac.suse.de> <20080228183243.GA6146@homac.suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gatW/ieO32f1wygP"
Content-Disposition: inline
In-Reply-To: <20080228183243.GA6146@homac.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 28. Feb - 19:32:43, Holger Macht wrote:
> On Thu 28. Feb - 16:58:17, Holger Macht wrote:
> > On Thu 28. Feb - 22:05:53, Tejun Heo wrote:
> > > Holger Macht wrote:
> > > > On Thu 28. Feb - 18:35:06, Tejun Heo wrote:
> > > >> Holger Macht wrote:
> > > >>> The hotplug handler is only called if the device is actually inside the
> > > >>> dock station. If it is not, nothing will happen. I hope that I got your
> > > >>> question right?
> > > >> Yes, right.
> > > >>
> > > >>> However, if this would be helpful, it would be easy to add something like
> > > >>> a am_I_on_dock_station?(...) function to the dock driver.
> > > >> Hmm.. as long as the event is only delivered when the device is actually
> > > >> connected behind dock, I think it's okay.
> > > > 
> > > > The dock driver also export a is_dock_device(acpi_handle) function, which
> > > > could be used to make more fine-grained decisions, but it shouldn't be
> > > > needed here.
> > > > 
> > > >> Does the attached patch fix the previous undock problem?  It now
> > > >> explicitly tells libata EH to detach the notified devices on
> > > >> EJECT_REQUEST and wait for EH to complete such that control is returned
> > > >> to ACPI after all notified devices are actually detached.
> > > > 
> > > > No it does not. Apparently, it freezes faster (from 1 second down to
> > > > immediately). Before, it just froze when someone (in this case HAL) tried
> > > > to access the device. The "echo 1 > undock" call does not even return, so
> > > > it might have introduced another problem.
> > > 
> > > The code should be in generally right direction.  Can you be persuaded
> > > into tracking down what's going on?
> > 
> > I had a quick glance with adding some printk's. Now I got a different
> > behaviour once. System did not freeze, but were certainly confused. The
> > last thing which got printed to messages was exactly before
> > spin_lock_irqsave(ap->lock, flags); at the beginning of ata_acpi_handle_hotplug(...)
> > 
> > The printk immediately after this call didn't come through anymore (with
> > being able to use the system for a short time afterwards).
> 
> Ok, it seems that there is something broken somewhere else in
> 2.6.25.rc3. Not sure at all if it's your patch freezing the machine. I'll
> give 2.6.24.3 a try...

So once again...

After applying your patch, I got the OOPS seen in attachment
'oops-undock-1'. After changing the following, which is hopefully
correct...

--- ../orig/linux-2.6.24.3/drivers/ata/libata-acpi.c	2008-02-29 00:31:44.000000000 +0100
+++ drivers/ata/libata-acpi.c	2008-02-29 00:32:26.000000000 +0100
@@ -123,7 +123,7 @@
 {
 	char event_string[12];
 	char *envp[] = { event_string, NULL };
-	struct ata_eh_info *ehi = &ap->link.eh_info;
+	struct ata_eh_info *ehi;
 	struct kobject *kobj = NULL;
 	int wait = 0;
 	unsigned long flags;
@@ -131,6 +131,8 @@
 	if (!ap)
 		ap = dev->link->ap;
 
+	ehi = &ap->link.eh_info;
+
 	spin_lock_irqsave(ap->lock, flags);
 
 	switch (event) {


...I got both an oops when docking (attachments oops-dock) and when undocking
(attachment oops-undock2).

Regards,
	Holger

--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=oops-undock-1

UG: unable to handle kernel paging request at virtual address 00001718
printing eip: f8bb5316 *pde = 00000000 
Oops: 0000 [#1] SMP 
Modules linked in: bay snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device iptable_filter ip_tables ip6table_filter ip6_tables x_tables ipv6 af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq speedstep_lib fuse dm_crypt ext3 jbd mbcache loop dm_mod arc4 ecb blkcipher pcmcia snd_hda_intel iwl3945 yenta_socket sdhci snd_pcm rsrc_nonstatic mmc_core ohci1394 firmware_class thinkpad_acpi intel_agp snd_timer ac pcmcia_core ieee1394 iTCO_wdt snd_page_alloc battery mac80211 snd_hwdep video iTCO_vendor_support output e1000 i2c_i801 hwmon parport_pc agpgart snd i2c_core rtc_cmos rtc_core parport cfg80211 nvram rtc_lib soundcore button sg ehci_hcd uhci_hcd sd_mod usbcore edd reiserfs fan thermal processor piix ide_core sr_mod cdrom ata_piix ahci libata scsi_mod dock

Pid: 13, comm: kacpi_notify Not tainted (2.6.24.3-devel-default #4)
EIP: 0060:[<f8bb5316>] EFLAGS: 00010096 CPU: 1
EIP is at ata_ehi_push_desc+0x9/0x47 [libata]
EAX: 000016a8 EBX: 00000000 ECX: c036d3ac EDX: f742fe0c
ESI: 000016a8 EDI: 00000000 EBP: f7448000 ESP: f7cc3ecc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kacpi_notify (pid: 13, ti=f7cc2000 task=f7c72670 task.ti=f7cc2000)
Stack: 00000006 c01d5cb9 00000000 f7fffc08 f8bb7958 000016a8 f8bbb771 f7f0b280 
       00000003 000016a8 00000246 c03837ec f7f82a00 f7f82a86 f7cc3ef8 00000000 
       f7f0f1e0 f7d1d900 f8bb7a7a f7d1d928 f8842169 f884212d 00000003 f7d1d910 
Call Trace:
 [<c01d5cb9>] kobject_uevent_env+0x35e/0x380
 [<f8bb7958>] ata_acpi_handle_hotplug+0xb5/0x1d7 [libata]
 [<f8bb7a7a>] ata_acpi_dev_notify+0x0/0xd [libata]
 [<f8842169>] hotplug_dock_devices+0x37/0xe8 [dock]
 [<f884212d>] dock_event+0x4d/0x52 [dock]
 [<c01fc468>] acpi_os_execute_notify+0x0/0x2b
 [<f8842397>] handle_eject_request+0xb5/0xd7 [dock]
 [<c02039d3>] acpi_ev_notify_dispatch+0x4c/0x55
 [<c01fc48a>] acpi_os_execute_notify+0x22/0x2b
 [<c0132cf6>] run_workqueue+0x7d/0x107
 [<c0132e3e>] worker_thread+0xbe/0xca
 [<c01361e3>] autoremove_wake_function+0x0/0x35
 [<c0132d80>] worker_thread+0x0/0xca
 [<c0135f5d>] kthread+0x38/0x5d
 [<c0135f25>] kthread+0x0/0x5d
 [<c01062c7>] kernel_thread_helper+0x7/0x10
 =======================
Code: 24 44 01 f9 11 eb 89 4c 24 0c 89 5c 24 10 89 54 24 08 89 04 24 e8 88 fe ff ff 83 c4 30 5b 5e 5f 5d c3 56 53 83 ec 08 8b 74 24 14 <83> 7e 70 00 74 10 c7 44 24 04 ad a9 bb f8 89 34 24 e8 31 fe ff 
EIP: [<f8bb5316>] ata_ehi_push_desc+0x9/0x47 [libata] SS:ESP 0068:f7cc3ecc
---[ end trace e5085e9aa813941f ]---
ata5.00: disabled

--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=oops-dock

WARNING: at drivers/ata/libata-eh.c:805 ata_port_freeze()
Pid: 13, comm: kacpi_notify Not tainted 2.6.24.3-devel-default #4
 [<f8bb4a78>] ata_port_freeze+0x39/0x51 [libata]
 [<f8bb7935>] ata_acpi_handle_hotplug+0x92/0x1c9 [libata]
 [<f8bb7a6c>] ata_acpi_dev_notify+0x0/0xd [libata]
 [<f8842169>] hotplug_dock_devices+0x37/0xe8 [dock]
 [<c01fc468>] acpi_os_execute_notify+0x0/0x2b
 [<c01fc468>] acpi_os_execute_notify+0x0/0x2b
 [<f884245c>] dock_notify+0x7e/0xde [dock]
 [<c02039d3>] acpi_ev_notify_dispatch+0x4c/0x55
 [<c01fc48a>] acpi_os_execute_notify+0x22/0x2b
 [<c0132cf6>] run_workqueue+0x7d/0x107
 [<c0132e3e>] worker_thread+0xbe/0xca
 [<c01361e3>] autoremove_wake_function+0x0/0x35
 [<c0132d80>] worker_thread+0x0/0xca
 [<c0135f5d>] kthread+0x38/0x5d
 [<c0135f25>] kthread+0x0/0x5d
 [<c01062c7>] kernel_thread_helper+0x7/0x10
 =======================
WARNING: at drivers/ata/libata-eh.c:704 ata_do_link_abort()
Pid: 13, comm: kacpi_notify Not tainted 2.6.24.3-devel-default #4
 [<f8bb49c0>] ata_do_link_abort+0x3f/0xb7 [libata]
 [<f8bb4a7f>] ata_port_freeze+0x40/0x51 [libata]
 [<f8bb7935>] ata_acpi_handle_hotplug+0x92/0x1c9 [libata]
 [<f8bb7a6c>] ata_acpi_dev_notify+0x0/0xd [libata]
 [<f8842169>] hotplug_dock_devices+0x37/0xe8 [dock]
 [<c01fc468>] acpi_os_execute_notify+0x0/0x2b
 [<c01fc468>] acpi_os_execute_notify+0x0/0x2b
 [<f884245c>] dock_notify+0x7e/0xde [dock]
 [<c02039d3>] acpi_ev_notify_dispatch+0x4c/0x55
 [<c01fc48a>] acpi_os_execute_notify+0x22/0x2b
 [<c0132cf6>] run_workqueue+0x7d/0x107
 [<c0132e3e>] worker_thread+0xbe/0xca
 [<c01361e3>] autoremove_wake_function+0x0/0x35
 [<c0132d80>] worker_thread+0x0/0xca
 [<c0135f5d>] kthread+0x38/0x5d
 [<c0135f25>] kthread+0x0/0x5d
 [<c01062c7>] kernel_thread_helper+0x7/0x10
 =======================
BUG: unable to handle kernel NULL pointer dereference at virtual address 00000004
printing eip: f8ba84ec *pde = 00000000 
Oops: 0000 [#1] SMP 
Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device iptable_filter ip_tables ip6table_filter ip6_tables x_tables ipv6 af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq speedstep_lib fuse dm_crypt ext3 jbd mbcache loop dm_mod arc4 ecb blkcipher snd_hda_intel pcmcia snd_pcm iwl3945 thinkpad_acpi sdhci snd_timer yenta_socket ohci1394 hwmon firmware_class mmc_core snd_page_alloc rsrc_nonstatic snd_hwdep video ieee1394 parport_pc mac80211 pcmcia_core battery output snd rtc_cmos ac button nvram iTCO_wdt parport e1000 rtc_core intel_agp rtc_lib i2c_i801 iTCO_vendor_support soundcore agpgart cfg80211 sg i2c_core ehci_hcd uhci_hcd sd_mod usbcore edd reiserfs fan thermal processor piix ide_core sr_mod cdrom ata_piix ahci libata scsi_mod dock

Pid: 13, comm: kacpi_notify Not tainted (2.6.24.3-devel-default #4)
EIP: 0060:[<f8ba84ec>] EFLAGS: 00010082 CPU: 1
EIP is at ata_qc_complete+0xb/0x12a [libata]
EAX: f7fb6c7c EBX: f7fb6c7c ECX: f7fb6c00 EDX: f7fb6c7c
ESI: 00000000 EDI: 00000000 EBP: f7fb6c00 ESP: f7cc3e98
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kacpi_notify (pid: 13, ti=f7cc2000 task=f7c72670 task.ti=f7cc2000)
Stack: 0000000d f7c72861 c03ef3dc c036a3ea f7fb6c00 00000000 00000001 f7fb6c00 
       f8bb4a17 f8bba104 f8bba0ec 000002c0 f8bb86c4 00000000 f7fb6c00 f7fb6c00 
       00000000 f7408000 f8bb4a7f f8bba104 f8bba0ec 00000325 f8bb86b4 f7fb6c00 
Call Trace:
 [<f8bb4a17>] ata_do_link_abort+0x96/0xb7 [libata]
 [<f8bb4a7f>] ata_port_freeze+0x40/0x51 [libata]
 [<f8bb7935>] ata_acpi_handle_hotplug+0x92/0x1c9 [libata]
 [<f8bb7a6c>] ata_acpi_dev_notify+0x0/0xd [libata]
 [<f8842169>] hotplug_dock_devices+0x37/0xe8 [dock]
 [<c01fc468>] acpi_os_execute_notify+0x0/0x2b
 [<c01fc468>] acpi_os_execute_notify+0x0/0x2b
 [<f884245c>] dock_notify+0x7e/0xde [dock]
 [<c02039d3>] acpi_ev_notify_dispatch+0x4c/0x55
 [<c01fc48a>] acpi_os_execute_notify+0x22/0x2b
 [<c0132cf6>] run_workqueue+0x7d/0x107
 [<c0132e3e>] worker_thread+0xbe/0xca
 [<c01361e3>] autoremove_wake_function+0x0/0x35
 [<c0132d80>] worker_thread+0x0/0xca
 [<c0135f5d>] kthread+0x38/0x5d
 [<c0135f25>] kthread+0x0/0x5d
 [<c01062c7>] kernel_thread_helper+0x7/0x10
 =======================
Code: b8 fe ff ff ff 83 63 34 fe d3 c0 21 86 80 16 00 00 89 d8 ff 93 a4 00 00 00 83 c4 10 5b 5e 5f c3 55 57 56 53 89 c3 83 ec 10 8b 38 <8b> 47 04 83 78 64 00 0f 84 ce 00 00 00 8b 73 04 f6 47 10 04 8b 
EIP: [<f8ba84ec>] ata_qc_complete+0xb/0x12a [libata] SS:ESP 0068:f7cc3e98
---[ end trace aa89e4d71e841cf2 ]---

--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=oops-undock-2

Feb 29 00:17:15 homac smartd[3078]: Unable to monitor any SMART enabled devices. Try debug (-d) option. Exiting...
Feb 29 00:17:16 homac klogd: ip6_tables: (C) 2000-2006 Netfilter Core Team
Feb 29 00:17:16 homac SuSEfirewall2: Warning: ip6tables does not support state matching. Extended IPv6 support disabled.
Feb 29 00:17:16 homac klogd: ip_tables: (C) 2000-2006 Netfilter Core Team
Feb 29 00:17:16 homac SuSEfirewall2: SuSEfirewall2 not active
Feb 29 00:17:16 homac syslog-ng[2579]: SIGHUP received, restarting syslog-ng
Feb 29 00:17:16 homac sshd[3239]: Server listening on :: port 22.
Feb 29 00:17:18 homac syslog-ng[2579]: new configuration initialized
Feb 29 00:17:23 homac klogd: wlan0: no IPv6 routers present
Feb 29 00:17:23 homac klogd: klogd 1.4.1, ---------- state change ----------
Feb 29 00:17:52 homac klogd: WARNING: at lib/vsprintf.c:399 vsnprintf()
Feb 29 00:17:52 homac klogd: Pid: 13, comm: kacpi_notify Not tainted 2.6.24.3-devel-default #4
Feb 29 00:17:52 homac klogd:  [<c01d8563>] vsnprintf+0x4d/0x4a0
Feb 29 00:17:52 homac klogd:  [<c028e3cb>] netlink_broadcast+0x2c1/0x301
Feb 29 00:17:52 homac klogd:  [<c01d8a41>] vscnprintf+0x14/0x1f
Feb 29 00:17:52 homac klogd:  [<f8bb5184>] __ata_ehi_push_desc+0x27/0x30 [libata]
Feb 29 00:17:52 homac klogd:  [<f8bb532c>] ata_ehi_push_desc+0x1f/0x47 [libata]
Feb 29 00:17:52 homac klogd:  [<f8bb794a>] ata_acpi_handle_hotplug+0xa7/0x1c9 [libata]
Feb 29 00:17:52 homac klogd:  [<f8bb7a6c>] ata_acpi_dev_notify+0x0/0xd [libata]
Feb 29 00:17:52 homac klogd:  [<f8842169>] hotplug_dock_devices+0x37/0xe8 [dock]
Feb 29 00:17:52 homac klogd:  [<f884212d>] dock_event+0x4d/0x52 [dock]
Feb 29 00:17:52 homac klogd:  [<c01fc468>] acpi_os_execute_notify+0x0/0x2b
Feb 29 00:17:52 homac klogd:  [<f8842397>] handle_eject_request+0xb5/0xd7 [dock]
Feb 29 00:17:52 homac klogd:  [<c02039d3>] acpi_ev_notify_dispatch+0x4c/0x55
Feb 29 00:17:52 homac klogd:  [<c01fc48a>] acpi_os_execute_notify+0x22/0x2b
Feb 29 00:17:52 homac klogd:  [<c0132cf6>] run_workqueue+0x7d/0x107
Feb 29 00:17:52 homac klogd:  [<c0132e3e>] worker_thread+0xbe/0xca
Feb 29 00:17:52 homac klogd:  [<c01361e3>] autoremove_wake_function+0x0/0x35
Feb 29 00:17:52 homac klogd:  [<c0132d80>] worker_thread+0x0/0xca
Feb 29 00:17:52 homac klogd:  [<c0135f5d>] kthread+0x38/0x5d
Feb 29 00:17:52 homac klogd:  [<c0135f25>] kthread+0x0/0x5d
Feb 29 00:17:52 homac klogd:  [<c01062c7>] kernel_thread_helper+0x7/0x10
Feb 29 00:17:52 homac klogd:  =======================
Feb 29 00:17:52 homac klogd: WARNING: at drivers/ata/libata-eh.c:689 ata_port_schedule_eh()
Feb 29 00:17:52 homac klogd: Pid: 13, comm: kacpi_notify Not tainted 2.6.24.3-devel-default #4
Feb 29 00:17:52 homac klogd:  [<f8bb4856>] ata_port_schedule_eh+0x38/0x5a [libata]
Feb 29 00:17:52 homac klogd:  [<f8bb7a01>] ata_acpi_handle_hotplug+0x15e/0x1c9 [libata]
Feb 29 00:17:52 homac klogd:  [<f8bb7a6c>] ata_acpi_dev_notify+0x0/0xd [libata]
Feb 29 00:17:52 homac klogd:  [<f8842169>] hotplug_dock_devices+0x37/0xe8 [dock]
Feb 29 00:17:52 homac klogd:  [<f884212d>] dock_event+0x4d/0x52 [dock]
Feb 29 00:17:52 homac klogd:  [<c01fc468>] acpi_os_execute_notify+0x0/0x2b
Feb 29 00:17:52 homac klogd:  [<f8842397>] handle_eject_request+0xb5/0xd7 [dock]
Feb 29 00:17:52 homac klogd:  [<c02039d3>] acpi_ev_notify_dispatch+0x4c/0x55
Feb 29 00:17:52 homac klogd:  [<c01fc48a>] acpi_os_execute_notify+0x22/0x2b
Feb 29 00:17:52 homac klogd:  [<c0132cf6>] run_workqueue+0x7d/0x107
Feb 29 00:17:52 homac klogd:  [<c0132e3e>] worker_thread+0xbe/0xca
Feb 29 00:17:52 homac klogd:  [<c01361e3>] autoremove_wake_function+0x0/0x35
Feb 29 00:17:52 homac klogd:  [<c0132d80>] worker_thread+0x0/0xca
Feb 29 00:17:52 homac klogd:  [<c0135f5d>] kthread+0x38/0x5d
Feb 29 00:17:52 homac klogd:  [<c0135f25>] kthread+0x0/0x5d
Feb 29 00:17:52 homac klogd:  [<c01062c7>] kernel_thread_helper+0x7/0x10
Feb 29 00:17:52 homac klogd:  =======================
Feb 29 00:17:52 homac klogd: ------------[ cut here ]------------
Feb 29 00:17:52 homac klogd: kernel BUG at kernel/timer.c:401!
Feb 29 00:17:52 homac klogd: invalid opcode: 0000 [#1] SMP 
Feb 29 00:17:52 homac klogd: Modules linked in: iptable_filter ip_tables ip6table_filter ip6_tables x_tables ipv6 snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq speedstep_lib fuse dm_crypt ext3 jbd mbcache loop dm_mod arc4 ecb blkcipher snd_hda_intel iwl3945 snd_pcm snd_timer pcmcia snd_page_alloc snd_hwdep firmware_class sdhci thinkpad_acpi ohci1394 yenta_socket battery intel_agp video rsrc_nonstatic mmc_core mac80211 snd ac output pcmcia_core ieee1394 parport_pc hwmon button iTCO_wdt e1000 agpgart iTCO_vendor_support parport i2c_i801 soundcore nvram cfg80211 rtc_cmos i2c_core rtc_core rtc_lib sg ehci_hcd uhci_hcd sd_mod usbcore edd reiserfs fan thermal processor piix ide_core sr_mod cdrom ata_piix ahci libata scsi_mod dock
Feb 29 00:17:52 homac klogd: 
Feb 29 00:17:52 homac klogd: Pid: 13, comm: kacpi_notify Not tainted (2.6.24.3-devel-default #4)
Feb 29 00:17:52 homac klogd: EIP: 0060:[<c012d19f>] EFLAGS: 00010046 CPU: 1
Feb 29 00:17:52 homac klogd: EIP is at __mod_timer+0x41/0xc5
Feb 29 00:17:52 homac klogd: EAX: 0000000d EBX: f741053c ECX: f740e408 EDX: ffff5e28
Feb 29 00:17:52 homac klogd: ESI: f7c72871 EDI: f7410568 EBP: f7448000 ESP: f7cc3eb0
Feb 29 00:17:52 homac klogd:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Feb 29 00:17:52 homac klogd: Process kacpi_notify (pid: 13, ti=f7cc2000 task=f7c72670 task.ti=f7cc2000)
Feb 29 00:17:52 homac klogd: Stack: ffff5e28 c036a3ea f740e408 f740fab0 00000001 f7448000 f8bb4868 f8bba104 
Feb 29 00:17:52 homac klogd:        f8bba0ec 000002b1 f8bb86d8 f740e408 f8bb7a01 f740fab0 f8bbb765 f77d1f20 
Feb 29 00:17:52 homac klogd:        00000003 00000246 c03837ec f77ec400 f77ec486 f7cc3ef8 00000000 f7f23920 
Feb 29 00:17:52 homac klogd: Call Trace:
Feb 29 00:17:52 homac klogd:  [<f8bb4868>] ata_port_schedule_eh+0x4a/0x5a [libata]
Feb 29 00:17:52 homac klogd:  [<f8bb7a01>] ata_acpi_handle_hotplug+0x15e/0x1c9 [libata]
Feb 29 00:17:52 homac klogd:  [<f8bb7a6c>] ata_acpi_dev_notify+0x0/0xd [libata]
Feb 29 00:17:52 homac klogd:  [<f8842169>] hotplug_dock_devices+0x37/0xe8 [dock]
Feb 29 00:17:52 homac klogd:  [<f884212d>] dock_event+0x4d/0x52 [dock]
Feb 29 00:17:52 homac klogd:  [<c01fc468>] acpi_os_execute_notify+0x0/0x2b
Feb 29 00:17:52 homac klogd:  [<f8842397>] handle_eject_request+0xb5/0xd7 [dock]
Feb 29 00:17:52 homac klogd:  [<c02039d3>] acpi_ev_notify_dispatch+0x4c/0x55
Feb 29 00:17:52 homac klogd:  [<c01fc48a>] acpi_os_execute_notify+0x22/0x2b
Feb 29 00:17:52 homac klogd:  [<c0132cf6>] run_workqueue+0x7d/0x107
Feb 29 00:17:52 homac klogd:  [<c0132e3e>] worker_thread+0xbe/0xca
Feb 29 00:17:52 homac klogd:  [<c01361e3>] autoremove_wake_function+0x0/0x35
Feb 29 00:17:52 homac klogd:  [<c0132d80>] worker_thread+0x0/0xca
Feb 29 00:17:52 homac klogd:  [<c0135f5d>] kthread+0x38/0x5d
Feb 29 00:17:52 homac klogd:  [<c0135f25>] kthread+0x0/0x5d
Feb 29 00:17:52 homac klogd:  [<c01062c7>] kernel_thread_helper+0x7/0x10
Feb 29 00:17:52 homac klogd:  =======================
Feb 29 00:17:52 homac klogd: Code: 89 43 18 8d 7b 1c 64 a1 00 60 3d c0 8d b0 f1 01 00 00 a5 a5 a5 a5 64 a1 00 60 3d c0 8b 80 ec 00 00 00 89 43 2c 83 7b 0c 00 75 04 <0f> 0b eb fe 8d 54 24 04 89 d8 e8 4f fe ff ff 8b 13 31 ed 85 d2 
Feb 29 00:17:52 homac klogd: EIP: [<c012d19f>] __mod_timer+0x41/0xc5 SS:ESP 0068:f7cc3eb0
Feb 29 00:17:52 homac klogd: ---[ end trace 040520069a3463d6 ]---

--gatW/ieO32f1wygP--
