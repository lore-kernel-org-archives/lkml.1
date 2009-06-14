Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbZFNXAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbZFNXAw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 19:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbZFNXAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 19:00:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52991 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbZFNXAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 19:00:43 -0400
Date: Mon, 15 Jun 2009 01:00:44 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-rt@pengutronix.de,
       Thomas Gleixner <tglx@linutronix.de>, Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>
Subject: Re: [PATCH -rt] disable building all staging drivers
Message-ID: <20090614230044.GA21624@pengutronix.de>
References: <1244929118-23326-1-git-send-email-u.kleine-koenig@pengutronix.de> <20090614112802.GA4502@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090614112802.GA4502@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Sun, Jun 14, 2009 at 04:28:02AM -0700, Greg KH wrote:
> On Sat, Jun 13, 2009 at 11:38:38PM +0200, Uwe Kleine-König wrote:
> > I know that at least COMEDI and RT2870 are broken with -rt,
> 
> I didn't know this, has anyone sent me a bug report?  What in -rt causes
> these drivers to break?
> 
> > but Thomas requested disabling all of staging.  He's the maintainer.
> 
> This seems like a patch to ensure that the staging drivers never get a
> chance to be fixed for any potential -rt issues.  How about just sending
> me bug reports instead?
COMEDI has:

  CC [M]  drivers/staging/comedi/comedi_fops.o
In file included from drivers/staging/comedi/comedidev.h:40,
                 from drivers/staging/comedi/comedi_fops.c:45:
drivers/staging/comedi/interrupt.h:27: error: conflicting types for ‘irqreturn_t’
include/linux/irqreturn.h:14: error: previous declaration of ‘irqreturn_t’ was here
In file included from drivers/staging/comedi/comedidev.h:40,
                 from drivers/staging/comedi/comedi_fops.c:45:
drivers/staging/comedi/interrupt.h:30:1: warning: "IRQ_RETVAL" redefined
In file included from include/linux/interrupt.h:10,
                 from drivers/staging/comedi/interrupt.h:22,
                 from drivers/staging/comedi/comedidev.h:40,
                 from drivers/staging/comedi/comedi_fops.c:45:
include/linux/irqreturn.h:15:1: warning: this is the location of the previous definition
make[3]: *** [drivers/staging/comedi/comedi_fops.o] Error 1
make[2]: *** [drivers/staging/comedi] Error 2
make[1]: *** [drivers/staging] Error 2
make: *** [drivers] Error 2

commit

	http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commitdiff;h=bedd30d986a05e32dc3eab874e4b9ed8a38058bb
	
removes the #define IRQ_NONE and drivers/staging/comedi/interrupt.h has

	#ifndef IRQ_NONE
	typedef void irqreturn_t;
	#define IRQ_NONE
	#define IRQ_HANDLED
	#define IRQ_RETVAL(x) (void)(x)
	...

Note that Linus merged bedd30d986a05e32dc3eab874e4b9ed8a38058bb already
so that problem should exist on mainline now, too.  (I havn't tried
though.)

I cannot reproduce the failure I saw for RT2870 at the moment.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
