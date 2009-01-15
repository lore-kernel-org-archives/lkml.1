Return-Path: <linux-kernel-owner+w=401wt.eu-S1763666AbZAOLLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763666AbZAOLLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:11:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbZAOLLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:11:38 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:44846 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbZAOLLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:11:37 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <496F19E2.8070306@gmail.com>
Date: Thu, 15 Jan 2009 11:11:30 +0000
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mike Rapoport <mike@compulab.co.il>
CC: Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@sirena.org.uk>, Samuel Ortiz <sameo@openedhand.com>,
       eric miao <eric.y.miao@gmail.com>, felipe.balbi@nokia.com,
       Liam Girdwood <lrg@kernel.org>
Subject: Re: [PATCH 2.6.29-rc1-git4] mfd: da9030 usb charge pump support within
 mfd driver.
References: <496E2BE5.1050803@cam.ac.uk> <496ED9EF.2050507@compulab.co.il>
In-Reply-To: <496ED9EF.2050507@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Rapoport wrote:
> Jonathan,
> Below are my two cents :)
>   
Thanks,
> Jonathan Cameron wrote:
>   
>> From: Jonathan Cameron <jic23@cam.ac.uk>
>>
>> Add support for changing the mode of the da9030 usb charge pump
>>
>> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
>>
>> ---
>>
>> Minor changes from previous version to reflect changes in the
>> driver being patched. Addtional cc's as per Mark's suggestion.
>>
>> This version simply adds the functionality to the da903x mfd driver
>> core. If anyone can suggest a way round simply maintaining a
>> global pointer to the device it would be good.
>>     
>
> I don't think the global pointer here is real problem. It should be *really*
> weird design with two da903x.
>
>   
>> To be able to call this from a board config file the driver must be
>> built in rather than a module but enforcing that is down to the
>> board Kconfig entry.
>>     
>
> Most probably the board with da9030 will anyway have it built-in...
>
>   
>> diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
>> index 99f8dcf..70ec3b0 100644
>> --- a/drivers/mfd/da903x.c
>> +++ b/drivers/mfd/da903x.c
>> @@ -30,6 +30,7 @@
>>  #define DA9030_SYS_CTRL_A	0x08
>>  #define DA9030_SYS_CTRL_B	0x09
>>  #define DA9030_FAULT_LOG	0x0a
>> +#define DA9030_USBPUMP_REG	0x19
>>  
>>  #define DA9034_CHIP_ID		0x00
>>  #define DA9034_EVENT_A		0x01
>> @@ -484,6 +485,32 @@ failed:
>>  	return ret;
>>  }
>>  
>> +/* Single device assumption */
>> +struct device *da9030_mfd_dev;
>> +
>> +int da9030_set_usb_charge_pump_mode(int mode)
>> +{
>> +	uint8_t val = 0;
>> +
>> +	if (da9030_mfd_dev == NULL)
>> +		return -EINVAL;
>> +
>> +	switch (mode) {
>> +	case DA9030_USBPUMP_AUTO:
>> +		val = 0;
>> +		break;
>> +	case DA9030_USBPUMP_CHARGE_PUMP:
>> +		val = 0x40;
>> +		break;
>> +	case DA9030_USBPUMP_CURRENT_SOURCE:
>> +		val = 0x80;
>> +		break;
>> +	}
>> +
>> +	return da903x_write(da9030_mfd_dev, DA9030_USBPUMP_REG, val);
>> +}
>> +EXPORT_SYMBOL_GPL(da9030_set_usb_charge_pump_mode);
>> +
>>     
>
> Maybe we want to have 'da9030_set_usb_charge_pump_mode' as well?
>   
(get?)
Possibly though not sure under what circumstances it would be needed
other than debugging?

