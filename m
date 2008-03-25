Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbYCYQyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbYCYQyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYCYQyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:54:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:48750 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbYCYQyf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:54:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,553,1199692800"; 
   d="scan'208";a="539732960"
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 0/5] Generic smp_call_function(), improvements, and smp_call_function_single()
Date: Tue, 25 Mar 2008 09:48:10 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECE5BEDC@orsmsx424.amr.corp.intel.com>
In-reply-to: <20080325081219.GO15355@kernel.dk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/5] Generic smp_call_function(), improvements, and smp_call_function_single()
Thread-Index: AciOULY4oQadQIDxQXuJeqMBJai9aAAQrO8g
References: <1205927772-31401-1-git-send-email-jens.axboe@oracle.com> <1FE6DD409037234FAB833C420AA843ECE137D9@orsmsx424.amr.corp.intel.com> <20080321183149.GB15355@kernel.dk> <1FE6DD409037234FAB833C420AA843ECE1387F@orsmsx424.amr.corp.intel.com> <20080322122903.GD15355@kernel.dk> <1FE6DD409037234FAB833C420AA843ECE5B76D@orsmsx424.amr.corp.intel.com> <20080325081219.GO15355@kernel.dk>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Cc: <linux-kernel@vger.kernel.org>, <npiggin@suse.de>, <paulus@samba.org>,
       <tglx@linutronix.de>, <mingo@redhat.com>
X-OriginalArrivalTime: 25 Mar 2008 16:48:13.0670 (UTC) FILETIME=[04334060:01C88E98]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So now I/we just need to figure out why the hack to call
> init_call_single_data() is needed. You seem to imply it was being called
> too late, I thought perhaps too early. Where did you stick the
> init_call_single_data() call in?

In ia64 the first calls to smp_call_function_single() are made
while bringing up other cpus ... which happens from:

	kernel_init()
		smp_init()

The init calls are made a few lines later (still in kernel_init):

		do_basic_setup()
			do_initcalls()

I moved the call radically earlier (before sched_init() in
init/main.c:start_kernel()) just to be sure, but that was
overkill.

Perhaps making the call from do_pre_smp_initcalls() is the
logical place?  Like this (though purists will say that the
extern declaration should be in some header file):

Signed-off-by: Tony Luck <tony.luck@intel.com>

diff --git a/init/main.c b/init/main.c
index 99ce949..0c140ed 100644
--- a/init/main.c
+++ b/init/main.c
@@ -750,7 +750,9 @@ __setup("nosoftlockup", nosoftlockup_setup);
 static void __init do_pre_smp_initcalls(void)
 {
 	extern int spawn_ksoftirqd(void);
+	extern int __cpuinit init_call_single_data(void);
 
+	init_call_single_data();
 	migration_init();
 	spawn_ksoftirqd();
 	if (!nosoftlockup)
diff --git a/kernel/smp.c b/kernel/smp.c
index ab2da5c..df1b651 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -40,7 +40,7 @@ struct call_single_queue {
 static struct call_function_data call_data_fallback;
 static unsigned long call_fallback_used;
 
-static int __cpuinit init_call_single_data(void)
+int __cpuinit init_call_single_data(void)
 {
 	int i;
 
@@ -53,7 +53,6 @@ static int __cpuinit init_call_single_data(void)
 	}
 	return 0;
 }
-core_initcall(init_call_single_data);
 
 /*
  * Insert a previously allocated call_single_data element for execution
