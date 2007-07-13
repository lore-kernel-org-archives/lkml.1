Return-Path: <linux-kernel-owner+w=401wt.eu-S934433AbXGMAG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934433AbXGMAG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 20:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759146AbXGMAGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 20:06:21 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:49466 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071AbXGMAGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 20:06:20 -0400
Date: Thu, 12 Jul 2007 17:06:16 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>
Subject: [patch] x86_64: Avoid too many remote cpu references due to /proc/stat
Message-ID: <20070713000615.GA11942@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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

Index: linux-2.6.22/fs/proc/proc_misc.c
===================================================================
--- linux-2.6.22.orig/fs/proc/proc_misc.c	2007-07-12 16:31:02.000000000 -0700
+++ linux-2.6.22/fs/proc/proc_misc.c	2007-07-12 16:33:45.226221759 -0700
@@ -498,7 +498,8 @@ static int show_stat(struct seq_file *p,
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
-#if !defined(CONFIG_PPC64) && !defined(CONFIG_ALPHA) && !defined(CONFIG_IA64)
+#if !defined(CONFIG_PPC64) && !defined(CONFIG_ALPHA) && !defined(CONFIG_IA64) \
+					&& !defined(CONFIG_X86_64)
 	for (i = 0; i < NR_IRQS; i++)
 		seq_printf(p, " %u", kstat_irqs(i));
 #endif
