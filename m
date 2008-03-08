Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYCHRY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYCHRY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 12:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbYCHRYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 12:24:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39796 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753691AbYCHRYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 12:24:50 -0500
Subject: Re: [UPDATED v3][PATCH 4/7] regulator: framework core
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20080307003910.72fb8043.akpm@linux-foundation.org>
References: <1204827115.15360.150.camel@a10323.wolfsonmicro.main>
	 <20080307003910.72fb8043.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 08 Mar 2008 17:24:46 +0000
Message-Id: <1204997086.13653.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-07 at 00:39 -0800, Andrew Morton wrote:
> On Thu, 06 Mar 2008 18:11:54 +0000 Liam Girdwood <lg@opensource.wolfsonmicro.com> wrote:
> 
> > This patch provides the regulator framework core. The core also provides a
> > sysfs interface for userspace information.
> > 
> > +/* gets the regulator for a given consumer device */
> > +static struct regulator *get_device_regulator(struct device *dev)
> > +{
> > +	struct regulator *regulator = NULL;
> > +	struct regulator_cdev *rcdev;
> > +
> > +	mutex_lock(&regulator_list_mutex);
> > +	list_for_each_entry(rcdev, &regulator_list, list) {
> > +		mutex_lock(&rcdev->mutex);
> > +		list_for_each_entry(regulator, &rcdev->consumer_list, list) {
> > +			if (regulator->dev == dev) {
> > +				mutex_unlock(&rcdev->mutex);
> > +				return regulator;
> > +			}
> > +		}
> > +		mutex_unlock(&rcdev->mutex);
> > +	}
> > +	mutex_unlock(&regulator_list_mutex);
> > +	return NULL;
> > +}
> 
> Is this really supposed to return with the list lock held?  If so, some
> comment describing the overall locking design here would be better than
> having to reverse-engineer it.
> 
> > +static inline int get_lowest_stable_voltage(struct regulator_cdev *rcdev)
> > +{
> > +	struct regulator *regulator;
> > +	int highest_uV = 0;
> > +
> > +	/* lock is held by caller */
> > +	list_for_each_entry(regulator, &rcdev->consumer_list, list) {
> > +		if (regulator->enabled && regulator->uV_required > highest_uV)
> > +			highest_uV = regulator->uV_required;
> > +	}
> > +	return highest_uV;
> > +}
> 
> Too large to inline - the compiler will do this for you if it is a benefit
> to do so.
> 
> > +/* Calculate the new optimum regulator operating mode based on the new total
> > + * consumer load. All locks held by caller */
> > +static void drms_uA_update(struct regulator_cdev *rcdev)
> > +{
> > +	struct regulator *sibling;
> > +	int current_uA = 0, output_uV, input_uV, err;
> > +	unsigned int mode;
> > +
> > +	err = regulator_check_drms(rcdev);
> > +	if (err < 0 || !rcdev->desc->ops->get_optimum_mode ||
> > +	    !rcdev->desc->ops->get_voltage || !rcdev->desc->ops->set_mode);
> > +	return;
> > +
> > +	/* get output voltage */
> > +	output_uV = rcdev->desc->ops->get_voltage(rcdev);
> > +
> > +	/* get input voltage */
> > +	if (rcdev->parent && rcdev->parent->desc->ops->get_voltage)
> > +		input_uV = rcdev->parent->desc->ops->get_voltage(rcdev->parent);
> > +	else
> > +		input_uV = rcdev->constraints->input_uV;
> > +
> > +	/* calc total requested load */
> > +	list_for_each_entry(sibling, &rcdev->consumer_list, list)
> > +	    current_uA += sibling->uA_load;
> 
> Should be indented with a tab, not spacespacespacespace

This patch releases the lock in get_device_regulator(), makes
get_lowest_stable_voltage() non inline and fixes a minor indentation
issue.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
---
 drivers/regulator/reg-core.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/reg-core.c b/drivers/regulator/reg-core.c
index 56367ab..e29584f 100644
--- a/drivers/regulator/reg-core.c
+++ b/drivers/regulator/reg-core.c
@@ -85,6 +85,7 @@ static struct regulator *get_device_regulator(struct device *dev)
 		list_for_each_entry(regulator, &rcdev->consumer_list, list) {
 			if (regulator->dev == dev) {
 				mutex_unlock(&rcdev->mutex);
+				mutex_unlock(&regulator_list_mutex);
 				return regulator;
 			}
 		}
@@ -336,7 +337,7 @@ struct class regulator_class = {
 };
 
 /* find the lowest stable voltage that all enabled clients can operate at */
-static inline int get_lowest_stable_voltage(struct regulator_cdev *rcdev)
+static int get_lowest_stable_voltage(struct regulator_cdev *rcdev)
 {
 	struct regulator *regulator;
 	int highest_uV = 0;
@@ -387,7 +388,7 @@ static void drms_uA_update(struct regulator_cdev *rcdev)
 
 	/* calc total requested load */
 	list_for_each_entry(sibling, &rcdev->consumer_list, list)
-	    current_uA += sibling->uA_load;
+			   current_uA += sibling->uA_load;
 
 	/* now get the optimum mode for our new total regulator load */
 	mode = rcdev->desc->ops->get_optimum_mode(rcdev, input_uV,
-- 
1.5.4.3



