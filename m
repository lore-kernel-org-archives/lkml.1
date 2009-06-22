Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbZFVP0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbZFVP0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbZFVP0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:26:05 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:57599 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751983AbZFVP0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:26:03 -0400
Subject: Re: [PATCH -tip 2/5] x86: use asm-generic/dma-mapping-common.h
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       akpm@linux-foundation.org, sam@ravnborg.org, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1245676935.6227.5.camel@penberg-laptop>
References: <20090620155605.GD12901@elte.hu>
	 <20090622135717T.fujita.tomonori@lab.ntt.co.jp>
	 <1245650501.18751.0.camel@penberg-laptop>
	 <20090622203333U.fujita.tomonori@lab.ntt.co.jp>
	 <19f34abd0906220459w39271e29x99d578d0a49d593b@mail.gmail.com>
	 <19f34abd0906220543v64b5418di8b97d36214d093cc@mail.gmail.com>
	 <20090622124916.GA30553@elte.hu>
	 <1245676212.15580.68.camel@pc1117.cambridge.arm.com>
	 <1245676935.6227.5.camel@penberg-laptop>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 22 Jun 2009 16:24:41 +0100
Message-Id: <1245684281.15580.102.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2009 15:24:42.0121 (UTC) FILETIME=[90A00F90:01C9F34D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 16:22 +0300, Pekka Enberg wrote:
> On Mon, 2009-06-22 at 14:10 +0100, Catalin Marinas wrote:
> > On Mon, 2009-06-22 at 14:49 +0200, Ingo Molnar wrote:
> > > * Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > > > Seems to be CONFIG_DEBUG_SLAB=y that is the culprit in this case. Hm,
> > > > is Kconfig busted?
> > > > 
> > > > lib/Kconfig.debug:301:config DEBUG_SLAB
> > > > lib/Kconfig.debug-302-  bool "Debug slab memory allocations"
> > > > lib/Kconfig.debug:303:  depends on DEBUG_KERNEL && SLAB && !KMEMCHECK
> > > > 
> > > > fujita-config:1475:CONFIG_DEBUG_SLAB=y
> > > > fujita-config:1558:CONFIG_KMEMCHECK=y
> > > > 
> > > > ...what gives? Pekka?
> > > 
> > > Kmemleak introduced this piece of not so nice solution recently:
> > > 
> > > +config DEBUG_KMEMLEAK
> > > +       bool "Kernel memory leak detector"
> > > +       depends on DEBUG_KERNEL && EXPERIMENTAL && (X86 || ARM) && \
> > > +               !MEMORY_HOTPLUG
> > > +       select DEBUG_SLAB if SLAB
> > > +       select SLUB_DEBUG if SLUB
> > > +       select DEBUG_FS if SYSFS
> > > +       select STACKTRACE if STACKTRACE_SUPPORT
> > > +       select KALLSYMS
> > > 
> > > that should be a depends line, not a select line.
> > 
> > Kmemleak doesn't strictly need DEBUG_SLAB to make it a dependency. But
> > enabling it may reduce (in theory) the false negatives by poisoning the
> > allocated objects (and hence clearing any possible pointers to other
> > objects). But I don't have any figures to show this is the case. I'll
> > post a patch to drop those selects.
> > 
> > BTW, wouldn't it be feasible for kbuild to ignore the select statements
> > if the selected config has unmet dependencies?
> 
> Hmm, no idea, lets cc some relevant people here. But can we remove the
> select and add a config option help text to kmemleak as a short-term
> solution?

Here it is:


kmemleak: Do not force the slab debugging Kconfig options

From: Catalin Marinas <catalin.marinas@arm.com>

Selecting DEBUG_SLAB or SLUB_DEBUG by the KMEMLEAK menu entry may cause
issues with other dependencies (KMEMCHECK). These configuration options
aren't strictly needed by kmemleak but they may increase the chances of
finding leaks. This patch also updates the KMEMLEAK config entry help
text.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 lib/Kconfig.debug |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 23067ab..4c32b1a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -340,8 +340,6 @@ config DEBUG_KMEMLEAK
 	bool "Kernel memory leak detector"
 	depends on DEBUG_KERNEL && EXPERIMENTAL && (X86 || ARM) && \
 		!MEMORY_HOTPLUG
-	select DEBUG_SLAB if SLAB
-	select SLUB_DEBUG if SLUB
 	select DEBUG_FS if SYSFS
 	select STACKTRACE if STACKTRACE_SUPPORT
 	select KALLSYMS
@@ -355,6 +353,9 @@ config DEBUG_KMEMLEAK
 	  allocations. See Documentation/kmemleak.txt for more
 	  details.
 
+	  Enabling DEBUG_SLAB or SLUB_DEBUG may increase the chances
+	  of finding leaks due to the slab objects poisoning.
+
 	  In order to access the kmemleak file, debugfs needs to be
 	  mounted (usually at /sys/kernel/debug).
 

-- 
Catalin

