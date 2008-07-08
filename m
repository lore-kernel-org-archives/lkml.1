Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbYGHGtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbYGHGtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 02:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYGHGtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 02:49:14 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:20502 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYGHGtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 02:49:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HOByuuEkKYf2Hc6QVkXVwrqvxHIuWVtRvitLEhRV2xtf12UdAbZ4rTHUGCb5ZDS/mM
         m6cqczzTAF2qIFbjp0dyjgJw4kZ3deoqp4dm+8kwiQYAWcTZ0fK36Go4lIuZJhK9HFM9
         t8rDZgAAiFANUPOm6F10hRQ+KxTpBgi7DmZIE=
Message-ID: <48730DE2.2050302@gmail.com>
Date: Tue, 08 Jul 2008 14:49:06 +0800
From: Eric Miao <eric.y.miao@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Stefan Schmidt <stefan@datenfreihafen.org>
CC: pHilipp Zabel <philipp.zabel@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, sameo@openedhand.com,
       linux-kernel@vger.kernel.org, Daniel Ribeiro <wyrm@openezx.org>
Subject: Re: [Patch 06/10] mfd: PCAP driver for the Motorola EZX GSM mobile
 phones
References: <20080707184000.411913919@datenfreihafen.org> <20080707184129.554483476@datenfreihafen.org> <74d0deb30807071221u4e216f76l479766925c903b5f@mail.gmail.com> <20080707200251.GA3449@datenfreihafen.org>
In-Reply-To: <20080707200251.GA3449@datenfreihafen.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Schmidt wrote:

>> Otherwise I'd dislike the hardcoded IRQ numbers in the MFD driver.
> 
> So far it seems to be no problem. If there is a strong feeling to change this we
> will of course work on that. Personally I would prefer to do this when new users
> of this driver appear.

The irq2pcap[] array looks horrible to me. It's actually a sparse array.
Isn't there a nice 1:1 mapping using a formular??

Besides, the IRQ numbering scheme has now changed to a more generic way,
I suggest to pull from Russell's latest git tree and rebase the IRQ
part.

> 
>> The machine_is_xyz() calls inside ezx-pcap could be replaced with
>> configuration via platform_data (have pcap_platform_data->cs_inverted,
>> for example)
> 
> We had this before and it turned out as messy as this solution. We have one
> machine file that supports up to 6 devices right now. So we would have to deal
> with the same machine_is_xyz macros in the machine file.
> 
> We thought it would be better to let the driver handle this. Open for discussion
> of course.

The following block of code:

+	if (pcap_data->cs >= 0) {
+		if (machine_is_ezx_a780() || machine_is_ezx_e680())
+			gpio_direction_output(pcap_data->cs, 1);
+		else
+			gpio_direction_output(pcap_data->cs, 0);
+	}

has 3 occurrences in the driver (2 in ezx_ssp_pcap_putget, 1 in ezx_pcap_probe)
which is good reason to fold this into the platform data.

Well, if the above is done in platform data, I guess you won't mind another bit
flag (e.g. PCAP_REDIRECT_IRQ or something alike) added in platform data, either

> 
>>> +#if 0
>>> +#define DEBUGP(x, args...) printk(x, ## args)
>>> +#else
>>> +#define DEBUGP(x, args...)
>>> +#endif
>> Could you remove the custom debug macros and use pr_debug (or even
>> better, dev_dbg) instead?
> 
> Will do.
> 
>>> +static void __exit ezx_pcap_exit(void)
>>> +{
>>> +       return platform_driver_unregister(&ezxpcap_driver);
>>> +}
>>> +
>>> +module_init(ezx_pcap_init);
>> Depending on what platform_devices depend on this, maybe use
>> subsys_initcall here.
> 
> Ok, I'll need to look up on this to see if it is an option.
> 
>>> +module_exit(ezx_pcap_exit);
>> Why bother with module_exit when the Kconfig option is bool?
> 
> Well, matter of taste. :)
> 
> Taking care about cleanup is good style. Still you are right that it is useles
> for the time being.
> 
>>> +#define PCAP_IRQ_USB4V         (1 << 6)        /* USB above 4volt???
>>> +                                               called "USBDET_4V" in blob */
>> I assume that's for OTG operation. The VBUS voltage is valid from 4.4 V, and the
>> PXA27x UDC controller has "Vbus valid 4.0 V" and "Vbus valid 4.4 V" interrupts
> 
> ok
> 
>>> +       /*  set core voltage */
>>> +       ezx_pcap_set_sw(SW1, SW_VOLTAGE, SW_VOLTAGE_1250);
>> Btw, did you see the voltage regulator framework that is in linux-next?
> 
> Heard of it, but not read the code yet. It's on my list. I just a bit hesitant
> to base on code that is not in mainline yet. But -next should be ok.
> 
>>> -
>>> +       platform_device_register(&ezx_pcap_device);
>>>        platform_add_devices(devices, ARRAY_SIZE(devices));
>> You could put ezx_pcap_device into the beginning of devices[].
> 
> Duh, will fix.
> 
> I send out an updated patch tomorrow. Need some sleep now.
> 
> Thanks for the feedback.
> 
> regards
> Stefan Schmidt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

