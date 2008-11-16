Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbYKPXFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbYKPXFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 18:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYKPXFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 18:05:11 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:40667 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753910AbYKPXFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 18:05:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=T4AdztX7B50aqFki8jYv8lqYq52DuHXlmQ47SZK/KE0SFsf+ZQsUqmhSNbD28vAx/Dq9l3pwD8uUXAecNUTFqVZgEkYQcsz+1nwTzMy8FuvxxxMLRjhwDeXVdn+Ca2hkuSyHSPWt7rqG+O26OBEhYDm+7ORMhXcQ1qReS6hUE30=  ;
X-YMail-OSG: E1bUOKgVM1lGQksSjXkM2TC12qW8PdadHwi4Ioxwh5v8T0iO9_XTUTJYmq.y6dJYOYce8UgZmzyv8aDnhz5kEgjWS3le5.qjff3A1qQX6dt4bs3kplB38hK6FqH9pwme22LF1tsZn_iG3E_Cg9e.XoEM0zfTfDaVNKnE7vAZ5bJuD1G7a9E9GATr8Zd9
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lrg@slimlogic.co.uk>, Mark Underwood <basicmark@yahoo.com>
Subject: [patch 2.6.28-rc5] regulator: improved mode error checks
Date: Sun, 16 Nov 2008 11:46:56 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811161146.56874.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Minor bugfixes in handling of regulator modes:

 - have the routine verifying regulator modes check against
   the set of legal modes (!);

 - have regulator_set_optimum_mode() verify the return value
   of regulator_ops.get_optimum_mode(), like drms_uA_update();

 - one call to regulator_ops.set_mode() treated zero as a
   failure code; make this consistent with other callers.

Both regulator_set_mode() and regulator_set_optimum_mode() now
require valid_ops_mask to include REGULATOR_CHANGE_MODE; that
seems like a bugfix too.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/regulator/core.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -174,6 +174,16 @@ static int regulator_check_current_limit
 /* operating mode constraint check */
 static int regulator_check_mode(struct regulator_dev *rdev, int mode)
 {
+	switch (mode) {
+	case REGULATOR_MODE_FAST:
+	case REGULATOR_MODE_NORMAL:
+	case REGULATOR_MODE_IDLE:
+	case REGULATOR_MODE_STANDBY:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	if (!rdev->constraints) {
 		printk(KERN_ERR "%s: no constraints for %s\n", __func__,
 		       rdev->desc->name);
@@ -1463,7 +1473,8 @@ int regulator_set_optimum_mode(struct re
 	mode = rdev->desc->ops->get_optimum_mode(rdev,
 						 input_uV, output_uV,
 						 total_uA_load);
-	if (ret <= 0) {
+	ret = regulator_check_mode(rdev, mode);
+	if (ret < 0) {
 		printk(KERN_ERR "%s: failed to get optimum mode for %s @"
 			" %d uA %d -> %d uV\n", __func__, rdev->desc->name,
 			total_uA_load, input_uV, output_uV);
@@ -1471,7 +1482,7 @@ int regulator_set_optimum_mode(struct re
 	}
 
 	ret = rdev->desc->ops->set_mode(rdev, mode);
-	if (ret <= 0) {
+	if (ret < 0) {
 		printk(KERN_ERR "%s: failed to set optimum mode %x for %s\n",
 			__func__, mode, rdev->desc->name);
 		goto out;
