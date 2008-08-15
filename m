Return-Path: <linux-kernel-owner+w=401wt.eu-S1760417AbYHOPur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760417AbYHOPur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbYHOPuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:50:37 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:20965 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbYHOPug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:50:36 -0400
Date: Fri, 15 Aug 2008 17:50:14 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <greg@kroah.com>
Cc: Milton Miller <miltonm@bga.com>, Michael Ellerman <michael@ellerman.id.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH/RFC] pci: dynids.use_driver_data considered harmful
Message-ID: <20080815175014.2e005377@hyperion.delvare>
In-Reply-To: <20080814221214.GG30057@kroah.com>
References: <for-27-patch1-0@bga.com>
	<for-27-patch9@bga.com>
	<20080712041137.GA5933@kroah.com>
	<e6b3109a0ab047bea58ceecb8734761d@bga.com>
	<0a67ecbf69649dce778db1b463e59c3a@bga.com>
	<ad61f8387a737bc410e9d6dc3a8a5b63@bga.com>
	<20080717070759.GE22090@kroah.com>
	<20080806093118.05396ad4@hyperion.delvare>
	<20080814221214.GG30057@kroah.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, 14 Aug 2008 15:12:14 -0700, Greg KH wrote:
> On Wed, Aug 06, 2008 at 09:31:18AM +0200, Jean Delvare wrote:
> > Hi Greg,
> > 
> > On Thu, 17 Jul 2008 00:07:59 -0700, Greg KH wrote:
> > > On Wed, Jul 16, 2008 at 05:18:18AM -0500, Milton Miller wrote:
> > > >
> > > > Greg,
> > > >
> > > > Please respond to this email and explain why the patch
> > > >
> > > > pci: dynids.use_driver_data considered harmful
> > > >
> > > > http://www.ussg.iu.edu/hypermail/linux/kernel/0807.1/index.html#2188
> > > >
> > > > should not be applied.   I am not arguing the correctness of
> > > > the removed code, rather its utility and benefit to the linux
> > > > community.
> > >
> > > (...)  I'll try to get
> > > to this by Monday, but my original point still stands, this was
> > > implemented for a reason,
> > 
> > Not a good enough argument, sorry. There have been many cases in the
> > past where code has been withdrawn after some times because we
> > realized that we got it wrong in the first place.
> 
> Fair enough :)
> 
> > So, please explain what the current code is good for. Honestly, my
> > initial reaction to Milton's proposal was "what an idiot, this flag is
> > there for an obvious safety reason and we don't want to remove it" but
> > after reading both his arguments and the code, I found that I have
> > nothing to backup my claim. If you do, please let us know your
> > technical reasons.
> 
> The technical reason was that this flag was needed to let some drivers
> work properly with the new_id file, right?

Hmm, so in fact you don't have a clue? ;)

I wasn't involved in the addition of this flag, but my impression is
that it was added in the hope that it would prevent users from passing
additional data to drivers using the driver_data field but not prepared
(read: not robust enough) to handle possibly wrong data from user-space.
Probably, the idea was that the person adding the
dynids.use_driver_data flag would be responsible for verifying that the
driver had the required checks in place to guarantee that "nothing"
would go wrong even if the data provided by the user wasn't correct.

(This doesn't make much sense IMHO, as there is zero guarantee that the
developer actually did that - but I believe this is the idea behind the
dynids.use_driver_data flag.)

> If the flag goes away, they break from what I can tell.

If the flag goes away, nothing will break per se. In particular, the
drivers which were using the flag won't stop working - you don't prevent
things from happening when removing a safety, on the contrary, you
allow more things to happen. What will change is that all the drivers
which _do_ use the driver_data field but didn't set the
dynids.use_driver_data flag, will now possibly receive their driver_data
from the user.

Which you may say is unsafe, because these drivers may not expect that
(i.e. they probably don't have any check to protect themselves against
bogus driver_data values.) But OTOH most of these drivers can't really
take dynamic IDs at the moment (because the code prevents the user from
passing the required driver_data, silently forcing it to 0) so this
would be a big win in terms of usability. On top of that, considering
that (silently) defaulting to 0 for driver_data is safe, is just plain
wrong. 0 might be an invalid driver_data value for some drivers.

> > >                           saying that not enough drivers use it properly
> > > does not make the need for it to go away.  It is required for them, so
> > > perhaps the other 419 drivers also need to have the flag set.  That's
> > > pretty trivial to do, right?
> > 
> > If you are suggesting to blindly set the flag to all PCI drivers (or
> > even just all the ones which make use of the driver_data field -
> > doesn't make a difference), this simply shows how useless this flag is.
> > If you don't, then one would have to check the code of all drivers and
> > add validation code for the driver_data value; but then this no longer
> > falls into the "trivial" category.
> 
> It's pretty "trivial" to look to see if the field is set in the pci_id
> structure, that should be all that is needed, right?

Well... If you consider that all drivers using the driver_data field
should have the dynids.use_driver_data flag set unconditionally and
without looking at the code, then in fact you agree with Milton and
myself that this flag should be dropped. The whole point of the flag,
if my guess is correct, was to hint the developer that he/she should
double check his/her code before setting the flag. If you set it for
all these drivers, then all it does is preventing users from passing a
driver_data value to drivers which do _not_ use the driver_data... but
doing that has zero effect at the moment, so that wouldn't actually be
any different from dropping dynids.use_driver_data altogether.

So I have to reiterate my support to Milton's idea of dropping
the dynids.use_driver_data flag. It does more harm than good.

Thanks,
-- 
Jean Delvare
