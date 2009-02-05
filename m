Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbZBEGBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbZBEGBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 01:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZBEGBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 01:01:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:51882 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752349AbZBEGBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 01:01:01 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+U7zFEwSyUJ/hrgLgtYwwJ/HvXQFsqVDehZVvjpe
	1hBYbzYS461IG4
Subject: [PATCH] perfcounters: fix "perf counters kills oprofile" bug
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-vVWKgO977F0ymlQYoYCD"
Date: Thu, 05 Feb 2009 07:00:50 +0100
Message-Id: <1233813650.9044.29.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vVWKgO977F0ymlQYoYCD
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Impact: fix "perf counters kills oprofile" bug

Both oprofile and perfcounters register an NMI die handler, but only one
can handle the NMI.  Conveniently, oprofile unregisters it's notifier
when not actively in use, so setting it's notifier priority higher than
perfcounter's allows oprofile to borrow the NMI for the duration of it's
run.  Tested/works both as module and built-in.

While testing, I found that if kerneltop was generating NMIs at very
high frequency, the kernel may panic when oprofile registered it's
handler.  This turned out to be because oprofile registers it's handler
before reset_value has been allocated, so if an NMI comes in while it's
still setting up, kabOom.  Rather than try more invasive changes, I
followed the lead of other places in op_model_ppro.c, and simply
returned in that highly unlikely event.  (debug warnings attached)

I can break this into two patches if you prefer, but since the panic was
initiated by borrowing the active NMI, I figured they belong together.

Signed-off-by: Mike Galbraith <efault@gmx.de>

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 46c436c..8bb2133 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -643,7 +643,9 @@ perf_counter_nmi_handler(struct notifier_block *self,
 }
 
 static __read_mostly struct notifier_block perf_counter_nmi_notifier = {
-	.notifier_call		= perf_counter_nmi_handler
+	.notifier_call		= perf_counter_nmi_handler,
+	.next			= NULL,
+	.priority		= 1
 };
 
 void __init init_hw_perf_counters(void)
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 202864a..c638685 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -40,8 +40,9 @@ static int profile_exceptions_notify(struct notifier_block *self,
 
 	switch (val) {
 	case DIE_NMI:
-		if (model->check_ctrs(args->regs, &per_cpu(cpu_msrs, cpu)))
-			ret = NOTIFY_STOP;
+	case DIE_NMI_IPI:
+		model->check_ctrs(args->regs, &per_cpu(cpu_msrs, cpu));
+		ret = NOTIFY_STOP;
 		break;
 	default:
 		break;
@@ -134,7 +135,7 @@ static void nmi_cpu_setup(void *dummy)
 static struct notifier_block profile_exceptions_nb = {
 	.notifier_call = profile_exceptions_notify,
 	.next = NULL,
-	.priority = 0
+	.priority = 2
 };
 
 static int nmi_setup(void)
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 07c9145..85eb626 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -126,6 +126,13 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 	u64 val;
 	int i;
 
+	/*
+	 * This can happen if perf counters are in use when
+	 * we steal the die notifier NMI.
+	 */
+	if (unlikely(!reset_value))
+		goto out;
+
 	for (i = 0 ; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
@@ -136,6 +143,7 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 		}
 	}
 
+out:
 	/* Only P6 based Pentium M need to re-unmask the apic vector but it
 	 * doesn't hurt other P6 variant */
 	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);


--=-vVWKgO977F0ymlQYoYCD
Content-Disposition: attachment; filename=warning
Content-Type: text/plain; name=warning; charset=UTF-8
Content-Transfer-Encoding: 7bit

[  251.783042] oprofile: using NMI interrupt.
[  252.107966] ------------[ cut here ]------------
[  252.107973] ------------[ cut here ]------------
[  252.107980] WARNING: at arch/x86/oprofile/op_model_ppro.c:132 ppro_check_ctrs+0x37/0xd9 [oprofile]()
[  252.107982] Hardware name: MS-7502
[  252.107984] Modules linked in: oprofile nfsd lockd snd_pcm_oss nfs_acl snd_mixer_oss auth_rpcgss snd_seq exportfs snd_seq_device sunrpc cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq ip_tables ip6_tables microcode nls_iso8859_1 nls_cp437 vfat fat fuse loop dm_mod hid_pl hid_cypress hid_zpff hid_gyration hid_sony hid_samsung hid_microsoft hid_tmff hid_monterey snd_hda_codec_realtek hid_ezkey hid_a4tech hid_logitech firewire_ohci snd_hda_intel ff_memless firewire_core hid_cherry snd_hda_codec crc_itu_t hid_sunplus hid_petalynx snd_hwdep usbhid hid_belkin snd_pcm hid_chicony snd_timer usb_storage ohci1394 i2c_i801 snd rtc_cmos hid soundcore libusual sr_mod rtc_core ieee1394 e1000e button intel_agp cdrom rtc_lib i2c_core snd_page_alloc sg ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod thermal processor [last unloaded: oprofile]
[  252.108029] Pid: 9407, comm: oprofiled Not tainted 2.6.29-tip-smp #121
[  252.108032] Call Trace:
[  252.108033]  <NMI>  [<ffffffff80237f1f>] warn_slowpath+0xd3/0x10f
[  252.108045]  [<ffffffff80273745>] ? rb_reserve_next_event+0x1a5/0x333
[  252.108049]  [<ffffffff80273a19>] ? ring_buffer_lock_reserve+0x83/0xca
[  252.108055]  [<ffffffff802182b1>] ? __smp_perf_counter_interrupt+0x348/0x3bc
[  252.108064]  [<ffffffffa03eab52>] ppro_check_ctrs+0x37/0xd9 [oprofile]
[  252.108073]  [<ffffffffa03e9f6d>] profile_exceptions_notify+0x39/0x40 [oprofile]
[  252.108077]  [<ffffffff8024e38b>] notifier_call_chain+0x33/0x5b
[  252.108080]  [<ffffffff8024e3d5>] atomic_notifier_call_chain+0x13/0x15
[  252.108083]  [<ffffffff8024e477>] notify_die+0x2e/0x30
[  252.108086]  [<ffffffff8020dd27>] do_nmi+0x86/0x21b
[  252.108094]  [<ffffffffa03ea401>] ? nmi_setup+0xfb/0x1b8 [oprofile]
[  252.108100]  [<ffffffff8047a99a>] nmi+0x1a/0x20
[  252.108108]  [<ffffffffa03ea401>] ? nmi_setup+0xfb/0x1b8 [oprofile]
[  252.108112]  [<ffffffff802587b2>] ? smp_call_function_many+0x1d2/0x1e3
[  252.108114]  <<EOE>>  [<ffffffffa03ea4be>] ? nmi_cpu_setup+0x0/0x7c [oprofile]
[  252.108126]  [<ffffffff8029634e>] ? map_vm_area+0x2d/0x40
[  252.108134]  [<ffffffffa03ea4be>] ? nmi_cpu_setup+0x0/0x7c [oprofile]
[  252.108137]  [<ffffffff802587e3>] smp_call_function+0x20/0x24
[  252.108141]  [<ffffffff8023cc71>] on_each_cpu+0x18/0x2c
[  252.108149]  [<ffffffffa03ea4a2>] nmi_setup+0x19c/0x1b8 [oprofile]
[  252.108157]  [<ffffffffa03e92a5>] ? event_buffer_open+0x0/0x6d [oprofile]
[  252.108165]  [<ffffffffa03e817d>] oprofile_setup+0x39/0xa4 [oprofile]
[  252.108173]  [<ffffffffa03e92f0>] event_buffer_open+0x4b/0x6d [oprofile]
[  252.108177]  [<ffffffff8029d43b>] __dentry_open+0x14c/0x265
[  252.108180]  [<ffffffff8029d621>] nameidata_to_filp+0x41/0x52
[  252.108184]  [<ffffffff802a9c48>] do_filp_open+0x448/0x897
[  252.108188]  [<ffffffff80294dda>] ? page_add_new_anon_rmap+0x5a/0x5f
[  252.108191]  [<ffffffff8028d7d4>] ? handle_mm_fault+0x290/0x676
[  252.108195]  [<ffffffff802b2014>] ? alloc_fd+0x6d/0x116
[  252.108198]  [<ffffffff8029d232>] do_sys_open+0x53/0xd3
[  252.108201]  [<ffffffff8029d2db>] sys_open+0x1b/0x1d
[  252.108204]  [<ffffffff8020be5b>] system_call_fastpath+0x16/0x1b
[  252.108207] ---[ end trace caef0a6178020015 ]---
[  252.111949] WARNING: at arch/x86/oprofile/op_model_ppro.c:132 ppro_check_ctrs+0x37/0xd9 [oprofile]()
[  252.111949] Hardware name: MS-7502
[  252.111949] Modules linked in: oprofile nfsd lockd snd_pcm_oss nfs_acl snd_mixer_oss auth_rpcgss snd_seq exportfs snd_seq_device sunrpc cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq ip_tables ip6_tables microcode nls_iso8859_1 nls_cp437 vfat fat fuse loop dm_mod hid_pl hid_cypress hid_zpff hid_gyration hid_sony hid_samsung hid_microsoft hid_tmff hid_monterey snd_hda_codec_realtek hid_ezkey hid_a4tech hid_logitech firewire_ohci snd_hda_intel ff_memless firewire_core hid_cherry snd_hda_codec crc_itu_t hid_sunplus hid_petalynx snd_hwdep usbhid hid_belkin snd_pcm hid_chicony snd_timer usb_storage ohci1394 i2c_i801 snd rtc_cmos hid soundcore libusual sr_mod rtc_core ieee1394 e1000e button intel_agp cdrom rtc_lib i2c_core snd_page_alloc sg ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod thermal processor [last unloaded: oprofile]
[  252.111949] Pid: 0, comm: swapper Tainted: G        W  2.6.29-tip-smp #121
[  252.111949] Call Trace:
[  252.111949]  <NMI>  [<ffffffff80237f1f>] warn_slowpath+0xd3/0x10f
[  252.111949]  [<ffffffff80273745>] ? rb_reserve_next_event+0x1a5/0x333
[  252.111949]  [<ffffffff80273a19>] ? ring_buffer_lock_reserve+0x83/0xca
[  252.111949]  [<ffffffff802182b1>] ? __smp_perf_counter_interrupt+0x348/0x3bc
[  252.111949]  [<ffffffffa03eab52>] ppro_check_ctrs+0x37/0xd9 [oprofile]
[  252.111949]  [<ffffffffa03e9f6d>] profile_exceptions_notify+0x39/0x40 [oprofile]
[  252.111949]  [<ffffffff8024e38b>] notifier_call_chain+0x33/0x5b
[  252.111949]  [<ffffffff8024e3d5>] atomic_notifier_call_chain+0x13/0x15
[  252.111949]  [<ffffffff8024e477>] notify_die+0x2e/0x30
[  252.111949]  [<ffffffff8020dd27>] do_nmi+0x86/0x21b
[  252.111949]  [<ffffffff8047a99a>] nmi+0x1a/0x20
[  252.111949]  [<ffffffff8021267b>] ? default_idle+0x2b/0x40
[  252.111949]  <<EOE>>  [<ffffffff8020b141>] cpu_idle+0x52/0x93
[  252.111949]  [<ffffffff804755cb>] start_secondary+0x191/0x196
[  252.111949] ---[ end trace caef0a6178020016 ]---

--=-vVWKgO977F0ymlQYoYCD--

