Return-Path: <linux-kernel-owner+w=401wt.eu-S1765120AbXGYVyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765120AbXGYVyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 17:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346AbXGYVx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 17:53:57 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:56275 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754277AbXGYVx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 17:53:56 -0400
Message-ID: <46A7C66E.305@lwfinger.net>
Date: Wed, 25 Jul 2007 16:53:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, luming.yu@intel.com,
       len.brown@intel.com, linux-acpi@vger.kernel.org
Subject: Regression in 2.6.22-rc3 and newer - Kernel oops in acpi_processor_throttling-seq-show
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On an x86_64 system with an AMD Turion 64 X2 processor, I get the following kernel oops with any
system later than 2.6.22-rc2:

Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
   [<ffffffff8805ec88>] :processor:acpi_processor_throttling_seq_show+0x106/0x134
PGD 5ab65067 PUD 557d7067 PMD 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device vboxdrv cpufreq_conservative
cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table button battery ac loop
dm_mod nfsd exportfs lockd nfs_acl auth_rpcgss sunrpc snd_hda_intel snd_pcm sdhci ide_cd mmc_core
ohci1394 snd_timer ieee1394 snd cdrom ohci_hcd ehci_hcd soundcore snd_page_alloc forcedeth
i2c_nforce2 usbcore bcm43xx firmware_class ieee80211softmac ieee80211 ieee80211_crypt ext3 mbcache
jbd edd sg fan sata_nv libata amd74xx thermal processor sd_mod scsi_mod ide_disk ide_core
Pid: 3493, comm: powersaved Not tainted 2.6.23-rc1-Linus-g72f0027e-dirty #86
RIP: 0010:[<ffffffff8805ec88>]  [<ffffffff8805ec88>]
:processor:acpi_processor_throttling_seq_show+0x106/0x134
RSP: 0018:ffff810054687e28  EFLAGS: 00010246
RAX: 0000000000000020 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 000000000000002a RSI: ffffffff88061ab0 RDI: ffff81005a1f2948
RBP: ffff810054687e48 R08: 0000000000000002 R09: ffffffff80234979
R10: ffffffffffffffff R11: ffff8100539f0000 R12: ffff810037dc4848
R13: ffff81005a1f2948 R14: 0000000000000000 R15: 0000000000000000
FS:  00002adfd9159e50(0000) GS:ffffffff80522000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000037dce000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process powersaved (pid: 3493, threadinfo ffff810054686000, task ffff8100554acf60)
Stack:  ffff81005a1f2948 0000000000000001 0000000000000001 0000000000000400
   ffff810054687eb8 ffffffff802aa52a ffff810054687e98 ffff810054687f48
   00002adfd712c000 ffff8100531b5000 ffff81005a1f2978 ffffffff802aa41d
Call Trace:
   [<ffffffff802aa52a>] seq_read+0x10d/0x29f
   [<ffffffff802aa41d>] seq_read+0x0/0x29f
   [<ffffffff802aa41d>] seq_read+0x0/0x29f
   [<ffffffff802c66e9>] proc_reg_read+0x8a/0xa7
   [<ffffffff80290f94>] vfs_read+0xab/0x134
   [<ffffffff80291359>] sys_read+0x47/0x6f
   [<ffffffff8020c07e>] system_call+0x7e/0x83


Code: 45 8b 04 0e 89 d9 0f 45 d0 31 c0 48 ff c3 49 83 c6 28 e8 6b
RIP  [<ffffffff8805ec88>] :processor:acpi_processor_throttling_seq_show+0x106/0x134
   RSP <ffff810054687e28>
CR2: 0000000000000000

==============================================================

Using bisect, I localized the problem to the following commit:

commit 01854e697a77a434104b2f7e6d7fd463a978af32
Author: Luming Yu <luming.yu@gmail.com>
Date:   Sat May 26 22:49:58 2007 +0800

      ACPI: add ACPI 3.0 _TPC _TSS _PTC throttling support

      adds _TPC _TSS _PTC -- Throttling Present Capabilities

      Signed-off-by: Luming Yu <luming.yu@intel.com>
      Signed-off-by: Len Brown <len.brown@intel.com>


The problem is that "acpi_processor_get_throttling_info" is never called for my cpu, which means 
that "acpi_processor_get_throttling_states" is never called, and no space is allocated for
pr->throttling.states_tss.

I didn't track the reason for not calling these routines, but leave that for the ACPI wizards. The 
following hack works for my system:

====================================================

Avoid a NULL pointer kernel oops on x86_64 caused by throttling.states_fss not
being allocated.

Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
---

Index: linux-2.6/drivers/acpi/processor_throttling.c
===================================================================
--- linux-2.6.orig/drivers/acpi/processor_throttling.c
+++ linux-2.6/drivers/acpi/processor_throttling.c
@@ -658,6 +658,12 @@ static int acpi_processor_throttling_seq
  		   pr->throttling.state_count - 1);

  	seq_puts(seq, "states:\n");
+	if ((acpi_processor_get_throttling != acpi_processor_get_throttling_fadt)
+	    && !pr->throttling.states_tss) {
+		seq_puts(seq,
+			 "There was no initialization of states_tss.\n");
+		goto end;
+	}
  	if (acpi_processor_get_throttling == acpi_processor_get_throttling_fadt)
  		for (i = 0; i < pr->throttling.state_count; i++)
  			seq_printf(seq, "   %cT%d:                  %02d%%\n",

