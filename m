Return-Path: <linux-kernel-owner+w=401wt.eu-S1763578AbYEOVSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763578AbYEOVSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755815AbYEOVSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:18:33 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56980 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbYEOVSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:18:32 -0400
Date: Thu, 15 May 2008 14:18:09 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       mhoffman@lightlink.com, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: [PATCH v2] ibmaem: Fix 64-bit division on 32-bit platforms
Message-ID: <20080515211809.GB7323@tree.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20080508180858.GM16078@tree.beaverton.ibm.com> <20080508163443.a1e9ffe7.akpm@linux-foundation.org> <20080509045527.GI16404@tree.beaverton.ibm.com> <20080514222704.GA11439@cs181133002.pp.htv.fi> <20080514231136.GA4308@beyonder.ift.unesp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514231136.GA4308@beyonder.ift.unesp.br>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> To avoid these kind of doubts may I suggest using the time 
> conversion definitions of include/linux/time.h?
> 
> It would be much easier to understand the intention with
> NSEC_PER_SEC, USEC_PER_SEC etc (comments would also help)

Ok, here's an updated version that makes the conversions a bit clearer.
Tested and run on i386/x86-64.
---
ibmaem: Fix 64-bit division on 32-bit platforms

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/ibmaem.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index 22fa7d6..3013492 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -31,6 +31,8 @@
 #include <linux/idr.h>
 #include <linux/sched.h>
 #include <linux/platform_device.h>
+#include <linux/math64.h>
+#include <linux/time.h>
 
 #define REFRESH_INTERVAL	(HZ)
 #define IPMI_TIMEOUT		(30 * HZ)
@@ -81,6 +83,7 @@
 
 #define AEM_DEFAULT_POWER_INTERVAL 1000
 #define AEM_MIN_POWER_INTERVAL	200
+#define UJ_PER_MJ		1000L
 
 static DEFINE_IDR(aem_idr);
 static DEFINE_SPINLOCK(aem_idr_lock);
@@ -841,7 +844,7 @@ static ssize_t aem_show_power(struct device *dev,
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct aem_data *data = dev_get_drvdata(dev);
-	u64 before, after, time;
+	u64 before, after, delta, time;
 	signed long leftover;
 	struct timespec b, a;
 
@@ -864,9 +867,9 @@ static ssize_t aem_show_power(struct device *dev,
 	mutex_unlock(&data->lock);
 
 	time = timespec_to_ns(&a) - timespec_to_ns(&b);
-	time /= 1000;
+	delta = (after - before) * UJ_PER_MJ;
 
-	return sprintf(buf, "%llu\n", (after - before) * 1000000000 / time);
+	return sprintf(buf, "%llu\n", div64_u64(delta * NSEC_PER_SEC, time));
 }
 
 /* Display energy use */
