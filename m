Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbZBZHRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbZBZHRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 02:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZBZHR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 02:17:27 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41157 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZBZHR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 02:17:27 -0500
Subject: Re: [PATCH] kmemcheck: Disable SLUB and SLAB debugging when
	kmemcheck is enabled
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0902251622460.13795@qirst.com>
References: <1235381712.6216.22.camel@penberg-laptop>
	 <alpine.DEB.1.10.0902231039580.7298@qirst.com>
	 <1235410406.6216.69.camel@penberg-laptop>
	 <19f34abd0902251117h7a4a6e9ao34e972110d8b40a1@mail.gmail.com>
	 <alpine.DEB.1.10.0902251622460.13795@qirst.com>
Date: Thu, 26 Feb 2009 09:17:23 +0200
Message-Id: <1235632643.5465.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009, Vegard Nossum wrote:
> > Can you rethink whether SLUB_DEBUG or SLUB_DEBUG_ON is the one we
> > really want to depend on !KMEMCHECK, and either submit a new patch or
> > convince me that this is sufficient?

On Wed, 2009-02-25 at 16:23 -0500, Christoph Lameter wrote:
> !SLUB_DEBUG_ON is the right thing to depend on.

Here's a patch to do that.

			Pekka

>From bae2afd233c24d766e20e09bb92c67c0e5ea16e3 Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Mon, 23 Feb 2009 11:35:13 +0200
Subject: [PATCH] kmemcheck: Disable SLUB and SLAB debugging when kmemcheck is enabled

Enabling kmemcheck in Kconfig is a painful experience. Lets make it a
tad bit easier by inverting the dependencies to SLUB and SLAB debugging.
As kmemcheck is more powerful than slab debugging, disable the latter
functionality if an user enables kmemcheck.

Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/Kconfig.debug |    2 +-
 lib/Kconfig.debug      |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index de186c5..3d1d593 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -276,7 +276,7 @@ menuconfig KMEMCHECK
 	bool "kmemcheck: trap use of uninitialized memory"
 	depends on X86
 	depends on !X86_USE_3DNOW
-	depends on (SLUB && !SLUB_DEBUG_ON) || (SLAB && !DEBUG_SLAB)
+	depends on SLUB || SLAB
 	depends on !CC_OPTIMIZE_FOR_SIZE
 	depends on !DEBUG_PAGEALLOC
 	depends on !FUNCTION_TRACER
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 29044f5..e9a930c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -262,7 +262,7 @@ config DEBUG_OBJECTS_ENABLE_DEFAULT
 
 config DEBUG_SLAB
 	bool "Debug slab memory allocations"
-	depends on DEBUG_KERNEL && SLAB
+	depends on DEBUG_KERNEL && SLAB && !KMEMCHECK
 	help
 	  Say Y here to have the kernel do limited verification on memory
 	  allocation as well as poisoning memory on free to catch use of freed
@@ -274,7 +274,7 @@ config DEBUG_SLAB_LEAK
 
 config SLUB_DEBUG_ON
 	bool "SLUB debugging on by default"
-	depends on SLUB && SLUB_DEBUG
+	depends on SLUB && SLUB_DEBUG && !KMEMCHECK
 	default n
 	help
 	  Boot with debugging on by default. SLUB boots by default with
-- 
1.5.4.3



