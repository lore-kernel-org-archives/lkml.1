Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbZJSP5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbZJSP5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756957AbZJSP5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:57:16 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:62450 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907AbZJSP5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:57:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=k3QgXYtBu7zDbGRx/xfbS5DymVNKW6NPfjsmzzrB43mnPaZ7sO69cNcCWFhNScnAgg
         8BFwAjD/D0ZvkGviXqf+Fw6EmgbLeWE8Ceoe/AaPqMjeTi8qABlYDCtm1n7e9+qa7H7i
         DlG74V4teVu5fcfuWqw6wltd9rFNE68WVjy2A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/2] rt2x00: Implement support for rt2800pci
Date: Mon, 19 Oct 2009 17:56:16 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31.1-56.fc12.x86_64; KDE/4.3.1; x86_64; ; )
Cc: John Linville <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
       users@host1.serialmonkey.com, Alban Browaeys <prahal@yahoo.com>,
       Benoit PAPILLAULT <benoit.papillault@free.fr>,
       Felix Fietkau <nbd@openwrt.org>,
       Luis Correia <luis.f.correia@gmail.com>,
       Mattias Nissler <mattias.nissler@gmx.de>,
       Mark Asselstine <asselsm@gmail.com>,
       Xose Vazquez Perez <xose.vazquez@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <200910152137.58164.IvDoorn@gmail.com> <200910171654.03344.bzolnier@gmail.com> <200910181859.22413.IvDoorn@gmail.com>
In-Reply-To: <200910181859.22413.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200910191756.16579.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 October 2009 18:59:21 Ivo van Doorn wrote:
> > I also used the opportunity to take a closer look at this driver and
> > it seems that it needlessly adds around 2 KLOC to kernel by duplicating
> > the common content of rt2800usb.h to rt2800pci.h instead of moving it
> > to the shared header (like it is done in the staging crap drivers):
> > 
> > $ wc -l drivers/net/wireless/rt2x00/rt2800usb.h drivers/net/wireless/rt2x00/rt2800pci.h
> >   1951 drivers/net/wireless/rt2x00/rt2800usb.h
> >   1960 drivers/net/wireless/rt2x00/rt2800pci.h
> >   3911 total
> > 
> > $ diff -u drivers/net/wireless/rt2x00/rt2800usb.h drivers/net/wireless/rt2x00/rt2800pci.h|diffstat
> >  rt2800pci.h |  213 +++++++++++++++++++++++++++++++-----------------------------
> >   1 file changed, 111 insertions(+), 102 deletions(-)
> 
> Creating rt2800.h with common register defines has been on the todo list for some time already,
> it will likely happen in the future, but until I get around to update my debugfs scripts the seperate
> rt2800pci.h and rt2800usb.h files make debugging and register analysis a bit easier.

Knowing that this driver has been in more-or-less unchanged state in your
tree for at least past half year I would say that there was a plenty of time
to fix this trivial issue..

Also are the said scripts available anywhere?

> > Similarly it looks like most of the code between rt2800usb.c and rt2800pci.c
> > could also be shared (up to another 2 KLOC saved) by adding abstraction layer
> > for accessing chipset registers over different buses (again like it is done
> > in staging crap drivers):
> > 
> > $ wc -l drivers/net/wireless/rt2x00/rt2800usb.c drivers/net/wireless/rt2x00/rt2800pci.c
> >   3077 drivers/net/wireless/rt2x00/rt2800usb.c
> >   3323 drivers/net/wireless/rt2x00/rt2800pci.c
> >   6400 total
> > 
> > $ diff -u drivers/net/wireless/rt2x00/rt2800usb.c drivers/net/wireless/rt2x00/rt2800pci.c|diffstat
> >  rt2800pci.c | 2190 +++++++++++++++++++++++++++++++++---------------------------
> >  1 file changed, 1218 insertions(+), 972 deletions(-)
> 
> I don't agree on this, for starters the whole "abstraction layer as done in the staging driver, really
> obfuscated the code in multiple areas, so whatever abstraction layer will be needed for rt2x00 it
> should be done much cleaner without the ugly defines and crap like that. So unless there is a _clean_
> and very _readable_ solution for such abstraction layer I might consider it.

Nobody was talking about duplicating any obfuscations present in the staging
driver -- adding struct rt2800_ops would be the preferred way to go.

> Secondly, you can't merge them until both drivers would correctly for all users/chipsets, because only
> then you can see what registers are initialized equaly, and where potential pitfalls are between the
> 2 busses.

Merge should be done sooner than later, or the drivers will diverge even
more, i.e. eFUSE support is needed for rt2800usb and is currently present
only in rt2800pci driver.

You can always split them later, OTOH joining diverged code bases is much
more difficult task (i.e. unifying rt2860, rt2870, rt3070 and rt3090 was)

Moreover rt2800pci doesn't work at all currently (why it is not labeled as
EXPERIMENTAL BTW, ditto for rt2800usb?) so there is no rush in merging it
and you have a plenty of time to improve your code for the usual kernel
standards (alternatively you may want consider submitting it for staging).

Could you please start looking into addressing valid review comments?

[ If you do not have a time for it, my offer to take over maintenance of
  rt2800 drivers is still actual.. ]
