Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbYFUIUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbYFUIUB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 04:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYFUITm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 04:19:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:8143 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYFUITj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 04:19:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NX5HRMVWaSDZ/OLMbaXqI1wlrUy8U8upxzVCK4xC+dtK+GUU1jeXn7Ed46SnwCro43
         qs+ueKBhTsHf8Nunlqx8839N2Ld3lfse+kk/K9r4mXuyxYBOOhBI3Sx1qHh+Wwq/41gc
         I6AcZ2dnbWODhAi5xZKN0WDLhmcRTergx7MCA=
Message-ID: <19f34abd0806210119o64a1c9ban78710651a01530cf@mail.gmail.com>
Date: Sat, 21 Jun 2008 10:19:38 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Len Brown" <lenb@kernel.org>
Subject: Re: [PATCH] ACPI: don't walk tables if ACPI was disabled
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Zhao Yakui" <yakui.zhao@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>
In-Reply-To: <19f34abd0806201427h740ca3e7gc2f01c7e34616fd4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080620135639.GA5073@damson.getinternet.no>
	 <alpine.LFD.1.10.0806201458500.3027@localhost.localdomain>
	 <19f34abd0806201340t502ce471n578dd2498a5f1992@mail.gmail.com>
	 <19f34abd0806201427h740ca3e7gc2f01c7e34616fd4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 11:27 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> So I guess this function, pnpbios_init() needs the check as well. In
> fact, it has this:
>
> #ifdef CONFIG_PNPACPI
>        if (!acpi_disabled && !pnpacpi_disabled) {
>                pnpbios_disabled = 1;
>                printk(KERN_INFO "PnPBIOS: Disabled by ACPI PNP\n");
>                return -ENODEV;
>        }
> #endif                          /* CONFIG_ACPI */
>
> ...I guess that should be changed to say if (acpi_disabled ||
> pnpacpi_disabled)? Or... I don't understand the purpose of the
> original test. But it seems to be there since the beginning of time
> (or, well, v2.6.12-rc2).

Nope. I found the introduction of the change in the historical git repository:

commit 4723ebe898a32262ed49fe677897ccea47e72ff4
Author: Adam Belay <ambx1@neo.rr.com>
Date:   Sun Oct 24 15:07:32 2004 -0400

    [PNPBIOS] disable if ACPI is active

    As further ACPI pnp functionaility is implemented it is no longer
    safe to run ACPI and PNPBIOS concurrently.

    We therefore take the following approach:
    - attempt to enable ACPI support
    - if ACPI fails (blacklist etc.) enable pnpbios support
    - if ACPI support is not compiled in the kernel enable pnpbios support

    Signed-off-by: Adam Belay <ambx1@neo.rr.com>

and now I understand the purpose of the check; pnpbios does not depend
on ACPI; ACPI/pnpacpi is incompatible with pnpbios.

Yet it remains a fact that pnpbios will discover devices which then
ACPI code uses erroneously. Which means that my original fix for Ingo
probably is the right one after all. Should I submit another patch
which does the right thing for everything under drivers/acpi/, or can
you do it on your own? :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
