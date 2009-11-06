Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbZKFNaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbZKFNaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 08:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757377AbZKFNaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 08:30:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249AbZKFNae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 08:30:34 -0500
Message-ID: <4AF42617.8070100@redhat.com>
Date: Fri, 06 Nov 2009 14:35:19 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [patch 1/5] hwmon: Convert fschmd to unlocked_ioctl
References: <20091015202722.372890083@linutronix.de>	<20091015202758.400949170@linutronix.de> <20091106141542.12404c5c@hyperion.delvare>
In-Reply-To: <20091106141542.12404c5c@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/06/2009 02:15 PM, Jean Delvare wrote:
> Hi Thomas,
>
> Sorry for the late answer.
>
> On Thu, 15 Oct 2009 20:28:31 -0000, Thomas Gleixner wrote:
>> The conversion of fschmd watchdog ioctl to unlocked_ioctl needs to
>> protect the static watchdog_info variable for the WDIOC_GETSUPPORT
>> command.
>>
>> All other commands are safe w/o BKL as the called watchdog functions
>> are already serialized with watchdog_lock of the sensor.
>>
>> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
>> Cc: lm-sensors@lm-sensors.org
>> ---
>>   drivers/hwmon/fschmd.c |    8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> Index: linux-2.6-tip/drivers/hwmon/fschmd.c
>> ===================================================================
>> --- linux-2.6-tip.orig/drivers/hwmon/fschmd.c
>> +++ linux-2.6-tip/drivers/hwmon/fschmd.c
>> @@ -844,8 +844,8 @@ static ssize_t watchdog_write(struct fil
>>   	return count;
>>   }
>>
>> -static int watchdog_ioctl(struct inode *inode, struct file *filp,
>> -	unsigned int cmd, unsigned long arg)
>> +static long watchdog_ioctl(struct file *filp, unsigned int cmd,
>> +			   unsigned long arg)
>>   {
>>   	static struct watchdog_info ident = {
>>   		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
>> @@ -857,11 +857,13 @@ static int watchdog_ioctl(struct inode *
>>
>>   	switch (cmd) {
>>   	case WDIOC_GETSUPPORT:
>> +		mutex_lock(&watchdog_data_mutex);
>>   		ident.firmware_version = data->revision;
>>   		if (!nowayout)
>>   			ident.options |= WDIOF_MAGICCLOSE;
>>   		if (copy_to_user((void __user *)arg,&ident, sizeof(ident)))
>>   			ret = -EFAULT;
>> +		mutex_unlock(&watchdog_data_mutex);
>>   		break;
>
> I'm not sure why we need to hold the mutex here? My understanding is
> that watchdog_data_mutex protects watchdog_data_list and each
> watchdog's kref. And the above code doesn't touch either.
>
> What I am more worried about is why ident is declared static. This
> looks like a bug to me. Instead of abusing watchdog_data_mutex to
> workaround this, I'd rather remove the "static". I guess that the
> current code happens to work because neither data->revision nor
> nowayout can change over time, but this looks needlessly fragile.
>
> Hans, any comment?
>

Note I'm on the road so do not have the code at question handy, but
I agree having ident static is not needed and is what needs to be fixed
here.

Regards,

Hans
