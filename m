Return-Path: <linux-kernel-owner+w=401wt.eu-S1760601AbXLUNyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbXLUNyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 08:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbXLUNyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 08:54:00 -0500
Received: from saeurebad.de ([85.214.36.134]:48791 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbXLUNx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 08:53:59 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: 2.6.24-rc5-git7: Reported regressions from 2.6.23
References: <200712210212.02666.rjw@sisk.pl>
Date: Fri, 21 Dec 2007 14:52:17 +0100
In-Reply-To: <200712210212.02666.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Fri, 21 Dec 2007 02:12:02 +0100")
Message-ID: <87d4t05f5a.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message contains a list of some regressions from 2.6.23 reported since
> 2.6.24-rc1 was released, for which there are no fixes in the mainline I know
> of.  If any of them have been fixed already, please let me know.
>
> If you know of any other unresolved regressions from 2.6.23, please let me know
> either and I'll add them to the list.  Also, please let me know if any of the
> entries below are invalid.

I still have a bug with cpufreq when using ondemand governor as default.

The performance governor, which has been the essential default until
1c2562459faedc35927546cfa5273ec6c2884cce,  was initialized with
fs_initcall() instead of module_init() to make sure the driver is up and
running when the bootcode (speedstep_init in my case) calls into it.

Since the above mentioned commit, other governors can also be chosen to
be the default but they are not correctly initialized before first use
then.

I poked Dave (added to CC) but no response since a few days.  I am
getting edgy now because this really breaks stuff and the attached patch
should get into .24 or at least the problem should be taken more
seriously.  I have not yet seen a discussion about this particular
problem, so if I missed something, please tell me and consider this mail
obsolete.

	Hannes


From: Johannes Weiner <hannes@saeurebad.de>
Date: Tue, 18 Dec 2007 13:03:49 +0100
Subject: [PATCH] cpufreq: Initialise default governor before use

When the cpufreq driver starts up at boot time, it calls into the
default governor which might not be initialised yet. This hurts when
the governor's worker function relies on memory that is not yet set up
by its init function.

This migrates all governors from module_init() to fs_initcall() when
being the default, as was already done in cpufreq_performance when it
was the only possible choice.

Fixes at least one actual oops where ondemand is the default governor
and cpufreq_governor_dbs() uses the uninitialised kondemand_wq
work-queue during boot-time.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 drivers/cpufreq/cpufreq_conservative.c |    4 ++++
 drivers/cpufreq/cpufreq_ondemand.c     |    5 ++++-
 drivers/cpufreq/cpufreq_performance.c  |    4 ++++
 drivers/cpufreq/cpufreq_userspace.c    |    4 ++++
 4 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 1bba997..5d3a04b 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -603,5 +603,9 @@ MODULE_DESCRIPTION ("'cpufreq_conservative' - A dynamic cpufreq governor for "
 		"optimised for use in a battery environment");
 MODULE_LICENSE ("GPL");
 
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
+fs_initcall(cpufreq_gov_dbs_init);
+#else
 module_init(cpufreq_gov_dbs_init);
+#endif
 module_exit(cpufreq_gov_dbs_exit);
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 369f445..d2af20d 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -610,6 +610,9 @@ MODULE_DESCRIPTION("'cpufreq_ondemand' - A dynamic cpufreq governor for "
                    "Low Latency Frequency Transition capable processors");
 MODULE_LICENSE("GPL");
 
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND
+fs_initcall(cpufreq_gov_dbs_init);
+#else
 module_init(cpufreq_gov_dbs_init);
+#endif
 module_exit(cpufreq_gov_dbs_exit);
-
diff --git a/drivers/cpufreq/cpufreq_performance.c b/drivers/cpufreq/cpufreq_performance.c
index e8e1451..df5fca3 100644
--- a/drivers/cpufreq/cpufreq_performance.c
+++ b/drivers/cpufreq/cpufreq_performance.c
@@ -60,5 +60,9 @@ MODULE_AUTHOR("Dominik Brodowski <linux@brodo.de>");
 MODULE_DESCRIPTION("CPUfreq policy governor 'performance'");
 MODULE_LICENSE("GPL");
 
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE
 fs_initcall(cpufreq_gov_performance_init);
+#else
+module_init(cpufreq_gov_performance_init);
+#endif
 module_exit(cpufreq_gov_performance_exit);
diff --git a/drivers/cpufreq/cpufreq_userspace.c b/drivers/cpufreq/cpufreq_userspace.c
index 51bedab..f8cdde4 100644
--- a/drivers/cpufreq/cpufreq_userspace.c
+++ b/drivers/cpufreq/cpufreq_userspace.c
@@ -231,5 +231,9 @@ MODULE_AUTHOR ("Dominik Brodowski <linux@brodo.de>, Russell King <rmk@arm.linux.
 MODULE_DESCRIPTION ("CPUfreq policy governor 'userspace'");
 MODULE_LICENSE ("GPL");
 
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE
 fs_initcall(cpufreq_gov_userspace_init);
+#else
+module_init(cpufreq_gov_userspace_init);
+#endif
 module_exit(cpufreq_gov_userspace_exit);
-- 
1.5.3.7

