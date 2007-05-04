Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbXEDFNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbXEDFNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 01:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbXEDFNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 01:13:16 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:50660 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbXEDFNP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 01:13:15 -0400
Date: Thu, 3 May 2007 22:13:13 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Markus Rechberger <mrechberger@gmail.com>, linux-dvb@linuxtv.org,
       linux-kernel@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] Re: DST/BT878 module customization (..	was:	Critical
 points about ...)
In-Reply-To: <1178200976.12651.104.camel@localhost>
Message-ID: <Pine.LNX.4.58.0705032123340.32689@shell2.speakeasy.net>
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com> 
 <1178031333.3958.63.camel@localhost>  <Pine.LNX.4.58.0705011606070.309@shell2.speakeasy.net>
  <1178071431.11109.62.camel@localhost>  <Pine.LNX.4.58.0705020348080.309@shell2.speakeasy.net>
 <1178200976.12651.104.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Mauro Carvalho Chehab wrote:
> Em Qua, 2007-05-02 às 04:10 -0700, Trent Piepho escreveu:
> > I promise, this time it's right!
> > http://linuxtv.org/hg/~tap/dst-new
>
> Confirmed. Now the patch is properly working. My tests were done with a
> board with DST. Those are the results:
>
> 1) when DST is unselected, on a board with DST, it will print the errors
> indicating that the Kconfig items were not selected:
>
> DVB: registering new adapter (bttv0).
> DVB: Unable to find symbol dst_attach()
> frontend_init: Could not find a Twinhan DST.
> dvb-bt8xx: A frontend driver was not found for device 109e/0878 subsystem fbfb/f800
>
> The only issue is the wrong printk msg, stating that a "frontend driver"
> were not found. As this issue also happens with the current driver, due
> the usage of dvb_attach() macro, I don't see any regressions.
>
> It would be nice, however, to have a patch making dvb_attach more
> generic, by e.g. having a variant that allows passing another message.

Only this message is from dvb_attach():
> DVB: Unable to find symbol dst_attach()

Is it saying that it cannot load the module that dst_attach() is in (it
doesn't know what module that is, modprobe knows that).  If you enabled dst
support and deleted the module, it would be the same.

If you turn off dvb_attach() and also disable dst, you should instead get
this message:
dst_attach: driver disabled by Kconfig

Maybe that would look nicer with a "DVB:  " prefix?  That would easier if it
wasn't necessary to update the printk in each boilerplate stub function.  What
if one macro created these stubs....

> frontend_init: Could not find a Twinhan DST.
> dvb-bt8xx: A frontend driver was not found for device 109e/0878 subsystem fbfb/f800

These two messages are printed by the dvb-bt8xx driver, not by dvb_attach().
It would be trivial to change of course, but I'm not sure what would be
pedantically correct for both dst and non-dst based hardware.

> There's an argument against the prototype changes on dst_attach and
> dst_ca_attach since they aren't frontend.

The reason I changed that, is the dst_attach() already did return a
dvb_frontend pointer, it was just inside an enclosing structure.  i.e. what
existed before:

{
	struct dst_state *state;
	state = dst_attach(...);
	card->fe = &state->frontend;
} /* state goes out of scope */

The frontend is inside the state struct and the state pointer isn't saved
anywhere.  dvb-bt8xx just saves a frontend pointer from inside the dst state
and tosses the state pointer away.  So I changed that to:

	card->fe = dst_attach(...);
