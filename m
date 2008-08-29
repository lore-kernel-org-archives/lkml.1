Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbYH2PXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbYH2PXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbYH2PWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:22:18 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:51964 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220AbYH2PWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:22:16 -0400
Date: Sat, 30 Aug 2008 00:22:15 +0900 (JST)
Message-Id: <20080830.002215.128620618.anemo@mba.ocn.ne.jp>
To: david@fries.net
Cc: linux-kernel@vger.kernel.org, p_gortmaker@yahoo.com
Subject: Re: [PATCH] ne.c fix for hibernate and rmmod oops fix
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080828041110.GA9404@spacedout.fries.net>
References: <20080828041110.GA9404@spacedout.fries.net>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008 23:11:15 -0500, David Fries <david@fries.net> wrote:
> do_ne_probe uses dev->mem_end special value 0xbad as a flag to deal
> specially when some bad, but usable devices.  The io port platform
> resource has a start and end, but if start is 0x300 and end is 0xbad,
> it will just fail with io ports in use and not probe the device.  Is
> using the flag IORESOURCE_DISABLED acceptable?  There doesn't seem to
> be any good way to pass some extra driver dependent data through to
> the platform probe function.
> 
> +	/* Bad, crippled, how about disabled?
> +	 * Any other suggestions for passing this through?
> +	 */
> +	if (dev->mem_end == BAD)
> +		r[0].flags |= IORESOURCE_DISABLED;

I'm not sure IORESOURCE_DISABLED is OK, but (ab)using r[0].name might
be safer. Something like this:

	if (dev->mem_end == BAD)
		r[0].name = "bad";

>     platform_driver support was added earlier, but without any
>     platform_device_register* calls I don't think it was being used.

Well, I added platform_driver support for some MIPS board.  I did not
touch ISA part at that time while it looks too complex for me.  Thank
you for better integration.

>     Now all devices are registered using platform_device_register_simple and
>     pointers are kept to unregister the ones that the probe failed for or
>     unregister all devices on module shutdown.  ne_init and ne_exit are no
>     longer compiled into the module to reduce confusion (and multiple
>     unregister paths that caused the rmmod oops).  With the devices
>     now registered they are added to the platform driver and get suspend
>     and resume events.  A call to pnp_stop_dev and pnp_start_dev now
>     shutsdown and initializes plug and play devices.

With your patch, cleanup_module() and ne_exit() is exactly same.  How
about unifying them?

>     mdelay(10) replaced by msleep(10) to give up the CPU.

I think this part is worth to do by separate patch.

> +	struct resource r[2] = {
> +		{
> +			.name = "io_port",
> +			.flags = IORESOURCE_IO},
> +		{
> +			.name = "irq",
> +			.flags = IORESOURCE_IRQ} };

This .name initialization seems a bit redundant for me.  They can be
left NULL.

Also I'd suggest CC-ing your patch to netdev@vger.kerne.org for more
reviews from genius people.

---
Atsushi Nemoto
