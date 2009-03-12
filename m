Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZCLAns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZCLAns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 20:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZCLAni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 20:43:38 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:33903 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752497AbZCLAnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 20:43:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fpFX3uS/ONFR3oVdYgPaw5x91fMYAtdbqeuR9tonPZNq8OJ4vlprhPWptbKUVgDnlTpRXiIh/751lDVHNCOU3NDcU3a0ukSunKae8nMuE6efpv1w9ZGiNsWxjuYEOq22kSXdwVFjJ5pJTHRTUqXczCm3r1C9cdkm/Xy5gTAP2r4=  ;
X-YMail-OSG: tocdeEIVM1lNLM0x2DWzMDmh39FkxKoIWiVG4n6U97Icys3b1CiYCcaNIWJ0JdwIYNrwyipJCsHtbXqEUt.m.O54h3nU74IsjO_kQ5Fofc_D.G4cUbYjeVDieZ6YgDoxe0WOSPTarw3w18p1FSVbO6x2nExW0xE2Bm1la0wpHHWKk4fa2FalZA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lrg@slimlogic.co.uk>, Mark Brown <broonie@sirena.org.uk>
Subject: [patch 2.6.29-rc7 regulator-next] regulator: refcount fixes
Date: Wed, 11 Mar 2009 16:43:34 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, OMAP <linux-omap@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903111743.34708.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Fix some refcounting issues in the regulator framework, supporting
regulator_disable() for regulators that were enabled at boot time
via machine constraints:

 - Update those regulators' usecounts after enabling, so they
   can cleanly be disabled at that level.

 - Remove the problematic per-consumer usecount, so there's
   only one level of enable/disable.

Buggy consumers could notice different bug symptoms.  The main
example would be refcounting bugs; also, any (out-of-tree) users
of the experimental regulator_set_optimum_mode() stuff which
don't call it when they're done using a regulator.

This is a net minor codeshrink.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Against the regulator-next tree; mainline has similar issues.

 drivers/regulator/core.c |   30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -52,7 +52,6 @@ struct regulator {
 	int uA_load;
 	int min_uV;
 	int max_uV;
-	int enabled; /* count of client enables */
 	char *supply_name;
 	struct device_attribute dev_attr;
 	struct regulator_dev *rdev;
@@ -811,6 +810,7 @@ static int set_machine_constraints(struc
 			rdev->constraints = NULL;
 			goto out;
 		}
+		rdev->use_count = 1;
 	}
 
 	print_constraints(rdev);
@@ -1066,10 +1066,6 @@ void regulator_put(struct regulator *reg
 	mutex_lock(&regulator_list_mutex);
 	rdev = regulator->rdev;
 
-	if (WARN(regulator->enabled, "Releasing supply %s while enabled\n",
-			       regulator->supply_name))
-		_regulator_disable(rdev);
-
 	/* remove any sysfs entries */
 	if (regulator->dev) {
 		sysfs_remove_link(&rdev->dev.kobj, regulator->supply_name);
@@ -1144,12 +1140,7 @@ int regulator_enable(struct regulator *r
 	int ret = 0;
 
 	mutex_lock(&rdev->mutex);
-	if (regulator->enabled == 0)
-		ret = _regulator_enable(rdev);
-	else if (regulator->enabled < 0)
-		ret = -EIO;
-	if (ret == 0)
-		regulator->enabled++;
+	ret = _regulator_enable(rdev);
 	mutex_unlock(&rdev->mutex);
 	return ret;
 }
@@ -1160,6 +1151,11 @@ static int _regulator_disable(struct reg
 {
 	int ret = 0;
 
+	if (WARN(rdev->use_count <= 0,
+			"unbalanced disables for %s\n",
+			rdev->desc->name))
+		return -EIO;
+
 	/* are we the last user and permitted to disable ? */
 	if (rdev->use_count == 1 && !rdev->constraints->always_on) {
 
@@ -1208,16 +1204,7 @@ int regulator_disable(struct regulator *
 	int ret = 0;
 
 	mutex_lock(&rdev->mutex);
-	if (regulator->enabled == 1) {
-		ret = _regulator_disable(rdev);
-		if (ret == 0)
-			regulator->uA_load = 0;
-	} else if (WARN(regulator->enabled <= 0,
-			"unbalanced disables for supply %s\n",
-			regulator->supply_name))
-		ret = -EIO;
-	if (ret == 0)
-		regulator->enabled--;
+	ret = _regulator_disable(rdev);
 	mutex_unlock(&rdev->mutex);
 	return ret;
 }
@@ -1264,7 +1251,6 @@ int regulator_force_disable(struct regul
 	int ret;
 
 	mutex_lock(&regulator->rdev->mutex);
-	regulator->enabled = 0;
 	regulator->uA_load = 0;
 	ret = _regulator_force_disable(regulator->rdev);
 	mutex_unlock(&regulator->rdev->mutex);
