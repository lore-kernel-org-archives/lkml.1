Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbXGIPrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbXGIPrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 11:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbXGIPq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 11:46:57 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:45360 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbXGIPq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 11:46:56 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Luca Tettamanti <kronos.it@gmail.com>
Subject: Re: [PATCH] Enable legacy support for serial ports when SERIAL_8250_PNP is disabled
Date: Mon, 9 Jul 2007 09:46:32 -0600
User-Agent: KMail/1.9.6
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070707233300.GA3267@dreamland.darkstar.lan>
In-Reply-To: <20070707233300.GA3267@dreamland.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707090946.33101.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 July 2007 05:33:00 pm Luca Tettamanti wrote:
> your patch:
> 
> commit 7e92b4fc345f5b6f57585fbe5ffdb0f24d7c9b26
> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Date:   Tue May 8 00:36:07 2007 -0700
> 
>     x86, serial: convert legacy COM ports to platform devices
> 
> disables probing using legacy code in favour of ACPI/PNP to avoid double
> discovery.
> 
> However if SERIAL_8250_PNP is not enabled the user is left without
> serial ports (been there, done that - my kernel config suddenly wasn't
> working anymore). So:

Yes, that's true.  Kconfig should automatically turn on SERIAL_8250_PNP
if PNP and SERIAL_8250 are selected, but it does give you a choice if
you have EMBEDDED set.  So I guess you must have this:

  CONFIG_EMBEDDED=y
  CONFIG_PNP=y
  CONFIG_SERIAL_8250=y
  CONFIG_SERIAL_8250_PNP=n

Why do you want PNP support, but not 8250_PNP support?  If you turn off
PNP completely, you will have "pnp_platform_devices == 0", and the
existing code will do what you need.

> Enable probing of serial ports using legacy code when PNP code
> (SERIAL_8250_PNP) is not enabled.
> 
> Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
> 
> ---
> 
>  arch/i386/kernel/legacy_serial.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/i386/kernel/legacy_serial.c b/arch/i386/kernel/legacy_serial.c
> index 2151011..457d307 100644
> --- a/arch/i386/kernel/legacy_serial.c
> +++ b/arch/i386/kernel/legacy_serial.c
> @@ -48,7 +48,11 @@ static struct platform_device x86_com_device = {
>  	},
>  };
>  
> +#ifndef CONFIG_SERIAL_8250_PNP
> +static int force_legacy_probe = 1;
> +#else
>  static int force_legacy_probe;
> +#endif
>  module_param_named(force, force_legacy_probe, bool, 0);
>  MODULE_PARM_DESC(force, "Force legacy serial port probe");
>  
> 
> 
> Luca


