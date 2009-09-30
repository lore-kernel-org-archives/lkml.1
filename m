Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbZI3BOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbZI3BOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 21:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbZI3BOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 21:14:55 -0400
Received: from mail-vw0-f203.google.com ([209.85.212.203]:42549 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbZI3BOy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 21:14:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=x9jJNGVhf0Oh02zFJwxBomUDcaem3W9mR+xKHk6GLNVHZCsMBfxqfd5u32sYhi4bYI
         ktdZdfnD8XqQCpsN8oNl/RWbdsrOuT1JRSo2qiLnRCSJm6IytJ4E1R9cwdf+PMW7K3SZ
         AiCTCbSMdcwc1KOMGDCTMvRSXm2SFZid6I3Hg=
MIME-Version: 1.0
In-Reply-To: <20090929153902.ab74aa01.akpm@linux-foundation.org>
References: <1253161357-22453-1-git-send-email-vapier@gentoo.org> 
	<20090929153902.ab74aa01.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 29 Sep 2009 21:14:37 -0400
Message-ID: <8bd0f97a0909291814l2de1f989lcf640633cf25b9c8@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] ad525x_dpot: new driver for AD525x 
	digital potentiometers
To: Andrew Morton <akpm@linux-foundation.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, chrisv@cyberswitching.com,
       linux-kernel@vger.kernel.org, michael.hennerich@analog.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 18:39, Andrew Morton wrote:
> On Thu, 17 Sep 2009 00:22:37 -0400 Mike Frysinger wrote:
>> This driver supports the non-volatile digital potentiometers via I2C:
>> AD5258, AD5259, AD5251, AD5252, AD5253, AD5254, and AD5255
>>
>> It provides a sysfs interface to each device for reading/writing.
>
> This sysfs interface is by far the most important aspect of this
> driver.  For both its users and for its reviewers.
>
> Yet you tell us nothing about it!  Not in code comments, not in the
> changelog, not in supporting documentation.
>
> So some poor idiot (ie: me) is left having to scratch his way through
> the implementation trying to work out what the propoed userspace
> interface is supposed to look like.

i'll have to get a description from some people

> +       if (reg & AD525X_REG_TOL)
> +               return sprintf(buf, "0x%04x\n", value & 0xFFFF);
> +       else
> +               return sprintf(buf, "%u\n", value & data->rdac_mask);
>
> which makes me suspect that the proposed userspace interface is quite
> poor.

not really.  the proposed interface was discussed with a few different
people (devs and end users) and reviewed for use across multiple parts
rather than just slapping together a raw interface onto it.  if you
actually read the datasheet as indicated in the comment you snipped,
you'll see that the value isnt formatted for trivial conversion.  if
the math can easily be done in the kernel, then that's one thing, but
it doesnt look like it to me.

this field is a read-only percentage programmed into the part by the
factory.  it can be interpreted by:
MSB: 0 = +
Next 7 MSB: 001 1100 = 28
8 LSB: 0000 1111 = 15 * 2^-8 = 0.06
Tolerance = 28.06%
Rounded Tolerance = 28.1% and therefore
RAB_ACTUAL = 12.810 kΩ

seems to me that this requires floating point support
-mike
