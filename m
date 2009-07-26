Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbZGZTpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbZGZTpi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 15:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZGZTph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 15:45:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57790 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbZGZTph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 15:45:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v2 -tip][RFC] serial8250: update to dev_pm_ops
Date: Sun, 26 Jul 2009 21:45:45 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Erik Ekman <erik@kryo.se>, Frans Pop <elendil@planet.nl>,
       Alan Cox <alan@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20090701083737.41f28c7d.erik@kryo.se> <20090725225937.dfbd4805.erik@kryo.se> <A64E62CE-DD3A-495F-A745-77588B25E495@gmail.com>
In-Reply-To: <A64E62CE-DD3A-495F-A745-77588B25E495@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907262145.46363.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 July 2009, Dmitry Torokhov wrote:
> On Jul 25, 2009, at 1:59 PM, Erik Ekman <erik@kryo.se> wrote:
> 
> > serial8250: update to dev_pm_ops
> >
> > From dmesg:
> > Platform driver 'serial8250' needs updating - please use dev_pm_ops
> >
> > Signed-off-by: Erik Ekman <erik@kryo.se>
> > --
> > Updated to handle hibernation as understood based on info from  
> > Rafael J. Wysocki.
> > Please let me know if any special handling is needed.
> >
> > diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> > index fb867a9..e93222c 100644
> > --- a/drivers/serial/8250.c
> > +++ b/drivers/serial/8250.c
> > @@ -2982,42 +2982,50 @@ static int __devexit serial8250_remove 
> > (struct platform_device *dev)
> >    return 0;
> > }
> >
> > -static int serial8250_suspend(struct platform_device *dev,  
> > pm_message_t state)
> > +static int serial8250_suspend(struct device *dev)
> > {
> >    int i;
> >
> >    for (i = 0; i < UART_NR; i++) {
> >        struct uart_8250_port *up = &serial8250_ports[i];
> >
> > -        if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev- 
> > >dev)
> > +        if (up->port.type != PORT_UNKNOWN && up->port.dev == dev)
> >            uart_suspend_port(&serial8250_reg, &up->port);
> >    }
> >
> >    return 0;
> > }
> >
> > -static int serial8250_resume(struct platform_device *dev)
> > +static int serial8250_resume(struct device *dev)
> > {
> >    int i;
> >
> >    for (i = 0; i < UART_NR; i++) {
> >        struct uart_8250_port *up = &serial8250_ports[i];
> >
> > -        if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev- 
> > >dev)
> > +        if (up->port.type != PORT_UNKNOWN && up->port.dev == dev)
> >            serial8250_resume_port(i);
> >    }
> >
> >    return 0;
> > }
> >
> > +static struct dev_pm_ops serial8250_pm_ops = {
> > +    .resume   = serial8250_resume,
> > +    .suspend  = serial8250_suspend,
> > +    .freeze   = serial8250_resume,
> > +    .thaw     = serial8250_suspend,
> > +    .restore  = serial8250_resume,
> > +    .poweroff = serial8250_suspend,
> > +};
> 
> 
> Do we really both freeze and poweroff for serial port? I am getting  
> wary of these mechanical conversions...

And this one is incorrect, because I made a mistake in one of my previous
messages.  Obviously _suspend() should not be used for .thaw(), but for
.freeze(), and analogously with _resume().

Also, .poweroff() in probably unnecessary and .freeze() is only necessary if
there's anything to be saved before hibernation and restored during the
subsequent resume.

In fact, I wouldn't advise anyone to do these conversions mechanically.

Best,
Rafael
