Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbZD2V2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbZD2V2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbZD2V2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:28:36 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:13873 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbZD2V2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:28:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lQR7LkDiaeL1EzTTHKIjnzmFp1e5AuspnNZN/Li4WChvOslJNIsWO/H5YXXC4YahyB
         Nc14a2xXf5T5/oirbAc+9Hhvi3LrmgdYTqFkG4acZtWHo8YN6XveIn8mbXnr76A8Fb4p
         Zze3OtwxMiJfLt+Uk0Gfwe5TSj6hzRjvv8qMY=
MIME-Version: 1.0
In-Reply-To: <ac3eb2510904291210y6d0a4199gc1800d0d02d0d7c6@mail.gmail.com>
References: <ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com>
	 <20090428101020.0e4c2b0c@hyperion.delvare>
	 <20090428173929.GA5006@sysman-doug.us.dell.com>
	 <ac3eb2510904281046i6e9899acg89f7606da783f72c@mail.gmail.com>
	 <20090428215844.GA1396@sysman-doug.us.dell.com>
	 <ac3eb2510904281842i785ee135h98502522f242f3f6@mail.gmail.com>
	 <437908170904282019h6a10ef9dg594002e22842b366@mail.gmail.com>
	 <ac3eb2510904290330r563f3717ue72029cbe24b39bb@mail.gmail.com>
	 <437908170904291000s10fe6a92q8a595e0bbbd159a6@mail.gmail.com>
	 <ac3eb2510904291210y6d0a4199gc1800d0d02d0d7c6@mail.gmail.com>
Date: Wed, 29 Apr 2009 16:28:35 -0500
X-Google-Sender-Auth: b1096488be3ac114
Message-ID: <437908170904291428k445fc8fdy9b3bb4e78ee91018@mail.gmail.com>
Subject: Re: Class device namespaces
From: Michael Brown <mebrown@michaels-house.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Doug Warzecha <Douglas_Warzecha@dell.com>,
       Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Matt Domsch <Matt_Domsch@dell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 2:10 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> Udev runs exactly at the time you create the device, and is not
> unlikely faster than your polling, at least not predictable slower.
> And it will cancel all requests which can not be fulfilled by udev
> itself.
>
> I strongly recommend switching to a different solution, you can not
> use the firmware_class interface on any udev system, the interface is
> already taken, and it's a single-user interface the way it is
> implemented today. That it seems to work for you, is pure luck, I
> guess. :)

Is there a safe/easy way to tell udev that we will handle a particular
request? I cant say that I've ever seen any problems due to udev
cancelling a firmware request.  In fact, if I manually trigger a
request using "echo" from the cmdline, I dont see udev take any action
with the dell_rbu device. eg (Fedora 10, udev-127-5.fc10):

# find /sys -name dell_rbu
/sys/devices/platform/dell_rbu
/sys/bus/platform/devices/dell_rbu
/sys/module/dell_rbu
[root@duo dell_rbu]# echo "init" > /sys/devices/platform/dell_rbu/image_type
[root@duo dell_rbu]# find /sys -name dell_rbu
/sys/devices/platform/dell_rbu
/sys/devices/platform/dell_rbu/firmware/dell_rbu
/sys/bus/platform/devices/dell_rbu
/sys/class/firmware/dell_rbu
/sys/module/dell_rbu
[root@duo dell_rbu]# ll /sys/class/firmware/dell_rbu/
total 0
-rw-r--r-- 1 root root    0 2009-04-29 16:25 data
lrwxrwxrwx 1 root root    0 2009-04-29 16:25 device -> ../../../dell_rbu
-rw-r--r-- 1 root root 4096 2009-04-29 16:25 loading
drwxr-xr-x 2 root root    0 2009-04-29 16:25 power
lrwxrwxrwx 1 root root    0 2009-04-29 16:25 subsystem ->
../../../../../class/firmware
-rw-r--r-- 1 root root 4096 2009-04-29 16:25 uevent
[root@duo dell_rbu]#
[root@duo dell_rbu]# echo 0 > /sys/class/firmware/dell_rbu/loading
[root@duo dell_rbu]#
[root@duo dell_rbu]# find /sys -name dell_rbu
/sys/devices/platform/dell_rbu
/sys/bus/platform/devices/dell_rbu
/sys/module/dell_rbu

I dont see any of the behaviour that you have talked about. If I let
it sit there for hours, it will stay at that state. It only closes up
the request_firmware() request when I echo 0 > loading.

At this point, we have had this interface in the upstream kernel.org
kernel since 2.6.14 and have a pretty huge legacy codebase that relies
on this behaviour. We need to make sure that the current behaviour
remains.

--
Michael
