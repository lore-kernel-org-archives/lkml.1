Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbZADXvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbZADXvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZADXvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:51:11 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:54618 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbZADXvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:51:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=VcaUV67ROjlgHQZnIxewoIomRLXd/bJQ4CwgvmORSZkA3if045BVN/S1Ylr8wYMdhS
         OmfEacEehscnsSYcVlQhQDY4Hyg7J8F6scTXpNkbNAxlg15kiEZPuq+5RRTNoHAYj6hq
         HW+E7DEOaEfd15xlvmp6Gg5YiSyH7XfYscu5U=
Message-ID: <86802c440901041551y321329e1l9c40186fc381f355@mail.gmail.com>
Date: Sun, 4 Jan 2009 15:51:08 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] [1/5] Only scan the root bus in early PCI quirks.
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090104233638.60AF53E6653@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901051236.281008835@firstfloor.org>
	 <20090104233638.60AF53E6653@basil.firstfloor.org>
X-Google-Sender-Auth: fcfe53bc24485fb0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2009 at 3:36 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> We found a situation on Linus' machine that the Nvidia timer
> quirk hit on a Intel chipset system. The problem is that the
> system has a fancy Nvidia card with an own PCI bridge, and
> the early-quirks code looking for any NVidia bridge triggered
> on it incorrectly. This didn't lead a boot failure by luck,
> but the timer routing code selecting the wrong timer first and
> some ugly messages. It might lead to real problems on
> other systems.
>
> I checked all the devices which are currently checked for
> by early_quirks and it turns out they are all located in
> the root bus zero.
>
> So change the early-quirks loop to only scan bus 0. This
> incidently also saves quite some unnecessary scanning work,
> because early_quirks doesn't go through all the non root
> busses.
>
> The graphics card is not on bus 0, so it is not matched
> anymore.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
> ---
>  arch/x86/kernel/early-quirks.c |   22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
>
> Index: linux-2.6.28-test/arch/x86/kernel/early-quirks.c
> ===================================================================
> --- linux-2.6.28-test.orig/arch/x86/kernel/early-quirks.c       2008-11-24 16:42:46.000000000 +0100
> +++ linux-2.6.28-test/arch/x86/kernel/early-quirks.c    2008-12-29 05:25:09.000000000 +0100
> @@ -200,6 +200,12 @@
>        void (*f)(int num, int slot, int func);
>  };
>
> +/*
> + * Only works for devices on the root bus. If you add any devices
> + * not on bus 0 readd another loop level in early_quirks(). But
> + * be careful because at least the Nvidia quirk here relies on
> + * only matching on bus 0.
> + */
>  static struct chipset early_qrk[] __initdata = {
>        { PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
>          PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, nvidia_bugs },
> @@ -266,17 +272,17 @@
>
>  void __init early_quirks(void)
>  {
> -       int num, slot, func;
> +       int slot, func;
>
>        if (!early_pci_allowed())
>                return;
>
>        /* Poor man's PCI discovery */
> -       for (num = 0; num < 32; num++)
> -               for (slot = 0; slot < 32; slot++)
> -                       for (func = 0; func < 8; func++) {
> -                               /* Only probe function 0 on single fn devices */
> -                               if (check_dev_quirk(num, slot, func))
> -                                       break;
> -                       }
> +       /* Only scan the root bus */
> +       for (slot = 0; slot < 32; slot++)
> +               for (func = 0; func < 8; func++) {
> +                       /* Only probe function 0 on single fn devices */
> +                       if (check_dev_quirk(0, slot, func))
> +                               break;
> +               }
>  }
> --

two cases:
1. how about system with two or more HT chains, and second will be
0x40, x0x80, or 0xc0 ?
2. some system with LinuxBIOS, could put first chain on bus 1

YH
