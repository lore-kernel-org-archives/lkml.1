Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbXJKT6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbXJKT6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 15:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbXJKT6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 15:58:05 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:61632 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbXJKT6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 15:58:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M8YlWkMRPyuIyXCnwqjPJz2Krtm/DuL2HDGSbM5SUXGvu3cXWBsBHHpVUNnWUGEo+g7fdI9pkQc4cP48ZKT/jwtH+xKex2nDC6qSFSA0UigMEVmNZOXLE5Uv4+iPBXhQmNQfY9gzYGCwSHV4B3W9dk9BMhFHE5s8i67OJ1c1XZQ=
Message-ID: <d120d5000710111258h187920e0x13cb35358205c5e9@mail.gmail.com>
Date: Thu, 11 Oct 2007 15:58:00 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH try #3] Blackfin BF54x Input Keypad controller driver
Cc: bryan.wu@analog.com, linux-input@atrey.karlin.mff.cuni.cz,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <600D5CB4DFD93545BF61FF01473D11AC0F13ABFE@limkexm2.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <600D5CB4DFD93545BF61FF01473D11AC0F13ABFE@limkexm2.ad.analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On 10/11/07, Hennerich, Michael <Michael.Hennerich@analog.com> wrote:
> >From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> >Sent: Donnerstag, 11. Oktober 2007 19:27
> >To: bryan.wu@analog.com
> >Cc: Michael Hennerich; linux-input@atrey.karlin.mff.cuni.cz; Linux
> Kernel;
> >uclinux-dist-devel@blackfin.uclinux.org
> >Subject: Re: [PATCH try #3] Blackfin BF54x Input Keypad controller
> driver
> >
> >On Thursday 11 October 2007, Bryan Wu wrote:
> >> From: Michael Hennerich <michael.hennerich@analog.com>
> >> Date: Fri, 12 Oct 2007 00:20:19 +0800
> >> Subject: [PATCH] Blackfin BF54x Input Keypad controller driver
> >>
> >> [try #2] Changelog:
> >>  - Coding style issue fixes
> >>  - using a temp variable for bf54x_kpad->input
> >>  - Other updates according to Dmitry's review
> >>
> >> [try #3] Changelog:
> >>  - Coding style cleanups
> >>  - Use local copy of keymap
> >>  - Remove empty PM functions
> >>  - Use input_set_drvdata() since input->private is going away
> >
> >
> >This looks very good, thank youvery much. I have only 1 more suggestion
> >(and I can make the changes locally, you don't need to resubmit) -
> >since it is highly unlikely that we will have a keycode > 65535 do you
> >think we could change keymap to unsigned short. It would save you a
> >couple of bytes. I am also going to change "input->cdev.dev =
> &pdev->dev;"
> >to "input_dev->dev.parent = &pdev->dev;". Please let me know if you are
> >OK with it.
>
> Hi Dmitry,
>
> Thanks for your excellent feedback and support.
>
> We do a pretty similar thing like the omap keypad driver.
> Our keycodes do not exceed KEY_MAX but we encode the ROW and COL into
> the keycode matrix, in order simplify things in a "normal use case"? .
> What we store is u32, 16-bit for the keycode and the upper for private
> use. My understanding is that we then have to set input->keycodesize
> also being u32.
>
> Otherwise the generic input layer might get screwed up?!
>
> Am I wrong here, or do I miss something?
> Either this is a valid use case or I was inspired by a bad example.
>

Thank you very much for alerting me of omap case, I missed it.

Drivers that use complex values in their keymap tables should not use
input->keycode, keycodesize and keycodemax. These fields are only used
by input core if the driver relies on default implementation of
getkeycode() and setkeycode() for manipulations with its keymap. But
this will not work in your case (nor with omap) because your keymap
table does not contain "pure" input keycodes.

Well, I guess the easiest is just not set these fields (and remove the
per-device map allocationand copying) and say that the driver does not
support altering keymaps. After all, like you said, it is an embedded
platform and it is unlikely that users will want to alter keymaps.

However, if you think that this is a nice feature, then you either
need to rethink how you handle your keymap of implement custom
getkeycode and setkeycode methods in your driver. The coice is yours,
I will gladly accept either version of drver.

-- 
Dmitry
