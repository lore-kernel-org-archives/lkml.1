Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbZJRQ70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbZJRQ70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 12:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbZJRQ7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 12:59:25 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:58465 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbZJRQ7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 12:59:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=hHKFPuoT3hN41WajxUV0Tm+fCOsQELCzaF10l94lNLWFEs5SZh/Mfsb0VAWKc5ab6B
         X8I9sEWyJQ2apwzzswJstHgXCVcbEE72n3IzXkiDknTZyfOCrchvKZmbBsUnbFJwj8PV
         /HOxVW5w3/F044XbhwzMffAzVMwgH++7eFqDY=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 2/2] rt2x00: Implement support for rt2800pci
Date: Sun, 18 Oct 2009 18:59:21 +0200
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
References: <200910152137.58164.IvDoorn@gmail.com> <200910152204.16407.IvDoorn@gmail.com> <200910171654.03344.bzolnier@gmail.com>
In-Reply-To: <200910171654.03344.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910181859.22413.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I also used the opportunity to take a closer look at this driver and
> it seems that it needlessly adds around 2 KLOC to kernel by duplicating
> the common content of rt2800usb.h to rt2800pci.h instead of moving it
> to the shared header (like it is done in the staging crap drivers):
> 
> $ wc -l drivers/net/wireless/rt2x00/rt2800usb.h drivers/net/wireless/rt2x00/rt2800pci.h
>   1951 drivers/net/wireless/rt2x00/rt2800usb.h
>   1960 drivers/net/wireless/rt2x00/rt2800pci.h
>   3911 total
> 
> $ diff -u drivers/net/wireless/rt2x00/rt2800usb.h drivers/net/wireless/rt2x00/rt2800pci.h|diffstat
>  rt2800pci.h |  213 +++++++++++++++++++++++++++++++-----------------------------
>   1 file changed, 111 insertions(+), 102 deletions(-)

Creating rt2800.h with common register defines has been on the todo list for some time already,
it will likely happen in the future, but until I get around to update my debugfs scripts the seperate
rt2800pci.h and rt2800usb.h files make debugging and register analysis a bit easier.

> Similarly it looks like most of the code between rt2800usb.c and rt2800pci.c
> could also be shared (up to another 2 KLOC saved) by adding abstraction layer
> for accessing chipset registers over different buses (again like it is done
> in staging crap drivers):
> 
> $ wc -l drivers/net/wireless/rt2x00/rt2800usb.c drivers/net/wireless/rt2x00/rt2800pci.c
>   3077 drivers/net/wireless/rt2x00/rt2800usb.c
>   3323 drivers/net/wireless/rt2x00/rt2800pci.c
>   6400 total
> 
> $ diff -u drivers/net/wireless/rt2x00/rt2800usb.c drivers/net/wireless/rt2x00/rt2800pci.c|diffstat
>  rt2800pci.c | 2190 +++++++++++++++++++++++++++++++++---------------------------
>  1 file changed, 1218 insertions(+), 972 deletions(-)

I don't agree on this, for starters the whole "abstraction layer as done in the staging driver, really
obfuscated the code in multiple areas, so whatever abstraction layer will be needed for rt2x00 it
should be done much cleaner without the ugly defines and crap like that. So unless there is a _clean_
and very _readable_ solution for such abstraction layer I might consider it.

Secondly, you can't merge them until both drivers would correctly for all users/chipsets, because only
then you can see what registers are initialized equaly, and where potential pitfalls are between the
2 busses.

> All in all, the total amount of the kernel code needed for implementing
> rt2800pci functionality should 1-2 KLOC instead of the current 5 KLOC.

Ivo
