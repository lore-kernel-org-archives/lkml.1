Return-Path: <linux-kernel-owner+w=401wt.eu-S1764536AbXHKWQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764536AbXHKWQl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 18:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762365AbXHKWQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 18:16:32 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58003 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758990AbXHKWQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 18:16:31 -0400
X-Sasl-enc: 3MgRYHE72P1yne+BNf8Bix0WbE2we3rf+WYiStGSkMLN 1186870589
Date: Sat, 11 Aug 2007 19:16:25 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: lenb@kernel.org, Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Richard Hughes <hughsient@gmail.com>
Subject: Re: [PATCH 3/3] ACPI: thinkpad-acpi: change thinkpad-acpi input
	default and kconfig help
Message-ID: <20070811221625.GB27761@khazad-dum.debian.net>
References: <11868017142597-git-send-email-hmh@hmh.eng.br> <11868017143582-git-send-email-hmh@hmh.eng.br> <20070811180602.GA17843@mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070811180602.GA17843@mellanox.co.il>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Aug 2007, Michael S. Tsirkin wrote:
> > Quoting Henrique de Moraes Holschuh <hmh@hmh.eng.br>:
> > Subject: [PATCH 3/3] ACPI: thinkpad-acpi: change thinkpad-acpi input default and kconfig help
> > 
> > The current kconfig help text was misleading users.  Also, the default for
> > an input-layer-optimized support caused way too many problems without
> > up-to-date userspace in place.
> > 
> > So, rework the help text, and change the default to N.  Note that
> > distributions are supposed to enable this option as soon as they update HAL
> > to a version that handles the thinkpad-acpi new input layer interface.
> 
> I don't really know the details here, so I could be completely wrong.

You can get up to speed through the archives of the ibm-acpi-devel
mailinglist at sourceforge.net (or gmane.org).

> However, generally, forcing HAL and kernel to be in sync really
> looks to me like a non-ideal way to handle interface change.

True.  But so far I didn't find any better way.  Sending hot key events over
the input layer and as an ACPI event at the same time is bound to cause
problems that are not that easy to work around, while configuring the driver
to send one of the two will always work, and autodetecting which channel to
use to deliver events is basically impossible (HAL, for example, always
opens the ACPI event sink, AND all input devices that issue EV_KEY).

I *can* make the compile-time option a module parameter, though.  That
wouldn't be much of a problem, and the compile-time option would select the
default for that parameter, but it would be easier to override it at run
time (you can already do it, but it requires reprogramming various driver
parameters using sysfs and the input device IOCTLs).

Would a module parameter address enough of your concerns?  Kconfig would
only set the default for that parameter, then...

> For example, this would mean that one can't use the same kernel
> for multiple distributions, and for a person like me
> that needs to switch distros all the time, it seems like a pain.

Setup the driver at boot time, then.  You can change its behaviour through
sysfs and some utility that can reprogram an input layer device keymap.  Or,
if I add a module parameter that duplicates the compile-time parameter, you
just need to use the module parameter.

> Could not the kernel expose both new and old interfaces
> somehow, so that HAL can be updated without recompiling the kernel?

It exposes all interfaces, all the time.  But you have to configure their
behaviour, and since you can't have both active at the same time, you need
to cause the driver to use the one your userland expects.

Also, there is a matter of the default of the hot key functionality (enabled
or disabled, and its masks) which used not to matter much as the driver was
basically useless without a lot configuration from userspace, but that is
not true anymore when dealing with input devices.

> For example, there could be a sysfs interface which let the HAL set
> the desired interface version.

HAL already can do that if it wants.  However, driver autodetection
information is lost when the input device is not enabled by default (you
lose the autodetected keymap).

This could be fixed by selecting whether to send events over ACPI or the
input device in a different way (but I found no better compromise than the
one I used.  Suggestions?).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
