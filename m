Return-Path: <linux-kernel-owner+w=401wt.eu-S937546AbXGSKOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937546AbXGSKOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760997AbXGSJzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:35402 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758907AbXGSJzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:23 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: kiran@scalex86.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [33/58] x86_64: Avoid too many remote cpu references due to /proc/stat
Message-Id: <20070719095519.10E4C14E11@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Ravikiran G Thirumalai <kiran@scalex86.org>
Too many remote cpu references due to /proc/stat.

On x86_64, with newer kernel versions, kstat_irqs is a bit of a problem.
On every call to kstat_irqs, the process brings in per-cpu data from all
online cpus.  Doing this for NR_IRQS, which is now 256 + 32 * NR_CPUS
results in (256+32*63) * 63 remote cpu references on a 64 cpu config.
/proc/stat is parsed by common commands like top, who etc, causing
lots of cacheline transfers

This statistic seems useless. Other 'big iron' arches disable this.
Can we disable computing/reporting this statistic?  This piece of
statistic is not human readable on x86_64 anymore,

If not, can we optimize computing this statistic so as to avoid
too many remote references (patch to follow)

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/proc/proc_misc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/fs/proc/proc_misc.c
===================================================================
--- linux.orig/fs/proc/proc_misc.c
+++ linux/fs/proc/proc_misc.c
@@ -499,7 +499,8 @@ static int show_stat(struct seq_file *p,
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
-#if !defined(CONFIG_PPC64) && !defined(CONFIG_ALPHA) && !defined(CONFIG_IA64)
+#if !defined(CONFIG_PPC64) && !defined(CONFIG_ALPHA) && !defined(CONFIG_IA64) \
+					&& !defined(CONFIG_X86_64)
 	for (i = 0; i < NR_IRQS; i++)
 		seq_printf(p, " %u", kstat_irqs(i));
 #endif
