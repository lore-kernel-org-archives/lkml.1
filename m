Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbZLNLRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbZLNLRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 06:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756828AbZLNLRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 06:17:10 -0500
Received: from smtp.nokia.com ([192.100.122.230]:43342 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819AbZLNLRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 06:17:05 -0500
Subject: Re: [PATCH 3/3] gpiolib: use chip->names for symlinks, always use
 gpioN for device names
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: ext Ben Nizette <bn@niasdigital.com>, David Brownell <david-b@pacbell.net>
Cc: Greg KH <gregkh@suse.de>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dsilvers@simtec.co.uk" <dsilvers@simtec.co.uk>,
       "ben@simtec.co.uk" <ben@simtec.co.uk>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <1260508357.12048.217.camel@ben-desktop>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
	 <71eff9c88d3fec3daa218341c83c19a106ee1f62.1260364108.git.ext-jani.1.nikula@nokia.com>
	 <8859db84eb13c0056e20c5edd5dba6837cb60c27.1260364108.git.ext-jani.1.nikula@nokia.com>
	 <200912101939.30446.david-b@pacbell.net>  <20091211034711.GA2773@suse.de>
	 <1260508357.12048.217.camel@ben-desktop>
Content-Type: text/plain
Date: Mon, 14 Dec 2009 13:16:03 +0200
Message-Id: <1260789363.25352.7358.camel@jani-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Dec 2009 11:16:09.0550 (UTC) FILETIME=[D6548EE0:01CA7CAE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David and Ben -

On Fri, 2009-12-11 at 06:12 +0100, ext Ben Nizette wrote:
> On Thu, 2009-12-10 at 19:47 -0800, Greg KH wrote:
> > As a sysfs file within the device directory called 'name'?  Then just
> > grep through the tree to find the right device, that also handles
> > duplicates just fine, right?
> 
> Well it bunts the handling of duplicates to who ever is grepping but
> yea, sounds good.  The user script can sanity-check it's results against
> the controlling gpio-chip if need be.  In fact, maybe symlink from
> gpioN/chip back to gpio-chipY could be useful?  A bit redundant though,
> as you can check using the number ranges..
> 
> In fact I thought I had a patch to create /sys/class/gpio/gpioN/name at
> some stage..  Can't find it though, oh well.

Ben, could you please look harder? ;)

If we were to add /sys/class/gpio/gpioN/name attribute, what would be
the optimal source for the names?

I'd prefer a scheme where a) the name could be set in both board files
and drivers, the latter overriding the former as necessary, and b) the
name could be set without actually requesting the gpio, so you could set
all known names in board files without interfering with the drivers.

AFAICS this would pretty much lead to adding a pair of new functions
gpio_set_name() and gpio_get_name(), which would work also for gpios
that haven't been requested. (IDR lookup Ben mentioned in another mail
sounds good, though there's the problem you can't specify the id - this
is why gpio_setup_irq() uses the flags for storing the id.)

Here are some other alternatives I could think of, but none of them
sound good to me:

1) Add new function gpio_export_name() to export with a certain name
attribute. Leads to two ways of exporting.

2) Add 'name' parameter to gpio_export() to export with a certain name
attribute. Changes an existing interface.

3) Use 'label' in gpio_request() for name attribute. Stores names also
for gpios that are never exported, wastes a pointer per gpio in
gpio_desc.

4) Use chip->names. Wastes a pointer per gpio even if one name is used,
almost the same as adding char *name to struct gpio_desc. Not convenient
to use, at least in OMAP.

Opinions?


BR,
Jani.


