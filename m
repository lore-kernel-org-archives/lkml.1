Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbXLBRmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbXLBRmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 12:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbXLBRmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 12:42:39 -0500
Received: from smtp110.plus.mail.re1.yahoo.com ([69.147.102.73]:21046 "HELO
	smtp110.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753999AbXLBRmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 12:42:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=bkwUY8qbkzVKcmz11+MYLc/rAWx2FKtdei0RTLc9m9sEZ82rA9AlvOC8nZM7urU4dvpFa9JrwNJCmu1JSeghwyyqQsV+09gCJh1CKRRhT2p158XOg+glTNngzHI+Ujhr194vWRUWmDs6M2as1s6rMQp7mHwGGXeFwcvjH/kQXkY=  ;
X-YMail-OSG: RnJb2UUVM1lsgzey66qFIPUiTgEAzQeWhnSlhxixuZ6H6rLj4TcXztmOWdpe1ze_Oo3LA.aS9n.E_3xpAbV09uKM
Date: Sun, 2 Dec 2007 18:40:59 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Lucy McCoy <lucy@keyspan.com>, Andrew Morton <akpm@linux-foundation.org>,
       greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] keyspan: init termios properly
Message-ID: <20071202174058.GA4445@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Lucy McCoy <lucy@keyspan.com>,
	Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
	linux-kernel@vger.kernel.org
References: <46954.192.168.1.71.1195161016.webmail@192.168.1.71> <20071118131130.GA3991@gollum.tnic> <20071126141852.a609cdb6.akpm@linux-foundation.org> <20071130054500.GB17350@gollum.tnic> <4750471F.5050007@keyspan.com> <20071202080340.GB6528@gollum.tnic> <20071202135734.323428c5@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071202135734.323428c5@the-village.bc.nu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2007 at 01:57:34PM +0000, Alan Cox wrote:
> On Sun, 2 Dec 2007 09:03:40 +0100
> Borislav Petkov <yme@gollum.tnic> wrote:
> 
> > On Fri, Nov 30, 2007 at 09:23:43AM -0800, Lucy McCoy wrote:
> > > Hi All,
> > >
> > > I've been too busy to get to this but i'd rather not use the code fragment 
> > > i sent Boris to try.  It would be better to go ahead with the tty setup if 
> > > the pointer is not NULL, otherwise use the defaults and not reference the 
> > > NULL pointer. I'll see if I can get to this today.
> > you might also want to take a look at usa90_indat_callback() - there is
> > port->tty accessed again and this time it kills the machine completely when
> > something is sent over the serial line from the other end (through minicom, for
> > example). Oops is at
> > 
> > http://www.screenshots.cc/view_image/ab9a1837/cimg00772.jpg
> 
> Change it to if (tty && urb->actual_length) in that function and it'll
> probably cure it
yep, this does the trick, however, this is just a brown paper bag over the issue, afaict.
Most of the usb serial drivers do something in the likes of

	struct usb_serial_port *port = (struct usb_serial_port *) urb->context;
	...
	tty = port->tty;
	...
	tty_insert_flip_{char,string,..}(tty,..)

in their _indat_callback()s.

In the keyspan case the port->tty is being accessed already in the ->open() function
from usb_console_setup(), before setting the termios settings and later again in the
_indat callback. I'm clearly missing the big picture here so what is the proper way
to initialize termios settings correctly in a driver?

-- 
Regards/Gruﬂ,
    Boris.
