Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbYHKXmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbYHKXmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 19:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYHKXmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 19:42:08 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:56158 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbYHKXmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 19:42:06 -0400
Date: Mon, 11 Aug 2008 16:42:49 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: lm-sensors <lm-sensors@lm-sensors.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ibmaem: Don't query the entire sensor repository when
	reading energy meter
Message-ID: <20080811234249.GC28331@tree.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, all sensors are read when the energy meter is queried via sysfs.
This introduces a considerable amount of delay and variation in the sysfs
reading, which is not desirable when trying to profile energy use.  Therefore,
read only the energy meters when a sysfs query comes in for them, and don't
cache the results so that we always get the latest reading.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/ibmaem.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index c9416e6..f660216 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -463,12 +463,18 @@ static int aem_read_sensor(struct aem_data *data, u8 elt, u8 reg,
 }
 
 /* Update AEM energy registers */
+static void update_aem_energy_one(struct aem_data *data, int which)
+{
+	aem_read_sensor(data, AEM_ENERGY_ELEMENT, which,
+			&data->energy[which], 8);
+}
+
 static void update_aem_energy(struct aem_data *data)
 {
-	aem_read_sensor(data, AEM_ENERGY_ELEMENT, 0, &data->energy[0], 8);
+	update_aem_energy_one(data, 0);
 	if (data->ver_major < 2)
 		return;
-	aem_read_sensor(data, AEM_ENERGY_ELEMENT, 1, &data->energy[1], 8);
+	update_aem_energy_one(data, 1);
 }
 
 /* Update all AEM1 sensors */
@@ -849,7 +855,7 @@ static ssize_t aem_show_power(struct device *dev,
 	struct timespec b, a;
 
 	mutex_lock(&data->lock);
-	update_aem_energy(data);
+	update_aem_energy_one(data, attr->index);
 	getnstimeofday(&b);
 	before = data->energy[attr->index];
 
@@ -861,7 +867,7 @@ static ssize_t aem_show_power(struct device *dev,
 		return 0;
 	}
 
-	update_aem_energy(data);
+	update_aem_energy_one(data, attr->index);
 	getnstimeofday(&a);
 	after = data->energy[attr->index];
 	mutex_unlock(&data->lock);
@@ -880,7 +886,9 @@ static ssize_t aem_show_energy(struct device *dev,
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 	struct aem_data *a = dev_get_drvdata(dev);
-	a->update(a);
+	mutex_lock(&a->lock);
+	update_aem_energy_one(a, attr->index);
+	mutex_unlock(&a->lock);
 
 	return sprintf(buf, "%llu\n",
 			(unsigned long long)a->energy[attr->index] * 1000);
