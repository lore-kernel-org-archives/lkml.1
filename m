Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbZDQT1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbZDQT1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbZDQT04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:26:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:64332 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbZDQT0z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:26:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Nc1nnMqWCp6bnd+pDdMMTemKMwuLJ94XAqxVgt2H4p8Oq9Xhj+3MdDiyPXVevGbWCM
         T34cX/YlkAwkGAkr4e5FpqbLF2be7I4KwEQcmhE/tPXLsMze2k1/JVFuP5zUerj7SuBI
         Z4lxotEanU/ubY2w3znpm/MslQZnK1rFa6Lko=
MIME-Version: 1.0
In-Reply-To: <20090417162115.GF8253@elte.hu>
References: <20090417100155.GE16198@alberich.amd.com>
	 <20090417162115.GF8253@elte.hu>
Date: Fri, 17 Apr 2009 12:26:54 -0700
Message-ID: <86802c440904171226g520e3b67h7318ff0f80f1e782@mail.gmail.com>
Subject: Re: [PATCH] pci: derive nearby CPUs from device's instead of bus' 
	NUMA information
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, jbarnes@virtuousgeek.org,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 9:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
>
>> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
>> index a7eb1b4..9360f3d 100644
>> --- a/drivers/pci/pci-sysfs.c
>> +++ b/drivers/pci/pci-sysfs.c
>> @@ -74,7 +74,11 @@ static ssize_t local_cpus_show(struct device *dev,
>>       const struct cpumask *mask;
>>       int len;
>>
>> +#ifdef CONFIG_NUMA
>> +     mask = cpumask_of_node(dev_to_node(dev));
>> +#else
>>       mask = cpumask_of_pcibus(to_pci_dev(dev)->bus);
>> +#endif
>>       len = cpumask_scnprintf(buf, PAGE_SIZE-2, mask);
>>       buf[len++] = '\n';
>>       buf[len] = '\0';
>> @@ -88,7 +92,11 @@ static ssize_t local_cpulist_show(struct device *dev,
>>       const struct cpumask *mask;
>>       int len;
>>
>> +#ifdef CONFIG_NUMA
>> +     mask = cpumask_of_node(dev_to_node(dev));
>> +#else
>>       mask = cpumask_of_pcibus(to_pci_dev(dev)->bus);
>> +#endif
>
> No objections against the change (at all), but this pattern cries
> out for a different, cleaner solution.
>
> Shouldnt there be a cpumask_of_pcidev(dev) helper instead, which
> [recognizing that most PCI devices dont get their node info
> initialized in practice] would do something like:
>
> const struct cpumask * cpumask_of_pcidev(struct pci_dev *dev)
> {
>        if (dev->numa_node == -1)
>                return cpumask_of_pcibus(to_pci_dev(dev)->bus);
>
>        return cpumask_of_node(dev_to_node(dev));
> }
>
> ? This would work fine in all cases.

you are right, dev_to_node(dev) could return -1 on 64bit, if there is
no memory on that node.

YH
