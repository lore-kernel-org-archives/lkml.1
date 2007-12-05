Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbXLEUjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbXLEUjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 15:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbXLEUjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 15:39:13 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:6308 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbXLEUjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 15:39:12 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: pnpacpi : exceeded the max number of IO resources
Date: Wed, 5 Dec 2007 13:39:04 -0700
User-Agent: KMail/1.9.6
Cc: Shaohua Li <shaohua.li@intel.com>, Rene Herman <rene.herman@keyaccess.nl>,
       yakui.zhao@intel.com, Chris Holvenstot <cholvenstot@comcast.net>,
       linux-kernel@vger.kernel.org, trenn@suse.de,
       Andrew Morton <akpm@osdl.org>
References: <1196428488.7066.6.camel@localhost> <1196729713.13969.1.camel@sli10-desk.sh.intel.com> <20071204011540.GA2713@darkstar.lan>
In-Reply-To: <20071204011540.GA2713@darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712051339.04936.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 December 2007 06:15:40 pm Dave Young wrote:
> On Tue, Dec 04, 2007 at 08:55:13AM +0800, Shaohua Li wrote:
> > 
> > On Mon, 2007-12-03 at 18:02 +0100, Rene Herman wrote:
> > > On 30-11-07 23:22, Rene Herman wrote:
> > > 
> > > > On 30-11-07 14:14, Chris Holvenstot wrote:
> > > > 
> > > >> For what it is worth I too have seen this problem this morning and it
> > > >> DOES appear to be new (in contrast to a previous comment)
> > > >>
> > > >> The message:  pnpacpi: exceeded the max number of mem resources: 12
> > > >>
> > > >> is displayed each time the system is booted with the 2.6.24-rc3-git5
> > > >> kernel but is NOT displayed when booting 2.6.24-rc3-git4
> > > >>
> > > >> I have made no changes in my config file between these two kernels other
> > > >> than to accept any new defaults when running make oldconfig.
> > > >>
> > > >> If you had already narrowed it down to a change between git4 and git5 I
> > > >> apologize for wasting your time.  Have to run to work now.
> > > > 
> > > > Thanks, and re-added the proper CCs. Sigh...
> > > > 
> > > > Well, yes, the warning is actually new as well. Previously your kernel 
> > > > just silently ignored 8 more mem resources than it does now it seems.
> > > > 
> > > > Given that people are hitting these limits, it might make sense to just 
> > > > do away with the warning for 2.6.24 again while waiting for the dynamic 
> > > > code?
> > > 
> > > Ping. Should these warnings be reverted for 2.6.24?
> > Revert the warning doesn't make any sense. I'd suggest changing the IO
> > resources number bigger till Thomas's patch in.
> Agree.
> Change it to 90 works for me, But I think maybe 128 is better.
> 
> include/linux/pnp.h |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -upr linux/include/linux/pnp.h linux.new/include/linux/pnp.h
> --- linux/include/linux/pnp.h	2007-12-04 09:09:23.000000000 +0800
> +++ linux.new/include/linux/pnp.h	2007-12-04 09:09:40.000000000 +0800
> @@ -13,7 +13,7 @@
>  #include <linux/errno.h>
>  #include <linux/mod_devicetable.h>
>  
> -#define PNP_MAX_PORT		24
> +#define PNP_MAX_PORT		128
>  #define PNP_MAX_MEM		12
>  #define PNP_MAX_IRQ		2
>  #define PNP_MAX_DMA		2

I don't think we can increase PNP_MAX_PORT to 128.  Only one or two
devices need that many, so just bumping the max wastes a LOT of space.
A struct resource is seven longs, so on a 32-bit system with sixteen
PNP devices, we'd be wasting (128-24)*7*4*16 = almost 47Kbytes.

In hindsight, I should not have removed drivers/acpi/motherboard.c
until we had dynamic PNP resource tables.  We could revert that
change [1], but the driver's been gone since 2.6.21, so I don't
think it's that urgent.  It's just that we used to silently ignore
resources past the limits, and in -mm, we now print a KERN_ERR message.

So I think we should either remove the message altogether (so we're
exactly like 2.6.23 in this regard), or at least tone it down to
a KERN_WARN or something.

And we need to get Thomas' dynamic patch into -mm ASAP :-)

Bjorn

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5eca338fb510af78eee5372ff6a3525768ab913f
