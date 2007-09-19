Return-Path: <linux-kernel-owner+w=401wt.eu-S1756843AbXISI2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbXISI2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 04:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbXISI1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 04:27:53 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:36928 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbXISI1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 04:27:52 -0400
Date: Wed, 19 Sep 2007 10:27:16 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: 2.6.23-rc6-mm1: atomic counter underflow
Message-ID: <20070919102716.09004317@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <200709182345.13435.m.kozlowski@tuxland.pl>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<200709182345.13435.m.kozlowski@tuxland.pl>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 23:45:13 +0200,
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> 	I wrote a simple script that finds all modules in /lib/modules/`uname -r`
> and performs sth like 'modprobe $x; rmmod $x;' for every of them. The result is the
> output below. This actually happens when rmmod'ing a module.
> 
> I narrowed it down to modules mmc_core and firewire_core. To reproduce that just
> rmmod them.

Hm, does that mean you can reproduce this when you modprobe/rmmod
either of them on a fresh boot? (There could be follow-on errors...)

Could you try with DEBUG_KOBJECT set?

> PS. X doesn't work but that's another story.
> 
> Regards,
> 
> 	Mariusz
> 
> WARNING: at lib/kref.c:33 kref_get()
>  [<c0104a1c>] dump_trace+0x202/0x22b
>  [<c0104a5f>] show_trace_log_lvl+0x1a/0x30
>  [<c0105608>] show_trace+0x12/0x14
>  [<c010572c>] dump_stack+0x15/0x17
>  [<c024c567>] kref_get+0x40/0x42
>  [<c024b81e>] kobject_get+0x12/0x17
>  [<c02d5800>] bus_get+0x11/0x22
>  [<c02d5a89>] bus_remove_file+0xe/0x27
>  [<c02d5ab2>] remove_probe_files+0x10/0x1f
>  [<c02d5afc>] bus_unregister+0x3b/0x66
>  [<dee3c2bd>] sdio_unregister_bus+0xd/0xf [mmc_core]
>  [<dee3d66d>] mmc_exit+0xd/0x23 [mmc_core]
>  [<c013c9d6>] sys_delete_module+0x154/0x202
>  [<c010406a>] sysenter_past_esp+0x5f/0x99
>  [<ffffe410>] 0xffffe410
>  =======================

Is this the first error message you see? This looks like the embedded
kset had its refcount decreased too much. (Or was the sdio bus never
registered? Don't see how this could happen if mmc_init was successful,
though.)

(The next errors seem to have the same cause.)

> modprobing: firewire-core
> WARNING: at lib/kref.c:33 kref_get()
>  [<c0104a1c>] dump_trace+0x202/0x22b
>  [<c0104a5f>] show_trace_log_lvl+0x1a/0x30
>  [<c0105608>] show_trace+0x12/0x14
>  [<c010572c>] dump_stack+0x15/0x17
>  [<c024c567>] kref_get+0x40/0x42
>  [<c024b81e>] kobject_get+0x12/0x17
>  [<c024b97b>] kobject_init+0x43/0x82
>  [<c024b9c8>] kset_init+0xe/0x2e
>  [<c024be4f>] kset_register+0x15/0x38
>  [<c024be7a>] subsystem_register+0x8/0xa
>  [<c02d6008>] bus_register+0x65/0x209
>  [<ded6300d>] fw_core_init+0xd/0x99 [firewire_core]
>  [<c013aceb>] sys_init_module+0x125/0x1612
>  [<c010406a>] sysenter_past_esp+0x5f/0x99
>  [<ffffe410>] 0xffffe410

Strange. Can't see how this can happen except as a follow-on error.

(Next ones are follow-on errors from this one.)

> modprobing: mmc_block

(Following errors don't look like they could have anything to do with
the driver core.)

