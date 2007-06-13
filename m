Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbXFMUjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbXFMUjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 16:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbXFMUjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 16:39:32 -0400
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:18053 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbXFMUjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 16:39:31 -0400
X-IronPort-AV: i="4.16,417,1175497200"; 
   d="scan'208"; a="2977408:sNHT21309240"
To: vgoyal@in.ibm.com
Cc: linux-kernel@vger.kernel.org,
       "Natalie.Protasevich@unisys.com" <Natalie.Protasevich@unisys.com>,
       akpm@linux-foundation.org
Subject: Re: CONFIG_X86_ES7000=y, CONFIG_X86_GENERICARCH=n, CONFIG_ACPI=y build broken
X-Message-Flag: Warning: May contain useful information
References: <adad5017zpt.fsf@cisco.com> <20070613173741.GA23618@in.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 13 Jun 2007 13:39:29 -0700
In-Reply-To: <20070613173741.GA23618@in.ibm.com> (Vivek Goyal's message of "Wed, 13 Jun 2007 23:07:41 +0530")
Message-ID: <adamyz34mim.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Jun 2007 20:39:29.0554 (UTC) FILETIME=[F0BA9F20:01C7ADFA]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Can you please try the attached patch? I have compiled it with CONFIG_ES7000=y
 > and CONFIG_X86_GENERICARCH=n. But don't have any ES7000 machine to test it.

I actually don't have anything remotely like ES7000 iether.  I just
found the problem while tracking down another randconfig failure.

 > Subarch build procedure is not straightforward and this patch adds to the
 > misery. Please suggest if there is a better way of handling things.

 > +/*
 > + * This file also gets compiled if CONFIG_X86_GENERICARCH is set. Generic
 > + * arch already has got following function definitions (asm-generic/es7000.c)
 > + * hence no need to define these for that case.
 > + */
 > +#ifndef CONFIG_X86_GENERICARCH

Seems it would be cleaner to figure out some way to build es7000.c for
if CONFIG_X86_ES7000 is set?  Or just move them here all the time?

 > --- linux-2.6.22-rc4-git4/include/asm-i386/mach-es7000/mach_mpparse.h~i386-es7000-build-breakage-fix	2007-06-13 22:52:14.000000000 +0530
 > +++ linux-2.6.22-rc4-git4-vivek/include/asm-i386/mach-es7000/mach_mpparse.h	2007-06-13 22:52:14.000000000 +0530
 > @@ -18,6 +18,12 @@ extern int parse_unisys_oem (char *oempt
 >  extern int find_unisys_acpi_oem_table(unsigned long *oem_addr);
 >  extern void setup_unisys(void);
 >  
 > +#ifndef CONFIG_X86_GENERICARCH
 > +extern int acpi_madt_oem_check(char *oem_id, char *oem_table_id);
 > +extern int mps_oem_check(struct mp_config_table *mpc, char *oem,
 > +				char *productid);
 > +#endif

It seems that this #ifndef is not needed -- even if there is another
declaration of these functions that is visible, the signatures should
match so it should be OK.

 - R.
