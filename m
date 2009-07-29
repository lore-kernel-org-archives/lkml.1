Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbZG2MP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbZG2MP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbZG2MP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:15:58 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:34662 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbZG2MP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:15:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=joHEnA8rwK17o4Yr17PR88jRtQFr+mGWrddIKG8NYim5lJUZNFj4S+V1NLFvBWxEOq
         xAkJVQIqpeAM8WSIFyLauaetvBWpe5Y3e4lfm/Z4aw16aNi1y6RUVct5f25U0zzHLMd1
         2Xqy3Rf//ZL4uElx5MCwe2qtLYmBBZpepqxtg=
MIME-Version: 1.0
In-Reply-To: <4A703A43.8050808@googlemail.com>
References: <9b2b86520907290301w79d5bfa5j27c7e0142cc44ba9@mail.gmail.com>
	 <71cd59b00907290321i50a51790ld2ba87cb2c61abc7@mail.gmail.com>
	 <4A703A43.8050808@googlemail.com>
Date: Wed, 29 Jul 2009 14:15:56 +0200
Message-ID: <71cd59b00907290515h6b02d43fkccca980f5ddefba9@mail.gmail.com>
Subject: Re: eeepc_hotkey rmmod issues
From: Corentin Chary <corentin.chary@gmail.com>
To: alan-jenkins@tuffmail.co.uk
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 2:02 PM, Alan
Jenkins<sourcejedi.lkml@googlemail.com> wrote:
> On 7/29/09, Corentin Chary <corentin.chary@gmail.com> wrote:
>> On Wed, Jul 29, 2009 at 12:01 PM, Alan
>> Jenkins<sourcejedi.lkml@googlemail.com> wrote:
>>> On 7/28/09, Corentin Chary <corentin.chary@gmail.com> wrote:
>>>> On Tue, Jul 28, 2009 at 9:19 PM, Alan
>>>> Jenkins<sourcejedi.lkml@googlemail.com> wrote:
>
>>>>> But we should still fix the underlying problem.  It sounds like
>>>>> there's a narrow danger window on module unload.  And it's still there
>>>>> in 2.6.31-rc4:
>>>>>
>>>>> 1019 static void eeepc_rfkill_exit(void)
>>>>> 1020 {
>>>>> 1021         eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P6");
>>>>> 1022         eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P7");
>>>>> 1023         if (ehotk->wlan_rfkill)
>>>>> 1024                 rfkill_unregister(ehotk->wlan_rfkill);
>>>>>
>>>>> Really we need to perform these unregistrations "at the same time".
>>>>> The rfkill device relies on the notifier, but the notifier callback
>>>>> also uses the rfkill device.  I guess we will need to a mutex to
>>>>> synchronize unregistration (and registration).
>>>>
>>>> I think 2.6.31 is ok,
>>>
>>>> In 2.6.30, we called eeepc_unregister_rfkill_notifier after
>>>> rfkill_free, which was an error because
>>>> the notifier callback uses the rfkill device.
>>>
>>> Ok.  I don't see how that causes Luciano's errors.  So I guess he was
>>> right to blame the wireless driver.
>>
>> If he was using 2.6.30, then :
>> eeepc_unregister_rfkill_notifier() was called after rfkill_unregister()
>> And the callback was still registered after rfkill_unregister(), *Ooops*
>>
>> In 2.6.31 we first unregister the callback, and then rfkill, so rmmod
>> should works.
>>
>>>> But I believe that the rfkill device can work without the notifier
>>>> (which is an acpi notifier).
>>>
>>> I don't think it can.
>>>
>>> If the rfkill device is set to "soft blocked", the pci device is
>>> removed.  If the acpi notifier is not called, the pci driver (e.g.
>>> ath5k) won't realise the device is gone.  The network device (e.g.
>>> wlan0) will remain present, but it won't work.
>>
>> Hum, there is a misunderstanding here. What I mean is : I think
>> eeepc_rfkill_exit(void) is ok in 2.6.31 (Luciano used 2.6.30).
>>
>> And eeepc_rfkill_exit() is only called on rmmod eeepc-laptop
>>
>> Commit 7de39389d8f61aa517ce2a8b4d925acc62696ae5 did a lot of
>> change in rfkill code.
>>
>>> So I believe there's a circular dependency which we need to resolve.
>>> Would you like me to write a patch for it?
>>
>> It's possible that I miss the issue here, so go ahead :)
>
> Thanks :)
>
> Here is a test case to show the race I am talking about
>
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index ec560f1..c478db5 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -1020,6 +1020,17 @@ static void eeepc_rfkill_exit(void)
>  {
>        eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P6");
>        eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P7");
> +
> +       //
> +       // Simulated error
> +       // Imagine that userspace set the wifi to "soft blocked" at this exact moment
> +       // (or the wireless toggle key was pressed)
> +       //
> +       // The PCI device will disappear, but we will not see any notification
> +       //
> +       set_acpi(CM_ASL_WLAN, 0);
> +       rfkill_set_sw_state(ehotk->wlan_rfkill, true);
> +
>        if (ehotk->wlan_rfkill)
>                rfkill_unregister(ehotk->wlan_rfkill);
>        if (ehotk->bluetooth_rfkill)
>
>
>
> If you unload eeepc-laptop with this simulated race, the wireless
> interface stays around but stops working.
>
> [  191.391155] ath5k phy0: can't reset hardware (-5)
> [  191.432983] ath5k phy0: failed to wakeup the MAC Chip
> [  196.940835] __ratelimit: 21 callbacks suppressed
>
> Alan
>

Indeed :) . Let's serialize that. Do you want me to do it ?
Thanks,

-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
