Return-Path: <linux-kernel-owner+w=401wt.eu-S936313AbYBCHvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936313AbYBCHvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 02:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759479AbYBCHvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 02:51:09 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:36328 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759469AbYBCHvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 02:51:08 -0500
Date: Sun, 3 Feb 2008 08:51:11 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Brownell <david-b@pacbell.net>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] sleepy linux self-test
Message-ID: <20080203075111.GB19981@uranus.ravnborg.org>
References: <20080130131748.GA3796@elf.ucw.cz> <20080203050537.GA18942@elte.hu> <20080203051425.GA20740@elte.hu> <200802022318.03597.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802022318.03597.david-b@pacbell.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- g26.orig/drivers/char/Kconfig
> +++ g26/drivers/char/Kconfig
> @@ -715,9 +715,12 @@ config NVRAM
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called nvram.
>  
> +comment "You are using the RTC framework, not the legacy CMOS RTC driver"
> +	depends on RTC_DRV_CMOS
> +
>  config RTC
>  	tristate "Enhanced Real Time Clock Support"
> -	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV && !ARM && !SUPERH && !S390
> +	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV && !ARM && !SUPERH && !S390 && !RTC_DRV_CMOS

This looks like a prime candidate for a HAVE_RTC config variable
So you do:

 config RTC
 	tristate "Enhanced Real Time Clock Support"
+	depends on HAVE_RTC && !RTC_DEV_CMOS

config HAVE_RTC
	bool

(No "depends on" allowed!)


And then the architectures that do support the RTC Framework do an:
(arch/x86/Kconfig as an example):
 config X86
+	select HAVE_RTC

So when PPC suddenly supports it they add this single
select statement and no more Kconfig magic needed.

See Documentation/kbuild/kconfig-language.txt for a bit more elaborate
description.

	Sam
