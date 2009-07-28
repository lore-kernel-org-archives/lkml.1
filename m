Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbZG1UIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbZG1UIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 16:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbZG1UIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 16:08:48 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:49167 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbZG1UIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 16:08:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pp9RlmGwPSCqaw9/LjFItf2Ov27t7k1gftCnaM55HjDDzhOWDDdMVUlQOZvAIs28gW
         jfcX/XpT2vh+IEUEqjcDstracDF2vWRf5ffuiuODEXv++ih4WT+gQbV67Uy3ysbC6uIJ
         JtbtBG5D5pLn9GkIXOvoad+SVJQrCoZFbkM2c=
MIME-Version: 1.0
In-Reply-To: <9b2b86520907281219g4d804f05v46af85fdb0690609@mail.gmail.com>
References: <20090727192720.GA30366@bit.office.eurotux.com>
	 <84144f020907271245q1d635e49j15a32c85303bf073@mail.gmail.com>
	 <20090728165026.GH11494@bit.office.eurotux.com>
	 <20090728165416.GI11494@bit.office.eurotux.com>
	 <9b2b86520907281219g4d804f05v46af85fdb0690609@mail.gmail.com>
Date: Tue, 28 Jul 2009 22:08:46 +0200
Message-ID: <71cd59b00907281308m3778bbaex2e4f4ba45f7014ef@mail.gmail.com>
Subject: Re: eeepc_hotkey adds 25s to boot
From: Corentin Chary <corentin.chary@gmail.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Luciano Rocha <luciano@eurotux.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 9:19 PM, Alan
Jenkins<sourcejedi.lkml@googlemail.com> wrote:
> On 7/28/09, Luciano Rocha <luciano@eurotux.com> wrote:
>> On Tue, Jul 28, 2009 at 05:50:26PM +0100, Luciano Rocha wrote:
>>> On Mon, Jul 27, 2009 at 10:45:14PM +0300, Pekka Enberg wrote:
>>> > (Adding Corentin to cc)
>>> >
>>> > On Mon, Jul 27, 2009 at 10:27 PM, Luciano Rocha<luciano@eurotux.com>
>>> > wrote:
>>> > > As subject says, loading the eeepc_hotkeys driver or including it
>>> > > inside
>>> > > the kernel adds 25s to the boot process:
>>> > > [   13.990092] eeepc: Eee PC Hotkey Driver
>>> > > [   39.560645] eeepc: Hotkey init flags 0x41
>>> > > [   39.566131] eeepc: Get control methods supported: 0x101713
>>> > > [   39.566418] input: Asus EeePC extra buttons as ...
>>> > >
>>> > > Kernel is 2.6.30.3 (with tuxonice).
>>> > >
>>> > > Config and full dmesg follows.
>>> > >
>>> > > Also, a "rmmod eeepc_hotkeys" resulted in a kernel panic. If asked,
>>> > > I'll
>>> > > try to replicate it.
>>> >
>>> > Yes, please.
>>>
>>> Hm, rebooted without i2c_i801, browsed some, then did a rmmod
>>> eeepc_laptop:
>>> ERROR!!! H2M_MAILBOX still hold by MCU. command fail
>>> ERROR!!! H2M_MAILBOX still hold by MCU. command fail
>>>
>>> Two equal lines, yes. What does it mean?
>>
>> Nevermind, the wireless driver didn't like that the hardware
>> disappeared.
>
> Thanks for the bug report anyway :-).
>
> So presumably this is what caused your oops earlier.  I assume the
> wireless toggle button doesn't normally cause any errors.
>
> The new rfkill core in 2.6.31 should avoid triggering this bug.  The
> new core won't disable the wireless when the eeepc-laptop module is
> removed.
>
> But we should still fix the underlying problem.  It sounds like
> there's a narrow danger window on module unload.  And it's still there
> in 2.6.31-rc4:
>
> 1019 static void eeepc_rfkill_exit(void)
> 1020 {
> 1021         eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P6");
> 1022         eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P7");
> 1023         if (ehotk->wlan_rfkill)
> 1024                 rfkill_unregister(ehotk->wlan_rfkill);
>
> Really we need to perform these unregistrations "at the same time".
> The rfkill device relies on the notifier, but the notifier callback
> also uses the rfkill device.  I guess we will need to a mutex to
> synchronize unregistration (and registration).
>
> Alan
>

I think 2.6.31 is ok,

In 2.6.30, we called eeepc_unregister_rfkill_notifier after
rfkill_free, which was an error because
the notifier callback uses the rfkill device.
But I believe that the rfkill device can work without the notifier
(which is an acpi notifier).



-- 
Corentin Chary
http://xf.iksaif.net - http://uffs.org
