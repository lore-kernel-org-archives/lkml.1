Return-Path: <linux-kernel-owner+w=401wt.eu-S1763312AbYHESE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763312AbYHESE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762010AbYHESEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:04:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:3799 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364AbYHESEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:04:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=iuoXk+fnwIb/TjhXk/SRDbeyvVRNfbpUvHFFROQ+ahZkES2vVEWLvvAocfDPQu3H4a
         bXd0dDEDDNh7ZB/+IcR6DdigYiL13rVVC4HA60WGltxykHYG4tgkR1MJjHWN4hiFG8Fe
         eKsXR7LLY591oQS6p1j5x/dqDybTpENrG+SvE=
Date: Tue, 5 Aug 2008 23:34:32 +0530
From: Rabin Vincent <rabin@rab.in>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: linux-kernel@vger.kernel.org, shaohua.li@intel.com,
       Andi Kleen <ak@linux.intel.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] cpuidle: make sysfs attributes sysdev class attributes
Message-ID: <20080805180432.GA1856@debian>
References: <20080805111836.GB12217@alice> <20080805123356.GA12656@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805123356.GA12656@alice>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These attributes are really sysdev class attributes.  The incorrect
definition leads to an oops because of recent changes which make sysdev
attributes use a different prototype.

Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
Based on Andi's f718cd4add5aea9d379faff92f162571e356cc5f ("sched: make
scheduler sysfs attributes sysdev class devices")

 drivers/cpuidle/sysfs.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 31a0e0b..97b0038 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -21,8 +21,8 @@ static int __init cpuidle_sysfs_setup(char *unused)
 }
 __setup("cpuidle_sysfs_switch", cpuidle_sysfs_setup);
 
-static ssize_t show_available_governors(struct sys_device *dev,
-		struct sysdev_attribute *attr, char *buf)
+static ssize_t show_available_governors(struct sysdev_class *class,
+					char *buf)
 {
 	ssize_t i = 0;
 	struct cpuidle_governor *tmp;
@@ -40,8 +40,8 @@ out:
 	return i;
 }
 
-static ssize_t show_current_driver(struct sys_device *dev,
-		struct sysdev_attribute *attr, char *buf)
+static ssize_t show_current_driver(struct sysdev_class *class,
+				   char *buf)
 {
 	ssize_t ret;
 
@@ -55,8 +55,8 @@ static ssize_t show_current_driver(struct sys_device *dev,
 	return ret;
 }
 
-static ssize_t show_current_governor(struct sys_device *dev,
-			struct sysdev_attribute *attr, char *buf)
+static ssize_t show_current_governor(struct sysdev_class *class,
+				     char *buf)
 {
 	ssize_t ret;
 
@@ -70,9 +70,8 @@ static ssize_t show_current_governor(struct sys_device *dev,
 	return ret;
 }
 
-static ssize_t store_current_governor(struct sys_device *dev,
-	struct sysdev_attribute *attr,
-	const char *buf, size_t count)
+static ssize_t store_current_governor(struct sysdev_class *class,
+				      const char *buf, size_t count)
 {
 	char gov_name[CPUIDLE_NAME_LEN];
 	int ret = -EINVAL;
@@ -104,8 +103,9 @@ static ssize_t store_current_governor(struct sys_device *dev,
 		return count;
 }
 
-static SYSDEV_ATTR(current_driver, 0444, show_current_driver, NULL);
-static SYSDEV_ATTR(current_governor_ro, 0444, show_current_governor, NULL);
+static SYSDEV_CLASS_ATTR(current_driver, 0444, show_current_driver, NULL);
+static SYSDEV_CLASS_ATTR(current_governor_ro, 0444, show_current_governor,
+			 NULL);
 
 static struct attribute *cpuclass_default_attrs[] = {
 	&attr_current_driver.attr,
@@ -113,9 +113,10 @@ static struct attribute *cpuclass_default_attrs[] = {
 	NULL
 };
 
-static SYSDEV_ATTR(available_governors, 0444, show_available_governors, NULL);
-static SYSDEV_ATTR(current_governor, 0644, show_current_governor,
-	store_current_governor);
+static SYSDEV_CLASS_ATTR(available_governors, 0444, show_available_governors,
+			 NULL);
+static SYSDEV_CLASS_ATTR(current_governor, 0644, show_current_governor,
+			 store_current_governor);
 
 static struct attribute *cpuclass_switch_attrs[] = {
 	&attr_available_governors.attr,
-- 
1.5.6.3
