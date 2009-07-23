Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbZGWPbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbZGWPbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 11:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbZGWPbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 11:31:47 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:54938 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbZGWPbq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 11:31:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KZozkXiwyCctHBrHVnuSC4PQIrXJ9MpwvyWKvSYMRmINDzxtjcDGJfoVvXhI3MKSLt
         JL/WuhSSWpaFug8gSmieUL8+jr6ciMv1Phy+4sgdO+grZwx2DIdvxEeR3kI2rtFGYK6E
         dNtj3zv4S1SAIeq/W6dkptbZgYMe0uetGyc58=
MIME-Version: 1.0
In-Reply-To: <4A65A2F9.1060509@tuffmail.co.uk>
References: <4A65A2F9.1060509@tuffmail.co.uk>
Date: Thu, 23 Jul 2009 17:31:45 +0200
Message-ID: <8db1092f0907230831w1255d0bey951342fb61b67c1e@mail.gmail.com>
Subject: Re: [PATCH] hp-wmi: improve rfkill support
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>, linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/21 Alan Jenkins <alan-jenkins@tuffmail.co.uk>:
> 1) Add support for reading the hardware blocked state.  Previously
>   we read a combination of the hardware and software blocked states,
>   reporting it as the software blocked state.  This caused some
>   confusing behaviour.
>
> 2) The software state is persistent, mark it as such.
>
> 3) Check rfkill in the resume handler.  Both the hard and soft
>   blocked states may change over hibernation.
>
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>

It's this patch is added to -rc4? I one case I have strange behaviour.

Before disable by button:
root@gumis:/home/maciek/Desktop# rfkill list
2: hp-wifi: Wireless LAN
        Soft blocked: no
        Hard blocked: no
3: hp-bluetooth: Bluetooth
        Soft blocked: no
        Hard blocked: no
16: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
17: phy7: Wireless LAN
        Soft blocked: no
        Hard blocked: no
	
Disable by button:
root@gumis:/home/maciek/Desktop# rfkill list
2: hp-wifi: Wireless LAN
        Soft blocked: yes
        Hard blocked: no
3: hp-bluetooth: Bluetooth
        Soft blocked: yes
        Hard blocked: no
17: phy7: Wireless LAN
        Soft blocked: no
        Hard blocked: yes
	
I do s2disk. After resume from suspend to disk (still disabled by button):
root@gumis:/home/maciek/Desktop# rfkill list
2: hp-wifi: Wireless LAN
        Soft blocked: yes
        Hard blocked: no
3: hp-bluetooth: Bluetooth
        Soft blocked: yes
        Hard blocked: no
18: phy8: Wireless LAN
        Soft blocked: no
        Hard blocked: yes
	
Try enable by button:
root@gumis:/home/maciek/Desktop# rfkill list
2: hp-wifi: Wireless LAN
        Soft blocked: yes
        Hard blocked: no
3: hp-bluetooth: Bluetooth
        Soft blocked: yes
        Hard blocked: no
18: phy8: Wireless LAN
        Soft blocked: no
        Hard blocked: yes
	
Nothing change (LED, wireless and bluetooth don't work). To enable it
I use this script rfkill.sh (I must use rfkill program):

#!/bin/sh
PROGRAM=/usr/local/sbin/rfkill
WIFI=`$PROGRAM list | grep -E 'Wireless|Bluetooth' | cut -d  ':' -f 1`

for DEVICE in $WIFI; do
  echo $DEVICE
  $PROGRAM unblock $DEVICE
done

Then works OK:
root@gumis:/home/maciek/Desktop# ./rfkill.sh
2
3
18
root@gumis:/home/maciek/Desktop# rfkill list
2: hp-wifi: Wireless LAN
        Soft blocked: no
        Hard blocked: no
3: hp-bluetooth: Bluetooth
        Soft blocked: no
        Hard blocked: no
18: phy8: Wireless LAN
        Soft blocked: no
        Hard blocked: no
19: hci0: Bluetooth
        Soft blocked: no
        Hard blocked: no
	
It's normal behaviour?

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
