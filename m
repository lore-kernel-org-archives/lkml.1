Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbYHLQPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbYHLQPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 12:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbYHLQP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 12:15:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:40126 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYHLQP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 12:15:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ipAdn0/DwfpnjOKVteFS6V6lsyK+GRVXk2N73mDkpCtNUlpBdz7jmh42NxG/sjQDCm
         2W6e0nHZFz9k/Y/x8UzD+COlnqXqEPDOgZw+IB+WiEIMG7aNiRZ5kgvdUGVaatIO9IAe
         Kea/HPGRWJJORvqXlwWFYKRL5Zlgz/63ZeJ7g=
Message-ID: <48A1B71C.6080201@gmail.com>
Date: Tue, 12 Aug 2008 18:15:24 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Marcin Obara <marcin_obara@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, pavel@suse.cz
Subject: Re: [PATCH] Intel Management Engine Interface
References: <alpine.DEB.1.00.0807172021450.26825@ip-195-3-221-75.vnet.pl>	<alpine.DEB.1.00.0807180742560.7868@ip-195-3-221-75.vnet.pl>	<alpine.DEB.1.00.0807181938180.12442@ip-195-3-221-75.vnet.pl>	<alpine.DEB.1.00.0807182122460.24146@ip-195-3-221-75.vnet.pl>	<alpine.DEB.1.00.0807182229070.30162@ip-195-3-221-75.vnet.pl>	<alpine.DEB.1.00.0807231958130.20791@ip-195-3-221-75.vnet.pl>	<alpine.DEB.1.00.0808112115140.6724@ip-195-3-221-75.vnet.pl> <20080811215340.2c0635dd.akpm@linux-foundation.org>
In-Reply-To: <20080811215340.2c0635dd.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2008 06:53 AM, Andrew Morton wrote:
> On Mon, 11 Aug 2008 21:23:01 +0200 (CEST)
> Marcin Obara <marcin_obara@users.sourceforge.net> wrote:
>> +/*
>> + * error code definition
>> + */
>> +#define     ESLOTS_OVERFLOW              1
>> +#define     ECORRUPTED_MESSAGE_HEADER    1000
>> +#define     ECOMPLETE_MESSAGE            1001
> 
> What's this?  The driver defines its onw errno numbers?
> 
> Are these ever returned to userspace?
> 
> This is risky/confusing/misleading, isn't it?

Yes and already pointed out. This leaks to userspace and it's wrong. Please go 
and read my comments to version #1 once again and if you don't understand 
anything, please drop a message, but do not silently ignore others' comments.

E.g. unlocked_ioctl switch hasn't been done plus other things mentioned below 
too (not all of them)

>> +static void host_init_wd(struct iamt_heci_device *dev)
>> +{
>> +	spin_lock_bh(&dev->device_lock);
>> +
>> +	heci_init_file_private(&dev->wd_file_ext, NULL);
>> +
>> +	/* look for WD client and connect to it */
>> +	dev->wd_file_ext.state = HECI_FILE_DISCONNECTED;
>> +	dev->wd_timeout = 0;
>> +
>> +	if (dev->asf_mode) {
>> +		memcpy(dev->wd_data, heci_stop_wd_params, HECI_WD_PARAMS_SIZE);
>> +	} else {
>> +		/* AMT mode */
>> +		dev->wd_timeout = AMT_WD_VALUE;
>> +		DBG("dev->wd_timeout=%d.\n", dev->wd_timeout);
>> +		memcpy(dev->wd_data, heci_start_wd_params, HECI_WD_PARAMS_SIZE);
>> +		memcpy(dev->wd_data + HECI_WD_PARAMS_SIZE,
>> +		       &dev->wd_timeout, sizeof(__u16));
>> +	}
>> +
>> +	/* find ME WD client */
>> +	heci_find_me_client(dev, &dev->wd_file_ext,
>> +			    &heci_wd_guid, HECI_WD_HOST_CLIENT_ID);
>> +	spin_unlock_bh(&dev->device_lock);
>> +
>> +	DBG("check wd_file_ext\n");
>> +	if (HECI_FILE_CONNECTING == dev->wd_file_ext.state) {
>> +		if (heci_connect_me_client(dev, &dev->wd_file_ext, 15) == 1) {
>> +			DBG("dev->wd_timeout=%d.\n", dev->wd_timeout);
>> +			if (dev->wd_timeout != 0)
>> +				dev->wd_due_counter = 1;
>> +			else
>> +				dev->wd_due_counter = 0;
>> +			DBG("successfully connected to WD client.\n");
>> +		}
>> +	} else
>> +		DBG("failed to find WD client.\n");
>> +
>> +
>> +	spin_lock_bh(&dev->device_lock);
>> +	dev->wd_timer.function = &heci_wd_timer;
>> +	dev->wd_timer.data = (unsigned long) dev;
>> +	spin_unlock_bh(&dev->device_lock);
> 
> Use setup_timer().
> 
> Note that setup_timer() does init_timer(), but we already have an
> init_timer(dev->wd_timer) elsewhere.  Please sort that out.

Already commented, left unchanged and without an explanation.

>> +/* IOCTL commands */
>> +#define IOCTL_HECI_GET_VERSION \
>> +    _IOWR('H' , 0x0, struct heci_message_data)
>> +#define IOCTL_HECI_CONNECT_CLIENT \
>> +    _IOWR('H' , 0x01, struct heci_message_data)
>> +#define IOCTL_HECI_WD \
>> +    _IOWR('H' , 0x02, struct heci_message_data)
>> +#define IOCTL_HECI_BYPASS_WD \
>> +    _IOWR('H' , 0x10, struct heci_message_data)
> 
> So this driver implements ioctls!
> 
> That is a core, top-level, userspace-visible design decision!  It
> should have been given prominent billing in the changelog description.
> 
> 
> These four values are supposed to be exported to userspace headers,
> yes?  But they're buried in a kernel-internal header and don't have the
> appropriate __KERNEL__ wrappers.

... and conflicts with hid as I commented before. Also ioctl-number.txt update 
should be done.

>> +	if (!dev->mem_addr) {
>> +		printk(KERN_ERR "heci: Remap IO device memory failure.\n");
>> +		err = -ENOMEM;
>> +		goto free_device;
>> +	}
>> +	/* request and enable interrupt   */
>> +	err = request_irq(pdev->irq, heci_isr_interrupt, IRQF_SHARED,
>> +			heci_driver_name, dev);
> 
> Doing request_irq() after pci_enable_device() is dengerous.  If the
> device happened to be requesting an interrupt when we did
> pci_enable_device(), things will generally go pear-shaped.

Hm, no, pci_enable_device sets up irq (i.e. even pdev->irq), this is correct 
sequence. Actually one should not touch pdev before enabling the device it's 
describing in most cases.
