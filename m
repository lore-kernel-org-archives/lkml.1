Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbXJKMKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbXJKMKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 08:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbXJKMKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 08:10:17 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:49703 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbXJKMKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 08:10:04 -0400
X-Originating-Ip: 99.236.101.138
Date: Thu, 11 Oct 2007 08:05:42 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Rob Landley <rob@landley.net>
cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: m68k Kconfig undefined symbol in 2.6.23.
In-Reply-To: <200710101719.52423.rob@landley.net>
Message-ID: <Pine.LNX.4.64.0710110756010.2012@localhost.localdomain>
References: <200710101719.52423.rob@landley.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007, Rob Landley wrote:

> The m68k Kconfig tries to select a symbol (APM_EMULATION) that doesn't exist.
>
> I did this to fix it, without really understanding the larger problem.  (Did
> APM go away?)  Just FYI...
>
> Rob
>
> diff -r 79f0ea1e0e70 drivers/macintosh/Kconfig
> --- a/drivers/macintosh/Kconfig	Tue Oct 09 21:00:40 2007 +0000
> +++ b/drivers/macintosh/Kconfig	Wed Oct 10 17:17:07 2007 -0500
> @@ -116,11 +116,6 @@ config PMAC_SMU
>  	  on the "SMU" system control chip which replaces the old PMU.
>  	  If you don't know, say Y.
>
> -config PMAC_APM_EMU
> -	tristate "APM emulation"
> -	select APM_EMULATION
> -	depends on ADB_PMU && PM && PPC32
> -
>  config PMAC_MEDIABAY
>  	bool "Support PowerBook hotswap media bay"
>  	depends on PPC_PMAC && PPC32

the obvious problem with the above is that APM_EMULATION is defined in
kernel/power/Kconfig arch-independently thusly:

config APM_EMULATION
        tristate "Advanced Power Management Emulation"
        depends on PM && SYS_SUPPORTS_APM_EMULATION
        help
        ... blah blah ...

but the Kconfig variable SYS_SUPPORTS_APM_EMULATION is defined for
only a small subset of architectures:

$ grep "config SYS_SUPPORTS_APM_EMULATION" $(find . -name Kconfig*)
./arch/mips/Kconfig:config SYS_SUPPORTS_APM_EMULATION
./arch/sh/Kconfig:config SYS_SUPPORTS_APM_EMULATION
./arch/arm/Kconfig:config SYS_SUPPORTS_APM_EMULATION
./arch/powerpc/Kconfig:config SYS_SUPPORTS_APM_EMULATION

  so there's a good chance that doing a kernel config with any other
arch than those listed above that supports PM is going to generate the
same warning.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
