Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbZG2KBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbZG2KBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 06:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbZG2KBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 06:01:47 -0400
Received: from mail-bw0-f221.google.com ([209.85.218.221]:39967 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbZG2KBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 06:01:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fCYNHqw3bfWDd4ssh2MMkeAmXWH2IRhAzpBN3Yoo4HKZ+FWvi8OA/CLADkcHdBJTsD
         jp8yM0lvrV+UUuhakgLdNhF9JSqJy1xK7+weBtkSSgp8D4P55BUePXCF3m1DWQFF6M7P
         fKbDzF1iqu8OxXxGULpI/gZPBUOKN0jEcNFdc=
MIME-Version: 1.0
Date: Wed, 29 Jul 2009 11:01:45 +0100
Message-ID: <9b2b86520907290301w79d5bfa5j27c7e0142cc44ba9@mail.gmail.com>
Subject: Re: eeepc_hotkey rmmod issues
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Luciano Rocha <luciano@eurotux.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/09, Corentin Chary <corentin.chary@gmail.com> wrote:
> On Tue, Jul 28, 2009 at 9:19 PM, Alan
> Jenkins<sourcejedi.lkml@googlemail.com> wrote:
>> On 7/28/09, Luciano Rocha <luciano@eurotux.com> wrote:
>>> On Tue, Jul 28, 2009 at 05:50:26PM +0100, Luciano Rocha wrote:
>>>> On Mon, Jul 27, 2009 at 10:45:14PM +0300, Pekka Enberg wrote:
>>>> > (Adding Corentin to cc)
>>>> >
>>>> > On Mon, Jul 27, 2009 at 10:27 PM, Luciano Rocha<luciano@eurotux.com>
>>>> > wrote:
>>>> > > Also, a "rmmod eeepc_hotkeys" resulted in a kernel panic. If asked,
>>>> > > I'll
>>>> > > try to replicate it.
>>>> >
>>>> > Yes, please.
>>>>
>>>> Hm, rebooted without i2c_i801, browsed some, then did a rmmod
>>>> eeepc_laptop:
>>>> ERROR!!! H2M_MAILBOX still hold by MCU. command fail
>>>> ERROR!!! H2M_MAILBOX still hold by MCU. command fail
>>>>
>>>> Two equal lines, yes. What does it mean?
>>>
>>> Nevermind, the wireless driver didn't like that the hardware
>>> disappeared.
>>
>> Thanks for the bug report anyway :-).
>>
>> So presumably this is what caused your oops earlier.  I assume the
>> wireless toggle button doesn't normally cause any errors.
>>
>> The new rfkill core in 2.6.31 should avoid triggering this bug.  The
>> new core won't disable the wireless when the eeepc-laptop module is
>> removed.
>>
>> But we should still fix the underlying problem.  It sounds like
>> there's a narrow danger window on module unload.  And it's still there
>> in 2.6.31-rc4:
>>
>> 1019 static void eeepc_rfkill_exit(void)
>> 1020 {
>> 1021         eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P6");
>> 1022         eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P7");
>> 1023         if (ehotk->wlan_rfkill)
>> 1024                 rfkill_unregister(ehotk->wlan_rfkill);
>>
>> Really we need to perform these unregistrations "at the same time".
>> The rfkill device relies on the notifier, but the notifier callback
>> also uses the rfkill device.  I guess we will need to a mutex to
>> synchronize unregistration (and registration).
>
> I think 2.6.31 is ok,

> In 2.6.30, we called eeepc_unregister_rfkill_notifier after
> rfkill_free, which was an error because
> the notifier callback uses the rfkill device.

Ok.  I don't see how that causes Luciano's errors.  So I guess he was
right to blame the wireless driver.

> But I believe that the rfkill device can work without the notifier
> (which is an acpi notifier).

I don't think it can.

If the rfkill device is set to "soft blocked", the pci device is
removed.  If the acpi notifier is not called, the pci driver (e.g.
ath5k) won't realise the device is gone.  The network device (e.g.
wlan0) will remain present, but it won't work.

So I believe there's a circular dependency which we need to resolve.
Would you like me to write a patch for it?

Regards
Alan
