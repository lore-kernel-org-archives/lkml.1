Return-Path: <linux-kernel-owner+w=401wt.eu-S1762017AbXJZSdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762017AbXJZSdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756441AbXJZSdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:33:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:5007 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbXJZSdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:33:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=IuFatMVSyIns2tjG5Mv9QZ4seezS3np6c+nTf29haIHypIYOqdfcwDv2ua1WuDkZOQWXqtJuX34DsI9j3LLAaIyc/PRpclzvVQV/IQInDYu0C4adYya7xkAnn7el562hvv/LuF+MMjgxwtEWGokqZUFxuYKdxTuzBFX+sUSOjZ8=
Message-ID: <472232D3.6000807@gmail.com>
Date: Fri, 26 Oct 2007 22:32:51 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.624-rc1 regression] lost battery information
References: <200710262024.06012.arvidjaar@mail.ru> <200710262120.22536.arvidjaar@mail.ru> <47222DF3.3040208@gmail.com> <200710262215.42939.arvidjaar@mail.ru>
In-Reply-To: <200710262215.42939.arvidjaar@mail.ru>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------010400060204040008010500"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010400060204040008010500
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andrey Borzenkov wrote:
> On Friday 26 October 2007, Alexey Starikovskiy wrote:
>> Andrey Borzenkov wrote:
>>> On Friday 26 October 2007, Alexey Starikovskiy wrote:
>>>> Andrey Borzenkov wrote:
>>>>> I have lost battery in 2.6.24-rc1. Without CONFIG_ACPI_PROCFS I have
>>>>> no /proc/acpi/battery and cannot test netlink interface because right
>>>>> now there is no consumer of this.
>>>> for /sysfs interface you need to enable power_supply driver.
>>>> or you could apply this patch and power_supply will be selected by
>>>> battery itself.
>>> I already have power_supply module, battery depends on it and it is
>>> autloaded. But I fail to see where I can get battery info in /sys
>> Intent was to put into /sysfs same information:
>> aystarik@samsung:~/client_conf$ ls /sys/class/power_supply/BAT1/
>> alarm  charge_full  charge_full_design  charge_now  current_now  device 
>> manufacturer  model_name  present  status  subsystem  technology  type 
>> uevent  voltage_min_design  voltage_now
>>
> 
> is it in -rc1 or can you point me to the patch (I'd rather avoid having to 
> pull from different git trees). Thank you.
No, it should be rc1.
> 
> And what about ACPI_PROCFS case? It still needs attention I believe.
As you can see, there is info in /proc too:
>> aystarik@samsung:~/client_conf$ cat /proc/acpi/battery/BAT1/*
>> alarm:                   unsupported
>> present:                 yes
>> design capacity:         4300 mAh
>> last full capacity:      4172 mAh
>> battery technology:      rechargeable
>> design voltage:          14800 mV
>> design capacity warning: 208 mAh
>> design capacity low:     41 mAh
>> capacity granularity 1:  41 mAh
>> capacity granularity 2:  41 mAh
>> model number:            Bat1
>> serial number:           001
>> battery type:            LION
>> OEM info:                Pacifi
>> present:                 yes
>> capacity state:          ok
>> charging state:          charged
>> present rate:            0 mA
>> remaining capacity:      4172 mAh
>> present voltage:         16518 mV

Your cat's "Bad address" means -EFAULT, according to "man errno".
Please apply this patch to see what exactly failed...


--------------010400060204040008010500
Content-Type: text/x-diff;
 name="x.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x.patch"

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 02a396d..55e9a8e 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -262,21 +262,29 @@ static int extract_package(struct acpi_battery *battery,
 {
 	int i, *x;
 	union acpi_object *element;
-	if (package->type != ACPI_TYPE_PACKAGE)
+	if (package->type != ACPI_TYPE_PACKAGE) {
+printk (KERN_ERR PREFIX "package->type = %x\n", package->type);
 		return -EFAULT;
+	}
 	for (i = 0; i < num; ++i) {
-		if (package->package.count <= i)
+		if (package->package.count <= i) {
+printk (KERN_ERR PREFIX "package.count = %d, i = %d\n", package->package.count, i);
 			return -EFAULT;
+		}
 		element = &package->package.elements[i];
 		if (offsets[i].mode) {
 			if (element->type != ACPI_TYPE_STRING &&
-			    element->type != ACPI_TYPE_BUFFER)
+			    element->type != ACPI_TYPE_BUFFER) {
+printk (KERN_ERR PREFIX "element[%d]->type = %x, expected string\n", i, element->type);
 				return -EFAULT;
+			}
 			strncpy((u8 *)battery + offsets[i].offset,
 				element->string.pointer, 32);
 		} else {
-			if (element->type != ACPI_TYPE_INTEGER)
+			if (element->type != ACPI_TYPE_INTEGER) {
+printk (KERN_ERR PREFIX "element[%d]->type = %x, expected integer\n", i, element->type);
 				return -EFAULT;
+			}
 			x = (int *)((u8 *)battery + offsets[i].offset);
 			*x = element->integer.value;
 		}

--------------010400060204040008010500--
