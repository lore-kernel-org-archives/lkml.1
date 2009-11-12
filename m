Return-Path: <linux-kernel-owner+w=401wt.eu-S1759853AbZKLAu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759853AbZKLAu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 19:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759628AbZKLAuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 19:50:25 -0500
Received: from mga03.intel.com ([143.182.124.21]:19515 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757511AbZKLAuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 19:50:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,726,1249282800"; 
   d="scan'208";a="210500359"
Date: Wed, 11 Nov 2009 16:50:29 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Dave Jones <davej@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       Alexander Miller <Miller@fmi.uni-stuttgart.de>
Subject: [PATCH] Resolve time unit thinko in ondemand/conservative govs
Message-ID: <20091112005029.GA14257@linux-os.sc.intel.com>
References: <200911061727.17541.Miller@fmi.uni-stuttgart.de> <B5B0CFF685D7DF46A05CF1678CFB42ED20E0C63D@orsmsx505.amr.corp.intel.com> <20091110222038.GA32028@linux-os.sc.intel.com> <200911112310.45175.Miller@fmi.uni-stuttgart.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911112310.45175.Miller@fmi.uni-stuttgart.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dave,

Here is the fix for the bug reported on this thread. Please Apply. Looks to
be a stable candidate as well.

Thanks,
Venki

ondemand and conservative governors are messing up time units in the
code path where NO_HZ is not enabled and ignore_nice is set. The walltime
idletime stored is in jiffies and nice time calculation is happening in
microseconds.

The problem was reported and diagnosed by Alexander here.
http://marc.info/?l=linux-kernel&m=125752550404513&w=2

The patch below fixes this thinko.

Reported-by: Alexander Miller <Miller@fmi.uni-stuttgart.de>
Tested-by: Alexander Miller <Miller@fmi.uni-stuttgart.de>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 drivers/cpufreq/cpufreq_conservative.c |    4 ++--
 drivers/cpufreq/cpufreq_ondemand.c     |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index bc33ddc..c7b081b 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -116,9 +116,9 @@ static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
 
 	idle_time = cputime64_sub(cur_wall_time, busy_time);
 	if (wall)
-		*wall = cur_wall_time;
+		*wall = (cputime64_t)jiffies_to_usecs(cur_wall_time);
 
-	return idle_time;
+	return (cputime64_t)jiffies_to_usecs(idle_time);;
 }
 
 static inline cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall)
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 071699d..4b34ade 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -133,9 +133,9 @@ static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
 
 	idle_time = cputime64_sub(cur_wall_time, busy_time);
 	if (wall)
-		*wall = cur_wall_time;
+		*wall = (cputime64_t)jiffies_to_usecs(cur_wall_time);
 
-	return idle_time;
+	return (cputime64_t)jiffies_to_usecs(idle_time);
 }
 
 static inline cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall)
-- 
1.6.0.6

