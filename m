Return-Path: <linux-kernel-owner+w=401wt.eu-S1161172AbXEDVVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161172AbXEDVVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 17:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031434AbXEDVVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 17:21:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43678 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031707AbXEDVVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 17:21:50 -0400
Date: Fri, 4 May 2007 14:21:46 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andy Whitcroft <apw@shadowen.org>, gregkh@suse.de, paulus@samba.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Christoph Lameter <clameter@cthulhu.engr.sgi.com>
Subject: Re: [PATCH] Re: 2.6.21-rc7-mm2 -- hvsi console driver registration
 failure
In-Reply-To: <20070504130952.b43fc676.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705041410440.25716@schroedinger.engr.sgi.com>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
 <4fe4528cb20beb569a8f2ac817c776e5@pinky> <20070504130952.b43fc676.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, Andrew Morton wrote:

> Better, we should be emitting loud warnigns which then disable themselves
> and then succeeding the allocation so that people can proceed with their
> kernel testing.
> 
> When all the loud-warning sites have been fixed, we can take that code out
> again.
> 
> The present situation is maximally tester-hostile.
i

SLUB: Allocate smallest object size if the user asks for 0 bytes.

Makes SLUB behave like SLAB in this area to avoid issues....

Throw a stack dump to alert people.

At some point the behavior should be switched back. NULL is no
memory as far as I can tell and if the use asked for 0 bytes then
he need to get no memory.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slub_def.h |    8 ++++++--
 mm/slub.c                |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

Index: slub/mm/slub.c
===================================================================
--- slub.orig/mm/slub.c	2007-05-04 14:17:22.000000000 -0700
+++ slub/mm/slub.c	2007-05-04 14:19:36.000000000 -0700
@@ -2009,7 +2009,7 @@ static struct kmem_cache *get_slab(size_
 {
 	int index = kmalloc_index(size);
 
-	if (!size)
+	if (!index)
 		return NULL;
 
 	/* Allocation too large? */
Index: slub/include/linux/slub_def.h
===================================================================
--- slub.orig/include/linux/slub_def.h	2007-05-04 14:13:40.000000000 -0700
+++ slub/include/linux/slub_def.h	2007-05-04 14:18:25.000000000 -0700
@@ -81,8 +81,12 @@ extern struct kmem_cache kmalloc_caches[
  */
 static inline int kmalloc_index(int size)
 {
-	if (size == 0)
-		return 0;
+	/*
+	 * We should return 0 if size == 0 but we use the smallest object
+	 * here for SLAB legacy reasons.
+	 */
+	WARN_ON(size == 0);
+
 	if (size > 64 && size <= 96)
 		return 1;
 	if (size > 128 && size <= 192)
