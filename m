Return-Path: <linux-kernel-owner+w=401wt.eu-S1751357AbYITQCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbYITQCp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 12:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYITQCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 12:02:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:56716 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbYITQCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 12:02:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=B37o6poM+xriZQqRhRFlcF1Vm7dS4QSIVUTrGJXFhnwoPicZ5xtZ6v3sKvl4pASTxv
         3zjB7anmxna/beyDMeo7Z6BL4JJs6aPIJaxl6wWeFFeHQqcCVO45ONGkXKPChERQiyHB
         qFXjj0uECUdktu/0zI0gbkwuEMc1gEpewRMs0=
Message-ID: <48D51E93.90804@gmail.com>
Date: Sat, 20 Sep 2008 18:02:27 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: robert.richter@amd.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       oprofile-list@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] oprofile: BUG scheduling while atomic
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nmi_shutdown() calls unregister_die_notifier() from an atomic context
after setting preempt_disable() via get_cpu_var():

[ 1049.404154] BUG: scheduling while atomic: oprofiled/7796/0x00000002
[ 1049.404171] INFO: lockdep is turned off.
[ 1049.404176] Modules linked in: oprofile af_packet rfcomm l2cap kvm_intel kvm i915 drm acpi_cpufreq cpufreq_userspace cpufreq_conservative cpufreq_ondemand cpufreq_powersave freq_table container sbs sbshc dm_mod arc4 ecb cryptomgr aead snd_hda_intel crypto_blkcipher snd_pcm_oss crypto_algapi snd_pcm iwlagn iwlcore snd_timer iTCO_wdt led_class btusb iTCO_vendor_support snd psmouse bluetooth mac80211 soundcore cfg80211 snd_page_alloc intel_agp video output button battery ac dcdbas evdev ext3 jbd mbcache sg sd_mod piix ata_piix libata scsi_mod dock tg3 libphy ehci_hcd uhci_hcd usbcore thermal processor fan fuse
[ 1049.404362] Pid: 7796, comm: oprofiled Not tainted 2.6.27-rc5-mm1 #30
[ 1049.404368] Call Trace:
[ 1049.404384]  [<ffffffff804769fd>] thread_return+0x4a0/0x7d3
[ 1049.404396]  [<ffffffff8026ad92>] generic_exec_single+0x52/0xe0
[ 1049.404405]  [<ffffffff8026ae1a>] generic_exec_single+0xda/0xe0
[ 1049.404414]  [<ffffffff8026aee3>] smp_call_function_single+0x73/0x150
[ 1049.404423]  [<ffffffff804770c5>] schedule_timeout+0x95/0xd0
[ 1049.404430]  [<ffffffff80476083>] wait_for_common+0x43/0x180
[ 1049.404438]  [<ffffffff80476154>] wait_for_common+0x114/0x180
[ 1049.404448]  [<ffffffff80236980>] default_wake_function+0x0/0x10
[ 1049.404457]  [<ffffffff8024f810>] synchronize_rcu+0x30/0x40
[ 1049.404463]  [<ffffffff8024f890>] wakeme_after_rcu+0x0/0x10
[ 1049.404472]  [<ffffffff80479ca0>] _spin_unlock_irqrestore+0x40/0x80
[ 1049.404482]  [<ffffffff80256def>] atomic_notifier_chain_unregister+0x3f/0x60
[ 1049.404501]  [<ffffffffa03d8801>] nmi_shutdown+0x51/0x90 [oprofile]
[ 1049.404517]  [<ffffffffa03d6134>] oprofile_shutdown+0x34/0x70 [oprofile]
[ 1049.404532]  [<ffffffffa03d721e>] event_buffer_release+0xe/0x40 [oprofile]
[ 1049.404543]  [<ffffffff802bdcdd>] __fput+0xcd/0x240
[ 1049.404551]  [<ffffffff802baa74>] filp_close+0x54/0x90
[ 1049.404560]  [<ffffffff8023e1d1>] put_files_struct+0xb1/0xd0
[ 1049.404568]  [<ffffffff8023f82f>] do_exit+0x18f/0x930
[ 1049.404576]  [<ffffffff8020be03>] restore_args+0x0/0x30
[ 1049.404584]  [<ffffffff80240006>] do_group_exit+0x36/0xa0
[ 1049.404592]  [<ffffffff8020b7cb>] system_call_fastpath+0x16/0x1b

This can be easily triggered with 'opcontrol --shutdown'.

Simply move get_cpu_var() above unregister_die_notifier().

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 arch/x86/oprofile/nmi_int.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 2e63357..c21ce0c 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -377,10 +377,12 @@ static void nmi_cpu_shutdown(void *dummy)
 
 static void nmi_shutdown(void)
 {
-	struct op_msrs *msrs = &get_cpu_var(cpu_msrs);
+	struct op_msrs *msrs;
+
 	nmi_enabled = 0;
 	on_each_cpu(nmi_cpu_shutdown, NULL, 1);
 	unregister_die_notifier(&profile_exceptions_nb);
+	msrs = &get_cpu_var(cpu_msrs);
 	model->shutdown(msrs);
 	free_msrs();
 	put_cpu_var(cpu_msrs);
