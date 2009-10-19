Return-Path: <linux-kernel-owner+w=401wt.eu-S1757100AbZJSRm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbZJSRm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 13:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbZJSRm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 13:42:56 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:52123 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbZJSRmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 13:42:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=vBwuY+/PAWezQdbsmyQVNQbHmoPUiGDNuUX3DIxIe2Bl+R1kL5EZn8ndL9vgvzHi4C
         cO/IetimryQNmvh9JX8aYBylU+6VSSQSRmywktt/00OO5YQIWPqrg1GWIJcBCFDbqBRR
         uHykneXqti8N+UV5f8ONbC5pp0v9zLsgw3gfQ=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 2/2] rt2x00: Implement support for rt2800pci
Date: Mon, 19 Oct 2009 19:42:54 +0200
User-Agent: KMail/1.9.10
Cc: John Linville <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
       users@host1.serialmonkey.com, Alban Browaeys <prahal@yahoo.com>,
       Benoit PAPILLAULT <benoit.papillault@free.fr>,
       Felix Fietkau <nbd@openwrt.org>,
       Luis Correia <luis.f.correia@gmail.com>,
       Mattias Nissler <mattias.nissler@gmx.de>,
       Mark Asselstine <asselsm@gmail.com>,
       Xose Vazquez Perez <xose.vazquez@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <200910152137.58164.IvDoorn@gmail.com> <200910181859.22413.IvDoorn@gmail.com> <200910191756.16579.bzolnier@gmail.com>
In-Reply-To: <200910191756.16579.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910191942.56510.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I also used the opportunity to take a closer look at this driver and
> > > it seems that it needlessly adds around 2 KLOC to kernel by duplicating
> > > the common content of rt2800usb.h to rt2800pci.h instead of moving it
> > > to the shared header (like it is done in the staging crap drivers):
> > > 
> > > $ wc -l drivers/net/wireless/rt2x00/rt2800usb.h drivers/net/wireless/rt2x00/rt2800pci.h
> > >   1951 drivers/net/wireless/rt2x00/rt2800usb.h
> > >   1960 drivers/net/wireless/rt2x00/rt2800pci.h
> > >   3911 total
> > > 
> > > $ diff -u drivers/net/wireless/rt2x00/rt2800usb.h drivers/net/wireless/rt2x00/rt2800pci.h|diffstat
> > >  rt2800pci.h |  213 +++++++++++++++++++++++++++++++-----------------------------
> > >   1 file changed, 111 insertions(+), 102 deletions(-)
> > 
> > Creating rt2800.h with common register defines has been on the todo list for some time already,
> > it will likely happen in the future, but until I get around to update my debugfs scripts the seperate
> > rt2800pci.h and rt2800usb.h files make debugging and register analysis a bit easier.
> 
> Knowing that this driver has been in more-or-less unchanged state in your
> tree for at least past half year I would say that there was a plenty of time
> to fix this trivial issue..

Well good to see you actually read the mails I send in this, and the previous, discussion regarding
the rt2800 development. Because that would have answered your question regarding the "plenty of time" part.

> Also are the said scripts available anywhere?

http://kernel.org/pub/linux/kernel/people/ivd/tools/

There is no howto for the scripts...
I have an updated script somewhere, but that is mostly performance fixes.

> > Secondly, you can't merge them until both drivers would correctly for all users/chipsets, because only
> > then you can see what registers are initialized equaly, and where potential pitfalls are between the
> > 2 busses.
> 
> Merge should be done sooner than later, or the drivers will diverge even
> more, i.e. eFUSE support is needed for rt2800usb and is currently present
> only in rt2800pci driver.

Well nobody mentioned which USB chipsets require the eFuse EEPROM,
and I am not adding it until that is figured out.

> You can always split them later, OTOH joining diverged code bases is much
> more difficult task (i.e. unifying rt2860, rt2870, rt3070 and rt3090 was)

There have been way to many problems with the rt2800pci/usb drivers where
the ordering of the register initialization really matters. And those parts seem
to be different between rt2800pci/usb or at least they depend on different registers
to make it work.
So until that has been figured out we can try to unify the drivers then,

> Moreover rt2800pci doesn't work at all currently (why it is not labeled as
> EXPERIMENTAL BTW, ditto for rt2800usb?)

+config RT2800PCI
+	tristate "Ralink rt2800 (PCI/PCMCIA) support"
+	depends on (RT2800PCI_PCI || RT2800PCI_SOC) && EXPERIMENTAL
                                                                                            ^^^^^^^^^

The same exists for RT2800USB....

> so there is no rush in merging it 
> and you have a plenty of time to improve your code for the usual kernel
> standards (alternatively you may want consider submitting it for staging).
>
> Could you please start looking into addressing valid review comments?

Haven't I been answering all your points already?

> [ If you do not have a time for it, my offer to take over maintenance of
>   rt2800 drivers is still actual.. ]

If I am going to hand over the maintainership to somebody else
(and don't worry I will in the near future), I will hand it over to somebody
who has experience with the rt2x00 driver (i.e. actually wrote code for
the drivers).
The second requirement is that the new maintainer needs to be interested
in _all_ rt2x00 drivers, and is willing to give the priority of the development
to those drivers rather then then staging drivers.

Ivo
