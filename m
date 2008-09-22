Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbYIVVAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbYIVVAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYIVVAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:00:14 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:36990 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYIVVAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:00:12 -0400
Message-ID: <48D8074F.9030106@freescale.com>
Date: Mon, 22 Sep 2008 15:59:59 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       leoli@freescale.com
Subject: Re: [PATCH] fsl-dma: allow Freescale Elo DMA driver to be compiled
 as a module
References: <1221755059-27204-1-git-send-email-timur@freescale.com> <e9c3a7c20809201432y31da1e00mf3a20c60b918fab1@mail.gmail.com>
In-Reply-To: <e9c3a7c20809201432y31da1e00mf3a20c60b918fab1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:

> The last three hunks should be broken out into a separate 'fix' patch
> with its own changelog.

Can you be more specific?  I can see how "return 0" -> "return -ENOMEM" could be
separated out, but the Kconfig hunk is integral to the patch, and the "if
(fsl_chan->desc_pool) return 1;" is needed to prevent a memory leak if the
module is unloaded.

>> -static __init int of_fsl_dma_chan_init(void)
>> +static void fsl_dma_chan_remove(struct fsl_dma_chan *fchan)
>>  {
>> -       return of_register_platform_driver(&of_fsl_dma_chan_driver);
>> +       if (fchan) {
>> +               of_device_unregister(fchan->of_dev);
>> +
>> +               free_irq(fchan->irq, fchan);
>> +               list_del(&fchan->common.device_node);
>> +               iounmap(fchan->reg_base);
>> +               kfree(fchan);
>> +       }
>>  }
> 
> removing a NULL fchan should be an error right?  

No, this is a side-effect of not using a linked-list to store the channels found
by the driver.  The driver has a 4-element array to store the channel info.
Normally, all four channels are defined in the OF device tree, so all four
elements are defined.  But it's not a requirement, so in those cases, the
non-defined channels will have NULL for fchan.

I have plans to replace the array with a linked list.  This change will fix a
few other minor problems with the driver.

> Perhaps move the
> check up to of_fsl_dma_remove().

I can do that.

-- 
Timur Tabi
Linux kernel developer at Freescale
