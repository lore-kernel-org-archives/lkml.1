Return-Path: <linux-kernel-owner+w=401wt.eu-S1760160AbYAUQ1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160AbYAUQ1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 11:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbYAUQ1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 11:27:07 -0500
Received: from gir.skynet.ie ([193.1.99.77]:35546 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbYAUQ1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 11:27:06 -0500
Date: Mon, 21 Jan 2008 16:27:02 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: Re: [PATCH 0/2] Relax restrictions on setting CONFIG_NUMA on x86
Message-ID: <20080121162702.GB8485@csn.ul.ie>
References: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie> <20080121093702.8FC2.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080121143508.GA8485@csn.ul.ie> <20080121144923.GA8959@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080121144923.GA8959@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (21/01/08 15:49), Ingo Molnar didst pronounce:
> 
> * Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > > I think this patch become easy to the porting of fakenuma.
> > 
> > It would be great if that was available, particularly if it could fake 
> > memoryless nodes as that is a place where we've found a few 
> > difficult-to-reproduce bugs.
> 
> yeah. Your previous patch (see below) had build problems - are those 
> resolved meanwhile?
> 

Odd, I couldn't reproduce it Friday and could today. Clearly I was not
firing on all cylinders. The problem was because NUMA && FLATMEM are
incompatible. Thanks for nudging a second time.

However in the patch below addressing the problem below, would it make more
sense to replace X86_PC with !NUMA instead of having X86_PC && !NUMA?

===

Subject: Do not allow FLATMEM && NUMA to be set on x86 at the same time

The FLATMEM memory model references a global mem_map and max_mapnr. This
is incompatible with how memory models used for NUMA view the world.
Builds fail if FLATMEM && NUMA are set on x86. This patch forbids that
combination of config items. This is consistent with x86_64
enforcements.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
--- 
 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.24-rc8-020_init_kmem3lists_nodes/arch/x86/Kconfig linux-2.6.24-rc8-025_memmap_reffix/arch/x86/Kconfig
--- linux-2.6.24-rc8-020_init_kmem3lists_nodes/arch/x86/Kconfig	2008-01-19 15:26:00.000000000 +0000
+++ linux-2.6.24-rc8-025_memmap_reffix/arch/x86/Kconfig	2008-01-21 15:51:03.000000000 +0000
@@ -891,7 +891,7 @@ config HAVE_ARCH_ALLOC_REMAP
 
 config ARCH_FLATMEM_ENABLE
 	def_bool y
-	depends on (X86_32 && ARCH_SELECT_MEMORY_MODEL && X86_PC) || (X86_64 && !NUMA)
+	depends on (X86_32 && ARCH_SELECT_MEMORY_MODEL && X86_PC && !NUMA) || (X86_64 && !NUMA)
 
 config ARCH_DISCONTIGMEM_ENABLE
 	def_bool y
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
