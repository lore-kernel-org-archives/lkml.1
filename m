Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbZDMRCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbZDMRCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 13:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbZDMRB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 13:01:59 -0400
Received: from relay4.ptmail.sapo.pt ([212.55.154.24]:50172 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752075AbZDMRB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 13:01:58 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Mon, 13 Apr 2009 17:59:13 +0100
From: Luis Henriques <henrix@sapo.pt>
To: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, mark.langsdorf@amd.com,
       linux-kernel@vger.kernel.org
Subject: [BUG -tip] unable to handle kernel paging request
Message-ID: <20090413165913.GA4798@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(not sure if I'm CC'ing all the relevant persons...)

I am hitting this bug, which occurs mainly when I am shutting down my laptop.  I
took a look at the cpufreq code and found out something which I am not sure if it
is related with this bug (or even if it is an issue at all):

void cpufreq_notify_transition(struct cpufreq_freqs *freqs, unsigned int state)
{
        struct cpufreq_policy *policy;

        BUG_ON(irqs_disabled());

        freqs->flags = cpufreq_driver->flags;

		...

This code accesses cpufreq_driver without using the cpufreq_driver_lock.  I
believe this is the only place in the code where this lock is not obtaining
before accessing the global cpufreq_driver.

Any ideas?
--
Luis Henriques

[ 2015.908598] BUG: unable to handle kernel paging request at 0000737463656a6f
[ 2015.908606] IP: [<0000737463656a6f>] 0x737463656a6f
[ 2015.908616] PGD 0 
[ 2015.908620] Oops: 0010 [#1] PREEMPT SMP 
[ 2015.908627] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
[ 2015.908631] CPU 0 
[ 2015.908635] Modules linked in: ipv6 powernow_k8 cpufreq_stats af_packet cpufreq_conservative cpufreq_ondemand freq_table cpufreq_powersave cpufreq_userspace sbp2 loop snd_hda_codec_atihdmi snd_hda_codec_realtek rfkill snd_hda_intel ath5k backlight snd_hda_codec evdev i2c_piix4 psmouse k8temp snd_hwdep snd_pcm snd_timer led_class snd_page_alloc input_polldev battery processor ac button sg sr_mod cdrom ata_generic pata_acpi sd_mod ohci_hcd ohci1394 ieee1394 pata_atiixp ahci libata ide_pci_generic ehci_hcd r8169 mii scsi_mod usbcore ide_core thermal fan [last unloaded: kvm]
[ 2015.908723] Pid: 3117, comm: powernowd Tainted: G   M       2.6.30-rc1-tip-01567-gacf5b32 #19 Satellite A210
[ 2015.908727] RIP: 0010:[<0000737463656a6f>]  [<0000737463656a6f>] 0x737463656a6f
[ 2015.908734] RSP: 0018:ffff88007b4ffcd0  EFLAGS: 00010282
[ 2015.908737] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffffa03957b0
[ 2015.908740] RDX: ffff88007b4ffdb8 RSI: 0000000000000000 RDI: ffffffffa03957b0
[ 2015.908744] RBP: ffff88007b4ffd08 R08: 0000000000000000 R09: 0000000000000000
[ 2015.908747] R10: ffffffff80274269 R11: 0000000000000000 R12: 00000000fffffffd
[ 2015.908750] R13: 0000000000000000 R14: ffff88007b4ffdb8 R15: 0000000000000000
[ 2015.908755] FS:  00007f327af266f0(0000) GS:ffff880001042000(0000) knlGS:00000000f6b24720
[ 2015.908758] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2015.908762] CR2: 0000737463656a6f CR3: 000000007a4ca000 CR4: 00000000000006e0
[ 2015.908765] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2015.908769] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2015.908772] Process powernowd (pid: 3117, threadinfo ffff88007b4fe000, task ffff88007d864020)
[ 2015.908776] Stack:
[ 2015.908778]  ffffffff8027465f ffff88007b4ffcf8 ffffffff810113a0 0000000000000000
[ 2015.908786]  00000000ffffffff ffffffff81011318 0000000000000000 ffff88007b4ffd58
[ 2015.908795]  ffffffff8027480e 0000000000000000 ffff88007b4ffdb8 0000000000000000
[ 2015.908805] Call Trace:
[ 2015.908808]  [<ffffffff8027465f>] ? notifier_call_chain+0x3f/0x80
[ 2015.908817]  [<ffffffff8027480e>] __srcu_notifier_call_chain+0x5e/0x90
[ 2015.908824]  [<ffffffff80274856>] srcu_notifier_call_chain+0x16/0x20
[ 2015.908830]  [<ffffffff804988a9>] cpufreq_notify_transition+0x89/0xd0
[ 2015.908837]  [<ffffffffa030da05>] powernowk8_target+0x285/0x7c0 [powernow_k8]
[ 2015.908845]  [<ffffffffa02da072>] ? cpufreq_set+0x32/0xc0 [cpufreq_userspace]
[ 2015.908852]  [<ffffffff8049862c>] __cpufreq_driver_target+0x3c/0x40
[ 2015.908858]  [<ffffffffa02da0ce>] cpufreq_set+0x8e/0xc0 [cpufreq_userspace]
[ 2015.908865]  [<ffffffff80498bbd>] store_scaling_setspeed+0x6d/0x80
[ 2015.908871]  [<ffffffff8049a66f>] store+0x6f/0xa0
[ 2015.908876]  [<ffffffff8037a54f>] sysfs_write_file+0xcf/0x140
[ 2015.908883]  [<ffffffff80318b4b>] vfs_write+0xcb/0x170
[ 2015.908889]  [<ffffffff80318ce5>] sys_write+0x55/0x90
[ 2015.908895]  [<ffffffff8020c1f2>] system_call_fastpath+0x16/0x1b
[ 2015.908902] Code:  Bad RIP value.
[ 2015.908907] RIP  [<0000737463656a6f>] 0x737463656a6f
[ 2015.908913]  RSP <ffff88007b4ffcd0>
[ 2015.908915] CR2: 0000737463656a6f
[ 2015.909459] ---[ end trace cefb79d041e94864 ]---
