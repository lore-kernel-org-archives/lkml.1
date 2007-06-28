Return-Path: <linux-kernel-owner+w=401wt.eu-S1764056AbXF1Cgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764056AbXF1Cgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 22:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761649AbXF1Cgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 22:36:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57132 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761487AbXF1Cgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 22:36:37 -0400
Date: Wed, 27 Jun 2007 19:36:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: NeilBrown <neilb@suse.de>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 007 of 8] knfsd: nfsd4: vary maximum delegation limit
 based on RAM size
Message-Id: <20070627193613.746dfbf3.akpm@linux-foundation.org>
In-Reply-To: <20070628021551.GB20605@fieldses.org>
References: <20070621142604.727.patches@notabene>
	<1070621043112.1144@suse.de>
	<20070625205244.bbf0976a.akpm@linux-foundation.org>
	<20070628021551.GB20605@fieldses.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 22:15:52 -0400 "J. Bruce Fields" <bfields@fieldses.org> wrote:

> +	/*
> +	 * Allow at most 4 delegations per megabyte of RAM.  Quick
> +	 * estimates suggest that in the worst case (where every delegation
> +	 * is for a different inode), a delegation could take about 1.5K,
> +	 * giving a worst case usage of about 6% of memory.
> +	 */
>  	sys.totalram >>= (18 - PAGE_SHIFT);

6% of 32GB is 2GB is too much for a large highmem machine.  We should base
this on the amount of kernel-addressable memory (aka lowmem).

How's this?

static void
set_max_delegations(void)
{
	/*
	 * Allow at most 4 delegations per megabyte of RAM.  Quick
	 * estimates suggest that in the worst case (where every delegation
	 * is for a different inode), a delegation could take about 1.5K,
	 * giving a worst case usage of about 6% of memory.
	 */
	max_delegations = nr_free_buffer_pages() >> (20 - 2 - PAGE_SHIFT);
}


 fs/nfsd/nfs4state.c |    7 ++-----
 mm/page_alloc.c     |    1 +

diff -puN fs/nfsd/nfs4state.c~knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix-fix fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix-fix
+++ a/fs/nfsd/nfs4state.c
@@ -49,6 +49,7 @@
 #include <linux/nfsd/state.h>
 #include <linux/nfsd/xdr4.h>
 #include <linux/namei.h>
+#include <linux/swap.h>
 #include <linux/mutex.h>
 #include <linux/lockd/bind.h>
 #include <linux/module.h>
@@ -3210,17 +3211,13 @@ get_nfs4_grace_period(void)
 static void
 set_max_delegations(void)
 {
-	struct sysinfo sys;
-
-	si_meminfo(&sys);
 	/*
 	 * Allow at most 4 delegations per megabyte of RAM.  Quick
 	 * estimates suggest that in the worst case (where every delegation
 	 * is for a different inode), a delegation could take about 1.5K,
 	 * giving a worst case usage of about 6% of memory.
 	 */
-	sys.totalram >>= (18 - PAGE_SHIFT);
-	max_delegations = (unsigned int) sys.totalram;
+	max_delegations = nr_free_buffer_pages() >> (20 - 2 - PAGE_SHIFT);
 }
 
 /* initialization to perform when the nfsd service is started: */
diff -puN mm/page_alloc.c~knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix-fix mm/page_alloc.c
--- a/mm/page_alloc.c~knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix-fix-fix-fix
+++ a/mm/page_alloc.c
@@ -1729,6 +1729,7 @@ unsigned int nr_free_buffer_pages(void)
 {
 	return nr_free_zone_pages(gfp_zone(GFP_USER));
 }
+EXPORT_SYMBOL_GPL(nr_free_buffer_pages);
 
 /*
  * Amount of free RAM allocatable within all zones
_

