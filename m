Return-Path: <linux-kernel-owner+w=401wt.eu-S1761273AbXKONQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761273AbXKONQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 08:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757662AbXKONQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 08:16:21 -0500
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:56614 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473AbXKONQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 08:16:19 -0500
Date: Thu, 15 Nov 2007 14:15:36 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: EIP is at device_shutdown+0x32/0x60
Message-ID: <20071115141536.696e3611@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071115213345.B3C1.Y-GOTO@jp.fujitsu.com>
References: <20071115091158.GB6216@localhost.sw.ru>
	<20071115014446.f943d835.akpm@linux-foundation.org>
	<20071115213345.B3C1.Y-GOTO@jp.fujitsu.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0-rc1 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 21:55:34 +0900,
Yasunori Goto <y-goto@jp.fujitsu.com> wrote:

> /**
>  * device_shutdown - call ->shutdown() on each device to shutdown.
>  */
> void device_shutdown(void)
> {
>         struct device * dev, *devn;
> 
>         list_for_each_entry_safe_reverse(dev, devn, &devices_kset->list,
>                                 kobj.entry) {
>                 if (dev->bus && dev->bus->shutdown) {
>                         dev_dbg(dev, "shutdown\n");
>                         dev->bus->shutdown(dev);
>                 } else if (dev->driver && dev->driver->shutdown) {
>                         dev_dbg(dev, "shutdown\n");
>                         dev->driver->shutdown(dev);
>                 }
>         }
> }
> --------
> When oops occured, dev->driver pointed kset_ktype's address,
> and dev->driver->shutdown was the address of bus_type_list.
> So, Oops was caused by "Illegal operation fault".
> kset_ktypes is pointed by system_kset.
> 
> If my understanding is correct, this loop can't distinguish between
> struct device and struct kset, but both are connected in this list,
> right? It may be the cause of this.

Uh. This fits with my observations on s390 as well (the list is not
corrupted, but it contains entities that are not devices...)

The other entries under /sys/devices (on my system css0, platform,
qeth) are all struct devices. This sysdev stuff is headache-inducing :(
