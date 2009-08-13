Return-Path: <linux-kernel-owner+w=401wt.eu-S1751789AbZHME3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbZHME3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 00:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbZHME3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 00:29:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43521 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbZHME3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 00:29:50 -0400
Message-ID: <4A8396B3.6090609@redhat.com>
Date: Thu, 13 Aug 2009 12:29:39 +0800
From: Danny Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: john.ronciak@intel.com, peter.p.waskiewicz.jr@intel.com,
       bruce.w.allan@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] e1000e: fix use of pci_enable_pcie_error_reporting
References: <1249637774-32419-1-git-send-email-dfeng@redhat.com> <20090812.204621.87530668.davem@davemloft.net>
In-Reply-To: <20090812.204621.87530668.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2009 11:46 AM, David Miller wrote:
> From: Xiaotian Feng<dfeng@redhat.com>
> Date: Fri,  7 Aug 2009 17:36:14 +0800
>
>> commit 111b9dc5 introduces pcie aer support for e1000e, but it is not
>> reasonable to disable it in e1000_remove but enable it in e1000_resume.
>> This patch enables aer support in e1000_probe.
>>
>> Signed-off-by: Xiaotian Feng<dfeng@redhat.com>
>
> In moving this block of code, you've corrupted the indentation,
> making it more indented than it should be.
>
> In any event, I expect the Intel folks to pick this up.
Yes, I agree.... but each time I resume from suspend or rmmod e1000e, 
there's a warning message like "pci_enable_pcie_error_reporting failed 
0xfffffffb". Since some devices may not support aer, why not silence 
this kind of warning?

modprobe e1000e everything is as usual, but then rmmod e1000e, we'll see 
"pci_disable_pcie_error_reporting failed 0xfffffffb", it is so weird...
>
>> diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
>> index 63415bb..e2f0304 100644
>> --- a/drivers/net/e1000e/netdev.c
>> +++ b/drivers/net/e1000e/netdev.c
>> @@ -4670,14 +4670,6 @@ static int e1000_resume(struct pci_dev *pdev)
>>   		return err;
>>   	}
>>
>> -	/* AER (Advanced Error Reporting) hooks */
>> -	err = pci_enable_pcie_error_reporting(pdev);
>> -	if (err) {
>> -		dev_err(&pdev->dev, "pci_enable_pcie_error_reporting failed "
>> -		                    "0x%x\n", err);
>> -		/* non-fatal, continue */
>> -	}
>> -
>>   	pci_set_master(pdev);
>>
>>   	pci_enable_wake(pdev, PCI_D3hot, 0);
>> @@ -4990,6 +4982,14 @@ static int __devinit e1000_probe(struct pci_dev *pdev,
>>   	if (err)
>>   		goto err_pci_reg;
>>
>> +        /* AER (Advanced Error Reporting) hooks */
>> +        err = pci_enable_pcie_error_reporting(pdev);
>> +        if (err) {
>> +                dev_err(&pdev->dev, "pci_enable_pcie_error_reporting failed "
>> +                                    "0x%x\n", err);
>> +                /* non-fatal, continue */
>> +        }
>> +
>>   	pci_set_master(pdev);
>>   	/* PCI config space info */
>>   	err = pci_save_state(pdev);
>> -- 
>> 1.6.2.5
>>

