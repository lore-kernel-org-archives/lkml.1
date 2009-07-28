Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbZG1T0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbZG1T0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbZG1T0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:26:36 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:62613 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbZG1T0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:26:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=mYHtchTin1jsAnlx+JsExxiVIUuLNqY693aoeikrZ9frH9SMIstGAMODD5auAJJVlo
         JXaPc0sCf9XQzbTMCXnUIa1hIH4kYGwDWPS9hf3PsayEgpHgCaqNDS+M+jZPKDU7kQYz
         W5nUN3bOvBD3kgilB7e7tX98HBScmTFYNVV1M=
MIME-Version: 1.0
In-Reply-To: <20090728165416.GI11494@bit.office.eurotux.com>
References: <20090727192720.GA30366@bit.office.eurotux.com>
	 <84144f020907271245q1d635e49j15a32c85303bf073@mail.gmail.com>
	 <20090728165026.GH11494@bit.office.eurotux.com>
	 <20090728165416.GI11494@bit.office.eurotux.com>
Date: Tue, 28 Jul 2009 20:19:05 +0100
Message-ID: <9b2b86520907281219g4d804f05v46af85fdb0690609@mail.gmail.com>
Subject: Re: eeepc_hotkey adds 25s to boot
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Luciano Rocha <luciano@eurotux.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, corentincj@iksaif.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/28/09, Luciano Rocha <luciano@eurotux.com> wrote:
> On Tue, Jul 28, 2009 at 05:50:26PM +0100, Luciano Rocha wrote:
>> On Mon, Jul 27, 2009 at 10:45:14PM +0300, Pekka Enberg wrote:
>> > (Adding Corentin to cc)
>> >
>> > On Mon, Jul 27, 2009 at 10:27 PM, Luciano Rocha<luciano@eurotux.com>
>> > wrote:
>> > > As subject says, loading the eeepc_hotkeys driver or including it
>> > > inside
>> > > the kernel adds 25s to the boot process:
>> > > [   13.990092] eeepc: Eee PC Hotkey Driver
>> > > [   39.560645] eeepc: Hotkey init flags 0x41
>> > > [   39.566131] eeepc: Get control methods supported: 0x101713
>> > > [   39.566418] input: Asus EeePC extra buttons as ...
>> > >
>> > > Kernel is 2.6.30.3 (with tuxonice).
>> > >
>> > > Config and full dmesg follows.
>> > >
>> > > Also, a "rmmod eeepc_hotkeys" resulted in a kernel panic. If asked,
>> > > I'll
>> > > try to replicate it.
>> >
>> > Yes, please.
>>
>> Hm, rebooted without i2c_i801, browsed some, then did a rmmod
>> eeepc_laptop:
>> ERROR!!! H2M_MAILBOX still hold by MCU. command fail
>> ERROR!!! H2M_MAILBOX still hold by MCU. command fail
>>
>> Two equal lines, yes. What does it mean?
>
> Nevermind, the wireless driver didn't like that the hardware
> disappeared.

Thanks for the bug report anyway :-).

So presumably this is what caused your oops earlier.  I assume the
wireless toggle button doesn't normally cause any errors.

The new rfkill core in 2.6.31 should avoid triggering this bug.  The
new core won't disable the wireless when the eeepc-laptop module is
removed.

But we should still fix the underlying problem.  It sounds like
there's a narrow danger window on module unload.  And it's still there
in 2.6.31-rc4:

1019 static void eeepc_rfkill_exit(void)
1020 {
1021         eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P6");
1022         eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P7");
1023         if (ehotk->wlan_rfkill)
1024                 rfkill_unregister(ehotk->wlan_rfkill);

Really we need to perform these unregistrations "at the same time".
The rfkill device relies on the notifier, but the notifier callback
also uses the rfkill device.  I guess we will need to a mutex to
synchronize unregistration (and registration).

Alan
