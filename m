Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbYDUK3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbYDUK3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbYDUK3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:29:34 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:12024 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbYDUK3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:29:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o1hPAJCW/0QrWDPC8zXss7lXSbSUbMb0UUls3FiEXMT+zYoyqM0rzBeRf3Mcm1LOvmp0tQrzaAIv3Ao5O2VXeibfkwGMDBJkmhOVkBkRpCT4wlol0zwzIUFfoTqwbZ5dZN/gojhCH49tOx0hM7unzDgI4Uc80Pih8WITLmz70zw=
Message-ID: <e1d5030b0804210329j38d3bb8cge62e833088c1e0c@mail.gmail.com>
Date: Mon, 21 Apr 2008 15:59:32 +0530
From: "Midhun A" <midhunagni@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: Userspace - Kernel Space "Connector" test
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <e1d5030b0804040001t2a2b2fd3j75c656ec2318a932@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e1d5030b0803260311j25831caeyd9fc111a06e572e2@mail.gmail.com>
	 <20080327143823.GA20443@2ka.mipt.ru>
	 <e1d5030b0804040001t2a2b2fd3j75c656ec2318a932@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

   I now want to use "connector" inside the MMC host module. The aim
is to get a notification to the userspace when the MMC/SD card is
inserted. I have put the code of the connector module (kernel side)
inside imxmmc.c (ernel version 2.6.22). I am running ucon to receive
the message. The kernel module seems to send the message but ucon is
not able to receive the message. The snipped code is as follows:

#include <linux/connector.h>

static struct cb_id cn_test_id = { 0x7, 0x7 };
static u32 cn_test_timer_counter;

/* The card detector method */
static void imxmci_check_status(unsigned long data)
{
	struct imxmci_host *host = (struct imxmci_host *)data;

	/*Netlink*/
	struct cn_msg *m;
	char cn_data[32] = "SD/MMC Card Status";
	/*Netlink*/

	if( host->pdata->card_present() != host->present ) {
		host->present ^= 1;
		dev_info(mmc_dev(host->mmc), "card %s\n",
		      host->present ? "inserted" : "removed");

	/*Netlink*/

	m = kmalloc(sizeof(*m) + sizeof(cn_data), GFP_ATOMIC);

	if (m) {
		printk("Inside if\n");
		memset(m, 0, sizeof(*m) + sizeof(cn_data));
		memcpy(&m->id, &cn_test_id, sizeof(m->id));
		m->seq = cn_test_timer_counter;
		m->len = sizeof(cn_data);

		m->len =
		    scnprintf(cn_data, sizeof(cn_data), "counter = %u",
			      cn_test_timer_counter) + 1;

		memcpy(m + 1, data, m->len);
		printk("Copied Message\n");		
		cn_netlink_send(m, 0, gfp_any());
		printk("Sent Message\n");		
		kfree(m);
	}
	else
	{
		printk("Memory issue with m\n");
	}			
		cn_test_timer_counter++;

	/*Netlink*/

		set_bit(IMXMCI_PEND_CARD_XCHG_b, &host->pending_events);
		tasklet_schedule(&host->tasklet);
	}

	if(test_bit(IMXMCI_PEND_WAIT_RESP_b, &host->pending_events) ||
	   test_bit(IMXMCI_PEND_DMA_DATA_b, &host->pending_events)) {
		atomic_inc(&host->stuck_timeout);
		if(atomic_read(&host->stuck_timeout) > 4)
			tasklet_schedule(&host->tasklet);
	} else {
		atomic_set(&host->stuck_timeout, 0);

	}

	mod_timer(&host->timer, jiffies + (HZ>>1));
}

I keep the ucon program running. As soon as I insert the card, the
kernel detects that the card is inserted and the printks say that the
message has sent. But ucon does not receive the message.

Any kind of help would be useful.

Thanks,
Midhun.


On 4/4/08, Midhun A <midhunagni@gmail.com> wrote:
> Hey,
>
>   Thanks a lot. I have changed the idx value to 7 and it worked. :)
>
> Thanks,
> Midhun
>
> On Thu, Mar 27, 2008 at 8:08 PM, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> wrote:
> > Hi.
> >
> >
> >  On Wed, Mar 26, 2008 at 03:41:16PM +0530, Midhun A (midhunagni@gmail.com)
> wrote:
> >  >    I want to use the Connector module (CONFIG_CONNECTOR) for Kernel
> >  > space to User space communication.  My kernel version is 2.6.22.
> >  > Before using it, I am trying out the example programs in the
> >  > Documentation folder. I have cn_test.c built into the kernel (not
> >  > loaded as a module) and I have compiled ucon.c.
> >
> >  You have to use smaller index than 32 or increase CN_NETLINK_USERS
> >  parameter in include/linux/connector.h
> >
> >  Currently all kernel users fit that limitation, which is ok.
> >
> >  Also, parameter used in bind() is a bitmap of requested groups, to
> >  listen on 0x123 idx you have to add it via setsockopt(), which is
> >  commented in ucon.c.
> >
> >  So, either switch to smaller group number (connector index) or increase
> >  above limit. If you will select the former case (it is simpler from
> >  userspace point of view), you have to change bind() group, note that it
> >  is a bitmap, os group N equals to (1<<N) bind() value. If you will
> >  select the latter case and recompile connector module, then you have to
> >  uncomment setsockopt() code in ucon.c
> >
> >  Both methods work, and you will get something like this:
> >  $ sudo ./ucon
> >  Thu Mar 27 17:29:19 2008 : [123.457] [00000002.00000000].
> >  Thu Mar 27 17:29:20 2008 : [123.457] [00000003.00000000].
> >  Thu Mar 27 17:29:21 2008 : [123.457] [00000004.00000000].
> >  Thu Mar 27 17:29:22 2008 : [123.457] [00000005.00000000].
> >  Thu Mar 27 17:29:23 2008 : [123.457] [00000006.00000000].
> >
> >  --
> >         Evgeniy Polyakov
> >
>


-- 
Midhun.
