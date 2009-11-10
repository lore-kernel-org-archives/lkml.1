Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbZKJWUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbZKJWUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZKJWUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:20:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:13294 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbZKJWUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:20:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,718,1249282800"; 
   d="scan'208";a="745706722"
Date: Tue, 10 Nov 2009 14:20:38 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Alexander Miller <Miller@fmi.uni-stuttgart.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] cpufreq: fix conservative/ondemand behaviour with ignore_nice_load
Message-ID: <20091110222038.GA32028@linux-os.sc.intel.com>
References: <200911061727.17541.Miller@fmi.uni-stuttgart.de> <B5B0CFF685D7DF46A05CF1678CFB42ED20E0C63D@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B5B0CFF685D7DF46A05CF1678CFB42ED20E0C63D@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 11:42:02AM -0800, Pallipadi, Venkatesh wrote:
> >-----Original Message-----
> >From: cpufreq-owner@vger.kernel.org 
> >[mailto:cpufreq-owner@vger.kernel.org] On Behalf Of Alexander Miller
> >Sent: Friday, November 06, 2009 8:27 AM
> >To: linux-kernel@vger.kernel.org
> >Cc: cpufreq@vger.kernel.org; Dave Jones
> >Subject: [PATCH] cpufreq: fix conservative/ondemand behaviour 
> >with ignore_nice_load
> >
> >Remove conversion of nice load to microseconds which caused addition
> >of times measured in different units and thus unreasonable behaviour
> >with both governors.                                                  
> 
> Can you describe the "unresonable behavior" you are seeing. Is it
> with NO_HZ enabled or disabled?
> 
> I see there can be a problem with this code when NO_HZ is disabled.
> But, the patch below is not the right solution as it will result in
> Adding times in different units with NO_HZ enabled.
> 
> Thanks,
> Venki

Does the below test patch (only compile tested) resolve the problem you
are seeing?

Thanks,
Venki

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

