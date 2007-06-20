Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbXFTNhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbXFTNhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 09:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbXFTNgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 09:36:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:58234 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbXFTNgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 09:36:51 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       Steven Whitehouse <swhiteho@redhat.com>, Andi Kleen <ak@suse.de>,
       Shai Fultheim <shai@scalex86.org>,
       Ravikiran Thirumalai <kiran@scalex86.org>
Subject: Re: [PATCH 7/12] acpi: fix another compile warning
Date: Wed, 20 Jun 2007 09:36:30 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20070619225035.GI5193@alberich.amd.com> <200706192338.02807.lenb@kernel.org> <20070620084911.GO5193@alberich.amd.com>
In-Reply-To: <20070620084911.GO5193@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706200936.31236.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 June 2007 04:49, Andreas Herrmann wrote:
> On Tue, Jun 19, 2007 at 11:38:02PM -0400, Len Brown wrote:
> > On Tuesday 19 June 2007 18:50, Andreas Herrmann wrote:
> > > Avoid compile warning if !ACPI_BLACKLIST_YEAR
> > > 
> > >   CC      drivers/acpi/blacklist.o
> > >   drivers/acpi/blacklist.c:76:5: warning: "CONFIG_ACPI_BLACKLIST_YEAR" is not defined
> > 
> > How were you able to produce a .config with CONFIG_ACPI_BLACKLIST_YEAR not defined?
> 
> Initially I used randconfig. But you can easily create it using
> "make menuconfig", too.
> 
> Just do "make mrproper && make menuconfig" and now
> deselect CONFIG_PM. On x86_64 ACPI keeps enabled by default.

As CONFIG_ACPI depends on CONFIG_PM, then if you are able to end up
with a config having ACPI && !PM, then the Kconfig system is broken.

The brokeness is x86_64 specific, and results from the "select ACPI" below.

Please test if this single patch fixes all your multiple ACPI related build errors.

I fear, however, that this patch defeats the purpose of 
b0bd35e622ffbda2c01dc67a0381c6a18817a29a -- which was to make selecting
NUMA more user-friendly.  So it might make more sense to simply revert that
patch entirely.

The underlying problem is that Kconfig doesn't support using select
on targets which themselves have dependencies.

Signed-off-by: Len Brown <len.brown@intel.com>


diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index 5ce9443..e9d7767 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -364,9 +364,9 @@ config NODES_SHIFT
 config X86_64_ACPI_NUMA
        bool "ACPI NUMA detection"
        depends on NUMA
-       select ACPI 
+       depends on ACPI 
 	select PCI
-       select ACPI_NUMA
+       depends on ACPI_NUMA
        default y
        help
 	 Enable ACPI SRAT based node topology detection.
