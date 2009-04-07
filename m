Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbZDGTQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbZDGTQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZDGTQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:16:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55447 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbZDGTQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:16:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH] acpi/battery: fix async boot oops
Date: Tue, 7 Apr 2009 21:16:31 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Len Brown <len.brown@intel.com>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <20090407091052.GA17822@damson.cased.tu-darmstadt.de>
In-Reply-To: <20090407091052.GA17822@damson.cased.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904072116.32475.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009, Vegard Nossum wrote:
> From 85a2a4447ce6b206d9ad20719ed8ac7cc707931c Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Tue, 7 Apr 2009 10:55:38 +0200
> Subject: [PATCH] acpi/battery: fix async boot oops
> 
> 2009/4/6 Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>:
> >
> > Pulled Linus git few minutes ago and new oops at boot (happens on every boot).
> > Yesterday git version was fine. Oopsed just while/after udev started.
> 
> [...]
> 
> > BUG: unable to handle kernel NULL pointer dereference at (null)
> > IP: [<ffffffffa00fd040>] 0xffffffffa00fd040
> > PGD 13998a067 PUD 139979067 PMD 0
> > Oops: 0002 [#1] PREEMPT SMP
> > last sysfs file: /sys/devices/platform/i8042/modalias
> > CPU 0
> > Modules linked in: evdev(+) cfg80211(+) battery ac button crc_itu_t xfs exportfs scsi_wait_scan sd_mod crc_t10dif ahci libata scsi_mod
> > Pid: 3167, comm: async/0 Not tainted 2.6.29 #12 2764CTO
> > RIP: 0010:[<ffffffffa00fd040>]  [<ffffffffa00fd040>] 0xffffffffa00fd040
> 
> What happens is that the battery module's init sections are being freed
> before the async callback (which was marked __init) has run. This theory
> is supported by the fact that the bad RIP value is a vmalloc address.
> 
> The immediate fix is to make this a non-init call.
> 
> (A better long-term fix is of course to wait with init-section unloading
> until a module's async initcalls have been run, which would allow us to
> discard this function which is still only run once, after all. Perhaps a
> new async_initcall() function for the async/module API, if this is needed
> for other modules in the future?)
> 
> Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>

This patch is necessary to fix a boot oops on my test box(es).

Tested-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  drivers/acpi/battery.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index b0de631..3c7d894 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -903,7 +903,7 @@ static struct acpi_driver acpi_battery_driver = {
>  		},
>  };
>  
> -static void __init acpi_battery_init_async(void *unused, async_cookie_t cookie)
> +static void acpi_battery_init_async(void *unused, async_cookie_t cookie)
>  {
>  	if (acpi_disabled)
>  		return;
