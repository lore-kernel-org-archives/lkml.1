Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbXFGHTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbXFGHTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXFGHTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:19:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55552 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbXFGHTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:19:37 -0400
Date: Thu, 7 Jun 2007 00:19:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.22-rc4-mm2
Message-Id: <20070607001922.9f73902b.akpm@linux-foundation.org>
In-Reply-To: <20070607070513.GT6909@holomorphy.com>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
	<20070607064231.GQ6909@holomorphy.com>
	<20070606235131.a56242cd.akpm@linux-foundation.org>
	<20070607065544.GR6909@holomorphy.com>
	<20070607000125.40ba8dc6.akpm@linux-foundation.org>
	<20070607070407.GS6909@holomorphy.com>
	<20070607070513.GT6909@holomorphy.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 00:05:13 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:

> On Thu, Jun 07, 2007 at 12:01:25AM -0700, Andrew Morton wrote:
> >> config, please?
> 
> On Thu, Jun 07, 2007 at 12:04:07AM -0700, William Lee Irwin III wrote:
> > It's the sparc32 defconfig. Included below for completeness.
> 
> The error output looks like the following.
> 
> 
> ERROR: "movable_zone" [fs/romfs/romfs.ko] undefined!
> ERROR: "movable_zone" [fs/isofs/isofs.ko] undefined!
> ERROR: "movable_zone" [fs/cifs/cifs.ko] undefined!
> ERROR: "movable_zone" [fs/afs/kafs.ko] undefined!
> ERROR: "movable_zone" [drivers/block/loop.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> make: *** Waiting for unfinished jobs....
> arch/sparc/mm/built-in.o: In function `kmap_atomic':
> (.text+0x433c): undefined reference to `movable_zone'
> arch/sparc/mm/built-in.o: In function `kmap_atomic':
> (.text+0x4348): undefined reference to `movable_zone'
> mm/built-in.o: In function `iov_iter_copy_from_user':
> (.text+0x770): undefined reference to `movable_zone'
> mm/built-in.o: In function `iov_iter_copy_from_user':
> (.text+0x844): undefined reference to `movable_zone'
> mm/built-in.o: In function `iov_iter_copy_from_user':
> (.text+0x850): undefined reference to `movable_zone'
> mm/built-in.o:(.text+0x870): more undefined references to `movable_zone' follow
> make[1]: *** [arch/sparc/boot/image] Error 1

hm, OK, this seems to work:

--- a/include/linux/mmzone.h~a
+++ a/include/linux/mmzone.h
@@ -541,10 +541,13 @@ static inline int populated_zone(struct 
 	return (!!zone->present_pages);
 }
 
+#ifdef CONFIG_ARCH_POPULATES_NODE_MAP
 extern int movable_zone;
+#endif
+
 static inline int zone_movable_is_highmem(void)
 {
-#ifdef CONFIG_HIGHMEM
+#if defined(CONFIG_HIGHMEM) && defined(CONFIG_ARCH_POPULATES_NODE_MAP)
 	return movable_zone == ZONE_HIGHMEM;
 #else
 	return 0;
_

(the first ifdef is just there to trip things at compile time rather than
link time)
