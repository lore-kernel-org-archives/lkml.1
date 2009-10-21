Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbZJUSHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbZJUSHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 14:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbZJUSHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 14:07:40 -0400
Received: from smtp.wp.pl ([212.77.101.1]:40490 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753991AbZJUSHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 14:07:40 -0400
Date: Wed, 21 Oct 2009 20:25:04 +0200
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       jfs-discussion@lists.sourceforge.net
Subject: Re: [Jfs-discussion] [PATCH] jfs: lockdep fix
Message-Id: <20091021202504.0daf2be7.krzysztof.h1@wp.pl>
In-Reply-To: <1256068823.3708.30.camel@norville.austin.ibm.com>
References: <4ade05f0af05a2.00981454@wp.pl>
	<1256068823.3708.30.camel@norville.austin.ibm.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [MfO0]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Oct 2009 15:00:23 -0500
Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
> I proposed another fix here:
> http://bugzilla.kernel.org/show_bug.cgi?id=13613
> 
> It seems I haven't followed up and submitted it to the vfs maintainer.
> Could you please give that patch a try and see if it fixes the problem
> for you?
> 

Your patch fixes the previously reported (old) lockdep problem.  I am not able to trigger 
the lockdep report while it takes a few minutes without the patch. 

Tested-by: Krzysztof Helt <krzysztof.h1@wp.pl>

Your fix I have tested is below:

VFS: Fix potential deadlock in __read_cache_page()

lockdep reports a potential deadlock when using jfs because
add_to_page_cache_lru() is called from __read_cache_page() with GFP_KERNEL.

Detailed lockdep output can be found at
http://bugzilla.kernel.org/show_bug.cgi?id=13613

Passing mapping_gfp_mask(mapping) instead of GFP_KERNEL fixes the problem.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

diff --git a/mm/filemap.c b/mm/filemap.c
index ccea3b6..59f5406 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1702,7 +1702,8 @@ repeat:
 		page = page_cache_alloc_cold(mapping);
 		if (!page)
 			return ERR_PTR(-ENOMEM);
-		err = add_to_page_cache_lru(page, mapping, index, GFP_KERNEL);
+		err = add_to_page_cache_lru(page, mapping, index,
+					    mapping_gfp_mask(mapping));
 		if (unlikely(err)) {
 			page_cache_release(page);
 			if (err == -EEXIST)

