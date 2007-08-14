Return-Path: <linux-kernel-owner+w=401wt.eu-S1755133AbXHNHwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbXHNHwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 03:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbXHNHqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 03:46:44 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55429 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbXHNHqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 03:46:24 -0400
Date: Tue, 14 Aug 2007 00:29:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 12/12] CPUFREQ: ondemand: add a check to avoid negative
	load calculation
Message-ID: <20070814072935.GJ15025@kroah.com>
References: <20070814072244.882283903@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cpufreq-ondemand-add-a-check-to-avoid-negative-load-calculation.patch"
In-Reply-To: <20070814072813.GA15025@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Due to rounding and inexact jiffy accounting, idle_ticks can sometimes
be higher than total_ticks. Make sure those cases are handled as
zero load case.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/cpufreq/cpufreq_ondemand.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -335,7 +335,7 @@ static struct attribute_group dbs_attr_g
 static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 {
 	unsigned int idle_ticks, total_ticks;
-	unsigned int load;
+	unsigned int load = 0;
 	cputime64_t cur_jiffies;
 
 	struct cpufreq_policy *policy;
@@ -381,7 +381,8 @@ static void dbs_check_cpu(struct cpu_dbs
 		if (tmp_idle_ticks < idle_ticks)
 			idle_ticks = tmp_idle_ticks;
 	}
-	load = (100 * (total_ticks - idle_ticks)) / total_ticks;
+	if (likely(total_ticks > idle_ticks))
+		load = (100 * (total_ticks - idle_ticks)) / total_ticks;
 
 	/* Check for frequency increase */
 	if (load > dbs_tuners_ins.up_threshold) {

-- 
