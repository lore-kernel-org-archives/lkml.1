Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbYCMBPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbYCMBPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 21:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYCMBPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 21:15:43 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33885 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbYCMBPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 21:15:42 -0400
Date: Wed, 12 Mar 2008 18:15:38 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: lm-sensors <lm-sensors@lm-sensors.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>
Subject: [PATCH] ibmpex: Correct power use multipliers for QS2x blade
Message-ID: <20080313011538.GA5731@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The QS2x blades ships with v2.54 of the firmware, which use the same multiplier
for all power meters.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/ibmpex.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
index 9c9cdb0..db551d8 100644
--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -327,10 +327,14 @@ static int is_temp_sensor(const char *sensor_id, int len)
 	return 0;
 }
 
-static int power_sensor_multiplier(const char *sensor_id, int len)
+static int power_sensor_multiplier(struct ibmpex_bmc_data *data,
+				   const char *sensor_id, int len)
 {
 	int i;
 
+	if (data->sensor_major == 2)
+		return 1000000;
+
 	for (i = PEX_SENSOR_TYPE_LEN; i < len - 1; i++)
 		if (!memcmp(&sensor_id[i], watt_sensor_sig, PEX_MULT_LEN))
 			return 1000000;
@@ -398,8 +402,9 @@ static int ibmpex_find_sensors(struct ibmpex_bmc_data *data)
 			num_power++;
 			sensor_counter = num_power;
 			data->sensors[i].multiplier =
-				power_sensor_multiplier(data->rx_msg_data,
-						     data->rx_msg_len);
+				power_sensor_multiplier(data,
+							data->rx_msg_data,
+							data->rx_msg_len);
 		} else if (is_temp_sensor(data->rx_msg_data,
 					  data->rx_msg_len)) {
 			sensor_type = TEMP_SENSOR;
