Return-Path: <linux-kernel-owner+w=401wt.eu-S1767098AbXEBSNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767098AbXEBSNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767100AbXEBSNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:13:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:16799 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767098AbXEBSNb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:13:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,481,1170662400"; 
   d="scan'208";a="238145527"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: vmstat: use our own timer events
Date: Wed, 2 May 2007 11:13:20 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F55455F0@scsmsx415.amr.corp.intel.com>
In-Reply-To: <Pine.LNX.4.64.0704282206530.29468@schroedinger.engr.sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: vmstat: use our own timer events
thread-index: AceKIFYJlhriXpEkQ6+RPoj577g7PACxDfJA
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Christoph Lameter" <clameter@sgi.com>, <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, "Arjan van de Ven" <arjan@linux.intel.com>
X-OriginalArrivalTime: 02 May 2007 18:13:21.0595 (UTC) FILETIME=[9144C0B0:01C78CE5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of 
>Christoph Lameter
>Sent: Saturday, April 28, 2007 10:09 PM
>To: akpm@linux-foundation.org
>Cc: linux-kernel@vger.kernel.org; Arjan van de Ven
>Subject: vmstat: use our own timer events
>
>
>We could implement an alternate approach that runs the first processor
>on each node at the second and then each of the other processor on a
>node on a subsequent tick. That may be useful to keep a large amount
>of the second free of timer activity. Maybe the timer folks will have
>some feedback on this one?
>

Can this use 'deferrable timer' along with round_jiffies. That
will eliminate the issue of too frequent interrupt when CPU is idle.


>CC: Arjan van de Ven <arjan@linux.intel.com>
>Signed-off-by: Christoph Lameter <clameter@sgi.com>
>
>Index: slub/mm/vmstat.c
>===================================================================
>--- slub.orig/mm/vmstat.c	2007-04-28 19:30:01.000000000 -0700
>+++ slub/mm/vmstat.c	2007-04-28 19:36:38.000000000 -0700
>@@ -640,6 +640,22 @@ const struct seq_operations vmstat_op = 
> #endif /* CONFIG_PROC_FS */
> 
> #ifdef CONFIG_SMP
>+static DEFINE_PER_CPU(struct delayed_work, vmstat_work);
>+
>+static void vmstat_update(struct work_struct *w)
>+{
>+	refresh_cpu_vm_stats(smp_processor_id());
>+	schedule_delayed_work(&__get_cpu_var(vmstat_work), HZ);
>+}
>+
>+static void __devinit start_cpu_timer(int cpu)
>+{
>+	struct delayed_work *vmstat_work = &per_cpu(vmstat_work, cpu);
>+
>+	INIT_DELAYED_WORK(vmstat_work, vmstat_update);

This change alone should help.
	INIT_DELAYED_WORK_DEFERRABLE(vmstat_work, vmstat_update);


>+	schedule_delayed_work_on(cpu, vmstat_work, HZ + cpu);
>+}
>+


Thanks,
Venki

Thanks,
Venki
