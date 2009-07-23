Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbZGWS1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbZGWS1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbZGWS1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:27:34 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:58995 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbZGWS1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:27:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=J+uyHiZBLteGR9M5qXxPZir7m5lfV8zqiKcsY+jCfiqrnv7IT1+KM0C3jWmcAHyT25
         TshyGsPWMrmMWFnxloGonhhpXYTk47dl27SAPy18TUgKTr5/HysSKhKQXPD2kSfqjYhH
         4Sa9+NLy/PEDinx/pVLvLEHu2VYZ0YnsDezSs=
Message-ID: <4A68AB8F.9020609@tuffmail.co.uk>
Date: Thu, 23 Jul 2009 19:27:27 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Matthew Garrett <mjg@redhat.com>, linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hp-wmi: improve rfkill support
References: <4A65A2F9.1060509@tuffmail.co.uk> <8db1092f0907230831w1255d0bey951342fb61b67c1e@mail.gmail.com>
In-Reply-To: <8db1092f0907230831w1255d0bey951342fb61b67c1e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> 2009/7/21 Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
>   
>> 1) Add support for reading the hardware blocked state.  Previously
>>   we read a combination of the hardware and software blocked states,
>>   reporting it as the software blocked state.  This caused some
>>   confusing behaviour.
>>
>> 2) The software state is persistent, mark it as such.
>>
>> 3) Check rfkill in the resume handler.  Both the hard and soft
>>   blocked states may change over hibernation.
>>
>> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
>> Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>
>>     
>
> It's this patch is added to -rc4?

No. 
<http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git&a=search&h=HEAD&st=commit&s=hp-wmi>

I didn't submit it for 2.6.31 because I didn't think it fixed a regression.

>  I one case I have strange behaviour.
>
> Before disable by button:
> root@gumis:/home/maciek/Desktop# rfkill list
> 2: hp-wifi: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 3: hp-bluetooth: Bluetooth
>         Soft blocked: no
>         Hard blocked: no
> 16: hci0: Bluetooth
>         Soft blocked: no
>         Hard blocked: no
> 17: phy7: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 	
> Disable by button:
> root@gumis:/home/maciek/Desktop# rfkill list
> 2: hp-wifi: Wireless LAN
>         Soft blocked: yes
>         Hard blocked: no
> 3: hp-bluetooth: Bluetooth
>         Soft blocked: yes
>         Hard blocked: no
> 17: phy7: Wireless LAN
>         Soft blocked: no
>         Hard blocked: yes
> 	
> I do s2disk. After resume from suspend to disk (still disabled by button):
> root@gumis:/home/maciek/Desktop# rfkill list
> 2: hp-wifi: Wireless LAN
>         Soft blocked: yes
>         Hard blocked: no
> 3: hp-bluetooth: Bluetooth
>         Soft blocked: yes
>         Hard blocked: no
> 18: phy8: Wireless LAN
>         Soft blocked: no
>         Hard blocked: yes
> 	
> Try enable by button:
> root@gumis:/home/maciek/Desktop# rfkill list
> 2: hp-wifi: Wireless LAN
>         Soft blocked: yes
>         Hard blocked: no
> 3: hp-bluetooth: Bluetooth
>         Soft blocked: yes
>         Hard blocked: no
> 18: phy8: Wireless LAN
>         Soft blocked: no
>         Hard blocked: yes
> 	
> Nothing change (LED, wireless and bluetooth don't work). To enable it
> I use this script rfkill.sh (I must use rfkill program):
>
> #!/bin/sh
> PROGRAM=/usr/local/sbin/rfkill
> WIFI=`$PROGRAM list | grep -E 'Wireless|Bluetooth' | cut -d  ':' -f 1`
>
> for DEVICE in $WIFI; do
>   echo $DEVICE
>   $PROGRAM unblock $DEVICE
> done
>
> Then works OK:
> root@gumis:/home/maciek/Desktop# ./rfkill.sh
> 2
> 3
> 18
> root@gumis:/home/maciek/Desktop# rfkill list
> 2: hp-wifi: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 3: hp-bluetooth: Bluetooth
>         Soft blocked: no
>         Hard blocked: no
> 18: phy8: Wireless LAN
>         Soft blocked: no
>         Hard blocked: no
> 19: hci0: Bluetooth
>         Soft blocked: no
>         Hard blocked: no
> 	
> It's normal behaviour?
>   

That's a bug.  You're saying this is in -rc4, without applying my patch?

I think I know exactly what is happening.  Apply my patch, and it will 
go away :-).

I'm not sure this is a new bug though.  It might be triggered by the big 
rfkill rewrite, but I don't see how that could happen.  Can you confirm 
if this happens in 2.6.30?

Thanks
Alan
