Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbYHTP5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbYHTP5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYHTP46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:56:58 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:1435 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbYHTP45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:56:57 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Frans Pop <elendil@planet.nl>
Subject: Re: char/tpm: tpm_infineon no longer loaded for HP 2510p laptop
Date: Wed, 20 Aug 2008 09:56:52 -0600
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Marcel Selhorst <tpm@selhorst.net>,
       Kay Sievers <kay.sievers@vrfy.org>, Thomas Renninger <trenn@suse.de>,
       Adam Belay <ambx1@neo.rr.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200808181540.25286.elendil@planet.nl>
In-Reply-To: <200808181540.25286.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808200956.52883.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 August 2008 07:40:24 am Frans Pop wrote:
> While comparing the loaded modules for 2.6.26 and 2.6.27-rc3 for my HP 
> 2510p, I noticed that the tpm_infineon module and related modules no 
> longer get loaded automatically.
> 
> The difference seems to be that 2.6.26 listed:
> /lib/modules/2.6.26.2/modules.alias:alias pnp:dIFX0102* tpm_infineon
> /lib/modules/2.6.26.2/modules.alias:alias pnp:dIFX0101* tpm_infineon
> 
> while 2.6.27 has:
> /lib/modules/2.6.27-rc3/modules.alias:alias acpi*:IFX0101:* tpm_infineon
> /lib/modules/2.6.27-rc3/modules.alias:alias pnp:dIFX0101* tpm_infineon
> 
> My system has:
> $ grep IFX /sys/bus/pnp/devices/*/id
> /sys/bus/pnp/devices/00:02/id:IFX0102

drivers/char/tpm/tpm_infineon.c hasn't changed since v2.6.26.  I think
the problem is more likely related to commit 22454cb99fc39f2629a:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=22454cb99fc39f2629ad06a7eccb3df312f8830e

I don't know enough about modaliases to understand the point of this
patch, but I am suspicious of this part of it:

-               do_table(symval, sym->st_size,
-                        sizeof(struct pnp_device_id), "pnp",
-                        do_pnp_entry, mod);
+               do_pnp_device_entry(symval, sym->st_size, mod);

That suggests to me that where we used to generate an alias for every
PNP ID in the table:

    static const struct pnp_device_id tpm_pnp_tbl[] = {
        {"IFX0101", 0},
        {"IFX0102", 0},
        {"", 0}
    };

possibly the new code only does it for the first entry (IFX0101).

Apart from problem Frans points out, I'd like to understand the reason
for generating the "acpi*" aliases for PNP drivers.  I'd like to move
away from ACPI being visible to userland, and this file2alias.c change
makes it *more* visible.

Bjorn
