Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbYCCQvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbYCCQvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 11:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbYCCQvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 11:51:44 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43457 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbYCCQvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 11:51:44 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47CC2C95.1050205@s5r6.in-berlin.de>
Date: Mon, 03 Mar 2008 17:51:33 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: reread config ROM when device reset the bus
References: <tkrat.c6610a8633fe0e41@s5r6.in-berlin.de>	 <tkrat.da30e6f15a74e036@s5r6.in-berlin.de> <59ad55d30803030817l6fce6716x2a97cc809b15b234@mail.gmail.com>
In-Reply-To: <59ad55d30803030817l6fce6716x2a97cc809b15b234@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
> I would just add a
> 
>   case REREAD_BIB_CHANGED:
>     break;
> 
> to the switch to make that clear,

Yes, that's nicer.

> but otherwise
> 
> Signed-off-by: Kristian Høgsberg <krh@redhat.com>

Thanks.

...
>>  --- linux.orig/drivers/firewire/fw-cdev.c
>>  +++ linux/drivers/firewire/fw-cdev.c
>>  @@ -269,20 +270,25 @@ static int ioctl_get_info(struct client
>>   {
>>         struct fw_cdev_get_info *get_info = buffer;
>>         struct fw_cdev_event_bus_reset bus_reset;
>>  +       struct fw_device *device = client->device;
>>  +       unsigned long ret = 0;
>>
>>         client->version = get_info->version;
>>         get_info->version = FW_CDEV_VERSION;
>>
>>  +       down(&device->device.sem);
>>         if (get_info->rom != 0) {
>>                 void __user *uptr = u64_to_uptr(get_info->rom);
>>                 size_t want = get_info->rom_length;
>>  -               size_t have = client->device->config_rom_length * 4;
>>  +               size_t have;
>>
>>  -               if (copy_to_user(uptr, client->device->config_rom,
>>  -                                min(want, have)))
>>  -                       return -EFAULT;
>>  +               have = device->config_rom_length * 4;
>>  +               ret = copy_to_user(uptr, device->config_rom, min(want, have));
>>         }
>>  -       get_info->rom_length = client->device->config_rom_length * 4;
>>  +       get_info->rom_length = device->config_rom_length * 4;
>>  +       up(&device->device.sem);
>>  +       if (ret != 0)
>>  +               return -EFAULT;
>>
>>         client->bus_reset_closure = get_info->bus_reset_closure;
>>         if (get_info->bus_reset != 0) {

Maybe I should rather use fw-device.c::idr_rwsem instead of device.sem, 
to have better control over who takes the mutex when.  Could also be a 
new dedicated mutex but we don't want to end up with too many of them... 
Do you have an opinion?
-- 
Stefan Richter
-=====-==--- --== ---==
http://arcgraph.de/sr/
