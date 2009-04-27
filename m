Return-Path: <linux-kernel-owner+w=401wt.eu-S1757107AbZD0Vg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbZD0Vg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 17:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbZD0VgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 17:36:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53327 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007AbZD0VgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 17:36:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: [warn_once] warning: at kernel/hrtimer.c:625 hres_timers_resume+0x24/0x38()
Date: Mon, 27 Apr 2009 23:35:32 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <208cbae30904190953t58105f13p6e11efca6d6f5322@mail.gmail.com>
In-Reply-To: <208cbae30904190953t58105f13p6e11efca6d6f5322@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904272335.33060.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 April 2009, Alexey Klimov wrote:
> Hello all
> When testing behaviour of radio-mr800 drvier when doing suspend/resume
> to disk, using echo disk > /sys/power/state i have such warning in
> dmesg(see below please).
> Kernel is 30-rc2, up-to-date. If you need more information, feel free to ask.

Can you please retest with the appended patch applied and report back?

> The code in hrtimer.c is:
> 
> void hres_timers_resume(void)
> {
>         WARN_ONCE(!irqs_disabled(),
>                   KERN_INFO "hres_timers_resume() called with IRQs enabled!");
> 
> 
> 
> ------------[ cut here ]------------
> WARNING: at kernel/hrtimer.c:625 hres_timers_resume+0x24/0x38()
> Hardware name: TravelMate 2350
> hres_timers_resume() called with IRQs enabled!Modules linked in:
> radio_mr800 v4l2_common videodev snd_intel8x0 nls_utf8 cifs
> snd_usb_audio snd_usb_lib snd_rawmidi snd_hwdep nls_iso8859_1
> nls_cp437 vfat fat nls_base v4l1_compat i915 drm cpufreq_ondemand
> acpi_cpufreq snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
> snd_seq_device snd_pcm_oss snd_mixer_oss usbhid hid snd_ac97_codec
> ac97_bus yenta_socket snd_pcm rsrc_nonstatic 8139cp pcmcia_core
> rtc_cmos snd_timer 8139too libipw ehci_hcd snd lib80211 psmouse
> rtc_core uhci_hcd mii soundcore usbcore shpchp sr_mod serio_raw cdrom
> ac thermal i2c_i801 battery button rtc_lib pci_hotplug sg
> snd_page_alloc [last unloaded: radio_mr800]
> Pid: 25506, comm: bash Not tainted 2.6.30-rc2 #43
> Call Trace:
>  [<c011852d>] ? warn_slowpath+0x80/0xae
>  [<c01fd36a>] ? acpi_ns_lookup+0x1fa/0x316
>  [<c011452e>] ? wakeup_preempt_entity+0xc3/0xe9
>  [<c012aa73>] ? getnstimeofday+0x4c/0xc9
>  [<c010d02f>] ? lapic_next_event+0x13/0x16
>  [<c012cb79>] ? clockevents_program_event+0xc2/0xd0
>  [<c012d687>] ? tick_dev_program_event+0x1e/0x81
>  [<c012d729>] ? tick_program_event+0xf/0x11
>  [<c01288be>] ? notifier_call_chain+0x2a/0x47
>  [<c0127ec6>] ? hres_timers_resume+0x24/0x38
>  [<c012a1b5>] ? timekeeping_resume+0xcb/0xd0
>  [<c02307f4>] ? __sysdev_resume+0x11/0x34
>  [<c0230835>] ? sysdev_resume+0x1e/0x50
>  [<c01344e0>] ? hibernation_snapshot+0xd5/0x15b
>  [<c01345f2>] ? hibernate+0x8c/0x141
>  [<c0133566>] ? state_store+0x0/0x9a
>  [<c01335b4>] ? state_store+0x4e/0x9a
>  [<c0133566>] ? state_store+0x0/0x9a
>  [<c01ca6f7>] ? kobj_attr_store+0x18/0x1c
>  [<c018b929>] ? sysfs_write_file+0xb0/0xdd
>  [<c018b879>] ? sysfs_write_file+0x0/0xdd
>  [<c015a537>] ? vfs_write+0x84/0xf7
>  [<c015a642>] ? sys_write+0x3c/0x63
>  [<c0102788>] ? sysenter_do_call+0x12/0x26
> ---[ end trace df0f2ac34650ffc9 ]---
> --

Best,
Rafael

---

    PM: Warn if interrupts are enabled during suspend-resume of sysdevs
    
    Sysdevs have to be suspended and resumed with interrupts disabled and
    things usually break in a way that's difficult to debug if one of
    sysdev drivers enables interrupts by mistake during suspend or
    resume.  Add extra checks that will generate warnings in such cases.
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 3236b43..9742a78 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -343,11 +343,15 @@ static void __sysdev_resume(struct sys_device *dev)
 	/* First, call the class-specific one */
 	if (cls->resume)
 		cls->resume(dev);
+	WARN_ONCE(!irqs_disabled(),
+		"Interrupts enabled after %pF\n", cls->resume);
 
 	/* Call auxillary drivers next. */
 	list_for_each_entry(drv, &cls->drivers, entry) {
 		if (drv->resume)
 			drv->resume(dev);
+		WARN_ONCE(!irqs_disabled(),
+			"Interrupts enabled after %pF\n", drv->resume);
 	}
 }
 
@@ -377,6 +381,9 @@ int sysdev_suspend(pm_message_t state)
 	if (ret)
 		return ret;
 
+	WARN_ONCE(!irqs_disabled(),
+		"Interrupts enabled while suspending system devices\n");
+
 	pr_debug("Suspending System Devices\n");
 
 	list_for_each_entry_reverse(cls, &system_kset->list, kset.kobj.entry) {
@@ -393,6 +400,9 @@ int sysdev_suspend(pm_message_t state)
 					if (ret)
 						goto aux_driver;
 				}
+				WARN_ONCE(!irqs_disabled(),
+					"Interrupts enabled after %pF\n",
+					drv->suspend);
 			}
 
 			/* Now call the generic one */
@@ -400,6 +410,9 @@ int sysdev_suspend(pm_message_t state)
 				ret = cls->suspend(sysdev, state);
 				if (ret)
 					goto cls_driver;
+				WARN_ONCE(!irqs_disabled(),
+					"Interrupts enabled after %pF\n",
+					cls->suspend);
 			}
 		}
 	}
@@ -452,6 +465,9 @@ int sysdev_resume(void)
 {
 	struct sysdev_class *cls;
 
+	WARN_ONCE(!irqs_disabled(),
+		"Interrupts enabled while resuming system devices\n");
+
 	pr_debug("Resuming System Devices\n");
 
 	list_for_each_entry(cls, &system_kset->list, kset.kobj.entry) {
