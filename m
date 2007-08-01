Return-Path: <linux-kernel-owner+w=401wt.eu-S1762042AbXHABFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762042AbXHABFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757417AbXHABE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:04:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37451 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301AbXHABE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:04:57 -0400
Date: Tue, 31 Jul 2007 18:04:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bongani Hlope <bonganilinux@mweb.co.za>
Cc: jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [OOPS] 2.6.23-rc1 Seems to be network related
Message-Id: <20070731180407.a5c3136e.akpm@linux-foundation.org>
In-Reply-To: <200708010257.48417.bonganilinux@mweb.co.za>
References: <200708010257.48417.bonganilinux@mweb.co.za>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007 02:57:48 +0200 Bongani Hlope <bonganilinux@mweb.co.za> wrote:

> I'm not sure if the first email went through, resending without .config 
> attachment.

It did come through, and I replied ;)

The below post-2.6.23-rc1 patch should fix it.

commit b8c1c5da1520977cb55a358f20fc09567d40cad9
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Tue Jul 24 12:02:40 2007 -0700

    slab: correctly handle __GFP_ZERO
    
    Use the correct local variable when calling into the page allocator.  Local
    `flags' can have __GFP_ZERO set, which causes us to pass __GFP_ZERO into the
    page allocator, possibly from illegal contexts.  The page allocator will later
    do prep_zero_page()->kmap_atomic(..., KM_USER0) from irq contexts and will
    then go BUG.
    
    Cc: Mike Galbraith <efault@gmx.de>
    Acked-by: Christoph Lameter <clameter@sgi.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/slab.c b/mm/slab.c
index bde271c..a684778 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2776,7 +2776,7 @@ static int cache_grow(struct kmem_cache 
 	 * 'nodeid'.
 	 */
 	if (!objp)
-		objp = kmem_getpages(cachep, flags, nodeid);
+		objp = kmem_getpages(cachep, local_flags, nodeid);
 	if (!objp)
 		goto failed;
 

