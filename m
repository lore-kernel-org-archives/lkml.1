Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655Ab0AUCTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab0AUCTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 21:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674Ab0AUCTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 21:19:17 -0500
Received: from mail-iw0-f196.google.com ([209.85.223.196]:47008 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab0AUCTQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 21:19:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kF87WOu/HYxHVkVyn/Rri+LvmkfUaVWPsg2QuqYw6O3zKxoVOcoGi+frdZU2MGUTjo
         Rihm9t/WqpM/EAeaE0TAFlhYIIr0difKcUxDtUt9jbK3Sy90z2f0TzM5IMKCXjyOZPHd
         3Yxldc/31Tn1YkBvcYOMUqaEBs3LuMuSa19xA=
MIME-Version: 1.0
In-Reply-To: <1264037485.1735.4988.camel@localhost.localdomain>
References: <1264011793.1735.3683.camel@localhost.localdomain>
	 <4B57A2D4.9030204@gmail.com>
	 <1264037485.1735.4988.camel@localhost.localdomain>
Date: Wed, 20 Jan 2010 20:19:14 -0600
Message-ID: <51f3faa71001201819w2d2d445dl8f4e0a8ab60a4791@mail.gmail.com>
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
From: Robert Hancock <hancockrwd@gmail.com>
To: Bastien Nocera <hadess@hadess.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 7:31 PM, Bastien Nocera <hadess@hadess.net> wrote:
> On Wed, 2010-01-20 at 18:41 -0600, Robert Hancock wrote:
>> On 01/20/2010 12:23 PM, Bastien Nocera wrote:
>> > As those computers never had any i8042 controllers, and the
>> > current lookup code could potentially lock up/hang/wait for
>> > timeout for long periods of time.
>> >
>> > Fixes intermittent hangs on boot on a MacbookAir1,1
>> >
>> > Signed-off-by: Bastien Nocera<hadess@hadess.net>
>>
>> I assume this is happening because of this code in
>> drivers/input/serio/i8042-x86ia64io.h:
>>
>>          if (!i8042_pnp_kbd_devices && !i8042_pnp_aux_devices) {
>>                  i8042_pnp_exit();
>> #if defined(__ia64__)
>>                  return -ENODEV;
>> #else
>>                  printk(KERN_INFO "PNP: No PS/2 controller found.
>> Probing ports directly.\n");
>>                  return 0;
>> #endif
>
> Actually, the error message is "i8042.c: No controller found". Which
> happens very early in a sub-function of i8042_init().
>
> So I don't think this would solve the problem.

That message comes out of i8042_controller_check which gets called
after i8042_platform_init, which does the check above. So it appears
either the "PNP: No PS/2 controller found" message should have been
printed or PNP did in fact show a controller is present..

>
>> In other words, on x86, if PNP and/or ACPI don't indicate any PS/2
>> controller exists, we randomly bang on the ports in the expectation
>> they'll be there anyway. This seems rather misguided. It would seem like
>> a better idea to fix this rather than adding yet another DMI list
>> (especially since there likely are, or will be, machines without i8042
>> other than Macs).
>
> They might also have a better BIOS than the Macs and avoid hanging when
> that happens...
>
>> I can see continuing on and probing if PNP isn't present on the machine,
>> but certainly if ACPI is enabled, I don't think we should be doing such
>> things.
>
>
