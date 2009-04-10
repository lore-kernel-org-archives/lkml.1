Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbZDJE4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbZDJE4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 00:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbZDJE4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 00:56:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbZDJE4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 00:56:11 -0400
Date: Thu, 9 Apr 2009 21:52:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       LKML-SCSI <linux-scsi@vger.kernel.org>, andrew.patterson@hp.com,
       mike.miller@hp.com
Subject: Re: [PATCH 1/1] cciss: resubmit export uid, model, vendor, rev to
 sysfs
Message-Id: <20090409215226.8b03bc2b.akpm@linux-foundation.org>
In-Reply-To: <20090407180411.GA4324@beardog.cca.cpqcorp.net>
References: <20090407180411.GA4324@beardog.cca.cpqcorp.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009 13:04:11 -0500 "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:

> Patch 1 of 1 resubmit
> 
> cciss: add cciss driver sysfs entries
> 
> This patch adds sysfs entries to the cciss driver needed for the
> dm/multipath tools. A file for vendor, model, rev, and unique_id are
> added for each logical drive under directory
> /sys/bus/pci/devices/<dev>/ccissX/cXdY. Where X = the controller (or
> host) number and Y is the logical drive number. A link from
> /sys/bus/pci/devices/<dev>/ccissX/cXdY/block:cciss!cXdY to
> /sys/block/cciss!cXdY/device is also created.
> 
> ...
>
> +static ssize_t dev_show_model(struct device *dev,
> +			      struct device_attribute *attr,
> +			      char *buf)
> +{
> +	drive_info_struct *drv = to_drv(dev);
> +	struct ctlr_info *h = to_hba(drv->dev.parent);
> +	char model[MODEL_LEN + 1];
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
> +	if (h->busy_configuring)
> +		ret = -EBUSY;
> +	else
> +		memcpy(model, drv->model, MODEL_LEN + 1);
> +	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
> +
> +	if (ret)
> +		return ret;
> +	else
> +		return snprintf(buf, MODEL_LEN + 2, "%s\n", drv->model);

Isn't the buffer sizing wrong here?  Should be MODEL_LEN+1.

> +}
> +DEVICE_ATTR(model, S_IRUGO, dev_show_model, NULL);
> +
> +static ssize_t dev_show_rev(struct device *dev,
> +			    struct device_attribute *attr,
> +			    char *buf)
> +{
> +	drive_info_struct *drv = to_drv(dev);
> +	struct ctlr_info *h = to_hba(drv->dev.parent);
> +	char rev[REV_LEN + 1];
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	spin_lock_irqsave(CCISS_LOCK(h->ctlr), flags);
> +	if (h->busy_configuring)
> +		ret = -EBUSY;
> +	else
> +		memcpy(rev, drv->rev, REV_LEN + 1);
> +	spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
> +
> +	if (ret)
> +		return ret;
> +	else
> +		return snprintf(buf, REV_LEN + 2, "%s\n", drv->rev);

Repeated in various places.

> +}

