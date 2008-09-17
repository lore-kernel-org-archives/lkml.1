Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbYIQSL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbYIQSL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 14:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbYIQSLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 14:11:05 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:60315 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbYIQSLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 14:11:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=W0OvhUA30CESYCD3CULrwlkWNJj2svs+xgHHzy7nj6I9RDcrBbhqBmbKJTdo6gis90
         1X2JsZzNGn8BW0/t4wDInac6dpSlssoUOEviA8dXceriQC0v/DtTAmXpuEcmlX5XXdpB
         e5oKYcVw9H1cDgKhENujFpIF+VyqgYQzlcTDM=
Message-ID: <48D1479C.9040702@gmail.com>
Date: Wed, 17 Sep 2008 11:08:28 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4 v2] libata: Implement disk shock protection support
References: <87d4j2n3dn.fsf@denkblock.local> <20080917163144.9870.97008.stgit@denkblock.local>
In-Reply-To: <20080917163144.9870.97008.stgit@denkblock.local>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Elias.

Looks generally good.  Just a few points.

Elias Oltmanns wrote:
> +static void ata_eh_pull_action(struct ata_link *link, struct ata_device *dev,
> +			unsigned int action)
> +{
> +	struct ata_port *ap = link->ap;
> +	struct ata_eh_info *ehi = &link->eh_info, *ehci = &link->eh_context.i;
> +	struct ata_device *tdev;
> +	unsigned int taction;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(ap->lock, flags);
> +
> +	if (dev) {
> +		taction = action & (ehi->action | ehi->dev_action[dev->devno]);
> +		ehci->dev_action[dev->devno] |= taction & ATA_EH_PERDEV_MASK;
> +		ehci->action |= taction & ~ATA_EH_PERDEV_MASK;
> +	} else {
> +		if (WARN_ON(action & ATA_EH_PERDEV_MASK))
> +			action &= ~ATA_EH_PERDEV_MASK;
> +		ata_link_for_each_dev(tdev, link)
> +			taction |= ehi->dev_action[tdev->devno] & action;

taction seems to be being used uninitialized.

> +	do {
> +		unsigned long now;
> +
> +		deadline = jiffies;
> +		ata_port_for_each_link(link, ap) {
> +			ata_link_for_each_dev(dev, link) {
> +				struct ata_eh_info *ehi = &link->eh_context.i;
> +
> +				if (dev->class != ATA_DEV_ATA)
> +					continue;
> +
> +				ata_eh_pull_action(link, dev, ATA_EH_PARK);
> +				if (ehi->dev_action[dev->devno] & ATA_EH_PARK) {
> +					unsigned long tmp =
> +						dev->unpark_deadline;
> +
> +					if (time_before(deadline, tmp))
> +						deadline = tmp;
> +					else if (time_before_eq(tmp, jiffies))
> +						continue;
> +				}
> +
> +				ata_eh_park_issue_cmd(dev, 1);
> +			}
> +		}
> +		now = jiffies;
> +		if (time_before_eq(deadline, now))
> +			break;
> +		prepare_to_wait(&ata_scsi_park_wq, &wait, TASK_UNINTERRUPTIBLE);

Doesn't prepare_to_wait() have to come before pull_action and timeout
check?  Which in turn means that it should be a completion instead of
wait combined with INIT_COMPLETION because thread state can't be used
to track wake up as ata_eh_park_issue_cmd() sleeps.

Thanks.  :-)

-- 
tejun
