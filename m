Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbZCWNRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbZCWNRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZCWNR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:17:26 -0400
Received: from dgate10.fujitsu-siemens.com ([80.70.172.49]:13152 "EHLO
	dgate10.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753889AbZCWNRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:17:24 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:X-Enigmail-Version:Content-Type;
  b=j4tJrkB54agvs5i+xm2kFI5bw8nlmZWPZWpcisEy/DjIlHqrihZlHeKC
   YcJL4RHdxQV7o0gCDincgvaESmoACoR7CEWkNXdwedtnEm7j7Qqj/w36l
   6L8ox5wmQ7aHh31;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.38,407,1233529200"; 
   d="diff'?scan'208";a="64640102"
X-IronPort-AV: E=Sophos;i="4.38,407,1233529200"; 
   d="diff'?scan'208";a="50011422"
Message-ID: <49C78BE0.9090107@fujitsu-siemens.com>
Date: Mon, 23 Mar 2009 14:17:20 +0100
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 2.0.0.15pre (X11/20080508)
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH] limit CPU time spent in kipmid (PREVIOUS WAS BROKEN)
References: <49C27281.4040207@fujitsu-siemens.com> <49C2B994.7040808@acm.org> <20090319235114.GA18182@kroah.com> <49C3B6A5.5030408@acm.org> <20090320174701.GA14823@kroah.com> <49C3E03E.10506@acm.org>
In-Reply-To: <49C3E03E.10506@acm.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------060903000805080006010203"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060903000805080006010203
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Corey, hi Greg, hi all,

first of all I need to apologize, because _the first patch I sent was 
broken_. The attached patch should work better.

I did some benchmarking with this patch. In short:

1. The kipmid_max_busy parameter is a tunable that behaves reasonably. 
2. Low values of this parameter use up almost as little CPU as the 
"force_kipmid=0" case, but perform better.
3. It is important to distinguish cases with and without CPU load.
4. To offer this tunable to make a balance between max. CPU load of 
kipmid and performance appears to be worthwhile for many users.

Now the details ... The following tables are in CSV format. The 
benchmark used was a script using ipmitool to read all SDRs and all SEL 
events from the BMC 10x in a loop. This takes 22s with the default 
driver (using nearly 100% CPU), and almost 30x longer without kipmid 
(force_kipmid=off). The "busy cycles" in the table were calculated from 
oprofile CPU_CLK_UNHALTED counts; the "kipmid CPU%" are output from "ps 
-eo pcpu". The tested kernel was an Enterprise Linux kernel with HZ=1000.

"Results without load"
         "elapsed(s)"    "elapsed (rel.)"        "kipmid CPU% (ps)" 
  "CPU busy cycles (%)"
"default       "        22      1       32      103.15
"force_kipmid=0"        621     28.23   0       12.7
"kipmid_max_busy=5000"  21      0.95    34      100.16
"kipmid_max_busy=2000"  22      1       34      94.04
"kipmid_max_busy=1000"  27      1.23    25      26.89
"kipmid_max_busy=500"   24      1.09    0       69.44
"kipmid_max_busy=200"   42      1.91    0       46.72
"kipmid_max_busy=100"   68      3.09    0       17.87
"kipmid_max_busy=50"    101     4.59    0       22.91
"kipmid_max_busy=20"    163     7.41    0       19.98
"kipmid_max_busy=10"    213     9.68    0       13.19

As expected, kipmid_max_busy > 1000 has almost no effect (with HZ=1000). 
kipmid_max_busy=500 saves 30% busy time losing only 10% performance. 
With kipmid_max_busy=10, the performance result is 3x better than just 
switching kipmid totally off, with almost the same amount of CPU busy 
cycles. Note that the %CPU displayed by "ps", "top" etc drops to 0 for 
kipmid_max_busy < HZ. This effect is an artefact caused by the CPU time 
being measured only at timer interrupts. But it will also make user 
complains about kipmid drop to 0 - think about it ;-)

I took another run with a system under 100% CPU load by other processes. 
Now there is hardly any performance difference any more. As expected,
the kipmid runs are all only slightly faster than the interrupt-driven 
run which isn't affected by the CPU load. In this case, recording the 
CPU load from kipmid makes no sense (it is ~0 anyway).

         "elapsed(s)"    "elapsed (rel.)"        "kipmid CPU% (ps)"
"Results with 100% CPU load"
"default       "        500     22.73
"force_kipmid=0"        620     28.18
"kipmid_max_busy=1000"  460     20.91
"kipmid_max_busy=500"   500     22.73
"kipmid_max_busy=200"   530     24.09
"kipmid_max_busy=100"   570     25.91


As I said initially, these are results taken on a single system. On this 
system the KCS response times (from start to end of the 
SI_SM_CALL_WITH_DELAY loop) are between 200 and 2000 us:

us	%wait finished until
200	0%
400	21%
600	39%
800	44%
1000	55%
1200	89%
1400	94%
1600	97%

This may well be different on other systems, depending on the BMC, 
number of sensors, etc. Therefore I think this should remain a tunable, 
because finding an optimal value for arbitrary systems will be hard. Of 
course, the impi driver could implement some sort of self-tuning logic, 
but that would be overengineered to my taste. kipmid_max_busy would give 
HW vendors a chance to determine an optimal value for a given system and 
give a respective recommendation to users.

Best regards
Martin

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DEV 6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 525 2796
Fax:			++49 5251 525 2820
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html

--------------060903000805080006010203
Content-Type: text/x-patch;
 name="ipmi_si_max_busy-fixed-2.6.29-rc8.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipmi_si_max_busy-fixed-2.6.29-rc8.diff"

Patch: Make busy-loops in kipmid configurable (take 2)

While the current kipmid implementation is optimal in the sense that kipmid obtains
data as quickly as possible without stealing CPU time from other processes
(by running on low prio and calling schedule() in each loop iteration), it
may spend a lot of CPU time polling for data e.g. on the KCS interface. The
busy loop also prevents CPUs from entering sleep states when no KCS data is
available.

This patch adds a module parameter "kipmid_max_busy" that specifies how many
microseconds kipmid should busy-loop before going to sleep. It affects only the
SI_SM_CALL_WITH_DELAY case, where a delay is acceptible. My experiments have shown
that SI_SM_CALL_WITH_DELAY catches about 99% of smi_event_handler calls. The
new parameter defaults to 0 (previous behavior - busy-loop forever).

Signed-off-by: Martin Wilck <martin.wilck@fujitsu-siemens.com>
--- linux-2.6.29-rc8/drivers/char/ipmi/ipmi_si_intf.c.orig	2009-03-13 03:39:28.000000000 +0100
+++ linux-2.6.29-rc8/drivers/char/ipmi/ipmi_si_intf.c	2009-03-23 12:48:17.595361036 +0100
@@ -298,6 +298,7 @@ static int force_kipmid[SI_MAX_PARMS];
 static int num_force_kipmid;
 
 static int unload_when_empty = 1;
+static unsigned int kipmid_max_busy;
 
 static int try_smi_init(struct smi_info *smi);
 static void cleanup_one_si(struct smi_info *to_clean);
@@ -927,20 +928,52 @@ static void set_run_to_completion(void *
 	}
 }
 
+static int ipmi_thread_must_sleep(enum si_sm_result smi_result, int *busy,
+				  struct timespec *busy_time)
+{
+	if (kipmid_max_busy == 0)
+		return 0;
+
+	if (smi_result != SI_SM_CALL_WITH_DELAY) {
+		if (*busy != 0)
+			*busy = 0;
+		return 0;
+	}
+
+	if (*busy == 0) {
+		*busy = 1;
+		getnstimeofday(busy_time);
+		timespec_add_ns(busy_time, kipmid_max_busy*NSEC_PER_USEC);
+	} else {
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
+						    &busy, &busy_time);
 		if (smi_result == SI_SM_CALL_WITHOUT_DELAY)
 			; /* do nothing */
-		else if (smi_result == SI_SM_CALL_WITH_DELAY)
+		else if (smi_result == SI_SM_CALL_WITH_DELAY && !must_sleep)
 			schedule();
 		else
 			schedule_timeout_interruptible(1);
@@ -1213,6 +1246,11 @@ module_param(unload_when_empty, int, 0);
 MODULE_PARM_DESC(unload_when_empty, "Unload the module if no interfaces are"
 		 " specified or found, default is 1.  Setting to 0"
 		 " is useful for hot add of devices using hotmod.");
+module_param(kipmid_max_busy, uint, 0);
+MODULE_PARM_DESC(kipmid_max_busy,
+		 "Max time (in microseconds) to busy-wait for IPMI data before"
+		 " sleeping. 0 (default) means to wait forever. Set to 100-500"
+		 " if kipmid is using up a lot of CPU time.");
 
 
 static void std_irq_cleanup(struct smi_info *info)

--------------060903000805080006010203--
