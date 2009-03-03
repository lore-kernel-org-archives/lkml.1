Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbZCCBi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbZCCBi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 20:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbZCCBiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 20:38:19 -0500
Received: from smtp-out.google.com ([216.239.45.13]:55495 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbZCCBiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 20:38:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=qoQKimv/kaj4WHWyFSYqIe84b092eDwXEYcUxUxWJcKJFRKVrWHNbdeLTfkmBfMiq
	FHKN1Pf+en3l3WhxLarpQ==
From: Paul Menage <menage@google.com>
Subject: [PATCH] Allow cpusets to be configured/built on non-SMP systems
To: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Date: Mon, 02 Mar 2009 17:36:19 -0800
Message-ID: <20090303013432.11211.18662.stgit@menage.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow cpusets to be configured/built on non-SMP systems

Currently it's impossible to build cpusets under UML on x86-64, since
cpusets depends on SMP and x86-64 UML doesn't support SMP.

There's code in cpusets that doesn't depend on SMP.  This patch
surrounds the minimum amount of cpusets code with #ifdef CONFIG_SMP in
order to allow cpusets to build/run on UP systems (for testing
purposes under UML).

Signed-off-by: Paul Menage <menage@google.com>

---

 init/Kconfig    |    2 +-
 kernel/cpuset.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 92d2c64..3f20aa2 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -477,7 +477,7 @@ config CGROUP_DEVICE
 
 config CPUSETS
 	bool "Cpuset support"
-	depends on SMP && CGROUPS
+	depends on CGROUPS
 	help
 	  This option will let you create and manage CPUSETs which
 	  allow dynamically partitioning a system into sets of CPUs and
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index a46d693..b4d12d8 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -517,6 +517,8 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
 	return 0;
 }
 
+#ifdef CONFIG_SMP
+
 /*
  * Helper routine for generate_sched_domains().
  * Do cpusets a, b have overlapping cpus_allowed masks?
@@ -811,6 +813,16 @@ static void do_rebuild_sched_domains(struct work_struct *unused)
 
 	put_online_cpus();
 }
+#else
+static void do_rebuild_sched_domains(struct work_struct *unused)
+{
+}
+
+static int generate_sched_domains(struct cpumask **domains,
+			struct sched_domain_attr **attributes)
+{
+}
+#endif // CONFIG_SMP
 
 static DECLARE_WORK(rebuild_sched_domains_work, do_rebuild_sched_domains);
 
@@ -1164,8 +1176,10 @@ int current_cpuset_is_being_rebound(void)
 
 static int update_relax_domain_level(struct cpuset *cs, s64 val)
 {
+#ifdef CONFIG_SMP
 	if (val < -1 || val >= SD_LV_MAX)
 		return -EINVAL;
+#endif
 
 	if (val != cs->relax_domain_level) {
 		cs->relax_domain_level = val;

