Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbYA1SLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbYA1SLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYA1SL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:11:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52930 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbYA1SL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:11:28 -0500
Date: Mon, 28 Jan 2008 19:11:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, jeremy@goop.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: git-x86 oopses in acpi_ps_peek_opcode
Message-ID: <20080128181113.GA5375@elte.hu>
References: <20080128171907.GA24037@basil.nowhere.org> <20080128173449.GA22487@elte.hu> <20080128183204.GA25724@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128183204.GA25724@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > do you still see that crash?
> 
> New the second oops in 
> allocate_threshold_blocks->sysfs_add_file->kobject_uevent_env happens 
> (see other mail)

that's a Linus -git problem, the upstream kobject changes - try Greg's 
and Yinghai Lu's patch below, does it help?

	Ingo

Index: linux-x86.q/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ linux-x86.q/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -450,7 +450,8 @@ recurse:
 	if (err)
 		goto out_free;
 
-	kobject_uevent(&b->kobj, KOBJ_ADD);
+	if (b)
+		kobject_uevent(&b->kobj, KOBJ_ADD);
 
 	return err;
 
@@ -553,8 +554,9 @@ static __cpuinit int threshold_create_de
 	unsigned int bank;
 	int err = 0;
 
+	printk(KERN_DEBUG "threshold_create_device: cpu %d, bank_map=%02x\n", cpu, per_cpu(bank_map,cpu));
 	for (bank = 0; bank < NR_BANKS; ++bank) {
-		if (!(per_cpu(bank_map, cpu) & 1 << bank))
+		if (!(per_cpu(bank_map, cpu) & (1 << bank)))
 			continue;
 		err = threshold_create_bank(cpu, bank);
 		if (err)
@@ -637,7 +639,7 @@ static void threshold_remove_device(unsi
 	unsigned int bank;
 
 	for (bank = 0; bank < NR_BANKS; ++bank) {
-		if (!(per_cpu(bank_map, cpu) & 1 << bank))
+		if (!(per_cpu(bank_map, cpu) & (1 << bank)))
 			continue;
 		threshold_remove_bank(cpu, bank);
 	}
