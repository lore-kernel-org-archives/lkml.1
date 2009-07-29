Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbZG2K02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbZG2K02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 06:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZG2K02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 06:26:28 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:61505 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZG2K01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 06:26:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kI6QMzCiwhAakiQ66ooS23UuvbHCvTvFpwWNLidh2oCr8nSU0qxmYzoSE3pTz2x32u
         hoiOzjz7v4CnkgAFSb0Whlt+Ma9HNTBV+q4oQI16mDQoy85piJAv1nsl+IF12Oe0WS+M
         e1VVGyiJad6UDGtir3xkRPAAW+OuollVhmC60=
MIME-Version: 1.0
In-Reply-To: <9b2b86520907290301w79d5bfa5j27c7e0142cc44ba9@mail.gmail.com>
References: <9b2b86520907290301w79d5bfa5j27c7e0142cc44ba9@mail.gmail.com>
Date: Wed, 29 Jul 2009 12:21:13 +0200
Message-ID: <71cd59b00907290321i50a51790ld2ba87cb2c61abc7@mail.gmail.com>
Subject: Re: eeepc_hotkey rmmod issues
From: Corentin Chary <corentin.chary@gmail.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Luciano Rocha <luciano@eurotux.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 12:01 PM, Alan
Jenkins<sourcejedi.lkml@googlemail.com> wrote:
> On 7/28/09, Corentin Chary <corentin.chary@gmail.com> wrote:
>> On Tue, Jul 28, 2009 at 9:19 PM, Alan
>> Jenkins<sourcejedi.lkml@googlemail.com> wrote:
>>> On 7/28/09, Luciano Rocha <luciano@eurotux.com> wrote:
>>>> On Tue, Jul 28, 2009 at 05:50:26PM +0100, Luciano Rocha wrote:
>>>>> On Mon, Jul 27, 2009 at 10:45:14PM +0300, Pekka Enberg wrote:
>>>>> > (Adding Corentin to cc)
>>>>> >
>>>>> > On Mon, Jul 27, 2009 at 10:27 PM, Luciano Rocha<luciano@eurotux.com>
>>>>> > wrote:
>>>>> > > Also, a "rmmod eeepc_hotkeys" resulted in a kernel panic. If asked,
>>>>> > > I'll
>>>>> > > try to replicate it.
>>>>> >
>>>>> > Yes, please.
>>>>>
>>>>> Hm, rebooted without i2c_i801, browsed some, then did a rmmod
>>>>> eeepc_laptop:
>>>>> ERROR!!! H2M_MAILBOX still hold by MCU. command fail
>>>>> ERROR!!! H2M_MAILBOX still hold by MCU. command fail
>>>>>
>>>>> Two equal lines, yes. What does it mean?
>>>>
>>>> Nevermind, the wireless driver didn't like that the hardware
>>>> disappeared.
>>>
>>> Thanks for the bug report anyway :-).
>>>
>>> So presumably this is what caused your oops earlier.  I assume the
>>> wireless toggle button doesn't normally cause any errors.
>>>
>>> The new rfkill core in 2.6.31 should avoid triggering this bug.  The
>>> new core won't disable the wireless when the eeepc-laptop module is
>>> removed.
>>>
>>> But we should still fix the underlying problem.  It sounds like
>>> there's a narrow danger window on module unload.  And it's still there
>>> in 2.6.31-rc4:
>>>
>>> 1019 static void eeepc_rfkill_exit(void)
>>> 1020 {
>>> 1021         eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P6");
>>> 1022         eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P7");
>>> 1023         if (ehotk->wlan_rfkill)
>>> 1024                 rfkill_unregister(ehotk->wlan_rfkill);
>>>
>>> Really we need to perform these unregistrations "at the same time".
>>> The rfkill device relies on the notifier, but the notifier callback
>>> also uses the rfkill device.  I guess we will need to a mutex to
>>> synchronize unregistration (and registration).
>>
>> I think 2.6.31 is ok,
>
>> In 2.6.30, we called eeepc_unregister_rfkill_notifier after
>> rfkill_free, which was an error because
>> the notifier callback uses the rfkill device.
>
> Ok.  I don't see how that causes Luciano's errors.  So I guess he was
> right to blame the wireless driver.

If he was using 2.6.30, then :
eeepc_unregister_rfkill_notifier() was called after rfkill_unregister()
And the callback was still registered after rfkill_unregister(), *Ooops*

In 2.6.31 we first unregister the callback, and then rfkill, so rmmod
should works.

>> But I believe that the rfkill device can work without the notifier
>> (which is an acpi notifier).
>
> I don't think it can.
>
> If the rfkill device is set to "soft blocked", the pci device is
> removed.  If the acpi notifier is not called, the pci driver (e.g.
> ath5k) won't realise the device is gone.  The network device (e.g.
> wlan0) will remain present, but it won't work.

Hum, there is a misunderstanding here. What I mean is : I think
eeepc_rfkill_exit(void) is ok in 2.6.31 (Luciano used 2.6.30).

And eeepc_rfkill_exit() is only called on rmmod eeepc-laptop

Commit 7de39389d8f61aa517ce2a8b4d925acc62696ae5 did a lot of
change in rfkill code.

> So I believe there's a circular dependency which we need to resolve.
> Would you like me to write a patch for it?

It's possible that I miss the issue here, so go ahead :)


-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
