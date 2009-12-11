Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbZLKFVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbZLKFVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbZLKFVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:21:36 -0500
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:1442
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494AbZLKFVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:21:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoABAAJmIUt8qNxK/2dsb2JhbAAI10mEKwQ
X-IronPort-AV: E=Sophos;i="4.47,379,1257091200"; 
   d="scan'208";a="535022629"
Subject: Re: [PATCH 3/3] gpiolib: use chip->names for symlinks, always use
 gpioN for device names
From: Ben Nizette <bn@niasdigital.com>
To: David Brownell <david-b@pacbell.net>
Cc: Greg KH <gregkh@suse.de>, Jani Nikula <ext-jani.1.nikula@nokia.com>,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       dsilvers@simtec.co.uk, ben@simtec.co.uk, Artem.Bityutskiy@nokia.com,
       akpm@linux-foundation.org
In-Reply-To: <200912102013.59329.david-b@pacbell.net>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
	 <200912101939.30446.david-b@pacbell.net> <20091211034711.GA2773@suse.de>
	 <200912102013.59329.david-b@pacbell.net>
Content-Type: text/plain
Date: Fri, 11 Dec 2009 16:22:29 +1100
Message-Id: <1260508949.12048.227.camel@ben-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 20:13 -0800, David Brownell wrote:
> On Thursday 10 December 2009, Greg KH wrote:
> > 
> > > IMO a "good" solution in this space needs to accept that
> > > those names are not going to be globally unique ... but
> > > that they'll be unique within some context, of necessity.
> > > 
> > > If Greg doesn't want to see those names under classes,
> > > so be it ... but where should they then appear?
> > 
> > As a sysfs file within the device directory called 'name'?  Then just
> > grep through the tree to find the right device, that also handles
> > duplicates just fine, right?
> 
> I want a concrete example.  Those chip->names things don't
> seem helpful to me though...
> 
> If for example I were building a JTAG adapter on Linux, it
> might consist of a spidev node (chardev) plus a handful of
> GPIOs.  So "the device directory" would be the sysfs home
> of that spidev node (or some variant)?  And inside that
> directory would be files named after various signals that
> are used as GPIOs ... maybe SRST, TRST, and DETECT to start
> with?  Holding some cookie that gets mapped to those GPIO's
> sysfs entries?

If you've got a spidev node then you've got a dev to pass to
gpio_export_link, all's right with the world.  I think the best thing
(which I think is what Greg was thinking) would be to
have /sys/class/gpio/gpioN/name which reads null unless the kernel has
registered a name against that gpio.

Now I don't like the chip->name thing as a way to hold these labels, I'd
prefer an IDR indexed by gpio number, but that's an implementation
detail for later.

A concrete use case: I've got a board here, the support patch for which
will hopefully appear in a few days.  On it I've got an 8-bit uC which
does a bunch of I/O and on certain conditions, toggles gpio lines so a
userspace daemon knows what's going on.  At the moment, I
have /sys/class/<board name>/ which exports things like revision
information as well as attributes telling me which gpio numbers are used
for which purpose.  My scripts therefore look something like

echo 1 > /sys/class/gpio/gpio`cat /sys/class/<board-name>/ack-gpio`/value

I'm actually fairly happy with that but I don't pretend it's everyone's
cup of tea.  The point is though, the microprocessor has no in-kernel
incarnation except these few gpio so there's no convenient dev node to
link the names through; gpio_export_link() isn't useful.

This problem could be solved as I have, but it could equally-well be
solved by exporting gpioN/name attributes which I could search for.

	--Ben.

