Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbZFIQSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbZFIQSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbZFIQSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:18:23 -0400
Received: from mx1.emlix.com ([193.175.82.87]:45672 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbZFIQSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:18:23 -0400
From: "Oskar Schirmer" <os@emlix.com>
Date: Tue, 9 Jun 2009 18:18:18 +0200
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oskar Schirmer <os@emlix.com>, Sascha Hauer <kernel@pengutronix.de>,
       linux-kernel@vger.kernel.org, Fabian Godehardt <fg@emlix.com>
Subject: Re: [PATCH 8/8] imx: serial: add IrDA support to serial driver
Message-ID: <20090609161817.GA17246@emlix.com>
References: <1244555211-15618-1-git-send-email-os@emlix.com> <1244555211-15618-2-git-send-email-os@emlix.com> <1244555211-15618-3-git-send-email-os@emlix.com> <1244555211-15618-4-git-send-email-os@emlix.com> <1244555211-15618-5-git-send-email-os@emlix.com> <1244555211-15618-6-git-send-email-os@emlix.com> <1244555211-15618-7-git-send-email-os@emlix.com> <1244555211-15618-8-git-send-email-os@emlix.com> <1244555211-15618-9-git-send-email-os@emlix.com> <20090609160132.31265ffc@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090609160132.31265ffc@lxorguk.ukuu.org.uk>
Organization: emlix GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 16:01:32 +0100, Alan Cox wrote:
> > +#ifdef CONFIG_IRDA
> > +#define USE_IRDA(sport)	((sport)->use_irda)
> > +#else
> > +#define USE_IRDA(sport)	(0)
> > +#endif
> > +
> 
> You define this but only use it in about half the cases ?

Yes, with CONFIG_IRDA undefined several locations look like e.g.:

if (0) {
	... (sport)->irda_inv_rx ...
}

Sure, the path will be optimized away, but still
the conditional statement is subjected to syntax
and scope analysis and gcc will correctly complain
that irda_inv_rx is not declared.

On the other hand, we could omit the USE_IRDA macro
altogether, but then we would have even more ifdefs
around.

> 
> > +#ifdef CONFIG_IRDA
> > +	if (sport->use_irda) {
> > +		/* half duplex - wait for end of transmission */
> > +		int n = 256;
> 
> Otherwise this series looks sound.
> 
> While you are fiddling with the baud rate the driver really should work
> out the resulting actual baud rate and call
> 
> 	tty_encode_baud_rate(tty, in-rate, out-rate);
> 
> that will report back the resulting rate and knows how to encode all the
> termios fields as well as reporting close values to the requested speed
> as the speed requested (eg if you ask for B38400 and it tries to encode
> 38215 or similar it will encode back B38400)

Ok, the driver will need another fix here with respect to its
interface to the upper layers. But the changes in
baud rate calculation we made are with focus on correct
peripheral register settings, because the old baud rate
calculation was not accurate enough for IrDA use.
That's why we introduced the approximation function
(and finally generalised it into lib/).

  Oskar
