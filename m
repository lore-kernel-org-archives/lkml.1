Return-Path: <linux-kernel-owner+w=401wt.eu-S1761120AbYBNPHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761120AbYBNPHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 10:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbYBNPH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 10:07:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:40981 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbYBNPH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:07:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=eLRgyNcYnHsoXwyK9ase8GweFJrM+5vCiORAQsY7L02I19xhNYbDPPGfIXJyakp6MZxPPI0zeYl4/LVACZJO2adei53C4xUcRsmRgf4WfV4KpdmZj7VvmAkAEqHtIt254xlzCs0jGbID2m4DRVX6Zm2s2PmFccFVDoKfYhl4Jvs=
Message-ID: <47B4592A.5090906@gmail.com>
Date: Thu, 14 Feb 2008 16:07:22 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Sergio Luis <sergio@larces.uece.br>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [SCSI] gdth: update deprecated pci_find_device
References: <200802140059.m1E0xrID025375@hera.kernel.org>	 <47B3C6F5.6060809@garzik.org> <1203000617.3189.8.camel@localhost.localdomain>
In-Reply-To: <1203000617.3189.8.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2008 03:50 PM, James Bottomley wrote:
> On Wed, 2008-02-13 at 23:43 -0500, Jeff Garzik wrote:
>> Linux Kernel Mailing List wrote:
>>> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=99109301d103fbf0de43fc5a580a406c12a501e0
>>> Commit:     99109301d103fbf0de43fc5a580a406c12a501e0
>>> Parent:     61c92814dc324b541391757062ff02fbf3b08086
>>> Author:     Sergio Luis <sergio@larces.uece.br>
>>> AuthorDate: Tue Feb 12 20:48:03 2008 -0300
>>> Committer:  James Bottomley <James.Bottomley@HansenPartnership.com>
>>> CommitDate: Wed Feb 13 09:33:10 2008 -0600
>>>
>>>     [SCSI] gdth: update deprecated pci_find_device
>>>     
>>>     Fix compilation warning in gdth.c, which was using the deprecated
>>>     pci_find_device.
>>>     
>>>     drivers/scsi/gdth.c:645: warning: 'pci_find_device' is deprecated (declared at include/linux/pci.h:495)
>>>     
>>>     Changing it to use pci_get_device, instead.
>>>     
>>>     Signed-off-by: Sergio Luis <sergio@larces.uece.br>
>>>     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>>> ---
>>>  drivers/scsi/Kconfig |    2 +-
>>>  drivers/scsi/gdth.c  |    7 +++++--
>>>  2 files changed, 6 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>>> index a5f0aaa..a7a0813 100644
>>> --- a/drivers/scsi/Kconfig
>>> +++ b/drivers/scsi/Kconfig
>>> @@ -722,7 +722,7 @@ config SCSI_FD_MCS
>>>  
>>>  config SCSI_GDTH
>>>  	tristate "Intel/ICP (former GDT SCSI Disk Array) RAID Controller support"
>>> -	depends on (ISA || EISA || PCI) && SCSI && ISA_DMA_API && PCI_LEGACY
>>> +	depends on (ISA || EISA || PCI) && SCSI && ISA_DMA_API
>>>  	---help---
>>>  	  Formerly called GDT SCSI Disk Array Controller Support.
>>>  
>>> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
>>> index 7079fef..6d67f5c 100644
>>> --- a/drivers/scsi/gdth.c
>>> +++ b/drivers/scsi/gdth.c
>>> @@ -642,12 +642,15 @@ static void __init gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt,
>>>            *cnt, vendor, device));
>>>  
>>>      pdev = NULL;
>>> -    while ((pdev = pci_find_device(vendor, device, pdev)) 
>>> +    while ((pdev = pci_get_device(vendor, device, pdev))
>>>             != NULL) {
>>>          if (pci_enable_device(pdev))
>>>              continue;
>>> -        if (*cnt >= MAXHA)
>>> +        if (*cnt >= MAXHA) {
>>> +            pci_dev_put(pdev);
>>>              return;
>>> +        }
>>> +
>> Why no pci_dev_put() in the module cleanup path?
> 
> Because the pci dev is never got ... nasty I know, but it's the way this
> driver works.

Then the change fixes nothing from my point of view. The core might drop the 
device from the system at any time after pci_get_device()'s next call.
