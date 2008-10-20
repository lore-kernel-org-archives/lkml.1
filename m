Return-Path: <linux-kernel-owner+w=401wt.eu-S1754947AbYJTSyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbYJTSyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 14:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYJTSx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 14:53:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:56347 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbYJTSx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 14:53:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,453,1220252400"; 
   d="scan'208";a="62682388"
Date: Mon, 20 Oct 2008 11:53:54 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Thomas Meyer <thomas@m3y3r.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dwmw2@infradead.org, c-d.hailfinger.devel.2006@gmx.net, dolsen@lnxi.com,
       rjackson@lnxi.com
Subject: Re: WARNING: at arch/x86/mm/ioremap.c:226
Message-ID: <20081020185353.GF7829@linux-os.sc.intel.com>
References: <1224526053.4948.2.camel@dhcppc2> <20081020112851.3ea44576@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020112851.3ea44576@infradead.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 11:28:51AM -0700, Arjan van de Ven wrote:
> [   16.914566] ck804xrom ck804xrom_init_one(): Unable to register resource 0x00000000ff000000-0x00000000ffffffff - kernel bug?
> [   16.914575] resource map sanity check conflict: 0xff000000
> 0xffffffff 0xff780000 0xffffffff reserved
> 
> [   16.914636]  [<c042c02c>] ioremap_nocache+0xd/0xf
> [   16.914640]  [<f87e4246>] ? init_ck804xrom+0x246/0x4c7 [ck804xrom]
> [   16.914643]  [<f87e4246>] init_ck804xrom+0x246/0x4c7 [ck804xrom]
> 
> the init_ck804xrom driver seems to be requesting a bunch of memory with
> ioremap that crosses several resources...
> which is very bad.
> 
> Can you sent the /proc/iomem file ?

drivers/mtd/maps/ck804xrom.c is hardcoding the address as:

	window->phys = 0xff000000; /* 16MiB, hardcoded for now */

followed by:

	ioremap_nocache(window->phys, window->size);

And later I see something like:

#if 1
	/* The probe sequence run over the firmware hub lock
	 * registers sets them to 0x7 (no access).
	 * Probe at most the last 4MiB of the address space.
	 */
	if (map_top < 0xffc00000)
		map_top = 0xffc00000;
#endif

If they are only probing the last 4MB, the above window mapping can also be
reduced accordingly.

Copying some folks.

thanks,
suresh
