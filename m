Return-Path: <linux-kernel-owner+w=401wt.eu-S1758959AbZFQQix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbZFQQix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672AbZFQQin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:38:43 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:54413 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759143AbZFQQim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:38:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rY6e5xGIgZhZpgJkTDiJgUB+HKMRyesUFv0T2WCP5KA1WJCYNAZgOsOAVl44evBLZy
         i4nNnERI6nGwYdy4pcqrFDPmOuycpGC7/XlyPSaoZ4TWiJtt2QBS5M2sr47A97lfcZ9f
         3+RhMz5tH/9vSUmZnheRm3BGb/Nd3qP8TRht0=
MIME-Version: 1.0
In-Reply-To: <20090617155337.GA10822@lenovo>
References: <19f34abd0906170811h36a7082asf68294db9490a049@mail.gmail.com>
	 <20090617151439.GC4675@lenovo>
	 <19f34abd0906170846k2a1ab1e9q36f2a47852fbb8a4@mail.gmail.com>
	 <20090617155337.GA10822@lenovo>
Date: Wed, 17 Jun 2009 18:33:31 +0200
Message-ID: <19f34abd0906170933m6be38a4cv2e4f49c3b78d71c4@mail.gmail.com>
Subject: Re: WARNING: at arch/x86/kernel/apic/apic.c:249 native_apic_write_dummy
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/17 Cyrill Gorcunov <gorcunov@gmail.com>:
> Vegard, could you test the patch?
>
>        -- Cyrill
> ---
>
> If we have apic disabled we don't even switch to APIC mode and do not
> calling for connect_bsp_APIC. Though on SMP compiled kernel the
> native_machine_shutdown does try to write the apic register anyway.
> Fix it with explicit check if we really should touch apic registers.
>
> Reported-by: Vegard Nossum <vegard.nossum@gmail.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  arch/x86/kernel/apic/io_apic.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> Index: linux-2.6.git/arch/x86/kernel/apic/io_apic.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/apic/io_apic.c
> +++ linux-2.6.git/arch/x86/kernel/apic/io_apic.c
> @@ -2003,7 +2003,9 @@ void disable_IO_APIC(void)
>        /*
>         * Use virtual wire A mode when interrupt remapping is enabled.
>         */
> -       disconnect_bsp_APIC(!intr_remapping_enabled && ioapic_i8259.pin != -1);
> +       if (cpu_has_apic)
> +               disconnect_bsp_APIC(!intr_remapping_enabled &&
> +                               ioapic_i8259.pin != -1);
>  }
>
>  #ifdef CONFIG_X86_32
>

Seems to work here:

[  317.596743] ACPI: Preparing to enter system sleep state S5
[  317.633421] Disabling non-boot CPUs ...
[  317.637493] Power down.
[  317.638305] acpi_power_off called

and no warning.

Thanks!


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
