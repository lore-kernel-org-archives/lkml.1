Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYANJ2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYANJ2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 04:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbYANJ2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 04:28:14 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:22112 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbYANJ2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:28:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xAjUi61QdA7xvezJnX5NjsFY+caGq8HHHMf4AH1jRzUoTLQ5RZYYox7/Wj/1lWOaiV3Yuo+fuzjN102+SyVeiRzAAgibOlkTjl6ZVwb74UklNF+i9bI4RzMOXfKV/NTA2kPoVMnKo5LmB0ZK20BQLNIXwsCf6j4WzYcHzNK9Sc0=
Message-ID: <8bd0f97a0801140128i2ebf9236uabe0e0b8cf15fbe@mail.gmail.com>
Date: Mon, 14 Jan 2008 04:28:11 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC, PATCH] watchdog on gpio
Cc: "Marc Pignat" <marc.pignat@hevs.ch>, wim@iguana.be,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080114090329.6efa2921@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801101611.08867.marc.pignat@hevs.ch>
	 <8bd0f97a0801140004q6a32c2ceh397a2208d3012f0e@mail.gmail.com>
	 <20080114090329.6efa2921@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 14, 2008 4:03 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > +static char banner[] __initdata = KERN_INFO PFX "fixed %d.%03d seconds timeout (nowayout= %d)\n";
> >
> > this only gets used once in the init function ... having it be broken
> > out like this is kind of silly
>
> Saves memory - you can't make inlined strings __initdata without breaking
> some compilers. So it is correct.

you could make the same argument about all strings used in all __init
functions.  making a special case for this one string is just
confusing.  this is also used from the *platfrom driver probe*
function, not the *module init* function, which means it should be
__devinitdata (see below) ... which quickly adds to the
confusion/craziness.

> > > +static int __init gpio_wdt_probe(struct platform_device *pdev)
> >
> > shouldnt this be __devinit ?
>
> IFF the device can be found/removed dynamically.

wont __init get freed once the module has finished loading ?  he's
writing a platform driver which means the resources are usually
static, but there's no hard requirement that would prevent loading a
small module that merely contains additional platform resources.  if
those resources declared a gpio watchdog, then i imagine things would
fall apart since the probe function for the registered platform driver
no longer exists.  i also dont think there's a hard logical guarantee
that the the probing step will happen after the call to the platform
device register and before the kernel finishes loading the module (and
thus frees __init resources).  so logically, using __init/__exit for
platform probe/remove drivers is plain wrong and it works here "by
accident".

> > > +       if (watchdog) {
> > > +               printk(KERN_ERR PFX "only one device supported\n");
> > > +               return -ENODEV;
> > > +       }
> >
> > why ?  it'd be trivial to abstract this driver away from a global
> > "watchdog" state into a proper arbitrary # of gpio watchdogs.
>
> The core watchdog code only supports one watchdog currently. This again
> is correct.

today you're of course correct.  but if we're looking to unify
watchdogs, keeping the 1 watchdog limit seems silly.  and considering
the trivial amount of effort to move these resources to the private
data pointers ... might as well get the work done now while it's fresh
in his mind.  his call of course though.
-mike
