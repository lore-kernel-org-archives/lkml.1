Return-Path: <linux-kernel-owner+w=401wt.eu-S933152AbZLNW1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbZLNW1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932885AbZLNW1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:27:12 -0500
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:2102
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932731AbZLNW1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:27:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak4BAMlKJkt8qNxK/2dsb2JhbAAI2ACEKwQ
X-IronPort-AV: E=Sophos;i="4.47,397,1257091200"; 
   d="scan'208";a="535697404"
Subject: Re: [PATCH 3/3] gpiolib: use chip->names for symlinks, always use
 gpioN for device names
From: Ben Nizette <bn@niasdigital.com>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: David Brownell <david-b@pacbell.net>, Greg KH <gregkh@suse.de>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dsilvers@simtec.co.uk" <dsilvers@simtec.co.uk>,
       "ben@simtec.co.uk" <ben@simtec.co.uk>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <1260789363.25352.7358.camel@jani-desktop>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
	 <71eff9c88d3fec3daa218341c83c19a106ee1f62.1260364108.git.ext-jani.1.nikula@nokia.com>
	 <8859db84eb13c0056e20c5edd5dba6837cb60c27.1260364108.git.ext-jani.1.nikula@nokia.com>
	 <200912101939.30446.david-b@pacbell.net>  <20091211034711.GA2773@suse.de>
	 <1260508357.12048.217.camel@ben-desktop>
	 <1260789363.25352.7358.camel@jani-desktop>
Content-Type: text/plain
Date: Tue, 15 Dec 2009 09:27:04 +1100
Message-Id: <1260829624.5729.18.camel@ben-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-14 at 13:16 +0200, Jani Nikula wrote:
> Hi David and Ben -
> 
> On Fri, 2009-12-11 at 06:12 +0100, ext Ben Nizette wrote:
> > On Thu, 2009-12-10 at 19:47 -0800, Greg KH wrote:
> > > As a sysfs file within the device directory called 'name'?  Then just
> > > grep through the tree to find the right device, that also handles
> > > duplicates just fine, right?
> > 
> > Well it bunts the handling of duplicates to who ever is grepping but
> > yea, sounds good.  The user script can sanity-check it's results against
> > the controlling gpio-chip if need be.  In fact, maybe symlink from
> > gpioN/chip back to gpio-chipY could be useful?  A bit redundant though,
> > as you can check using the number ranges..
> > 
> > In fact I thought I had a patch to create /sys/class/gpio/gpioN/name at
> > some stage..  Can't find it though, oh well.
> 
> Ben, could you please look harder? ;)

hehe, likely destroyed in the Great Hard-Disk Fire of '08.  Shouldn't be
hard to recreate, though I don't have the time at the moment.

> 
> If we were to add /sys/class/gpio/gpioN/name attribute, what would be
> the optimal source for the names?

You and I seem to be on the same page here; my $0.02 is for an IDR with
gpio_{get,set,lookup}_name() functions.  Actually, I can't remember, do
the new flex arrays efficiently store sparse array data, or are they
just useful 'coz they can grow?

Still open to debate though is whether gpio_set_name should enforce
uniqueness; is isn't required at a FS-level any more but I can't see
anything good coming from namespace collisions here.

> 
> I'd prefer a scheme where a) the name could be set in both board files
> and drivers, the latter overriding the former as necessary, and b) the
> name could be set without actually requesting the gpio, so you could set
> all known names in board files without interfering with the drivers.
> 
> AFAICS this would pretty much lead to adding a pair of new functions
> gpio_set_name() and gpio_get_name(), which would work also for gpios
> that haven't been requested. (IDR lookup Ben mentioned in another mail
> sounds good, though there's the problem you can't specify the id - this
> is why gpio_setup_irq() uses the flags for storing the id.)

Agreed.

> 
> Here are some other alternatives I could think of, but none of them
> sound good to me:
> 
> 1) Add new function gpio_export_name() to export with a certain name
> attribute. Leads to two ways of exporting.

Well 3 including _link().  I don't think that's the problem so much as
restricting naming to userspace users only.  While I can't think of
kernel users who /need/ this functionality, it'd clean a few code paths
and while we're at it, why not?

> 
> 2) Add 'name' parameter to gpio_export() to export with a certain name
> attribute. Changes an existing interface.

As above

> 
> 3) Use 'label' in gpio_request() for name attribute. Stores names also
> for gpios that are never exported, wastes a pointer per gpio in
> gpio_desc.

And while debugfs is emphatically /not/ an ABI, it's still a semantic
change to the exported information

> 
> 4) Use chip->names. Wastes a pointer per gpio even if one name is used,
> almost the same as adding char *name to struct gpio_desc. Not convenient
> to use, at least in OMAP.

Not convenient on any platform I know of, I've never liked chip->names
and would hope it goes away when (something like) the above interface is
implemented.

	--Ben.


