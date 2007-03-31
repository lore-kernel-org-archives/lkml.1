Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbXCaPBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbXCaPBQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 11:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbXCaPBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 11:01:16 -0400
Received: from smtp-1.hut.fi ([130.233.228.91]:58452 "EHLO smtp-1.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbXCaPBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 11:01:15 -0400
Date: Sat, 31 Mar 2007 18:00:34 +0300 (EEST)
From: Mikko Tiihonen <mikko.tiihonen@iki.fi>
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
cc: Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org,
       ranma@tdiedrich.de, om.turyx@gmail.com
Subject: Re: [PATCH 1/5] RT kernel: force detect HPET from PCI space
In-Reply-To: <1175340987.4174.9.camel@rousalka.dyndns.org>
Message-ID: <Pine.OSF.4.64.0703311746170.412261@kosh.hut.fi>
References: <Pine.OSF.4.64.0703310049090.412261@kosh.hut.fi>
 <1175294288.32441.6.camel@rousalka.dyndns.org> <m3bqi9u2an.fsf@maximus.localdomain>
 <1175340987.4174.9.camel@rousalka.dyndns.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-TKK-Virus-Scanned: by amavisd-new-2.1.2-hutcc at katosiko.hut.fi
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 31 Mar 2007, Nicolas Mailhot wrote:

> [adding some people in CC that expressed interest in the problem before]
>
> I'm crazy enough to test a patch if someone cooks it, but I'm way out of
> my depth there :)

After struggling with totally broken kernels for the whole morning I got the 
HPET to work with my NForce4 with the following hard coded ACPI quirk. My 
machine has been now stable for few hours and I tested that the HPET really 
seems to be working by switching the clock source using

echo hpet|tsc|acpi_pm > /sys/devices/system/clocksource/clocksource0/current_clocksource

Results of a simple benchmark show that the time to execute gettimeofday 
really varies based on the clock source: (performance normalised to tsc)
tsc:      1x
hpet:     4x
acpi_pm: 12x

At least on my motherboard it seems to be enough to just grab the HPET address 
from the lspci output and not bother with any of the other changing bits.

--- linux-2.6.21-rc5-git5/arch/i386/kernel/acpi/boot.c	2007-03-31 17:49:24.000000000 +0300
+++ linux-2.6.21-rc5-git5.hpet/arch/i386/kernel/acpi/boot.c	2007-03-31 17:02:27.000000000 +0300
@@ -1189,6 +1189,8 @@ int __init acpi_boot_table_init(void)

  int __init acpi_boot_init(void)
  {
+        struct acpi_table_hpet hpet_tbl;
+
  	/*
  	 * If acpi_disabled, bail out
  	 * One exception: acpi=ht continues far enough to enumerate LAPICs
@@ -1208,7 +1210,12 @@ int __init acpi_boot_init(void)
  	 */
  	acpi_process_madt();

-	acpi_table_parse(ACPI_SIG_HPET, acpi_parse_hpet);
+	hpet_tbl.address.address = 0xfefff000L;
+	hpet_tbl.address.space_id = ACPI_SPACE_MEM;
+	hpet_tbl.sequence = 0;
+	hpet_tbl.id = 0xbabe;
+        acpi_parse_hpet((struct acpi_table_header *) &hpet_tbl);
+	//	acpi_table_parse(ACPI_SIG_HPET, acpi_parse_hpet);

  	return 0;
  }

-Mikko
