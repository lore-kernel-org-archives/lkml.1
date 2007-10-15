Return-Path: <linux-kernel-owner+w=401wt.eu-S1764912AbXJOQ4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764912AbXJOQ4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760252AbXJOQ4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:56:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38795 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531AbXJOQ4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:56:03 -0400
Date: Mon, 15 Oct 2007 18:55:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch] scsi: fix crash in gdth_timeout()
Message-ID: <20071015165534.GA17833@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


the patch below fixes a bootup-crash bug merged via today's SCSI git 
merge:

 commit df3d80f5a5c74168be42788364d13cf6c83c7b9c
 Merge: 3d06f7a... c8e91b0...
 Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
 Date:   Mon Oct 15 08:19:33 2007 -0700

     Merge master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6

--------------------->
Subject: scsi: fix crash in gdth_timeout()
From: Ingo Molnar <mingo@elte.hu>

fix the following bootup crash in gdth_timeout():

[   40.739625] BUG: spinlock bad magic on CPU#1, swapper/1
[   40.744822]  lock: 788a6e40, .magic: 784d8cec, .owner: <none>/-1, .owner_cpu: 2018346022
[   40.752881]  [<78104f2c>] show_trace_log_lvl+0x1a/0x2f
[   40.757994]  [<781058d1>] show_trace+0x12/0x14
[   40.762414]  [<781058e9>] dump_stack+0x16/0x18
[   40.766833]  [<782f1683>] spin_bug+0xa1/0xa9
[   40.771079]  [<782f17b0>] _raw_spin_lock+0x1e/0xe4
[   40.775846]  [<78643f9f>] _spin_lock_irqsave+0x53/0x64
[   40.781461]  [<784b224a>] gdth_timeout+0x1c/0xa6
[   40.786054]  [<7812632f>] run_timer_softirq+0x142/0x1a4
[   40.791254]  [<78123fb8>] __do_softirq+0x7b/0xf1
[   40.795847]  [<78105fb8>] do_softirq+0x61/0xc7
[   40.800267]  =======================

the bug is that list_first_entry() assumes a non-empty list.

A further problem is probably that the GDTH timer is not stopped by a
failed GDTH probe?

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/scsi/gdth.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/drivers/scsi/gdth.c
===================================================================
--- linux.orig/drivers/scsi/gdth.c
+++ linux/drivers/scsi/gdth.c
@@ -3793,6 +3793,9 @@ static void gdth_timeout(ulong data)
     gdth_ha_str *ha;
     ulong flags;
 
+    if (list_empty(&gdth_instances))
+	    return;
+
     ha = list_first_entry(&gdth_instances, gdth_ha_str, list);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
