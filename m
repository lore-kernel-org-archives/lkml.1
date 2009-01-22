Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbZAVNXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbZAVNXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 08:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbZAVNXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 08:23:11 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:36238 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZAVNXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 08:23:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HKUNmaQ1qR3ojV9vpZIvRiHzLGI0rXC7SeM/K09+OtG7MKG2ouhgqJ5X38JandQeBL
         9M8/Mi0Hd0qu6TCm0T3+T/RFmkXR7iH6p2dIaUvKtbxfCH1xXp91JxlcPeMXVJM0EgFR
         zAdibrhzemsvv9sdiFrrK34zkzJDU4rLLFUtk=
Message-ID: <49787339.7080900@tuffmail.co.uk>
Date: Thu, 22 Jan 2009 13:23:05 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@suse.cz>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: BISECTED: 2.6.29-rc2 regression: hibernation hang on eeepc-701
References: <9b2b86520901180345j434eacbdn7386958991ee50b@mail.gmail.com> <497858E1.5070303@tuffmail.co.uk> <200901221344.16178.rjw@sisk.pl>
In-Reply-To: <200901221344.16178.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday 22 January 2009, Alan Jenkins wrote:
>   
>> Alan Jenkins wrote:
>>     
>>> Hibernation hangs just after writing the image.  With s2disk I can see
>>> this from the console messages.  The same hang happens with kernel
>>> swsusp ('echo disk | sudo tee /sys/power/state'), and I can see that
>>> the image has been written from the HDD led.
>>>
>>> In either case, I can still hard-power-off and resume from hibernation.
>>>
>>> It doesn't hang if I use the shutdown method (either 'echo shutdown |
>>> sudo tee /sys/power/disk' or  's2disk -P "shutdown method=shutdown"').
>>>   
>>>       
>> I've bisected this to commit 571ff7584bb9e05fca0eb79752ae55a46faf3a98. 
>> It doesn't revert cleanly from RC2.
>>
>> I think it's distinct from the other two reported suspend regressions. 
>> I'm not using acpi-cpufreq, and the issue doesn't affect resume.
>>     
>
> It looks distinct.
>
> Do you suspend this box to RAM and does it work?
>   
Yes, I do use STR on it occasionally, and it still works in RC2.

> Please retest with the appended patch applied.
>   

That fixes it.

Thanks!
Alan

> Thanks,
> Rafael
>
>
> ---
>  drivers/pci/pci-driver.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/drivers/pci/pci-driver.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci-driver.c
> +++ linux-2.6/drivers/pci/pci-driver.c
> @@ -660,7 +660,10 @@ static int pci_pm_poweroff(struct device
>  	if (pci_has_legacy_pm_support(pci_dev))
>  		return pci_legacy_suspend(dev, PMSG_HIBERNATE);
>  
> -	if (drv && drv->pm && drv->pm->poweroff) {
> +	if (!drv || !drv->pm)
> +		return 0;
> +
> +	if (drv->pm->poweroff) {
>  		error = drv->pm->poweroff(dev);
>  		suspend_report_result(drv->pm->poweroff, error);
>  	}
>
>   

