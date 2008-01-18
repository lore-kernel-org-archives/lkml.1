Return-Path: <linux-kernel-owner+w=401wt.eu-S1763809AbYARTl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763809AbYARTl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760441AbYARTlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:41:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:43239 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759024AbYARTlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:41:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=MkGru/ReNUFWEEkIjv3HSKIBe36KzAThj/Hxg/i8JgEpgfGn9h8EJhU1Rm+0Q3Cn4ebKKVtq1xYSfOCpN+W6/zf2QIBiRMa2WSsR+tXjpsPo6CgaxZpaw3QIQxaUAkw5vT48ib/8+8GhgSkm1h8jE1Gdq/267sj66AX+YuqXA2k=
Message-ID: <479100DA.20401@gmail.com>
Date: Fri, 18 Jan 2008 20:41:14 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       auke-jan.h.kok@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, john.ronciak@intel.com,
       e1000-devel@lists.sourceforge.net, venkatesh.pallipadi@intel.com
Subject: Re: [PATCH 1/1] Net: e100, fix iomap mem accesses
References: <1200608900-3507-1-git-send-email-jirislaby@gmail.com> <4791004B.50408@garzik.org>
In-Reply-To: <4791004B.50408@garzik.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2008 08:38 PM, Jeff Garzik wrote:
> Jiri Slaby wrote:
>> readX functions are not permitted on iomap-ped space change to ioreadX,
>> also pci_unmap pci_map-ped space on exit (instead of iounmap).
>>
>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>> ---
>>  drivers/net/e100.c |    8 ++++----
>>  1 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/e100.c b/drivers/net/e100.c
>> index 51cf577..47548ef 100644
>> --- a/drivers/net/e100.c
>> +++ b/drivers/net/e100.c
>> @@ -1836,7 +1836,7 @@ static int e100_rx_indicate(struct nic *nic, 
>> struct rx *rx,
>>          if ((le16_to_cpu(rfd->command) & cb_el) &&
>>              (RU_RUNNING == nic->ru_running))
>>  
>> -            if (readb(&nic->csr->scb.status) & rus_no_res)
>> +            if (ioread8(&nic->csr->scb.status) & rus_no_res)
>>                  nic->ru_running = RU_SUSPENDED;
>>          return -ENODATA;
>>      }
>> @@ -1859,7 +1859,7 @@ static int e100_rx_indicate(struct nic *nic, 
>> struct rx *rx,
>>      if ((le16_to_cpu(rfd->command) & cb_el) &&
>>          (RU_RUNNING == nic->ru_running)) {
>>  
>> -        if (readb(&nic->csr->scb.status) & rus_no_res)
>> +        if (ioread8(&nic->csr->scb.status) & rus_no_res)
>>          nic->ru_running = RU_SUSPENDED;
>>      }
>>  
>> @@ -1958,7 +1958,7 @@ static void e100_rx_clean(struct nic *nic, 
>> unsigned int *work_done,
>>  
>>      if(restart_required) {
>>          // ack the rnr?
>> -        writeb(stat_ack_rnr, &nic->csr->scb.stat_ack);
>> +        iowrite8(stat_ack_rnr, &nic->csr->scb.stat_ack);
>>          e100_start_receiver(nic, nic->rx_to_clean);
>>          if(work_done)
>>              (*work_done)++;
>> @@ -2774,7 +2774,7 @@ static void __devexit e100_remove(struct pci_dev 
>> *pdev)
>>          struct nic *nic = netdev_priv(netdev);
>>          unregister_netdev(netdev);
>>          e100_free(nic);
>> -        iounmap(nic->csr);
>> +        pci_iounmap(pdev, nic->csr);
>>          free_netdev(netdev);
>>          pci_release_regions(pdev);
> 
> ACK, but patch doesn't seem to apply...

It's against 2.6.24-rc8-mm1. Doesn't apply against net.git?
