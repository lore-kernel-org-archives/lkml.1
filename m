Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458Ab0AUWRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab0AUWRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 17:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200Ab0AUWRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 17:17:20 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:64378 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab0AUWRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 17:17:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=CCYLKoC7UkDYlkX920ccaglRayFKL8HdsQjMYJ9FYL7APzIvcvSxBVgyDqsXa0utW3
         YwtmLCcfs8uYfH6690hY5C5yW0287MgTyoGCAaAs8HsVQ6FTw0lQtNCpswUAW04oKVPf
         oLlIPd+mKgktUCMceOZvHB1N1ak9syxSCMGw4=
Date: Thu, 21 Jan 2010 14:17:01 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Bastien Nocera <hadess@hadess.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com,
       vojtech@suse.cz
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
Message-ID: <20100121221701.GA15293@core.coreip.homeip.net>
References: <1264011793.1735.3683.camel@localhost.localdomain>
 <4B57A2D4.9030204@gmail.com>
 <20100121185544.GB11996@core.coreip.homeip.net>
 <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 03:39:25PM -0600, Robert Hancock wrote:
> On Thu, Jan 21, 2010 at 12:55 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Wed, Jan 20, 2010 at 06:41:56PM -0600, Robert Hancock wrote:
> >> On 01/20/2010 12:23 PM, Bastien Nocera wrote:
> >> >As those computers never had any i8042 controllers, and the
> >> >current lookup code could potentially lock up/hang/wait for
> >> >timeout for long periods of time.
> >> >
> >> >Fixes intermittent hangs on boot on a MacbookAir1,1
> >> >
> >> >Signed-off-by: Bastien Nocera<hadess@hadess.net>
> >>
> >> I assume this is happening because of this code in
> >> drivers/input/serio/i8042-x86ia64io.h:
> >>
> >>         if (!i8042_pnp_kbd_devices && !i8042_pnp_aux_devices) {
> >>                 i8042_pnp_exit();
> >> #if defined(__ia64__)
> >>                 return -ENODEV;
> >> #else
> >>                 printk(KERN_INFO "PNP: No PS/2 controller found.
> >> Probing ports directly.\n");
> >>                 return 0;
> >> #endif
> >>
> >> In other words, on x86, if PNP and/or ACPI don't indicate any PS/2
> >> controller exists, we randomly bang on the ports in the expectation
> >> they'll be there anyway. This seems rather misguided.
> >
> > Basically, we do not trust BIOS writers on x86 ;) In the past there were
> > occasions when they forgot to mention presence of KBD/AUX in DSDT and
> > elsewhere which lead to non-functional keyboard/mouse.
> 
> Are we certain about that? Any pointers to reports?
> 

This is from the changelog when this was introduced:

-------------------------------------------------------------------------
2005/02/25 21:21:03+01:00 vojtech
input: After testing on real world hardware, it's obvious we can't trust
       ACPIPnP nor PnPBIOS to properly report the existence of a keyboard
       and mouse port in all cases. Some BIOSes hide the ports if no mouse
       or keyboard is connected, causing trouble with eg. KVM switches.

       The i8042 driver now does read-only probing first, which should
       not cause any problems even if an i8042 controller really is not
       present.

       However, on IA64 we still need to trust ACPI, since legacy-free
       hardware is common there and invalid port accesses cause exceptions.

 Signed-off-by: Vojtech Pavlik <vojtech@suse.cz>

>> Input: Add ACPI-based i8042 keyboard and aux controller enumeration;
> > can be disabled by passing i8042.noacpi as a boot parameter.
> 
> On a whim I decided to turn on ACPI, only to discover that my keyboard
> no longer worked. Passing i8042.noacpi=1 makes it work again.
> Attached please find boot messages with and without the boot
> parameter. Inlined below is a diff of the two.

--------------------------------------------------------------------------

I'm adding Vojtech in case he manages to recall what other failures he
has seen.

> >
> >> It would seem
> >> like a better idea to fix this rather than adding yet another DMI
> >> list (especially since there likely are, or will be, machines
> >> without i8042 other than Macs).
> >>
> >
> > If they are not Macs that mean they are tested with windows and thus
> > expect probes in i8042 port region so no harm done. In a few years if
> > everyone uses USB only we could add a year threshold to trust ACPI/PNP
> > data.
> 
> Macs will be tested with Windows too, so obviously it manages to avoid
> this problem somehow, and I very much doubt it has an Apple-specific
> check..

Why not?

-- 
Dmitry
