Return-Path: <linux-kernel-owner+w=401wt.eu-S1751632AbXBVPVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbXBVPVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 10:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbXBVPVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 10:21:07 -0500
Received: from tim.rpsys.net ([194.106.48.114]:51084 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbXBVPVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 10:21:05 -0500
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
From: Richard Purdie <rpurdie@rpsys.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alex Romosan <romosan@sycorax.lbl.gov>,
       Yaroslav Halchenko <kernel@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       James Simmons <jsimmons@infradead.org>
In-Reply-To: <20070222145613.GD25887@khazad-dum.debian.net>
References: <20070219044616.GC25659@washoe.onerussian.com>
	 <20070219000412.acad13de.akpm@linux-foundation.org>
	 <1171876788.6046.3.camel@localhost.localdomain>
	 <877iub9mu2.fsf@sycorax.lbl.gov>
	 <1172097718.5790.29.camel@localhost.localdomain>
	 <20070221231706.GA3336@khazad-dum.debian.net>
	 <1172103159.5790.45.camel@localhost.localdomain>
	 <20070222005122.GA7928@khazad-dum.debian.net>
	 <20070222011017.GA8845@khazad-dum.debian.net>
	 <1172138450.5837.34.camel@localhost.localdomain>
	 <20070222145613.GD25887@khazad-dum.debian.net>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 15:19:52 +0000
Message-Id: <1172157592.5837.89.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 12:56 -0200, Henrique de Moraes Holschuh wrote:
> On Thu, 22 Feb 2007, Richard Purdie wrote:
> > > it to Len Brown for merging into 2.6.21, or NACK it if you'd rather do it in
> > > the backlight class core.
> > 
> > We can't change the backlight class code since some hardware can't read
> > from the device, only write to it. Initialisation in that case is a bit
> > different.
> 
> Initializing stuff after registering is also racy as the device is not
> locked but we are going to clobber data in its properties struct.  I don't
> particularly care about that race, but...

If you really care, add a a call to backlight_update_status() after you
set the brightness attribute like some of the other drivers have. The
only data you're changing are single numbers and as long as
update_status is called afterwards, a consistent state is pushed to the
hardware so there is no race problem.

> Anyway, you have the 2.6.21-rc patch now, to ACK or NACK.  I still think the
> class should be handling this.  If a device is write-only, it should have no
> _get ops handler, which means that the class can easily differentiate the
> two cases and do the right thing for both.  There's less code duplication
> that way.

Have a look at what corgi_bl does. It can know what state it set the
hardware too as it keeps track itself, it just can't read that state
from the hardware. Note how there is extra code in it to handle a power
limit on the backlight under certain conditions and how this is fed back
through the class through the get_brightness method.

Adding one line of code (admittedly slight more due to error handling),
is hardly that much code duplication.

> Howerver, I *do* strongly wish for a way to combine various drivers into a
> single backlight device, where radeon/intelfb takes care of some stuff,
> ibm-acpi/asus-laptop/sony-laptop takes care of other stuff, etc.  Also, a
> standard naming for the builtin screen(s) would help, calling it "ibm",
> "asus", "sony" is not good IMHO.

I wasn't aware of this problem. If some devices need bits from both
raedon/whatever and acpi, the current implementations are just plain
wrong. Its not really a backlight class problem and more of an
implementation and interaction problem between acpi and the framebuffer
drivers. They should be presenting and registering *one* backlight class
device, not two. Without knowing more about the circumstances and
how/when to combine which drivers its hard for me to help further...

Richard


