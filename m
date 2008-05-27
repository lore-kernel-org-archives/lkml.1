Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYE0AST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYE0AST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 20:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbYE0ASD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 20:18:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:56136 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbYE0ASB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 20:18:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JVEi0xbNTZPOSn+KpjeGLCQtEEC9DR6G6W8GwLb7GgGvi0+A2qaZdGnMkqsphlXAv/DW2rEDNFiANztEBODUbFOhPkeJJcB0/kQFSYKW15fWUcce7fWf24keSuHH2iU5rRzJwtgJJGb0/mUkeZmIA1kXx89EHjKzWr/Dyl2dStk=
Message-ID: <86802c440805261718i616d7740v2e1cbc352d29d58a@mail.gmail.com>
Date: Mon, 26 May 2008 17:18:00 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: aperture_64.c: corner case wrong
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Dave Jones" <davej@codemonkey.org.uk>,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <20080526191730.GA18425@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080526191730.GA18425@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 12:17 PM, Pavel Machek <pavel@suse.cz> wrote:
>
> If
>
> fix == 0, aper_enabled == 1, gart_fix_e820 == 0
>
>        if (!fix && !aper_enabled)
>                return;
>
>        if (gart_fix_e820 && !fix && aper_enabled) {
>                if (e820_any_mapped(aper_base, aper_base + aper_size,
>                                    E820_RAM)) {
>                        /* reserve it, so we can reuse it in second
> kernel */
>                        printk(KERN_INFO "update e820 for GART\n");
>                        add_memory_region(aper_base, aper_size,
> E820_RESERVED);
>                        update_e820();
>                }
>                return;
>        }
>
>        /* different nodes have different setting, disable them all atfirst*/
>
> we'll fall back here and disable all the settings, even when they were
> all consistent.
>
> What about this? (I hope it compiles...)
>
> Signed-off-by: Pavel Machek <pavel@suse.cz>
>
>
> diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
> index 02f4dba..aa4876a 100644
> --- a/arch/x86/kernel/aperture_64.c
> +++ b/arch/x86/kernel/aperture_64.c
> @@ -344,14 +323,16 @@ out:
>        if (gart_fix_e820 && !fix && aper_enabled) {
>                if (!e820_all_mapped(aper_base, aper_base + aper_size,
>                                    E820_RESERVED)) {
>                        /* reserve it, so we can reuse it in second kernel */
>                        printk(KERN_INFO "update e820 for GART\n");
>                        add_memory_region(aper_base, aper_size, E820_RESERVED);
>                        update_e820();
>                }
> -               return;
>        }
>
> +       if (!fix)
> +               return;
> +
>        /* different nodes have different setting, disable them all at first*/
>        for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
>                int bus;
>
good catch.

Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>

YH
