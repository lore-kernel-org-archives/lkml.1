Return-Path: <linux-kernel-owner+w=401wt.eu-S1762841AbYEIEza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762841AbYEIEza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 00:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYEIEzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 00:55:20 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46690 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbYEIEzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 00:55:19 -0400
Date: Thu, 8 May 2008 21:55:27 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mhoffman@lightlink.com, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: [PATCH] ibmaem: Fix 64-bit division on 32-bit platforms
Message-ID: <20080509045527.GI16404@tree.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20080508180858.GM16078@tree.beaverton.ibm.com> <20080508163443.a1e9ffe7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508163443.a1e9ffe7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 04:34:43PM -0700, Andrew Morton wrote:

> This driver is littered with 64-bit divides and doesn't link on i386.
> I'll make it depend on CONFIG_64BIT for now.

Oops, sorry, I didn't remember that one can't do 64-bit division on
i386.  The patch below fixes that.
---
ibmaem: Fix 64-bit division on 32-bit platforms

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/ibmaem.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index 22fa7d6..f808ca3 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -31,6 +31,7 @@
 #include <linux/idr.h>
 #include <linux/sched.h>
 #include <linux/platform_device.h>
+#include <linux/math64.h>
 
 #define REFRESH_INTERVAL	(HZ)
 #define IPMI_TIMEOUT		(30 * HZ)
@@ -864,9 +865,10 @@ static ssize_t aem_show_power(struct device *dev,
 	mutex_unlock(&data->lock);
 
 	time = timespec_to_ns(&a) - timespec_to_ns(&b);
-	time /= 1000;
+	time = div_u64(time, 1000);
 
-	return sprintf(buf, "%llu\n", (after - before) * 1000000000 / time);
+	return sprintf(buf, "%llu\n",
+		       div64_u64((after - before) * 1000000000, time));
 }
 
 /* Display energy use */
