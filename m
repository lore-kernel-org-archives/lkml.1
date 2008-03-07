Return-Path: <linux-kernel-owner+w=401wt.eu-S1760831AbYCGIl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831AbYCGIl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759898AbYCGIlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:41:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757148AbYCGIlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:41:03 -0500
Date: Fri, 7 Mar 2008 00:39:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [UPDATED v3][PATCH 4/7] regulator: framework core
Message-Id: <20080307003910.72fb8043.akpm@linux-foundation.org>
In-Reply-To: <1204827115.15360.150.camel@a10323.wolfsonmicro.main>
References: <1204827115.15360.150.camel@a10323.wolfsonmicro.main>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Mar 2008 18:11:54 +0000 Liam Girdwood <lg@opensource.wolfsonmicro.com> wrote:

> This patch provides the regulator framework core. The core also provides a
> sysfs interface for userspace information.
> 
> +/* gets the regulator for a given consumer device */
> +static struct regulator *get_device_regulator(struct device *dev)
> +{
> +	struct regulator *regulator = NULL;
> +	struct regulator_cdev *rcdev;
> +
> +	mutex_lock(&regulator_list_mutex);
> +	list_for_each_entry(rcdev, &regulator_list, list) {
> +		mutex_lock(&rcdev->mutex);
> +		list_for_each_entry(regulator, &rcdev->consumer_list, list) {
> +			if (regulator->dev == dev) {
> +				mutex_unlock(&rcdev->mutex);
> +				return regulator;
> +			}
> +		}
> +		mutex_unlock(&rcdev->mutex);
> +	}
> +	mutex_unlock(&regulator_list_mutex);
> +	return NULL;
> +}

Is this really supposed to return with the list lock held?  If so, some
comment describing the overall locking design here would be better than
having to reverse-engineer it.

> +static inline int get_lowest_stable_voltage(struct regulator_cdev *rcdev)
> +{
> +	struct regulator *regulator;
> +	int highest_uV = 0;
> +
> +	/* lock is held by caller */
> +	list_for_each_entry(regulator, &rcdev->consumer_list, list) {
> +		if (regulator->enabled && regulator->uV_required > highest_uV)
> +			highest_uV = regulator->uV_required;
> +	}
> +	return highest_uV;
> +}

Too large to inline - the compiler will do this for you if it is a benefit
to do so.

> +/* Calculate the new optimum regulator operating mode based on the new total
> + * consumer load. All locks held by caller */
> +static void drms_uA_update(struct regulator_cdev *rcdev)
> +{
> +	struct regulator *sibling;
> +	int current_uA = 0, output_uV, input_uV, err;
> +	unsigned int mode;
> +
> +	err = regulator_check_drms(rcdev);
> +	if (err < 0 || !rcdev->desc->ops->get_optimum_mode ||
> +	    !rcdev->desc->ops->get_voltage || !rcdev->desc->ops->set_mode);
> +	return;
> +
> +	/* get output voltage */
> +	output_uV = rcdev->desc->ops->get_voltage(rcdev);
> +
> +	/* get input voltage */
> +	if (rcdev->parent && rcdev->parent->desc->ops->get_voltage)
> +		input_uV = rcdev->parent->desc->ops->get_voltage(rcdev->parent);
> +	else
> +		input_uV = rcdev->constraints->input_uV;
> +
> +	/* calc total requested load */
> +	list_for_each_entry(sibling, &rcdev->consumer_list, list)
> +	    current_uA += sibling->uA_load;

Should be indented with a tab, not spacespacespacespace

> +	/* now get the optimum mode for our new total regulator load */
> +	mode = rcdev->desc->ops->get_optimum_mode(rcdev, input_uV,
> +						  output_uV, current_uA);
> +
> +	/* check the new mode is allowed */
> +	err = regulator_check_mode(rcdev, mode);
> +	if (err == 0)
> +		rcdev->desc->ops->set_mode(rcdev, mode);
> +}
> +
> +#define REG_STR_SIZE	32
> +

