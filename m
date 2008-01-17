Return-Path: <linux-kernel-owner+w=401wt.eu-S1758973AbYAQXEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbYAQXEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757428AbYAQXEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:04:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:60409 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467AbYAQXEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:04:11 -0500
X-ExtLoop1: 1
Date: Thu, 17 Jan 2008 15:04:10 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andreas Herrmann3 <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug fixes
Message-ID: <20080117230410.GA8694@linux-os.sc.intel.com>
References: <20080116203328.GA17869@linux-os.sc.intel.com> <20080117191211.GA12631@alberich.amd.com> <20080117203600.GB27778@elte.hu> <20080117210301.GC12631@alberich.amd.com> <20080117211308.GA7858@elte.hu> <20080117213131.GA25389@linux-os.sc.intel.com> <20080117214209.GA12811@elte.hu> <20080117220650.GE12631@alberich.amd.com> <20080117221505.GB18883@elte.hu> <20080117225243.GH12631@alberich.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117225243.GH12631@alberich.amd.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 11:52:43PM +0100, Andreas Herrmann3 wrote:
> On Thu, Jan 17, 2008 at 11:15:05PM +0100, Ingo Molnar wrote:
> > 
> > * Andreas Herrmann3 <andreas.herrmann3@AMD.COM> wrote:
> > 
> > > On Thu, Jan 17, 2008 at 10:42:09PM +0100, Ingo Molnar wrote:
> > > > 
> > > > * Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:
> > > > 
> > > > > On Thu, Jan 17, 2008 at 10:13:08PM +0100, Ingo Molnar wrote:
> > > > > > but in general we must be robust enough in this case and just degrade 
> > > > > > any overlapping page to UC (and emit a warning perhaps) - instead of 
> > > > > > failing the ioremap and thus failing the driver (and the bootup).
> > > > > 
> > > > > But then, this will cause an attribute conflicit. Old one was 
> > > > > specifying WB in PAT (ioremap with noflags) and the new ioremap 
> > > > > specifies UC.
> > > > 
> > > > we could fix up all aliases of that page as well and degrade them to UC?
> > > 
> > > Yes, we must fix all aliases or reject the conflicting mapping. But 
> > > fixing all aliases might not be that easy. (I've just seen a panic 
> > > when using your patch ;-(
> > 
> > yes, indeed my patch is bad if you have PAT enabled: conflicting cache 
> > attributes might be present. I'll go with your patch for now.
> 
> I think the best is to just reject conflicting mappings. (Because now
> I am too tired to think about a safe way how to change the aliases to the
> most restrictive memory type. ;-)
> 
> But then of course such boot-time problems like I've seen on my test
> machines should be avoided somehow.
> 
> 

Below is another potential fix for the problem here. Going through ACPI
ioremap usages, we found at one place the mapping is cached for possible
optimization reason and not unmapped later. Patch below always unmaps
ioremap at this place in ACPICA.

Thanks,
Venki


Index: linux-2.6.git/drivers/acpi/executer/exregion.c
===================================================================
--- linux-2.6.git.orig/drivers/acpi/executer/exregion.c	2008-01-17 03:18:39.000000000 -0800
+++ linux-2.6.git/drivers/acpi/executer/exregion.c	2008-01-17 07:34:33.000000000 -0800
@@ -48,6 +48,8 @@
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exregion")
 
+static int ioremap_cache;
+
 /*******************************************************************************
  *
  * FUNCTION:    acpi_ex_system_memory_space_handler
@@ -249,6 +251,13 @@
 		break;
 	}
 
+	if (!ioremap_cache) {
+		acpi_os_unmap_memory(mem_info->mapped_logical_address,
+		                     window_size);
+		mem_info->mapped_logical_address = 0;
+		mem_info->mapped_physical_address = 0;
+		mem_info->mapped_length = 0;
+	}
 	return_ACPI_STATUS(status);
 }
 
