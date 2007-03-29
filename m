Return-Path: <linux-kernel-owner+w=401wt.eu-S965801AbXC2BAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965801AbXC2BAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 21:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934290AbXC2BAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 21:00:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:1943 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934291AbXC2BAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 21:00:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,342,1170662400"; 
   d="scan'208"; a="218249012:sNHT154819931"
Date: Wed, 28 Mar 2007 17:59:53 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel <linux-kernel@vger.kernel.org>, davej@codemonkey.org.uk,
       johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Add support for deferrable timers (respun-Mar28)
Message-ID: <20070329005953.GA8764@linux-os.sc.intel.com>
References: <200703212353.l2LNrNOj007453@shell0.pdx.osdl.net> <20070322140532.GA120@tv-sign.ru> <20070322151817.GA29840@linux-os.sc.intel.com> <20070322161355.GA160@tv-sign.ru> <20070327204344.GA21529@linux-os.sc.intel.com> <20070327211145.GB216@tv-sign.ru> <20070327215542.GA27408@linux-os.sc.intel.com> <20070327222227.GA279@tv-sign.ru> <20070328230021.GA29774@linux-os.sc.intel.com> <20070328170159.7fc8c289.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328170159.7fc8c289.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 05:01:59PM -0700, Andrew Morton wrote:
> On Wed, 28 Mar 2007 16:00:21 -0700
> Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
> 
> > Please drop the patch you included yesterday and two incremental patches and
> > use the patch below.
> 
> As you saw, I went and turned it into an incremental patch again.  It makes
> it easier to see what changed, but harder to see the whole thing.
> 
> > Introduce a new flag for timers - deferrable:
> 
> OK, but there's nothing in-kernel whcih actually uses this.
> 
> It would be good to identify some timer users which can be switched over (as
> many as possible, really) so this thing actually gets some runtime testing.

ondemand is the biggest offender and the patch below reduces the number of
interrupts by 50% or more (depending on HZ) on different test systems here.

Yes. There are quite a few other timers inside kernel that can be
migrated. I will use timer_stats and track others and send in the patches
soon.

Thanks,
Venki


------

Add a new deferrable delayed work init. This can be used to schedule work
that are 'unimportant' when CPU is idle and can be called later, when CPU
eventually comes out of idle.

Use this init in cpufreq ondemand governor.
 
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: new/drivers/cpufreq/cpufreq_ondemand.c
===================================================================
--- new.orig/drivers/cpufreq/cpufreq_ondemand.c	2007-03-28 10:03:21.000000000 -0800
+++ new/drivers/cpufreq/cpufreq_ondemand.c	2007-03-28 10:05:44.000000000 -0800
@@ -470,7 +470,7 @@
 	dbs_info->enable = 1;
 	ondemand_powersave_bias_init();
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
-	INIT_DELAYED_WORK(&dbs_info->work, do_dbs_timer);
+	INIT_DELAYED_WORK_DEFERRABLE(&dbs_info->work, do_dbs_timer);
 	queue_delayed_work_on(dbs_info->cpu, kondemand_wq, &dbs_info->work,
 	                      delay);
 }
Index: new/include/linux/workqueue.h
===================================================================
--- new.orig/include/linux/workqueue.h	2007-03-28 10:03:21.000000000 -0800
+++ new/include/linux/workqueue.h	2007-03-28 10:05:44.000000000 -0800
@@ -89,6 +89,12 @@
 		init_timer(&(_work)->timer);			\
 	} while (0)
 
+#define INIT_DELAYED_WORK_DEFERRABLE(_work, _func)			\
+	do {							\
+		INIT_WORK(&(_work)->work, (_func));		\
+		init_timer_deferrable(&(_work)->timer);		\
+	} while (0)
+
 /**
  * work_pending - Find out whether a work item is currently pending
  * @work: The work item in question
