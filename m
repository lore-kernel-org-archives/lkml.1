Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbZAETJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbZAETJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbZAETJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:09:47 -0500
Received: from outbound-mail-316.bluehost.com ([67.222.54.9]:58954 "HELO
	outbound-mail-316.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751760AbZAETJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:09:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=P6cgUT1/geGdTElvwiZ8xhgZtWHPkL9Ucn0ntxe3uylbMfqJlhvnBsEZjScPz+xmb6vtlHnh5/9CNnD6WHfKjtv/DrOBOX4tgJBfGV2aamSi/2X+oAasy663flwAikxm;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH] pci: fix no_pci_devices() #2
Date: Mon, 5 Jan 2009 11:09:43 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.9-73.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20081220111419.GA5367@localhost.localdomain>
In-Reply-To: <20081220111419.GA5367@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901051109.43953.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 20, 2008 3:14 am Vegard Nossum wrote:
> On Sat, Dec 20, 2008 at 11:56 AM, Vegard Nossum <vegard.nossum@gmail.com> 
wrote:
> > On Sat, Dec 20, 2008 at 9:58 AM, Greg KH <gregkh@suse.de> wrote:
> >> Care to make a patch for no_pci_devices() to work properly in this kind
> >> of situation?
> >
> > How does this look?
> >
> > I have introduced a variable pci_is_initiated, which is set after the bus
> > has been registered.
>
> This patch is simpler and also works for me. But I am not too fond of it
> either...
>
>
> Vegard
>
>
> From 1f047c86fc7a831d85174452da92344a3582a158 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Sat, 20 Dec 2008 12:08:18 +0100
> Subject: [PATCH] pci: fix no_pci_devices() #2
>
> In short, no_pci_devices() should not use bus_find_device() before
> initcalls have run, because the pci bus structure has not been
> initialized yet.
>
> Reference: http://lkml.org/lkml/2008/12/20/21
>
> Cc: Greg KH <gregkh@suse.de>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  drivers/base/bus.c  |    1 +
>  drivers/pci/probe.c |    3 +++
>  2 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 5aee1c0..5e83faf 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -931,6 +931,7 @@ bus_devices_fail:
>  bus_uevent_fail:
>  	kset_unregister(&bus->p->subsys);
>  	kfree(bus->p);
> +	bus->p = NULL;
>  out:
>  	return retval;
>  }
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 003a9b3..d561be7 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -35,6 +35,9 @@ int no_pci_devices(void)
>  	struct device *dev;
>  	int no_devices;
>
> +	if (!pci_bus_type.p)
> +		return 1;
> +
>  	dev = bus_find_device(&pci_bus_type, NULL, NULL, find_anything);
>  	no_devices = (dev == NULL);
>  	put_device(dev);

Assuming Greg already took the generic part, can you resend the PCI part to 
the linux-pci@vger.kernel.org list for review just in case anyone has a better 
idea of how to do it?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center

