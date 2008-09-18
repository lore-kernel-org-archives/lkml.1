Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbYIRUpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbYIRUpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 16:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbYIRUox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 16:44:53 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:59771 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbYIRUow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 16:44:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=jgbkkpsMkr6mq3GF8AZypJ3aCnLi7q6wOU8vUA7fuqRkZvlPvCiLQfO8dJiiln3K0k
         y9XgXKDhKKc//94uGQOfckuD4CBTZOPl6n+srHjtu9n2toKAjxRgzeL7vBQ6afZ/Ji8b
         iHelzMshO7O8NMO990MDEBSf9EqTzOIzVEreE=
Message-ID: <43e72e890809181344q416b5944w3332ee5a33db048c@mail.gmail.com>
Date: Thu, 18 Sep 2008 13:44:50 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <f488382f0809181200u9aa03fcv4fc70bd1be7acc71@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0809181123n55a4979eg1996bbc30fa47d54@mail.gmail.com>
	 <43e72e890809181134ybbec8fdxcb2a466aa17fe390@mail.gmail.com>
	 <43e72e890809181142n7738cd99g522e6688e68d11ce@mail.gmail.com>
	 <f488382f0809181200u9aa03fcv4fc70bd1be7acc71@mail.gmail.com>
X-Google-Sender-Auth: 17aeb4bf0e7474b1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 12:00 PM, Steven Noonan <steven@uplinklabs.net> wrote:
> On Thu, Sep 18, 2008 at 11:42 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Thu, Sep 18, 2008 at 11:34 AM, Luis R. Rodriguez
>>> irqpoll is a monster of evil and that should make your system crawl to
>>> its knees. I would advise instead we work with you fixing the the
>>> missed interrupts issue upon rmmod.
>>
>> Also, please provide the output of
>>
>> cat /proc/interrupts
>
> Note that the problem necessitating use of irqpoll in the first place
> seems to only happen under certain conditions. I am unsure what these
> conditions are. Before 'ath9k: connectivity is lost after Group
> rekeying is done',

You mean this patch:

[PATCH] ath9k: connectivity is lost after Group rekeying is done
http://marc.info/?l=linux-wireless&m=122163541519736&w=2

So let me get this straight -- you applied this new patch, and haven't
tried disabling irqpoll now?

> I had used rmmod/modprobe as my solution to the
> issue, which triggered the IRQ issue.

Understood, but I also have used this before with ath9k and I got
exactly the same results you did -- I just refused to use it again and
just try to fix the issues present.

ath9k issues tons of interrupts, not sure why irqpoll option would
cause latency so bad as the interrupts *are* handled. Not sure
*exactly* how irqpoll works but its description mentions using it
forces each interrupt handler on the IRQ line to check the interrupt
is for it. You have to keep in mind that not only are ath9k interrupts
then being sent to the devices on its line but it would seem that all
other devices on each line would suffer from the interrupts of the
other guys. Why ath9k would be the *only* culprit of causing latency
when using irqpoll if the irq line it son is clean? Beats me.

> alcarin steven # cat /proc/interrupts
>           CPU0       CPU1
> 0x0:      63227          0   IO-APIC-edge      hpet
> 0x8:          1          0   IO-APIC-edge      rtc0
> 0x9:      13080          0   IO-APIC-fasteoi   acpi
> 0xe:       8195          0   IO-APIC-edge      ide0
> 0xf:          0          0   IO-APIC-edge      ide1
> 0x10:         36          0   IO-APIC-fasteoi   uhci_hcd:usb5
> 0x11:      10645          0   IO-APIC-fasteoi   ath

In this case your 11n Atheros device is on a clean line.

> 0x12:         42          0   IO-APIC-fasteoi   uhci_hcd:usb4
> 0x17:        919          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2

But it was this interrupt line which had an interrupt not handled.

I'm not sure why this would happen. Can't we rule out ath9k then since
its on a different interrupt line?

> 0x13:      32885          0   IO-APIC-fasteoi   uhci_hcd:usb3,
> ata_piix, ohci1394
> 0x200100:          1          0   PCI-MSI-edge      eth0
> 0x16:        223          0   IO-APIC-fasteoi   HDA Intel
> NMI:          0          0   Non-maskable interrupts
> LOC:      78087      95718   Local timer interrupts
> RES:      11576      16384   Rescheduling interrupts
> CAL:       6862       8889   Function call interrupts
> TLB:         54         41   TLB shootdowns
> TRM:          0          0   Thermal event interrupts
> THR:          0          0   Threshold APIC interrupts
> SPU:          0          0   Spurious interrupts
> ERR:          0

Can you try to reproduce the irq not handled again?

>>
>> and also please do not cross post to all these lists, just use
>> linux-wireless or ath9k.
>>
>
> Sorry, but in the past I've posted to linux-wireless, ath9k-devel, and
> all the maintainers of ath9k and didn't get a single response (except
> a 'me too' from a fellow ath9k user). I didn't just want to hear
> crickets this time.

Patches speak more than words, but yeah sorry, we should have
addressed this there. I've personally have just been busy with
tackling aggregation.

 Luis
