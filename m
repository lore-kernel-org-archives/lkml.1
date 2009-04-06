Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbZDFN6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbZDFN6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 09:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbZDFN6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 09:58:39 -0400
Received: from dgate10.ts.fujitsu.com ([80.70.172.49]:15037 "EHLO
	dgate10.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbZDFN6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 09:58:37 -0400
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Apr 2009 09:58:36 EDT
DomainKey-Signature: s=s1536a; d=ts.fujitsu.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:X-Enigmail-Version:Content-Type;
  b=WVs2nfp1GndxINAaRbw8JBLwGv/SnbqJdd4Q4y/t68olJFEl/etsQRJc
   xrUSmFG4o1rFWlE8DnR5Lq8sWTcjyAJSPeON4K0bFzXpkxadyRKnuUwKe
   JHUTMcVeiF+kraUpjSmu2Xngz/c4sUFte/OgwIuLnXF4sOQBIcJRJeoJy
   tGa9JGklX48uips1K+g1TfBRJOgaAisrtPGZP3nwoQP3tBFIPA/o1e8kN
   M1O2T3FByvKNsNqXhAsSpE40okSbJ;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.39,330,1235948400"; 
   d="diff'?scan'208";a="66614767"
X-IronPort-AV: E=Sophos;i="4.39,330,1235948400"; 
   d="diff'?scan'208";a="45958854"
Message-ID: <49DA0829.20504@ts.fujitsu.com>
Date: Mon, 06 Apr 2009 15:48:25 +0200
From: Martin Wilck <martin.wilck@ts.fujitsu.com>
Organization: Fujitsu Technology Solutions
User-Agent: Thunderbird 2.0.0.15pre (X11/20080508)
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: Wilck Martin <Martin.Wilck@ts.fujitsu.com>, Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH] limit CPU time spent in kipmid (PREVIOUS WAS BROKEN)
References: <49C27281.4040207@fujitsu-siemens.com> <49C2B994.7040808@acm.org> <20090319235114.GA18182@kroah.com> <49C3B6A5.5030408@acm.org> <20090320174701.GA14823@kroah.com> <49C3E03E.10506@acm.org> <49C78BE0.9090107@fujitsu-siemens.com> <49C7F368.5040304@acm.org>
In-Reply-To: <49C7F368.5040304@acm.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------020502000704070403030107"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020502000704070403030107
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello Corey,

> I've done some experimenting with your patch and some more thinking.  
> (BTW, setting the permissions of kipmid_max_busy to 0644 as Greg 
> suggested makes changing the value for testing a lot easier :).

I apologize for the long delay - busy with other stuff.

Here is the patch with modifiable, per-interface module parameter. 
Feedback is welcome.

Best regards,
Martin (*note changed email address!*)

-- 
Dr. Martin Wilck
PRIMERGY System Software Engineer
x86 Server Engineering

Fujitsu Technology Solutions GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn, Germany

Phone:			++49 5251 525 2796
Fax:			++49 5251 525 2820
Email:			martin.wilck@ts.fujitsu.com
Internet:		http://ts.fujitsu.com
Company Details:	http://de.ts.fujitsu.com/imprint.html

--------------020502000704070403030107
Content-Type: text/x-patch;
 name="kipmid_max_busy_arr_2.6.29.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kipmid_max_busy_arr_2.6.29.diff"

Patch: Make busy-loops in kipmid configurable (take 3)

This patch adds a module parameter "kipmid_max_busy" that specifies how many
microseconds kipmid should busy-loop before going to sleep. The
new parameter defaults to 0 (previous behavior - busy-loop forever).

The main rationale of this patch is to be able to avoid irritating users
who see lots of CPU time spent int kipmid0. With a bit of tuning of the
kipmid_max_busy parameter it is possible to decrease the CPU usage of kipmid
to negligible values without losing much performance.

In this version of the patch, the parameter can be specified per-interface,
like other ipmi_si parameters, and can be modified at runtime via sysfs.

Signed-off-by: martin.wilck@ts.fujitsu.com

--- a/drivers/char/ipmi/ipmi_si_intf.c	2009-03-24 00:12:14.000000000 +0100
+++ b/drivers/char/ipmi/ipmi_si_intf.c	2009-04-06 17:16:41.000000000 +0200
@@ -297,6 +297,9 @@ struct smi_info {
 static int force_kipmid[SI_MAX_PARMS];
 static int num_force_kipmid;
 
+static unsigned int kipmid_max_busy[SI_MAX_PARMS];
+static int num_max_busy;
+
 static int unload_when_empty = 1;
 
 static int try_smi_init(struct smi_info *smi);
@@ -927,23 +930,57 @@ static void set_run_to_completion(void *
 	}
 }
 
+static int ipmi_thread_must_sleep(enum si_sm_result smi_result, int intf_num,
+				  int *busy, struct timespec *busy_time)
+{
+	unsigned int max_busy = 0;
+	if (smi_result != SI_SM_CALL_WITH_DELAY) {
+		if (*busy)
+			*busy = 0;
+		return 0;
+	}
+	if (intf_num < num_max_busy)
+		max_busy = kipmid_max_busy[intf_num];
+	if (*busy == 0) {
+		*busy = 1;
+		getnstimeofday(busy_time);
+		timespec_add_ns(busy_time, max_busy*NSEC_PER_USEC);
+	} else if (max_busy == 0)
+		return 0;
+	else {
+		struct timespec now;
+		getnstimeofday(&now);
+		if (unlikely(timespec_compare(&now, busy_time) > 0)) {
+			*busy = 0;
+			return 1;
+		}
+	}
+	return 0;
+}
+
 static int ipmi_thread(void *data)
 {
 	struct smi_info *smi_info = data;
 	unsigned long flags;
 	enum si_sm_result smi_result;
+	struct timespec busy_time;
+	int busy = 0;
 
 	set_user_nice(current, 19);
 	while (!kthread_should_stop()) {
+		int must_sleep;
 		spin_lock_irqsave(&(smi_info->si_lock), flags);
 		smi_result = smi_event_handler(smi_info, 0);
 		spin_unlock_irqrestore(&(smi_info->si_lock), flags);
+		must_sleep = ipmi_thread_must_sleep(smi_result,
+						    smi_info->intf_num,
+						    &busy, &busy_time);
 		if (smi_result == SI_SM_CALL_WITHOUT_DELAY)
 			; /* do nothing */
-		else if (smi_result == SI_SM_CALL_WITH_DELAY)
+		else if (smi_result == SI_SM_CALL_WITH_DELAY && !must_sleep)
 			schedule();
 		else
-			schedule_timeout_interruptible(1);
+			schedule_timeout_interruptible(0);
 	}
 	return 0;
 }
@@ -1213,6 +1250,11 @@ module_param(unload_when_empty, int, 0);
 MODULE_PARM_DESC(unload_when_empty, "Unload the module if no interfaces are"
 		 " specified or found, default is 1.  Setting to 0"
 		 " is useful for hot add of devices using hotmod.");
+module_param_array(kipmid_max_busy, uint, &num_max_busy, 0644);
+MODULE_PARM_DESC(kipmid_max_busy,
+		 "Max time (in microseconds) to busy-wait for IPMI data before"
+		 " sleeping. 0 (default) means to wait forever. Set to 100-500"
+		 " if kipmid is using up a lot of CPU time.");
 
 
 static void std_irq_cleanup(struct smi_info *info)

--------------020502000704070403030107--
