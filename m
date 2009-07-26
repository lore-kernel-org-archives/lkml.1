Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbZGZKem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbZGZKem (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 06:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbZGZKel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 06:34:41 -0400
Received: from compulab.co.il ([67.18.134.219]:50483 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbZGZKek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 06:34:40 -0400
Message-ID: <4A6C313C.9050101@compulab.co.il>
Date: Sun, 26 Jul 2009 13:34:36 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.21 (X11/20090712)
MIME-Version: 1.0
To: Liam Girdwood <lrg@slimlogic.co.uk>
CC: broonie@opensource.wolfsonmicro.com, eric.y.miao@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: da903x: add support for DA9030 BUCK2 with
 DVM
References: <1248594842-23456-1-git-send-email-mike@compulab.co.il> <1248601239.25964.883.camel@vega.slimlogic.co.uk>
In-Reply-To: <1248601239.25964.883.camel@vega.slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Liam Girdwood wrote:
> On Sun, 2009-07-26 at 10:54 +0300, Mike Rapoport wrote:
>> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
>> ---
>>  drivers/regulator/da903x.c |   17 ++++++++++++-----
>>  1 files changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
>> index b8b89ef..fab755d 100644
>> --- a/drivers/regulator/da903x.c
>> +++ b/drivers/regulator/da903x.c
>> @@ -367,24 +367,24 @@ static struct regulator_ops da9034_regulator_ldo12_ops = {
>>  	.enable_bit	= (ebit),					\
>>  }
>>  
> 
> Looks fine but did not apply :-
> 
> Applying: regulator: da903x: add support for DA9030 BUCK2 with DVM
> error: patch failed: drivers/regulator/da903x.c:367
> error: drivers/regulator/da903x.c: patch does not apply
> Patch failed at 0001 regulator: da903x: add support for DA9030 BUCK2 with DVM
> 
> Could you regenerate against the regulator tree for-next branch.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git

It seems I'm getting senile. The BUCK2 is already supported, moreover I've acked
the patch.
The only thing left to do is to consolidate DA903[045]_DVC macros:

> From: Mike Rapoport <mike@compulab.co.il>
Date: Sun, 26 Jul 2009 13:33:04 +0300
Subject: [PATCH] regulator: da903x: consolidate DA903[045]_DVC macros

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/regulator/da903x.c |   66 +++++++++++--------------------------------
 1 files changed, 17 insertions(+), 49 deletions(-)

diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 236de11..7d9c250 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -404,69 +404,25 @@ static struct regulator_ops da9034_regulator_ldo12_ops = {
 	.enable_bit	= (ebit),					\
 }

-#define DA9030_DVC(_id, min, max, step, vreg, nbits, ureg, ubit, ereg, ebit) \
+#define DA903x_DVC(_pmic, _id, min, max, step, vreg, nbits, ureg, ubit, ereg, ebit) \
 {									\
 	.desc	= {							\
 		.name	= #_id,						\
 		.ops	= &da9034_regulator_dvc_ops,			\
 		.type	= REGULATOR_VOLTAGE,				\
-		.id	= DA9030_ID_##_id,				\
+		.id	= _pmic##_ID_##_id,				\
 		.n_voltages = (step) ? ((max - min) / step + 1) : 1,	\
 		.owner	= THIS_MODULE,					\
 	},								\
 	.min_uV		= (min) * 1000,					\
 	.max_uV		= (max) * 1000,					\
 	.step_uV	= (step) * 1000,				\
-	.vol_reg	= DA9030_##vreg,				\
-	.vol_shift	= (0),						\
-	.vol_nbits	= (nbits),					\
-	.update_reg	= DA9030_##ureg,				\
-	.update_bit	= (ubit),					\
-	.enable_reg	= DA9030_##ereg,				\
-	.enable_bit	= (ebit),					\
-}
-
-#define DA9034_DVC(_id, min, max, step, vreg, nbits, ureg, ubit, ereg, ebit) \
-{									\
-	.desc	= {							\
-		.name	= #_id,						\
-		.ops	= &da9034_regulator_dvc_ops,			\
-		.type	= REGULATOR_VOLTAGE,				\
-		.id	= DA9034_ID_##_id,				\
-		.n_voltages = (step) ? ((max - min) / step + 1) : 1,	\
-		.owner	= THIS_MODULE,					\
-	},								\
-	.min_uV		= (min) * 1000,					\
-	.max_uV		= (max) * 1000,					\
-	.step_uV	= (step) * 1000,				\
-	.vol_reg	= DA9034_##vreg,				\
-	.vol_shift	= (0),						\
-	.vol_nbits	= (nbits),					\
-	.update_reg	= DA9034_##ureg,				\
-	.update_bit	= (ubit),					\
-	.enable_reg	= DA9034_##ereg,				\
-	.enable_bit	= (ebit),					\
-}
-
-#define DA9035_DVC(_id, min, max, step, vreg, nbits, ureg, ubit, ereg, ebit) \
-{									\
-	.desc	= {							\
-		.name	= #_id,						\
-		.ops	= &da9034_regulator_dvc_ops,			\
-		.type	= REGULATOR_VOLTAGE,				\
-		.id	= DA9035_ID_##_id,				\
-		.n_voltages = (step) ? ((max - min) / step + 1) : 1,	\
-		.owner	= THIS_MODULE,					\
-	},								\
-	.min_uV		= (min) * 1000,					\
-	.max_uV		= (max) * 1000,					\
-	.step_uV	= (step) * 1000,				\
-	.vol_reg	= DA9035_##vreg,				\
+	.vol_reg	= _pmic##_##vreg,				\
 	.vol_shift	= (0),						\
 	.vol_nbits	= (nbits),					\
-	.update_reg	= DA9035_##ureg,				\
+	.update_reg	= _pmic##_##ureg,				\
 	.update_bit	= (ubit),					\
-	.enable_reg	= DA9035_##ereg,				\
+	.enable_reg	= _pmic##_##ereg,				\
 	.enable_bit	= (ebit),					\
 }

@@ -476,6 +432,18 @@ static struct regulator_ops da9034_regulator_ldo12_ops = {
 #define DA9030_LDO(_id, min, max, step, vreg, shift, nbits, ereg, ebit)	\
 	DA903x_LDO(DA9030, _id, min, max, step, vreg, shift, nbits, ereg, ebit)

+#define DA9030_DVC(_id, min, max, step, vreg, nbits, ureg, ubit, ereg, ebit) \
+	DA903x_DVC(DA9030, _id, min, max, step, vreg, nbits, ureg, ubit, \
+		   ereg, ebit)
+
+#define DA9034_DVC(_id, min, max, step, vreg, nbits, ureg, ubit, ereg, ebit) \
+	DA903x_DVC(DA9034, _id, min, max, step, vreg, nbits, ureg, ubit, \
+		   ereg, ebit)
+
+#define DA9035_DVC(_id, min, max, step, vreg, nbits, ureg, ubit, ereg, ebit) \
+	DA903x_DVC(DA9035, _id, min, max, step, vreg, nbits, ureg, ubit, \
+		   ereg, ebit)
+
 static struct da903x_regulator_info da903x_regulator_info[] = {
 	/* DA9030 */
 	DA9030_DVC(BUCK2, 850, 1625, 25, BUCK2DVM1, 5, BUCK2DVM1, 7, RCTL11, 0),
-- 
1.6.0.6




> Thanks
> 
> Liam
> 
> 

-- 
Sincerely yours,
Mike.


