Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbYFCRAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbYFCRAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYFCRAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:00:10 -0400
Received: from ns.suse.de ([195.135.220.2]:55320 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbYFCRAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:00:08 -0400
Message-ID: <48457896.8050902@suse.de>
Date: Tue, 03 Jun 2008 19:00:06 +0200
From: Stefan Assmann <sassmann@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Olaf Dabrunz <od@suse.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Jon Masters <jonathan@jonmasters.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/7] add kernel cmdline option to disable pci-irq quirks
References: <12124107071847-git-send-email-od@suse.de> <12124107071030-git-send-email-od@suse.de> <alpine.LFD.1.10.0806031211500.3235@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0806031211500.3235@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner schrieb:
> On Mon, 2 Jun 2008, Olaf Dabrunz wrote:
>   
>> From: Olaf Dabrunz <od@suse.de>
>>
>> Add a switch to disable all boot interrupt quirks, using the parameter
>> nobootirqquirk.
>>     
>
> This should be a parameter in the form of
>
> pci=ioapicquirk
>
> and not a separate and completely unintuitive thing.
>
> Thanks,
> 	tglx
>
>   
Introducing 2 parameters then:
pci=ioapicreroute to enable rerouting of interrupts to the primary io-apic,
pci=noioapicquirk to disable all sorts of io-apic quirks.

This implies that disabling boot interrupts, on bridges where we know 
how to do it, will be enabled by default. I'd favor this solution 
because I can't think of any harm this could possibly cause. Boot 
interrupts shouldn't happen on systems that run in apic mode.
>> Signed-off-by: Olaf Dabrunz <od@suse.de>
>> Signed-off-by: Stefan Assmann <sassmann@suse.de>
>> ---
>>  drivers/pci/quirks.c |   15 +++++++++++++++
>>  1 files changed, 15 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
>> index dabb563..6245486 100644
>> --- a/drivers/pci/quirks.c
>> +++ b/drivers/pci/quirks.c
>> @@ -1363,6 +1363,21 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x2609, quirk_intel_pcie_pm);
>>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x260a, quirk_intel_pcie_pm);
>>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x260b, quirk_intel_pcie_pm);
>>  
>> +
>> +#ifdef CONFIG_X86_IO_APIC
>> +int nobootirqquirk __read_mostly = 0;
>> +
>> +int nobootirqquirk_setup(char *str)
>> +{
>> +	nobootirqquirk = 1;
>> +	printk(KERN_INFO "Boot IRQ quirk handling disabled\n");
>> +
>> +	return 1;
>> +}
>> +__setup("nobootirqquirk", nobootirqquirk_setup);
>> +#endif /* CONFIG_X86_IO_APIC */
>> +
>> +
>>  /*
>>   * Toshiba TC86C001 IDE controller reports the standard 8-byte BAR0 size
>>   * but the PIO transfers won't work if BAR0 falls at the odd 8 bytes.
>> -- 
>> 1.5.2.4
>>
>> -- 
>> Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, N??rnberg
>>
>>     
    Stefan

-- 
Stefan Assmann          | SUSE LINUX Products GmbH
Software Engineer       | Maxfeldstr. 5, D-90409 Nuernberg
Mail : sassmann@suse.de | GF: Markus Rex, HRB 16746 (AG Nuernberg)

