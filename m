Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbZDGKSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbZDGKSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 06:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbZDGKRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 06:17:51 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48567 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbZDGKRu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 06:17:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xJU0IajLfQ96TYCtGTxYGVNVi4BVe0Wve7Pbr6n951fxf/yDSJS5h3XCyUPZUhe+a1
         vJ72DYaxtxewDXOS578Ch1+A6jxierIS9Aos5jSqkpXtYsiZ63JNd2LhrnRvirhLGQK2
         VSv1DEn00rSxaoxW5UgNUHU+DRfW2G5vNhKso=
MIME-Version: 1.0
In-Reply-To: <20090407091052.GA17822@damson.cased.tu-darmstadt.de>
References: <20090407091052.GA17822@damson.cased.tu-darmstadt.de>
Date: Tue, 7 Apr 2009 12:17:47 +0200
Message-ID: <5a4c581d0904070317u4feaab06i4d85498d721d20e5@mail.gmail.com>
Subject: Re: [PATCH] acpi/battery: fix async boot oops
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Len Brown <len.brown@intel.com>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 7, 2009 at 11:10 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> From 85a2a4447ce6b206d9ad20719ed8ac7cc707931c Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Tue, 7 Apr 2009 10:55:38 +0200
> Subject: [PATCH] acpi/battery: fix async boot oops
>
> 2009/4/6 Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>:
>>
>> Pulled Linus git few minutes ago and new oops at boot (happens on every boot).
>> Yesterday git version was fine. Oopsed just while/after udev started.
>
> [...]
>
>> BUG: unable to handle kernel NULL pointer dereference at (null)
>> IP: [<ffffffffa00fd040>] 0xffffffffa00fd040
>> PGD 13998a067 PUD 139979067 PMD 0
>> Oops: 0002 [#1] PREEMPT SMP
>> last sysfs file: /sys/devices/platform/i8042/modalias
>> CPU 0
>> Modules linked in: evdev(+) cfg80211(+) battery ac button crc_itu_t xfs exportfs scsi_wait_scan sd_mod crc_t10dif ahci libata scsi_mod
>> Pid: 3167, comm: async/0 Not tainted 2.6.29 #12 2764CTO
>> RIP: 0010:[<ffffffffa00fd040>]  [<ffffffffa00fd040>] 0xffffffffa00fd040
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
> ---
>  drivers/acpi/battery.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index b0de631..3c7d894 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -903,7 +903,7 @@ static struct acpi_driver acpi_battery_driver = {
>                },
>  };
>
> -static void __init acpi_battery_init_async(void *unused, async_cookie_t cookie)
> +static void acpi_battery_init_async(void *unused, async_cookie_t cookie)
>  {
>        if (acpi_disabled)
>                return;
> --
> 1.6.0.6


Just to add a Tested-by: <alessandro.suardi@gmail.com>

 (I had the same problem since -git13 on my Dell E6400, and
 this patch on top of -git14 gives me back a bootable laptop)

thanks,

--alessandro

 "Sun keeps rising in the west / I keep on waking fully confused"

   (The Replacements, "Within Your Reach")
