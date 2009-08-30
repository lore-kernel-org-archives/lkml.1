Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbZH3MwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbZH3MwA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 08:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbZH3MwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 08:52:00 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:63817 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbZH3Mv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 08:51:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RCq4Ji0Ris5aNxDuCQEJfn+niMp6Ycc+k6MldxLnLWYopDqfjKihqSSqKgTefqV1nq
         DfX4HDd9uV3N8n63OxmLuIAFBSYWx56G2PBTyyIrwI96/GJktbrck41ojT0ALqqYHNGA
         NrTcoj7jxv6PXUKqjze7t0vHHaAA7Aq5s4kdQ=
MIME-Version: 1.0
In-Reply-To: <20090830103448.GD4334@sirena.org.uk>
References: <1250806271-24419-1-git-send-email-linus.walleij@stericsson.com>
	 <20090821105636.GA2850@sirena.org.uk>
	 <63386a3d0908291603i76603a17hc20a8d219c1dc07a@mail.gmail.com>
	 <20090830103448.GD4334@sirena.org.uk>
Date: Sun, 30 Aug 2009 14:51:57 +0200
Message-ID: <63386a3d0908300551s9c7f69dt5b3861fa329da35a@mail.gmail.com>
Subject: Re: [PATCH] AB3100 regulator support v1
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/30 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> [While setting up a child platform device from a platform driver
> probe...]
>
>> >> +     /* This would seem logical but makes everything break... */
>> >> +     /* pdev->dev.parent = parent; */
>
>> > Err...  it does?  In what way?
>
>> The sub-platform devices are added, but when I add a platform driver for
>> them, the probing does not commence, because they hang in
>> driver base/dd.c: __driver_attach() trying to take the parent semaphore,
>> i.e. this line:
>
>>       if (dev->parent)        /* Needed for USB */
>>               down(&dev->parent->sem);
>
>> In this case the parent is ab3100-regulators, the platform device for
>> the set of regulators.
>
> On the face of it (and without having actually looked at a running
> system or anything yet) I'm rather surprised that platform based MFD
> drivers aren't running into this issue more often.  CCing in Alan who
> made the change.

I think it hasn't happened a lot because most MFD:s spawn their
platform device children at subsystem_init and then register drivers
for them at driver_init. E.g. all the wm8350 children have their
drivers at higher init levels, except for the regulators which are by
chance saved by having the i2c device as parent.

> However, fixing this is not required to avoid the issue for this
> particular driver.  The problem is being caused because in addition to
> the core MFD driver for the device you've chosen to create both a
> platform device covering all regulators and further per-regulator child
> platform devices.

Yeah I know, I thought it was elegant... :-/

> If you create only one level of child device for the
> MFD you'll avoid the issue because your core device is an I2C device.
> Either have a device per regulator or have a single device which
> registers multiple regulators.

Yep I elaborated registering multiple regulators to the ab3100-regulators
platform device, I'll try this.

Linus
