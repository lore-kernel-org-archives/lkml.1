Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbZI2C1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbZI2C1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 22:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbZI2C1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 22:27:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:47570 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZI2C1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 22:27:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,470,1249282800"; 
   d="scan'208";a="554564106"
Message-ID: <4AC1707D.6020909@intel.com>
Date: Tue, 29 Sep 2009 10:27:09 +0800
From: Shane Wang <shane.wang@intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
Subject: [PATCH] intel_txt: fix the buggy timeout warning logic in tboot
References: <4A9CE0B2.5060608@intel.com> <4ABF2B50.6070106@intel.com>
In-Reply-To: <4ABF2B50.6070106@intel.com>
Content-Type: multipart/mixed;
 boundary="------------020706060308080905090802"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020706060308080905090802
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch based on an original version by H. Peter Anvin fixed the buggy 
timeout warning logic in tboot.

---
  arch/x86/kernel/tboot.c |    9 +++++----
  1 file changed, 5 insertions(+), 4 deletions(-)


Signed-off-by: Shane Wang <shane.wang@intel.com>

diff -r 0edd117ada44 arch/x86/kernel/tboot.c
--- a/arch/x86/kernel/tboot.c	Wed Sep 23 10:06:56 2009 -0700
+++ b/arch/x86/kernel/tboot.c	Mon Sep 28 07:42:18 2009 -0700
@@ -301,16 +301,17 @@ static int tboot_wait_for_aps(int num_ap
  	unsigned long timeout;

  	timeout = AP_WAIT_TIMEOUT*HZ;
-	while (atomic_read((atomic_t *)&tboot->num_in_wfs) != num_aps &&
-	       timeout) {
+	while (timeout) {
+		if (atomic_read((atomic_t *)&tboot->num_in_wfs) == num_aps)
+			break;
  		mdelay(1);
  		timeout--;
  	}

-	if (timeout)
+	if (!timeout)
  		pr_warning("tboot wait for APs timeout\n");

-	return !(atomic_read((atomic_t *)&tboot->num_in_wfs) == num_aps);
+	return !timeout;
  }

  static int __cpuinit tboot_cpu_callback(struct notifier_block *nfb,

--------------020706060308080905090802
Content-Type: text/plain;
 name="timeout_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="timeout_fix.patch"

This patch based on an original version by H. Peter Anvin fixed the buggy timeout warning logic in tboot.

Signed-off-by: Shane Wang <shane.wang@intel.com>

diff -r 0edd117ada44 arch/x86/kernel/tboot.c
--- a/arch/x86/kernel/tboot.c	Wed Sep 23 10:06:56 2009 -0700
+++ b/arch/x86/kernel/tboot.c	Mon Sep 28 07:42:18 2009 -0700
@@ -301,16 +301,17 @@ static int tboot_wait_for_aps(int num_ap
 	unsigned long timeout;
 
 	timeout = AP_WAIT_TIMEOUT*HZ;
-	while (atomic_read((atomic_t *)&tboot->num_in_wfs) != num_aps &&
-	       timeout) {
+	while (timeout) {
+		if (atomic_read((atomic_t *)&tboot->num_in_wfs) == num_aps)
+			break;
 		mdelay(1);
 		timeout--;
 	}
 
-	if (timeout)
+	if (!timeout)
 		pr_warning("tboot wait for APs timeout\n");
 
-	return !(atomic_read((atomic_t *)&tboot->num_in_wfs) == num_aps);
+	return !timeout;
 }
 
 static int __cpuinit tboot_cpu_callback(struct notifier_block *nfb,

--------------020706060308080905090802--
