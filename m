Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab0BLLXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 06:23:20 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:61888 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab0BLLXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 06:23:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=kwzalczRviZmt1r4Q4h5TQmWy+IuG9GgwO1LGSMkXGQ1HICKeSPMnTC4UDUbipM9vh
         9sYRspXh/ZtZOEACJK4LD5dbeekE9Dqh1ky8oo8W4jqbKcA3sFRWhg0iTDZDr0w+RuYG
         F5l3K8UR3wxSy9A6Mjexae3S0WP3HcecqQ/q8=
Message-ID: <4B753BCD.8060100@gmail.com>
Date: Fri, 12 Feb 2010 12:30:21 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] regulator/lp3971: vol_map out of bounds in lp3971_{ldo,dcdc}_set_voltage()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After `for (val = LDO_VOL_MIN_IDX; val <= LDO_VOL_MAX_IDX; val++)', if no break
occurs, val reaches LDO_VOL_MIN_IDX + 1, which is out of bounds for
ldo45_voltage_map[] and ldo123_voltage_map[].

Similarly BUCK_TARGET_VOL_MAX_IDX + 1 is out of bounds for buck_voltage_map[].

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 76d08c2..4f33a0f 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -183,7 +183,7 @@ static int lp3971_ldo_set_voltage(struct regulator_dev *dev,
 		if (vol_map[val] >= min_vol)
 			break;
 
-	if (vol_map[val] > max_vol)
+	if (val > LDO_VOL_MAX_IDX || vol_map[val] > max_vol)
 		return -EINVAL;
 
 	return lp3971_set_bits(lp3971, LP3971_LDO_VOL_CONTR_REG(ldo),
@@ -272,7 +272,7 @@ static int lp3971_dcdc_set_voltage(struct regulator_dev *dev,
 		if (vol_map[val] >= min_vol)
 			break;
 
-	if (vol_map[val] > max_vol)
+	if (val > BUCK_TARGET_VOL_MAX_IDX || vol_map[val] > max_vol)
 		return -EINVAL;
 
 	ret = lp3971_set_bits(lp3971, LP3971_BUCK_TARGET_VOL1_REG(buck),
