Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbZIOQYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbZIOQYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 12:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbZIOQYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 12:24:10 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:64774 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988AbZIOQYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 12:24:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=LjwZ1LH5/ofmRXTnqMM5y2W26VBzgsGApI5y2AiOg5m4p8qPrYVaNChnjxlhSS+5Sz
         8DJ0Wwa71QeQUxez8CB/ybBL1/XvOrF1i8d229JhdaDVfNdHjravRa585+03875pAr7V
         P41fDUqbvpE0O0ikNGBkyni6tZT8zNYJewLhw=
Date: Tue, 15 Sep 2009 09:23:50 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Javier Herrero <jherrero@hvsistemas.es>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v3] input/keyboard: new OpenCores Keyboard Controller
	driver
Message-ID: <20090915162349.GA29241@core.coreip.homeip.net>
References: <1252911864-19233-1-git-send-email-vapier@gentoo.org> <1252950003-9451-1-git-send-email-vapier@gentoo.org> <200909141049.50705.dmitry.torokhov@gmail.com> <8bd0f97a0909141102l5fa309f4ua1bedd0f1ac99295@mail.gmail.com> <4AAE8908.1000104@hvsistemas.es> <20090915055224.GD1132@core.coreip.homeip.net> <8bd0f97a0909150416j444999e4sfcb6ad77146a97d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0909150416j444999e4sfcb6ad77146a97d7@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 07:16:25AM -0400, Mike Frysinger wrote:
> On Tue, Sep 15, 2009 at 01:52, Dmitry Torokhov wrote:
> > On Mon, Sep 14, 2009 at 08:18:48PM +0200, Javier Herrero wrote:
> >> It has a bit long since last time I touched the driver, so I should also
> >> try to refresh my memory about it :). I suppose that you're right in the
> >> double allocation issue (I took another keyboard driver as a starting
> >> point and probably the double allocation was already there...), so feel
> >> free to introduce the change and I will test it as soon as I can.
> >>
> >> About the exact scancode - key mapping, the reason is that since the
> >> FPGA opencores device already implements a translation table, I found
> >> that another translation table sounded a bit redundant.
> >
> > OK, below is what I have now... One concern though - don't we need to do
> > request_mem_region/ioremap for the addr_res?
> 
> i think so ... these operations are nops on a Blackfin CPU which is
> probably why it "just works".
> 

Surely request_mem_region is not a nop? I think even if uoremap is a nop
we need to convert the driver since it does not have to be on a
Blackfin, does it?

> > +struct opencores_kbd {
> > +       struct input_dev *input;
> > +       void __iomem *addr;
> > +       int irq;
> > +       struct resource *irq_res;
> 
> the irq_res member is no longer needed
> 
> +#define NUM_KEYS 128
> > +       unsigned short keycodes[NUM_KEYS];
> 
> since this is the only usage of NUM_KEYS, could just inline it now ...
> 
> > +       error = request_irq(irq, &opencores_kbd_isr,
> > +                           IRQF_TRIGGER_RISING, pdev->name, opencores_kbd);
> > +       if (error) {
> > +               dev_err(&pdev->dev, "unable to claim irq %d\n", irq);
> > +               goto err_free_mem;
> > +       }
> > +
> > +       error = input_register_device(input);
> > +       if (error) {
> > +               dev_err(&pdev->dev, "unable to register input device\n");
> > +               goto err_free_irq;
> > +       }
> 
> the input layer can handle input even if it's not registered ?

The device can survive input events as soon as it was allocated with
input_allocate_device() but of course the event will not get anywhere.
This is a property that I intend to keep since it is very convenient.

-- 
Dmitry
