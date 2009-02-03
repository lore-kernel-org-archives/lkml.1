Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbZBCQsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbZBCQsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbZBCQq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:46:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:55970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbZBCQqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:46:52 -0500
From: Thomas Renninger <trenn@suse.de>
To: davej@codemonkey.org.uk
Cc: mark.langsdorf@amd.com, cpufreq@vger.kernel.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>
Subject: [PATCH 1/7] CPUFREQ: Introduce /sys/devices/system/cpu/cpu*/cpufreq/cpuinfo_transition_latency
Date: Tue,  3 Feb 2009 17:46:40 +0100
Message-Id: <1233679606-1971-2-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233679606-1971-1-git-send-email-trenn@suse.de>
References: <1233679606-1971-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not only useful for the ondemand and conservative governors, but
also for userspace daemons to know about the HW transition latency of
the CPU.
It is especially useful for userspace to know about this value when
the ondemand or conservative governors are run. The sampling rate
control value depends on it and for userspace being able to set sane
tuning values there it has to know about the transition latency.

Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 Documentation/cpu-freq/user-guide.txt |   12 ++++++++++++
 drivers/cpufreq/cpufreq.c             |    3 +++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/Documentation/cpu-freq/user-guide.txt b/Documentation/cpu-freq/user-guide.txt
index e3443dd..57f23cb 100644
--- a/Documentation/cpu-freq/user-guide.txt
+++ b/Documentation/cpu-freq/user-guide.txt
@@ -152,6 +152,18 @@ cpuinfo_min_freq :		this file shows the minimum operating
 				frequency the processor can run at(in kHz) 
 cpuinfo_max_freq :		this file shows the maximum operating
 				frequency the processor can run at(in kHz) 
+cpuinfo_transition_latency	The time it takes on this CPU to
+				switch between two frequencies in nano
+				seconds. If unknown or known to be
+				that high that the driver does not
+				work with the ondemand governor, -1
+				(CPUFREQ_ETERNAL) will be returned.
+				Using this information can be useful
+				to choose an appropriate polling
+				frequency for a kernel governor or
+				userspace daemon. Make sure to not
+				switch the frequency too often
+				resulting in performance loss.
 scaling_driver :		this file shows what cpufreq driver is
 				used to set the frequency on this CPU
 
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index b55cb67..ae92986 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -455,6 +455,7 @@ static ssize_t show_##file_name				\
 
 show_one(cpuinfo_min_freq, cpuinfo.min_freq);
 show_one(cpuinfo_max_freq, cpuinfo.max_freq);
+show_one(cpuinfo_transition_latency, cpuinfo.transition_latency);
 show_one(scaling_min_freq, min);
 show_one(scaling_max_freq, max);
 show_one(scaling_cur_freq, cur);
@@ -660,6 +661,7 @@ __ATTR(_name, 0644, show_##_name, store_##_name)
 define_one_ro0400(cpuinfo_cur_freq);
 define_one_ro(cpuinfo_min_freq);
 define_one_ro(cpuinfo_max_freq);
+define_one_ro(cpuinfo_transition_latency);
 define_one_ro(scaling_available_governors);
 define_one_ro(scaling_driver);
 define_one_ro(scaling_cur_freq);
@@ -673,6 +675,7 @@ define_one_rw(scaling_setspeed);
 static struct attribute *default_attrs[] = {
 	&cpuinfo_min_freq.attr,
 	&cpuinfo_max_freq.attr,
+	&cpuinfo_transition_latency.attr,
 	&scaling_min_freq.attr,
 	&scaling_max_freq.attr,
 	&affected_cpus.attr,
-- 
1.6.0.2

