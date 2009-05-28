Return-Path: <linux-kernel-owner+w=401wt.eu-S1764083AbZE1S7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764083AbZE1S7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 14:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758356AbZE1S7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 14:59:25 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:50815 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbZE1S7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 14:59:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lFvGWnyrQBLNAZcF+NV3weNwa89uAfL4umVPORIFyQ0jAHigSrMhqQvaGRehCj2K+7
         u/2qhFt2oksfoMClpPSDyczMl0eiN9H4NnNJjOWY5qDrWe7ooQNcv1YC5f+4GuyPdYEr
         +62CjhFnXgYYJ1trpr5lq1mbNZwtZOHC7RIPM=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       Robert Jarzmik <robert.jarzmik@free.fr>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH] regulator/max1586: fix V3 gain calculation integer overflow
Date: Thu, 28 May 2009 21:00:03 +0200
Message-Id: <1243537203-4663-1-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090528085920.GA4624@rakim.wolfsonmicro.main>
References: <20090528085920.GA4624@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 10:59 AM, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, May 28, 2009 at 07:15:16AM +0200, Philipp Zabel wrote:
>> The V3 regulator can be configured with an external resistor
>> connected to the feedback pin (R24 in the data sheet) to
>> increase the voltage range.
>>
>> For example, hx4700 has R24 = 3.32 kOhm to achieve a maximum
>> V3 voltage of 1.55 V which is needed for 624 MHz CPU frequency.
>>
>> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
>
> Looks good.
>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Thanks, but it turns out I hit a 32 bit integer overflow in
the gain calculation. I'd like to mend that with the following
patch. Now max_uV could be increased up to 4.294 V, enough to
charge LiPo cells.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/regulator/max1586.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index 92799f4..2c082d3 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -40,8 +40,8 @@ struct max1586_data {
 	struct i2c_client *client;
 
 	/* min/max V3 voltage */
-	int min_uV;
-	int max_uV;
+	unsigned int min_uV;
+	unsigned int max_uV;
 
 	struct regulator_dev *rdev[0];
 };
@@ -199,8 +199,8 @@ static int max1586_pmic_probe(struct i2c_client *client,
 		ret = -EINVAL;
 		goto out_unmap;
 	}
-	max1586->min_uV = MAX1586_V3_MIN_UV * pdata->v3_gain / 1000000;
-	max1586->max_uV = MAX1586_V3_MAX_UV * pdata->v3_gain / 1000000;
+	max1586->min_uV = MAX1586_V3_MIN_UV / 1000 * pdata->v3_gain / 1000;
+	max1586->max_uV = MAX1586_V3_MAX_UV / 1000 * pdata->v3_gain / 1000;
 
 	rdev = max1586->rdev;
 	for (i = 0; i < pdata->num_subdevs && i <= MAX1586_V6; i++) {
-- 
1.6.3.1

