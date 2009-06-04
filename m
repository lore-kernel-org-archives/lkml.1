Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbZFDSuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbZFDSuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZFDSuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:50:00 -0400
Received: from dgate10.ts.fujitsu.com ([80.70.172.49]:6916 "EHLO
	dgate10.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbZFDSt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:49:59 -0400
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Jun 2009 14:49:57 EDT
DomainKey-Signature: s=s1536a; d=ts.fujitsu.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:X-Enigmail-Version:Content-Type;
  b=jZ3638ApHKQ2iwMT52OyLZZq0GdspSnXMtk+LX4OLy/3twVq3RCffN+D
   uVT+/X0Xavumo+Y/R29rqH6xUYnBB+pw3sZVdprMMCwFJwMF1Y94CpGPj
   U1useTB4Amrrl29YT8MDkwat8KUIPZCeJTHlh3gk2TX1rvJOuG10Dgjha
   ZqTaNLONQpY+RFG57KD6c+yxFDGuXFCpg+8D4HURuZO4LZAl9KbPS9sN2
   WY1N0Nrg/eilXh4RaZl4kSpqKEkND;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.41,306,1241388000"; 
   d="diff'?scan'208";a="80293634"
X-IronPort-AV: E=Sophos;i="4.41,306,1241388000"; 
   d="diff'?scan'208";a="51577985"
Message-ID: <4A2814FF.4020400@ts.fujitsu.com>
Date: Thu, 04 Jun 2009 20:39:59 +0200
From: Martin Wilck <martin.wilck@ts.fujitsu.com>
Organization: Fujitsu Technology Solutions
User-Agent: Thunderbird 2.0.0.15pre (X11/20080508)
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
       Bela Lubkin <blubkin@vmware.com>
Subject: [PATCH] limit CPU time spent in kipmid (version 4)
References: <49C27281.4040207@fujitsu-siemens.com> <49C2B994.7040808@acm.org> <20090319235114.GA18182@kroah.com> <49C3B6A5.5030408@acm.org> <20090320174701.GA14823@kroah.com> <49C3E03E.10506@acm.org> <49C78BE0.9090107@fujitsu-siemens.com> <49C7F368.5040304@acm.org> <49DA0829.20504@ts.fujitsu.com>
In-Reply-To: <49DA0829.20504@ts.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------090509060106030803030901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090509060106030803030901
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

I am sorry for the long silence. I am sending here a new version of my 
patch which takes into account Bela's suggestions (well, most of them).
I compiled and tested it with 2.6.29.4, the results are similar as 
before. By setting kipmid_max_busy_us to a value between 100 and 500, it 
is possible to bring down kipmid CPU load to practically 0 without 
loosing too much ipmi throughput performance.

Please give me some feedback whether this patch will get merged, and if 
not, what improvement is needed.

Regards
Martin

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

--------------090509060106030803030901
Content-Type: text/x-patch;
 name="kipmid_max_busy_arr2_2.6.29.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kipmid_max_busy_arr2_2.6.29.diff"

Signed-off-by: martin.wilck@ts.fujitsu.com
--- linux-2.6.29.4/drivers/char/ipmi/ipmi_si_intf.c	2009-05-19 01:52:34.000000000 +0200
+++ linux-2.6.29-rc8/drivers/char/ipmi/ipmi_si_intf.c	2009-06-04 15:30:34.855398091 +0200
@@ -297,6 +297,9 @@
 static int force_kipmid[SI_MAX_PARMS];
 static int num_force_kipmid;
 
+static unsigned int kipmid_max_busy_us[SI_MAX_PARMS];
+static int num_max_busy_us;
+
 static int unload_when_empty = 1;
 
 static int try_smi_init(struct smi_info *smi);
@@ -927,23 +930,56 @@
 	}
 }
 
+#define ipmi_si_set_not_busy(timespec) \
+	do { (timespec)->tv_nsec = -1; } while (0)
+#define ipmi_si_is_busy(timespec) ((timespec)->tv_nsec != -1)
+
+static int ipmi_thread_busy_wait(enum si_sm_result smi_result,
+				 const struct smi_info *smi_info,
+				 struct timespec *busy_until)
+{
+	unsigned int max_busy_us = 0;
+
+	if (smi_info->intf_num < num_max_busy_us)
+		max_busy_us = kipmid_max_busy_us[smi_info->intf_num];
+	if (max_busy_us == 0 || smi_result != SI_SM_CALL_WITH_DELAY)
+		ipmi_si_set_not_busy(busy_until);
+	else if (!ipmi_si_is_busy(busy_until)) {
+		getnstimeofday(busy_until);
+		timespec_add_ns(busy_until, max_busy_us*NSEC_PER_USEC);
+	} else {
+		struct timespec now;
+		getnstimeofday(&now);
+		if (unlikely(timespec_compare(&now, busy_until) > 0)) {
+			ipmi_si_set_not_busy(busy_until);
+			return 0;
+		}
+	}
+	return 1;
+}
+
 static int ipmi_thread(void *data)
 {
 	struct smi_info *smi_info = data;
 	unsigned long flags;
 	enum si_sm_result smi_result;
+	struct timespec busy_until;
 
+	ipmi_si_set_not_busy(&busy_until);
 	set_user_nice(current, 19);
 	while (!kthread_should_stop()) {
+		int busy_wait;
 		spin_lock_irqsave(&(smi_info->si_lock), flags);
 		smi_result = smi_event_handler(smi_info, 0);
 		spin_unlock_irqrestore(&(smi_info->si_lock), flags);
+		busy_wait = ipmi_thread_busy_wait(smi_result, smi_info,
+						  &busy_until);
 		if (smi_result == SI_SM_CALL_WITHOUT_DELAY)
 			; /* do nothing */
-		else if (smi_result == SI_SM_CALL_WITH_DELAY)
+		else if (smi_result == SI_SM_CALL_WITH_DELAY && busy_wait)
 			schedule();
 		else
-			schedule_timeout_interruptible(1);
+			schedule_timeout_interruptible(0);
 	}
 	return 0;
 }
@@ -1213,6 +1249,11 @@
 MODULE_PARM_DESC(unload_when_empty, "Unload the module if no interfaces are"
 		 " specified or found, default is 1.  Setting to 0"
 		 " is useful for hot add of devices using hotmod.");
+module_param_array(kipmid_max_busy_us, uint, &num_max_busy_us, 0644);
+MODULE_PARM_DESC(kipmid_max_busy_us,
+		 "Max time (in microseconds) to busy-wait for IPMI data before"
+		 " sleeping. 0 (default) means to wait forever. Set to 100-500"
+		 " if kipmid is using up a lot of CPU time.");
 
 
 static void std_irq_cleanup(struct smi_info *info)

--------------090509060106030803030901--
