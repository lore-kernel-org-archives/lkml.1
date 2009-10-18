Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbZJROjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbZJROjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 10:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZJROji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 10:39:38 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:44436 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZJROjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 10:39:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=T/UYggw+sZYQRmxzwo5fBXD+5Rb+3uB/YiNEfkPAsxVxRLROC8wjnYgyPK5JZAMYAu
         EcC2IF7NNpC4LPKn7F3LeExu6SEFmta+ZHkgTy2xdbU1DdQd29pAUpMp1Odr4MBOOTf3
         kxtvZhXz2Cqjr0BpUzG+paGL8KX79css4CAOk=
Message-ID: <4ADB2922.9060008@tuffmail.co.uk>
Date: Sun, 18 Oct 2009 15:41:38 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Alexey Starikovskiy <aystarik@gmail.com>,
       linux acpi <linux-acpi@vger.kernel.org>
CC: pm list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: acpi battery: crash after inserting battery at wrong time during
 hibernation
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This crash happened with 2.6.32-rc4+, but I suspect it's not a 
regression, just a rare race condition.  As normal, I initiated 
hibernation, plugged in my battery, and removed the mains power.  I did 
more or less the reverse on resume.


[87672.698198] HDA Intel 0000:00:1b.0: PCI INT A disabled
[87672.711285] pci 0000:00:02.0: PCI INT A disabled
[87672.712076] ACPI: Preparing to enter system sleep state S4
[87672.732153] PM: Saving platform NVS memory
[87672.734911] power_supply BAT0: parent PNP0C0A:00 should not be sleeping

This first error message is from device_pm_add() in 
drivers/base/power/main.c.  It's clear what this means; BAT0 was created 
when the battery was inserted, even though it's parent device was 
supposed to be suspended.  In general this sounds pretty bad - I guess 
it means we will suspend the system without suspending the new child 
device.  I'm not sure why it would cause the specific backtrace below 
though.

[87672.763640] PM: Creating hibernation image:
[87672.764573] PM: Need to copy 56490 pages
[87672.764573] PM: Restoring platform NVS memory
[87672.764573] ACPI: Waking up from system sleep state S4

On resume, the battery was removed again, and this happens
(extracted from messages.log, which seems to miss certain standard 
BUG/OOPS lines).

[87673.506817] *pdpt = 00000000173b9001 *pde = 0000000000000000
[87673.507175] Modules linked in: eeepc_laptop pci_hotplug af_packet 
i915 drm_kms_helper drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect 
ipv6 loop joydev snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep ath5k snd_pcm_oss mac80211 uvcvideo snd_mixer_oss ath videodev 
snd_pcm v4l1_compat i2c_i801 cfg80211 snd_timer psmouse snd pcspkr 
i2c_core serio_raw rfkill snd_page_alloc battery ac processor evdev 
intel_agp video agpgart backlight output button thermal fan [last 
unloaded: pci_hotplug]
[87673.508520]
[87673.508520] Pid: 98, comm: kacpi_notify Not tainted 
(2.6.32-rc4eeepc-test #16) 701
[87673.508520] EIP: 0060:[<c02e5f4e>] EFLAGS: 00010246 CPU: 0
[87673.508520] EIP is at led_trigger_unregister+0x18/0x8a
[87673.508520] EAX: 00200200 EBX: dbec24a0 ECX: 00000000 EDX: 00100100
[87673.508520] ESI: dbec24a0 EDI: d7587a00 EBP: df12def4 ESP: df12dee8
[87673.508520] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[87673.508520] dbec24a0 00000000 d7587a00 df12df00 c02e5fcf d7587a0c 
df12df0c c02e168c
[87673.508520] <0> d7587a0c df12df18 c02e10bb d7587a00 df12df24 e008d04d 
d7587a00 df12df44
[87673.508520] <0> e008d2bd 000026c0 df12df54 c0198903 c0249319 00000081 
df148800 df12df58
[87673.508520] [<c02e5fcf>] ? led_trigger_unregister_simple+0xf/0x19
[87673.508520] [<c02e168c>] ? power_supply_remove_triggers+0x14/0x4c
[87673.508520] [<c02e10bb>] ? power_supply_unregister+0x12/0x24
[87673.508520] [<e008d04d>] ? sysfs_remove_battery+0x1f/0x29 [battery]
[87673.508520] [<e008d2bd>] ? acpi_battery_update+0x3d/0x1e4 [battery]
[87673.508520] [<c0198903>] ? kmem_cache_free+0x7a/0xb1
[87673.508520] [<c0249319>] ? acpi_os_release_object+0x8/0xc
[87673.508520] [<e008d995>] ? acpi_battery_notify+0x1e/0x72 [battery]
[87673.508520] [<c024b4d2>] ? acpi_device_notify+0x12/0x15
[87673.508520] [<c0256142>] ? acpi_ev_notify_dispatch+0x4c/0x57
[87673.508520] [<c0249400>] ? acpi_os_execute_deferred+0x1d/0x28
[87673.508520] [<c013ca1a>] ? worker_thread+0x111/0x184
[87673.508520] [<c02493e3>] ? acpi_os_execute_deferred+0x0/0x28
[87673.508520] [<c013f601>] ? autoremove_wake_function+0x0/0x30
[87673.508520] [<c013c909>] ? worker_thread+0x0/0x184
[87673.508520] [<c013f472>] ? kthread+0x60/0x66
[87673.508520] [<c013f412>] ? kthread+0x0/0x66
[87673.508520] [<c0107aab>] ? kernel_thread_helper+0x7/0x10
[87673.517367] ---[ end trace a56e8fbd666eda59 ]---

My system was then rendered unusable by a storm of segfaults.

[87673.528512] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
...
[87674.680592] Restarting tasks ... done.
[87674.758624] console-kit-dae[1757]: segfault at ac7dfff4 ip b76ff668 
sp b74802c0 error 4 in libglib-2.0.so.0.2200.0[b769b000+b6000]
...
[87675.035585] in libglib-2.0.so.0.2200.0[b769b000+b6000]
[87696.282399] __ratelimit: 13 callbacks suppressed
...



So at minimum, we want to avoid the initial error message.  We could 
easily stop the ACPI battery driver from doing anything if it's 
suspended (it will re-read the updated state on resume anyway).  But 
perhaps the real problem is that the ACPI core calls notify() between 
suspend() and resume()?  Should we fix that instead?

Regards
Alan
