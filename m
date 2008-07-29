Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYG2FsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYG2FsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 01:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbYG2Fr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 01:47:59 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:7099 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbYG2Fr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:47:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=I6cn94gcA8XS64h4Nt/Od7O/ivOESJs8dtWXdqcOr+PqScNi1OExgWewcTbtesY3KW
         XB9cOcotvSPMNaE7oM+nD+m9vk7lF3zBfMEw4HVG5Dv07M1OCQDv4LpGdBrGCGDcarAI
         g4gcxYL9iqD+YdApJW9zMKrwMw61dwF0yerxI=
Date: Tue, 29 Jul 2008 01:47:53 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Alfred E. Heggestad" <aeh@db.org>
Cc: Oliver Neukum <oliver@neukum.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: driver for USB VoIP phones with CM109 chipset #2
Message-ID: <20080729054753.GB5345@anvil.corenet.prv>
References: <200806271424.50425.oliver@neukum.org> <486652D1.4010008@db.org> <20080725141420.GA29395@anvil.corenet.prv> <488B48F7.5060002@db.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488B48F7.5060002@db.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 05:55:35PM +0200, Alfred E. Heggestad wrote:
> Dmitry Torokhov wrote:
>>
>> Hi Alfred,
>>
>> I tried to adjust the patch to fix isues with CTL URB sharing between
>> keys and buzzer, bitfield access from process context and IRQ and keymap
>> loading support. The result is below. Could you please try it and see if
>> I broke it completely or if it indeed works. The patch depends on some
>> new key definitions so you probbaly want to fetch 'master' branch form
>> my tree on kernel.org before applying it.
>>
>> BTW, can I please have your 'Signed-off-by:' string so I can add it to
>> the commit?
>>
>> Thanks!
>>
>
> Hi Dmitry
>
> thanks for your patch, I have merged it into my working copy and the
> updated patch is below.
>
> Your patch is working and keys are reported as expected, buzzer is
> also working, although with some syslog warnings:
>
>
> Jul 26 17:32:22 io kernel: cm109: Keymap for Komunikate KIP1000 phone loaded
> Jul 26 17:32:22 io kernel: input: CM109 USB driver as /class/input/input14
> Jul 26 17:32:22 io kernel: usbcore: registered new interface driver cm109
> Jul 26 17:32:22 io kernel: cm109: CM109 phone driver: 20080726 (C) Alfred E. Heggestad
>
> -> key is pressed here ..
>
> Jul 26 17:32:33 io kernel: hald-addon-keyb[23629]: segfault at 6f6f6c5f ip b7e9855b sp bf9d89dc error 4 in libc-2.6.1.so[b7e28000+144000]
> Jul 26 17:32:43 io kernel: cm109: cm109_urb_ctl_callback: usb_submit_urb (urb_irq) failed -22
> Jul 26 17:33:21 io last message repeated 6 times
> Jul 26 17:34:28 io last message repeated 17 times
>
>
> Jul 26 17:35:02 io kernel: cm109: cm109_urb_ctl_callback: usb_submit_urb (urb_irq) failed -22
> Jul 26 17:35:21 io last message repeated 2 times
> Jul 26 17:35:55 io last message repeated 2 times
>
> -> module is unloaded here:
>
> Jul 26 17:35:59 io kernel: usbcore: deregistering interface driver cm109
> Jul 26 17:35:59 io kernel: cm109: cm109_toggle_buzzer_sync: usb_control_msg) failed 4
>

Hmm, should not be happening, I don't quite see anything wrong.
Hopefully USB debug that Oliver mentioned will help us figure this out.

>
> In addition the latest patch also adds support for special keys like volume up/down
> and mute, and preliminary keymap for carpophone II.
>

I wonder if we should keep adding new keymaps to the driver... Now that
setkeycode [supposedly] works we can offload this task to userspace.

>
> it is my understanding that all user-space applications must be updated
> or rewritten to consume KEY_NUMERIC_xyz ? I have written a simple application
> that reads input from /dev/input/event8 and handles KEY_NUMERIC_xyz correctly.
> this application is working with your input-branch kernel version.
>

Well, kind of. You have the option of resetting the keymap to old KEY_1
(by means of setkeycode) or you can load keymap that maps KEY_NUMERIC_1
to '1' etc for legacy console. But since you need to handle new keycodes
KEY_NUMERIC_POUND/STAR in applications anyway (we really don't want the
shift tricks because they break in sertain keyboard layouts) you may add
support for KEY_NUMERIC_[0-9] as well.

-- 
Dmitry
