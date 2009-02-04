Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbZBDOTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbZBDOTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbZBDOS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:18:58 -0500
Received: from mail.gmx.net ([213.165.64.20]:52674 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751482AbZBDOS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:18:57 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX1822XhthUA2tUd73tduGfH7ZeXG6Lt7K5TCYD3xrk
	lMQgS6OBUDM/OC
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: gregkh@suse.de
Subject: Re: patch sata_nv-fix-mcp5x-reset.patch added to 2.6.28-stable tree
Date: Wed, 4 Feb 2009 15:18:50 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, jgarzik@redhat.com,
       stable@kernel.org
References: <20090203224712.E16AA4901A@coco.kroah.org>
In-Reply-To: <20090203224712.E16AA4901A@coco.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041518.52708.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Dienstag, 3. Februar 2009, gregkh@suse.de wrote:
> This is a note to let you know that we have just queued up the patch titled
> 
>     Subject: sata_nv: fix MCP5x reset
> 
> to the 2.6.28-stable tree.  Its filename is
> 
>     sata_nv-fix-mcp5x-reset.patch
> 
> A git repo of this tree can be found at 
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> 
> From 2d775708bc6613f1be47f1e720781343341ecc94 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Sun, 25 Jan 2009 11:29:38 +0900
> Subject: sata_nv: fix MCP5x reset
> 
> From: Tejun Heo <tj@kernel.org>
> 
> commit 2d775708bc6613f1be47f1e720781343341ecc94 upstream.
> 
> MCP5x family of controllers seem to share much more with nf2's as far
> as reset protocol is concerned.  It requires heardreset to get the PHY
> going and classfication code report after hardreset is unreliable.
> Create a new board type MCP5x and use noclassify hardreset.  SWNCQ is
> modified to inherit from this new type.
> 
> This fixes hotplug regression reported in kernel bz#12351.
[...]
> --- a/drivers/ata/sata_nv.c
> +++ b/drivers/ata/sata_nv.c
[...]
> +/* Kernel bz#12351 reports that when SWNCQ is enabled, for hotplug to
> + * work, hardreset should be used and hardreset can't report proper
> + * signature, which suggests that mcp5x is closer to nf2 as long as
> + * reset quirkiness is concerned.  Define separate ops for mcp5x with
> + * nv_noclassify_hardreset().
> + */
> +static struct ata_port_operations nv_mcp5x_ops = {
> +	.inherits		= &nv_common_ops,
> +	.hardreset		= nv_noclassify_hardreset,
> +};
[...]

This fails to compile on 2.6.28.3+stable-queue (and most likely 2.6.27 as 
well), because it depends on the rename from nv_nf2_hardreset() to 
nv_noclassify_hardreset() in:

commit e8caa3c70e94d867ca2efe9e53fd388b52d6d0c8
Author: Tejun Heo <tj@kernel.org>
Date:   Sun Jan 25 11:25:22 2009 +0900

    sata_nv: rename nv_nf2_hardreset()

    nv_nf2_hardreset() will be used by other flavors too.  Rename it to
    nv_noclassify_hardreset().

    Signed-off-by: Tejun Heo <tj@kernel.org>
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

As this function has only been renamed without functional changes, either 
applying "sata_nv: rename nv_nf2_hardreset()" as well or using
s/nv_nf2_hardreset/nv_noclassify_hardreset/g on this patch
(and potentially following changes, "sata_nv: ck804 has borked hardreset 
too" 8d993eaa9c3c61b8a5929a7f695078a1fcfb4869 comes to mind) fixes the 
build.

Regards
	Stefan Lippers-Hollmann
