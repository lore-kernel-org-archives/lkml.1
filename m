Return-Path: <linux-kernel-owner+w=401wt.eu-S1761310AbXIZThV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761310AbXIZThV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 15:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbXIZThJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 15:37:09 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:52193 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbXIZThI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 15:37:08 -0400
Message-ID: <46FAB4DF.4040901@tiscali.nl>
Date: Wed, 26 Sep 2007 21:37:03 +0200
From: roel <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Konrad Rzeszutek <konrad@darnok.org>
CC: linux-kernel@vger.kernel.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com
Subject: Re: [PATCH] Add iSCSI iBFT support.
References: <20070926184652.GA16369@andromeda.dapyr.net>
In-Reply-To: <20070926184652.GA16369@andromeda.dapyr.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek wrote:

[...]

> +static ssize_t
> +ibft_read_binary(struct kobject *kobj, struct bin_attribute *attr, char *buf,
> +		 loff_t off, size_t count)
> +{
> +
> +	struct ibft_device *ibft = container_of(kobj, struct ibft_device, kobj);
> +	ssize_t len = ibft->hdr->length;
> +
> +	if (off > len)
> +		return 0;
> +
> +	if (off + count > len)
> +		count = len - off;

maybe you want to use:

count = min(count, len - off)

> +
> +	memcpy(buf, ibft->hdr + off, count);
> +
> +	return count;
> +}

[...]

> +static struct ibft_device *ibft_idev;
> +/*
> + * ibft_init() - creates  sysfs tree entry for ibft data
> + */
> +static int __init ibft_init(void)
> +{
> +	int rc = 0;
> +
> +	printk(KERN_INFO "BIOS iBFT facility v%s %s\n", ISCSI_IBFT_VERSION,
> +	       ISCSI_IBFT_DATE);
> +
> +	if (!ibft_phys)
> +		find_ibft();
> +
> +	/* What if the ibft_subsys is underneath another struct? */
> +	rc = firmware_register(&ibft_subsys);
> +	if (rc)
> +		return rc;
> +
> +	if (ibft_phys) {
> +		printk(KERN_INFO "iBFT detected at 0x%lx.\n",
> +		       (unsigned long)ibft_phys);
> +		ibft_idev = kzalloc(sizeof(*ibft_idev), GFP_KERNEL);
> +		if (!ibft_idev)
> +			return -ENOMEM;
> +
> +		rc = ibft_device_register(ibft_idev);
> +		if (rc) {
> +			kfree(ibft_idev);
> +			return rc;
> +		}

you could do without this return statement (and the brackets) since rc is returned anyway...

> +	} else {
> +		printk(KERN_INFO "No iBFT detected.\n");
> +	}

these brackets are not required either

> +	return rc;

... here

> +}

[...]

Roel
