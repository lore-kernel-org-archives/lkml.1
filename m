Return-Path: <linux-kernel-owner+w=401wt.eu-S1755654AbZJARlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbZJARlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 13:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbZJARlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 13:41:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58619 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311AbZJARlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 13:41:16 -0400
Date: Thu, 1 Oct 2009 19:41:16 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 31/34] move virtrng_remove to .devexit.text
Message-ID: <20091001174116.GA27288@pengutronix.de>
References: <20091001082607.GA2181@pengutronix.de> <1254385718-14254-31-git-send-email-u.kleine-koenig@pengutronix.de> <200910011044.48293.borntraeger@de.ibm.com> <20091001091218.GE5718@redhat.com> <20091001093106.GA6386@pengutronix.de> <20091001094518.GI5718@redhat.com> <20091001101727.GC6386@pengutronix.de> <20091001123213.GL5718@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091001123213.GL5718@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michael,

> > But note it's not an error in general to use a .text function as remove
> > callback.  E.g. take drivers/gpio/twl4030-gpio.c.  gpio_twl4030_remove
> > is used in gpio_twl4030_probe which is defined using __devinit.  So
> > using __devexit for gpio_twl4030_remove is wrong.  (So there is a bug,
> > as gpio_twl4030_remove uses __devexit.)  I didn't try, but as far as I
> > understand this will result in a compile error if the driver is built-in
> > with HOTPLUG=n.
> 
> Wait a second.
> As far as I understand, __devexit makes it possible to remove code if
> hotplug is off.
right.
 
> At least for static functions, it's enough to mark their only use
> as _devexit_p, and compiler will remove the text as it's unused.
> 
> Isn't that right?
hmm, I don't know.  I'll try, one moment.  OK, you're right.  The
function is discarded with a compiler warning.
 
> If so, what, again, was the motivation for the patches that added
> __devexit to functions that were already used with __devexit_p?
I thought it saves some memory, but as it looks now it only fixes a
compiler warning.

Note there are two types of errors fixed in this series.  One is:

	-static int func(void arg)
	+static int __devexit func(void arg)

if the only usage of func() is wraped by __devexit_p.  This is (as
seen above) not that critical, there is only a warning fixed.

The other type results in a build failure:

	-remove = __devexit_p(another_func),
	+remove = __exit_p(another_func),

with another_func being defined using __exit.  In the case 
defined(MODULE) && defined(CONFIG_HOTPLUG) another_func is discarded,
but __devexit_p(another_func) evaluates to another_func and thus the
module doesn't link.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
