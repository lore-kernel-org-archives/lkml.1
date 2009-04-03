Return-Path: <linux-kernel-owner+w=401wt.eu-S1761347AbZDCKOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761347AbZDCKOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 06:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbZDCKOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 06:14:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36687 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbZDCKOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 06:14:07 -0400
Message-ID: <49D5E16A.80104@garzik.org>
Date: Fri, 03 Apr 2009 06:14:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
References: <20090402015455.GA14087@havoc.gtf.org> <1238722324.13399.25.camel@mulgrave.int.hansenpartnership.com>
In-Reply-To: <1238722324.13399.25.camel@mulgrave.int.hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
>> +   1) Map a Linux block device to an existing OSD object.
>> +
>> +      In this example, we will use partition id 1234, object id 5678,
>> +      OSD device /dev/osd1.
>> +
>> +      $ echo "1234 5678 /dev/osd1" > /sys/class/osdblk/add
>> +
>> +
>> +   2) List all active blkdev<->object mappings.
>> +
>> +      In this example, we have performed step #1 twice, creating two blkdevs,
>> +      mapped to two separate OSD objects.
>> +
>> +      $ cat /sys/class/osdblk/list
>> +      0 174 1234 5678 /dev/osd1
>> +      1 179 1994 897123 /dev/osd0
> 
> This is a slight violation of the one piece of data per sysfs file
> rule ... might it not be better as a file named <partid>-<objid> linking
> to the osd device location in sysfs?

Yeah...   I leaned more towards a consolidated table, as it was 
elegantly implemented in just a few lines of code, including locking :)


>> +      The columns, in order, are:
>> +      - blkdev unique id
>> +      - blkdev assigned major
>> +      - OSD object partition id
>> +      - OSD object id
>> +      - OSD device
>> +
>> +
>> +   3) Remove an active blkdev<->object mapping.
>> +


>> +	unsigned long		obj_id;
>> +	char			osd_path[0];
>> +};
>> +
>> +static struct class *class_osdblk;		/* /sys/class/osdblk */
>> +static struct mutex ctl_mutex;	/* Serialize open/close/setup/teardown */
>> +static struct osdblk_device *osdblk_devs[OSDBLK_MAX_DEVS];
> 
> Might it not be better to do this as a linked list on the private dev
> structure instead?  This only works if you have one entry
> in /sys/class/osdblock per device because now you have a device private
> pointer to hang it off

converted to list



>> +static int osdblk_get_free_req(struct osdblk_device *osdev)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < OSDBLK_MAX_REQ; i++) {
>> +		if (!osdev->req[i].rq)
>> +			return i;
>> +	}
> 
> Rather than using a static list of outstanding requests, I think you
> could probably use the block tag handling infrastructure for all of this

converted to use blk-tag.c gadgetry

Thanks for the review!

	Jeff


